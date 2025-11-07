cat > ip_change_demo.sh <<'EOF'
#!/data/data/com.termux/files/usr/bin/env bash
# -----------------------------------------------------
# Termux IP Change Tools — by Z3R0 para Friends School
# https://github.com/ralvarado9/termux-ip-change
# -----------------------------------------------------

set -euo pipefail

ACTION=${1:-none}
TIMEOUT=${2:-30}        # segundos a esperar
SLEEP_INTERVAL=2
IP_CHECK_URL="https://ipinfo.io/ip"

notify() {
  if command -v termux-notification >/dev/null 2>&1; then
    termux-notification --title "$1" --content "$2"
  else
    echo "[NOTIF] $1 - $2"
  fi
}

get_ip() {
  local ip
  ip=$(curl -s --max-time 6 "$IP_CHECK_URL" 2>/dev/null || true)
  # quitar saltos/espacios
  ip="${ip//$'\n'/}"
  ip="${ip//$'\r'/}"
  ip="${ip//[[:space:]]/}"
  echo "$ip"
}

do_action() {
  case "$ACTION" in
    wifi)
      echo "[*] Toggle Wi-Fi (requiere Termux:API instalado)…"
      if ! command -v termux-wifi-enable >/dev/null 2>&1; then
        echo "ERROR: falta termux-api o la app Termux:API."
        return 1
      fi
      termux-wifi-enable false
      sleep 2
      termux-wifi-enable true
      ;;
    cellular)
      echo "[*] Reiniciar datos móviles (requiere root)…"
      if ! command -v su >/dev/null 2>&1; then
        echo "ERROR: no hay 'su' (root)."
        return 1
      fi
      su -c 'svc data disable' || true
      sleep 3
      su -c 'svc data enable' || true
      ;;
    tor)
      echo "[*] Reiniciar Tor (si está instalado)…"
      if ! command -v tor >/dev/null 2>&1; then
        echo "ERROR: tor no está instalado."
        return 1
      fi
      pkill -f tor 2>/dev/null || true
      sleep 1
      nohup tor >/dev/null 2>&1 &
      ;;
    none)
      echo "[*] Sin acción automática. Cambia la IP manualmente (activa tu VPN, etc.)."
      ;;
    *)
      echo "Acción desconocida: $ACTION"
      echo "Usa: wifi | cellular | tor | none"
      return 1
      ;;
  esac
  return 0
}

echo "============================================"
echo " Acción: $ACTION"
echo " Timeout: ${TIMEOUT}s"
echo " Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"

IP_BEFORE=$(get_ip)
echo "IP pública inicial: ${IP_BEFORE:-sin-conexion}"

# Ejecutar acción
if ! do_action; then
  echo "[!] La acción falló; de todos modos se verificará el cambio de IP."
fi

echo "[*] Esperando hasta ${TIMEOUT}s para detectar cambio…"
elapsed=0
changed=0
while [ $elapsed -lt $TIMEOUT ]; do
  sleep $SLEEP_INTERVAL
  elapsed=$((elapsed + SLEEP_INTERVAL))
  IP_NOW=$(get_ip)
  if [ -n "$IP_NOW" ] && [ "$IP_NOW" != "$IP_BEFORE" ]; then
    changed=1
    echo ">>> IP cambió en ${elapsed}s: $IP_BEFORE -> $IP_NOW"
    notify "IP cambiada" "Antes: $IP_BEFORE → Ahora: $IP_NOW"
    break
  fi
  echo "Esperando... ${elapsed}s (IP actual: ${IP_NOW:-sin-respuesta})"
done

if [ $changed -eq 0 ]; then
  IP_NOW=$(get_ip)
  echo "=== Resultado final tras ${TIMEOUT}s ==="
  echo "IP anterior: ${IP_BEFORE:-no-disp}"
  echo "IP actual:   ${IP_NOW:-no-disp}"
  if [ -z "$IP_NOW" ] || [ "$IP_NOW" = "$IP_BEFORE" ]; then
    echo "→ No se detectó cambio de IP."
    notify "IP no cambió" "IP: ${IP_NOW:-no-disp}"
    exit 2
  else
    echo "→ La IP sí cambió al final: ${IP_BEFORE} -> ${IP_NOW}"
    notify "IP cambiada" "Antes: $IP_BEFORE → Ahora: $IP_NOW"
  fi
else
  echo "Proceso finalizado: IP cambió correctamente."
fi

echo "============================================"
exit 0
EOF

chmod +x ip_change_demo.sh

