#!/bin/bash
set -e

STARTT=$(date +%s.%N)

# ls csgo-base/csgo

docker build -t='base:latest' base/
docker build -t='cs2-base:latest' cs2-base/
#docker build -t='sourcemod:latest' sourcemod/
#docker build -t='ls-warmod:latest' ls-warmod/
docker build -t='cs2-comp:latest' cs2-comp/
#docker build -t='csgo-dm:latest' csgo-dm/
#docker build -t='csgo-ar:latest' csgo-ar/
#docker build -t='csgo-surf:latest' csgo-surf/
docker build -t='cs2-wingman:latest' cs2-wingman/

docker image prune -f

ENDT=$(date +%s.%N)
printf "Time: "
echo "$ENDT - $STARTT" | bc
