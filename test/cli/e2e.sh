#!/bin/bash

set -e

STATE_BEFORE_SNAPSHOT=$(truffle exec test/cli/read_contract.js)
SNAP_ID=$(truffle run snapshot make)
echo $STATE_BEFORE_SNAPSHOT

STATE_AFTER_WRITE=$(truffle exec test/cli/write_contract.js)

if [ "$STATE_AFTER_WRITE" == "$STATE_BEFORE_SNAPSHOT" ]
then
    echo "Expected write operation to change something"
    exit 1
fi

truffle run snapshot revert $SNAP_ID
STATE_AFTER_REVERT=$(truffle exec test/cli/read_contract.js)

if [ "$STATE_AFTER_REVERT" != "$STATE_BEFORE_SNAPSHOT" ]
then
    echo "Expected to revert state to before snapshot"
    exit 1
fi