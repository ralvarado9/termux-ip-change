#!/data/data/com.termux/files/usr/bin/env python3
# -----------------------------------------------------
# Termux IP Change Tools — by Z3R0 para Friends School
# https://github.com/<TU_USUARIO>/termux-ip-change
# -----------------------------------------------------
import requests, time, subprocess

def get_ip():
    try:
        r = requests.get("https://ipinfo.io/json", timeout=6)
        j = r.json()
        return j.get("ip"), j.get("country"), j.get("city")
    except:
        return None, None, None

prev_ip, country, city = get_ip()
print(f"IP inicial: {prev_ip} ({country}, {city})")
while True:
    time.sleep(10)
    ip, country, city = get_ip()
    if ip and ip != prev_ip:
        print(f"IP cambió: {prev_ip} → {ip} ({country}, {city})")
        subprocess.run(["termux-notification", "--title", "IP cambiada",
                        "--content", f"{prev_ip} → {ip} ({country})"])
        prev_ip = ip
