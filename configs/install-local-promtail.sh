PROMTAIL_VERSION=$(curl -s "https://api.github.com/repos/grafana/loki/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
sudo mkdir /opt/promtail
sudo wget -qO /opt/promtail/promtail.gz "https://github.com/grafana/loki/releases/download/v${PROMTAIL_VERSION}/promtail-linux-amd64.zip"
sudo gunzip /opt/promtail/promtail.gz
sudo chmod a+x /opt/promtail/promtail
sudo ln -s /opt/promtail/promtail /usr/local/bin/promtail
##CONFIG
##
echo "[Unit]
Description=Promtail client for sending logs to Loki
After=network.target

[Service]
ExecStart=/opt/promtail/promtail -config.file=/opt/promtail/promtail-local-config.yaml
Restart=always
TimeoutStopSec=3

[Install]
WantedBy=multi-user.target" >/etc/systemd/system/promtail.service


echo "server:
  http_listen_port: 0
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://206.166.251.7:3100/loki/api/v1/push

scrape_configs:
- job_name: neutron-node-1-job
  static_configs:
  - targets:
      - localhost
    labels:
      job: neutron-node-1
      __path__: /opt/neutron/data/test-1.log
- job_name: neutron-node-2-job
  static_configs:
  - targets:
      - localhost
    labels:
      job: neutron-node-2
      __path__: /opt/neutron/data/test-2.log" > /opt/promtail/promtail-local-config.yaml

sudo systemctl daemon-reload
sudo service promtail start
