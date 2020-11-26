#!/bin/bash

SPL_BIN=$(which spl-token)
KEYPAIR_PATH=$(find $HOME -type f -iname validator-keypair.json)

$SPL_BIN --owner $KEYPAIR_PATH transfer $($SPL_BIN --owner $KEYPAIR_PATH accounts 432FsYZLkqu6fiXbEm7NDVR58xJPfJTHNzsTSEE1KmwW |tail -n1 | awk '{print $1}') ALL 3iAe6JeecrC5XgrJtrCqFWXqfeh55JEBjcTes3siFbB6
