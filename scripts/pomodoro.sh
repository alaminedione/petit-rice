#!/usr/bin/env bash
#
# pomodoro.sh — simple Pomodoro timer.
# Defaults: 25m work, 5m break, unlimited cycles.
#
# Usage:
#   pomodoro.sh           # infinite 25/5 cycles
#   pomodoro.sh -w 50     # infinite 50/5 cycles
#   pomodoro.sh -b 10     # infinite 25/10 cycles
#   pomodoro.sh -w 45 -b 15 -c 4   # 4 cycles of 45/15

WORK=25
BREAK=5
CYCLES=0   # 0 means infinite

usage() {
  cat <<EOF
Usage: $0 [-w work_minutes] [-b break_minutes] [-c cycles] [-h]

  -w MIN    minutes of work (default: $WORK)
  -b MIN    minutes of break (default: $BREAK)
  -c N      number of pomodoro cycles (default: infinite)
  -h        show this help
EOF
  exit 1
}

while getopts "w:b:c:h" opt; do
  case "$opt" in
    w) WORK=$OPTARG ;;
    b) BREAK=$OPTARG ;;
    c) CYCLES=$OPTARG ;;
    h|\?) usage ;;
  esac
done

# countdown seconds with live MM:SS display
countdown() {
  local T=$1
  local LABEL=$2
  while (( T > 0 )); do
    printf "\r%s %02d:%02d " \
      "$LABEL" $(( T/60 )) $(( T%60 ))
    sleep 1
    ((T--))
  done
  printf "\r%s 00:00 \n" "$LABEL"
}

# one work+break cycle
run_cycle() {
  echo
  echo "▶ Work for $WORK minutes..."
  countdown $((WORK * 60)) "Work ⏱"
  printf "\a"   # terminal bell
  echo
  echo "☕ Break for $BREAK minutes..."
  countdown $((BREAK * 60)) "Break ⏱"
  printf "\a"
}

if (( CYCLES > 0 )); then
  for ((i=1; i<=CYCLES; i++)); do
    echo
    echo "===== Pomodoro $i of $CYCLES ====="
    run_cycle
  done
  echo
  echo "All $CYCLES cycles complete. Good job!"
else
  i=1
  while true; do
    echo
    echo "===== Pomodoro cycle $i ====="
    run_cycle
    ((i++))
  done
fi


