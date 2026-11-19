#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/webpage-bootstrap.log) 2>&1

echo "Starting AWS webpage setup..."


mkdir -p /opt/webpage

cat > /opt/webpage/index.html <<'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>AWS Webpage Project</title>
</head>
<body>
    <h1>Hello World!</h1>
    <p>My webpage is hosted on AWS using Terraform.</p>
    <p>High Availability and Auto Scaling Demo</p>
</body>
</html>
HTML

cat > /etc/systemd/system/webpage.service <<'SERVICE'
[Unit]
Description=Simple AWS Webpage
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 -m http.server 80 --bind 0.0.0.0 --directory /opt/webpage
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable --now webpage.service
