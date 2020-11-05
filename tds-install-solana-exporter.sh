#!/bin/bash

USER1="root"
NODE_EXPORTER_SERVICE_PATH="/etc/systemd/system/node_exporter.service"
EXPORTER_PATH="/root/solana/solana_exporter.sh"
TEXTFILE_COLLECTOR_DIR="/var/lib/node_exporter/textfile_collector/"

echo "Downloading solana-exporter"
curl -s https://raw.githubusercontent.com/c29r3/solana-utils/master/solana-exporter.sh > $EXPORTER_PATH
chmod u+x $EXPORTER_PATH

crontab -l | grep "solana_exporter.sh" &> /dev/null
if [ $? == 1 ]; then
  echo "Creating crontab job"
  echo "* * * * * /bin/bash -c 'for i in {1..15}; do /root/solana/solana_exporter.sh; sleep 4; done'" >> /var/spool/cron/crontabs/$USER1
fi

if ! [ -d "$TEXTFILE_COLLECTOR_DIR" ]; then
  echo "Creating default TEXTFILE_COLLECTOR_DIR"
  mkdir -p $TEXTFILE_COLLECTOR_DIR
fi


if [ $(grep -c "collector.textfile.directory" $NODE_EXPORTER_SERVICE_PATH) -eq 0 ]; then
  sed -i "s|ExecStart=/usr/local/bin/node_exporter|ExecStart=/usr/local/bin/node_exporter --collector.textfile.directory=$TEXTFILE_COLLECTOR_DIR|g" $NODE_EXPORTER_SERVICE_PATH \
  && echo "Restarting node_exporter service" \
  && systemctl daemon-reload \
  && systemctl restart node_exporter.service
fi

echo "Done"
