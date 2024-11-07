#!/bin/bash

set -xe

GAME_NAME="Crow_Glide"

zip -9 -r $GAME_NAME.love . -x '*.git*'

cat ../love-11.5-win64/love.exe $GAME_NAME.love > $GAME_NAME.exe
