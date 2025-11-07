# termux-ip-change
# 🛰️ Termux IP Change Tools

Conjunto de scripts **gratuitos y legales** para comprobar, renovar o cambiar tu IP pública desde Termux (Android).
# 🛰️ Termux IP Change Tools — by Z3R0 para Friends School
## 🚀 Contenido
- `scripts/ip_change_demo.sh` → Muestra IP antes/después de una acción (Wi-Fi, datos, VPN o Tor).
- `scripts/renew_wifi.sh` → Renueva IP local del Wi-Fi (usa Termux:API).
- `scripts/watch_ip.py` → Monitorea IP y notifica si cambia.

## 🧰 Requisitos
- **Termux actualizado**
- `pkg install git curl python termux-api`
- (opcional) `pip install requests`
- App **Termux:API** instalada (desde F-Droid o PlayStore)

## ⚙️ Uso rápido

```bash
git clone https://github.com/ralvarado9/termux-ip-change.git
cd termux-ip-change/scripts
bash ip_change_demo.sh wifi 30
