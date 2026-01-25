#!/usr/bin/env python3
import socket
import sys
import os
import subprocess
import json
import time
import signal
import threading

SOCKET_PATH = "/tmp/luminosite.sock"
displays = [1, 2]

luminosite_presente = 0

def _set_display(display: int, luminosite: int):
    global luminosite_presente
    subprocess.run(["ddcutil", "setvcp", "10", str(luminosite), "-d", str(display)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    luminosite_presente = luminosite

def changer_luminosite(luminosite: int):

    threads = []
    for display in displays:
        t = threading.Thread(target=_set_display, args=(display, luminosite))
        t.start()
        threads.append(t)

    for t in threads:
        t.join()

    print(json.dumps({"luminosite": luminosite_presente}))


DEBOUNCE_DELAY = 0.3  # secondes sans nouvel appel avant exécution

_pending_delta = 0
_timer = None
_lock = threading.Lock()

def _set_display_delta(display: int, delta: int):
    global luminosite_presente
    if delta > 0:
        cmd = ["ddcutil", "setvcp", "10", "+", str(delta), "-d", str(display)]
    else:
        cmd = ["ddcutil", "setvcp", "10", "-", str(abs(delta)), "-d", str(display)]

    luminosite_presente += delta
    if(luminosite_presente < 0): luminosite_presente = 0
    if(100 < luminosite_presente): luminosite_presente = 100
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def appliquer_luminosite(delta: int):
    if delta == 0:
        return

    threads = []
    for display in displays:
        t = threading.Thread(target=_set_display_delta, args=(display, delta))
        t.start()
        threads.append(t)

    for t in threads:
        t.join()

    print(json.dumps({"luminosite": luminosite_presente}))

def _debounced_apply():
    global _pending_delta, _timer

    with _lock:
        delta = _pending_delta
        _pending_delta = 0
        _timer = None

    appliquer_luminosite(delta)

def modifier_luminosite(luminosite: int):
    global _pending_delta, _timer

    with _lock:
        _pending_delta += luminosite

        if _timer is not None:
            _timer.cancel()

        _timer = threading.Timer(DEBOUNCE_DELAY, _debounced_apply)
        _timer.start()

def cleanup_and_exit(signum=None, frame=None):
    print(json.dumps({"message": "Nettoyage du socket..."}))
    try:
        if os.path.exists(SOCKET_PATH):
            os.remove(SOCKET_PATH)
    finally:
        sys.exit(0)

def deja_lance() -> bool:
    return os.path.exists(SOCKET_PATH)

def run_server():
    if deja_lance():
        print(json.dumps({"message": "Programme déjà lancé"}))
        return

    server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    server.bind(SOCKET_PATH)
    server.listen(1)

    print(json.dumps({"message": "Programme lancé, en attente..."}))

    for sig in (signal.SIGINT, signal.SIGTERM, signal.SIGQUIT):
        signal.signal(sig, cleanup_and_exit)

    try:
        while True:
            conn, _ = server.accept()
            cmd = conn.recv(1024).decode()
            conn.close()

            print(json.dumps({"message": f"Commande reçue: {cmd}"}))

            args = cmd.split(" ")

            if(args[0] == "+"):
                modifier_luminosite(int(args[1]))
            elif(args[0] == "-"):
                modifier_luminosite(-int(args[1]))
            else:
                changer_luminosite(int(args[0]))

    finally:
        server.close()
        cleanup_and_exit()

def send_command(cmd):
    client = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    client.connect(SOCKET_PATH)
    client.sendall(cmd.encode())
    client.close()

if __name__ == "__main__":
    if len(sys.argv) > 1:
        args = sys.argv
        args.pop(0)
        if(args[0] == "check"):
            if deja_lance():
                print(json.dumps({"message": "programme déjà lancé"}))
                exit(1)
            else: 
                exit(0)
        else:
            send_command(' '.join(args))
    else:
        run_server()

