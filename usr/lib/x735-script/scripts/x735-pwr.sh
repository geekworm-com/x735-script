#!/bin/bash


readonly SHUTDOWN=5
readonly BOOT=12

readonly GPIO_PATH="/sys/class/gpio"

readonly REBOOTPULSEMINIMUM="200"
readonly REBOOTPULSEMAXIMUM="600"
readonly STATE_EXPORT="export"
readonly STATE_UNEXPORT="unexport"

readonly PERMISSION_DENIED="151"

terminate() {
  local -r msg=$1
  local -r err_code=${2:-150}
  echo "${msg}" >&2
  exit "${err_code}"
}


# export / unexport a GPIO
manage_gpio() {
  local gpio_nr="$1"
  local state="$2"

  # modify GPIO files' values if function has 3 arguments, otherwise the function is to export and unexport a specific GPIO
  if [[ "${#}" -eq "3" ]]; then
    local gpio_nr="$1"
    local file="$2"
    local value="$3"
    echo "${value}" > "${GPIO_PATH}/gpio${gpio_nr}/${file}"
    return 0
  fi

  echo "${gpio_nr}" > "${GPIO_PATH}/${state}"
}

function get_gpio_value() {
  local -r gpio_nr="$1"
  echo "$(cat ${GPIO_PATH}/gpio${gpio_nr}/value)"
}

gpio_cleanup() {
  if [ -d "${GPIO_PATH}/gpio${SHUTDOWN}" ]; then
    manage_gpio "${SHUTDOWN}" "${STATE_UNEXPORT}"
  fi

  if [ -d "${GPIO_PATH}/gpio${BOOT}" ]; then
    manage_gpio "${BOOT}" "${STATE_UNEXPORT}"
  fi

  terminate "unexpected exit..."
}

function init_pgio() {
  if [ ! -d "${GPIO_PATH}/gpio${SHUTDOWN}" ]; then
    manage_gpio "${SHUTDOWN}" "${STATE_EXPORT}"
  fi

  if [ ! -d "${GPIO_PATH}/gpio${BOOT}" ]; then
    manage_gpio "${BOOT}" "${STATE_EXPORT}"
  fi

  manage_gpio "${SHUTDOWN}" "direction" "in"
  manage_gpio "${BOOT}" "direction" "out"
  manage_gpio "${BOOT}" "value" "1"
}

echo "The x735-script is lestining to the shutdown button clicks..."

# Main method
function __main__() {
  # Handle exit and interrupt signals to cleanup GPIO
  trap gpio_cleanup EXIT SIGINT SIGTERM

  init_pgio
  
  while [ 1 ]; do
    shutdownSignal="$(get_gpio_value ${SHUTDOWN})"
    if [ $shutdownSignal = 0 ]; then
      /bin/sleep 0.2
    else
      pulseStart=$(date +%s%N | cut -b1-13)
      while [ $shutdownSignal = 1 ]; do
        /bin/sleep 0.02
        if [ $(($(date +%s%N | cut -b1-13)-$pulseStart)) -gt $REBOOTPULSEMAXIMUM ]; then
          echo "Your device are shutting down", SHUTDOWN, ", halting Rpi ..."
          sudo poweroff
          exit
        fi
        shutdownSignal="$(get_gpio_value ${SHUTDOWN})"
      done
      if [ $(($(date +%s%N | cut -b1-13)-$pulseStart)) -gt $REBOOTPULSEMINIMUM ]; then
        echo "Your device are rebooting", SHUTDOWN, ", recycling Rpi ..."
        sudo reboot
        exit
      fi
    fi
  done
}

__main__
