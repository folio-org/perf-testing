#!/bin/bash -e

## This file needs to be in kafka/bin directory to leverage kafka-config.sh

awk '{ system("./kafka-configs.sh --alter --bootstrap-server <bootstrap-plaintext-connection-url> --entity-type topics --entity-name="$1" --add-config retention.ms=" 1000) }' topics.txt
