#!/data/data/com.termux/files/usr/bin/bash
# -----------------------------------------------------
# Termux IP Change Tools — by Z3R0 para Friends School
# https://github.com/<TU_USUARIO>/termux-ip-change
# -----------------------------------------------------

set -e
echo "[*] Apagando Wi-Fi..."
termux-wifi-enable false
sleep 2
echo "[*] Encendiendo Wi-Fi..."
termux-wifi-enable true

for i in $(seq 1 20); do
  if ip -4 addr show wlan0 2>/dev/null | grep -q 'inet '; then
    echo "[+] Wi-Fi reconectado"
    ip -4 addr show wlan0 | awk '/inet /{print "IP local:", $2}'
    break
  fi
  sleep 1
done

echo "[*] IP pública actual:"
curl -s https://ipinfo.io/ip || echo "No se pudo consultar IP pública"
