#!/bin/bash

print_help() {
	echo "Usage: $0 <device> <mark> <serial string>"
	echo "Valid devices: ${VALID_DEVICES[*]}"
    echo "Only non-negative numbers (>= 0) are allowed for the device MK"
    echo "Serial strings are limited to 12 characters"
	echo "Example: $0 KDAC 2 0123456789AB"
}

# Define which devices can be flashed from this CLI
VALID_DEVICES=("KDAC" "KHUB" "KHA")

# Get inputs for device and mark
SELECTED_DEVICE="$1"
SELECTED_MK="$2"
SELECTED_SERIAL_STR="$3"

# Check if no inputs were given
if [[ -z "$SELECTED_DEVICE" || -z "$SELECTED_MK" || -z "$SELECTED_SERIAL_STR" ]]; then
    print_help
	exit 1
fi

# Validate device and mark
is_valid=false
for device in "${VALID_DEVICES[@]}"; do
	if [ "$device" = "$SELECTED_DEVICE" ]; then
		is_valid=true
		break
	fi
done

if ! [[ "$SELECTED_MK" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Invalid mark specified: $SELECTED_MK"
    print_help
	exit 1
fi

if (( ${#SELECTED_SERIAL_STR} > 12 )); then
    echo "ERROR: Serial string $SELECTED_SERIAL_STR is ${#SELECTED_SERIAL_STR} characters long!"
    print_help
	exit 1
fi

# Handle result
if [ "$is_valid" = true ]; then
    # Confirm
    echo "Flashing board for $SELECTED_DEVICE MK $SELECTED_MK with serial string $SELECTED_SERIAL_STR"
    read -p "Confirm? [y/n] " confirmation
    if ! [[ "$confirmation" == "y" ]]; then
        echo "Aborting..."
        exit 0
    fi

	# Build and flash for selected hardware
	make clean
	make DEVICE_NAME="DEV_$SELECTED_DEVICE" DEVICE_MK="$SELECTED_MK" DEVICE_SERIAL_STR="$SELECTED_SERIAL_STR"
    make flash

	# TODO: Update serial number in JSON file
else
    echo "Invalid input: $SELECTED_DEVICE $SELECTED_MK $SELECTED_SERIAL_STR"
	print_help
	exit 1
fi
