#!/bin/bash -e

## This file needs to be in kafka/bin directory to leverage kafka-config.sh
 
awk '{ system("./kafka-configs.sh --bootstrap-server <bootstrap-plaintext-connection-url> --entity-type topics --entity-name="$1" --alter --delete-config retention.ms") }' topics.txt
