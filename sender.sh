#!/bin/bash

KEY_PATH="/home/solana-mb/solana"
BIN_FILE="/home/solana-mb/.local/share/solana/install/active_release/bin/solana"
RPC="http://localhost:8999"
PROXY_KEYPAIR="proxy-key.json"
ADDR=$1

#sleep $(shuf -i 1-1021 -n 1)

cd ${KEY_PATH}

BALANCE=$(${BIN_FILE} balance validator-keypair.json -u ${RPC} | cut -d " " -f1)
BALANCE=$(echo "${BALANCE} - $(shuf -i 19-22 -n 1)" | bc)

echo -e "\n\n" | ${BIN_FILE}-keygen new -o ${PROXY_KEYPAIR}
solana transfer --keypair validator-keypair.json ${PROXY_KEYPAIR} ${BALANCE} --url ${RPC} --allow-unfunded-recipient
sleep 10

BALANCE=$(${BIN_FILE} balance ${PROXY_KEYPAIR} -u ${RPC} | cut -d " " -f1)
SEND_AMOUNT=$(echo "${BALANCE} - $(seq 0 .0001 0.0005 | shuf | head -n1)" | bc)
solana transfer --keypair ${PROXY_KEYPAIR} ${ADDR} ${SEND_AMOUNT} --url ${RPC}

echo $(${BIN_FILE} balance ${PROXY_KEYPAIR} -u ${RPC} | cut -d " " -f1)
