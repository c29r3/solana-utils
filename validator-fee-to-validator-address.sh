#!/bin/bash

BIN_FILE="/home/solana-mb/.local/share/solana/install/active_release/bin/solana"
KEYS_PATH="/home/solana-mb/solana"
RPC="http://localhost:8999"

BALANCE=$(${BIN_FILE} balance ${KEYS_PATH}/vote-account-keypair.json -u ${RPC} | awk -F' ' '{print $1}')
BALANCE=$(echo "${BALANCE} - $(seq 0 .02 1 | shuf | head -n1)" | bc)

${BIN_FILE} withdraw-from-vote-account ${KEYS_PATH}/vote-account-keypair.json ${KEYS_PATH}/validator-keypair.json ${BALANCE} --authorized-withdrawer ${KEYS_PATH}/vote-account-keypair.json -u ${RPC}
