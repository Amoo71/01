#!/bin/bash
set -e

PORT="${PORT:-10000}"
VNC_PASSWORD="${VNC_PASSWORD:-V1312}"

echo "[01] Restoring state from DB..."
python3 /restore-state.py || echo "[01] No DB state to restore, continuing."

echo "[01] Starting Xvfb..."
Xvfb :1 -screen 0 1280x720x24 -ac +extension GLX +render -noreset &
XVFB_PID=$!
sleep 2

echo "[01] Starting Openbox..."
DISPLAY=:1 openbox --config-file /dev/null &
sleep 1

echo "[01] Setting VNC password..."
mkdir -p /root/.vnc
x11vnc -storepasswd "$VNC_PASSWORD" /root/.vnc/passwd

echo "[01] Starting x11vnc..."
x11vnc \
    -display :1 \
    -rfbauth /root/.vnc/passwd \
    -rfbport 5900 \
    -forever \
    -noxdamage \
    -nopw \
    -shared \
    -bg \
    -quiet
sleep 1

echo "[01] Starting noVNC..."
websockify --web /usr/share/novnc/ --daemon 6080 localhost:5900
sleep 1

echo "[01] Starting API..."
python3 /api.py &
API_PID=$!
sleep 1

echo "[01] Configuring nginx on port $PORT..."
export PORT
envsubst '${PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
nginx -t
nginx

echo "[01] Desktop ready."
echo "     noVNC:  https://[service-url]/"
echo "     API:    https://[service-url]/api/health"

# Keep container alive
wait $XVFB_PID
