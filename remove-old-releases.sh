#!/bin/bash

# keep n latest releases
SAVE_REL_NUM=2
REL_PATH="$HOME/.local/share/solana/install/releases/"
REL_NUM=$(/bin/ls $REL_PATH | wc -l)


if [[ "$REL_NUM" -gt "$SAVE_REL_NUM"  ]]; then
  echo -e "Number of releases stored locally:  ${SAVE_REL_NUM}"
  REL_TO_DELETE=$(/bin/ls $REL_PATH | sort | head -n $(echo -e ${REL_NUM}-${SAVE_REL_NUM} | bc) | paste -sd" " -)
  
  echo -e "Removing next releases: $REL_TO_DELETE"
  cd $REL_PATH
  rm -rf $REL_TO_DELETE
fi
