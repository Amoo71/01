FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y \
    wget curl gnupg2 ca-certificates \
    xvfb x11vnc xdotool scrot \
    openbox \
    nginx \
    novnc websockify \
    python3 python3-pip \
    xterm fonts-liberation fonts-noto-core \
    libxss1 libnss3 libatk-bridge2.0-0 libgtk-3-0 \
    libgbm1 libasound2 \
    gettext-base procps \
    && rm -rf /var/lib/apt/lists/*

# Google Chrome (includes Widevine for Netflix/Disney+)
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /requirements.txt
RUN pip3 install --no-cache-dir -r /requirements.txt

COPY api.py /api.py
COPY restore-state.py /restore-state.py
COPY nginx.conf.template /etc/nginx/nginx.conf.template
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 10000

CMD ["/start.sh"]
