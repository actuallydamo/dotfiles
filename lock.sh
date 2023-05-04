#!/bin/sh

BLANK='#2d2d2d00'
CLEAR='#ffffff22'
DEFAULT='#6c99bbcc'
TEXT='#6c99bbee'
WRONG='#d25252bb'
VERIFYING='#d197d9bb'

i3lock \
--insidever-color=$CLEAR     \
--ringver-color=$VERIFYING   \
--insidewrong-color=$CLEAR   \
--ringwrong-color=$WRONG     \
--inside-color=$BLANK        \
--ring-color=$DEFAULT        \
--line-color=$BLANK          \
--separator-color=$DEFAULT   \
--verif-color=$TEXT          \
--wrong-color=$TEXT          \
--time-color=$TEXT           \
--date-color=$TEXT           \
--layout-color=$TEXT         \
--keyhl-color='#bed6ffbb'    \
--bshl-color=$WRONG          \
--screen 1                   \
--blur 10                    \
--clock                      \
--indicator                  \
--time-str="%H:%M"           \
--date-str="%A %d/%m"        \
--radius=200                 \
--ring-width=14
