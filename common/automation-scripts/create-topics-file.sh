#!/bin/bash -e

## This file needs to be in kafka/bin directory to leverage kafka-topics.sh

source ./kafka-topics.sh --describe --zookeeper <zookeeper-plaintext-connection-url> --topic "imtc.Default.tenant001.*" | grep Configs | awk '{printf "%s\n", $2}' > topics.txt
