#!/bin/bash

readonly SHUTDOWN=5
readonly BOOT=12
readonly GPIO_PATH="/sys/class/gpio"
readonly REBOOT_PULSE_MINIMUM="200"
readonly REBOOT_PULSE_MAXIMUM="600"
readonly STATE_EXPORT="export"
readonly STATE_UNEXPORT="unexport"

terminate() {
  local -r msg=$1
  local -r err_code=${2:-150}
  echo "${msg}" >&2
  exit "${err_code}"
}

# Export / unexport a GPIO or modify its files' values
manage_gpio() {
  local gpio_nr="$1"
  local state="$2"

  # If function has 3 arguments, modify GPIO files' values
  if [[ "${#}" -eq "3" ]]; then
    local file="$2"
    local value="$3"
    echo "${value}" > "${GPIO_PATH}/gpio${gpio_nr}/${file}"
    return 0
  fi

  echo "${gpio_nr}" > "${GPIO_PATH}/${state}"
}

get_gpio_value() {
  local -r gpio_nr="$1"
  echo "$(<"${GPIO_PATH}/gpio${gpio_nr}/value")"
}

gpio_cleanup() {
  if [ -d "${GPIO_PATH}/gpio${SHUTDOWN}" ]; then
    manage_gpio "${SHUTDOWN}" "${STATE_UNEXPORT}"
  fi

  if [ -d "${GPIO_PATH}/gpio${BOOT}" ]; then
    manage_gpio "${BOOT}" "${STATE_UNEXPORT}"
  fi

  terminate "Unexpected exit..."
}

init_gpio() {
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

echo "The x735-script is listening to the shutdown button clicks..."

# Main method
__main__() {
  # Handle exit and interrupt signals to clean up GPIO
  trap gpio_cleanup EXIT SIGINT SIGTERM

  init_gpio

  while true; do
    local shutdown_signal="$(get_gpio_value ${SHUTDOWN})"
    if [ "$shutdown_signal" = "0" ]; then
      sleep 0.2
    else
      local pulse_start=$(($(date +%s%N | cut -b1-13)))
      while [ "$shutdown_signal" = "1" ]; do
        sleep 0.02
        local current_time=$(($(date +%s%N | cut -b1-13)))
        local elapsed_time=$((current_time - pulse_start))
        if [ "$elapsed_time" -gt "$REBOOT_PULSE_MAXIMUM" ]; then
          echo "Your device is shutting down (GPIO $SHUTDOWN), halting RPi ..."
          #sudo poweroff
          exit
        fi
        shutdown_signal="$(get_gpio_value ${SHUTDOWN})"
      done
      if [ "$elapsed_time" -gt "$REBOOT_PULSE_MINIMUM" ]; then
        echo "Your device is rebooting (GPIO $SHUTDOWN), recycling RPi ..."
        #sudo reboot
        exit
      fi
    fi
  done
}

__main__
