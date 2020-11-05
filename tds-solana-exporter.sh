#!/bin/bash

export PATH="/root/.local/share/solana/install/active_release/bin:$PATH"
TEXTFILE_COLLECTOR_DIR=/var/lib/node_exporter/textfile_collector/
FILENAME=solana-tds-stats.prom

BALANCE=$(timeout 5 solana balance /root/solana/validator-keypair.json | awk '{print $1}')
BALANCE=${BALANCE:-0}

SLOT=$(timeout 5 solana --url http://127.0.0.1:8899 slot| awk '{print $1}')
SLOT=${SLOT:-0}
[ ! -z "${SLOT##[0-9]*}" ] && SLOT=0

SLOT_MAX=$(timeout 5 solana --url http://127.0.0.1:8899 slot --commitment max | awk '{print $1}')
SLOT_MAX=${SLOT_MAX:-0}
[ ! -z "${SLOT_MAX##[0-9]*}" ] && SLOT_MAX=0

UPTIME_IN_SEC=$(ps -p $(pidof solana-validator) -o etimes | egrep -o [0-9]+)
UPTIME_IN_SEC=${UPTIME_IN_SEC:-0}

# CURRENT_CLIENT_VERSION=$(timeout 10 curl --silent -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getVersion"}' http:///localhost:8899 | jq -r '.result."solana-core"' | cut -f1)
# LAST_CLIENT_VERSION=$(timeout 10 curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getVersion"}' http://testnet.solana.com | jq -r '.result."solana-core"' | cut -f1)
HEIGHT=$(timeout 5 curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getSlot"}' http://localhost:8899 | jq .result)
HEIGHT=${HEIGHT:-0}
[ ! -z "${HEIGHT##[0-9]*}" ] && HEIGHT=0

DEV_HEIGHT=$(timeout 5 curl -s -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1, "method":"getSlot"}' http://testnet.solana.com | jq .result)
DEV_HEIGHT=${HEIGHT:-0}
[ ! -z "${DEV_HEIGHT##[0-9]*}" ] && DEV_HEIGHT=0

HEALTH_STRING=$(timeout 5 curl -s http:///localhost:8899/health)
HEALTH_OK=0
if [ "$HEALTH_STRING" = "ok" ]; then
    HEALTH_OK=1
fi

# SIZES=$(du -sb /root/validator-ledger | sed -ne 's/^\([0-9]\+\)\t\(.*\)$/node_directory_size_bytes{directory="\2"} \1/p')

# LOG=$(journalctl -u solana -n 100 --no-pager --utc | tac)
# GOSSIP_OK_COUNT=$(echo "$OUT" | grep -m1 -i 'active stake visible in gossip' | awk '{print $4}'| sed 's/[^0-9]*//g')
# GOSSIP_OK_COUNT=${GOSSIP_OK_COUNT:-0}

# GOSSIP_FAIL_COUNT=$(echo "$OUT" | grep -m1 -i 'active stake has the wrong shred version in gossip' | awk '{print $4}'| sed 's/[^0-9]*//g')
# GOSSIP_FAIL_COUNT=${GOSSIP_FAIL_COUNT:-0}

cat << EOF > "$TEXTFILE_COLLECTOR_DIR/$FILENAME.$$"
solana_uptime $UPTIME_IN_SEC
solana_balance $BALANCE
solana_height $HEIGHT
solana_dev_height $DEV_HEIGHT
solana_health_ok $HEALTH_OK
solana_slot $SLOT
solana_slot_max $SLOT_MAX
# solana_current_version $CURRENT_CLIENT_VERSION
# solana_last_version $LAST_CLIENT_VERSION
EOF

mv "$TEXTFILE_COLLECTOR_DIR/$FILENAME.$$" "$TEXTFILE_COLLECTOR_DIR/$FILENAME"
