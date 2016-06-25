#!/bin/bash

for tty in `w -hs | grep -P '\d\ddays' | awk '$3 == "mosh-" {print $2}'`; do pkill -9 -t $tty; done
