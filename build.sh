#!/bin/bash

# Define which devices can be flashed from this CLI
VALID_DEVICES=("KDAC", "KHUB", "KHA")

# Get inputs for device and mark
SELECTED_DEVICE="$1"
SELECTED_MK="$2"

# Check if no inputs were given
if [[ -z "$SELECTED_DEVICE" || -z "$SELECTED_MK" ]]; then
	echo "Usage: $0 <device> <mark>"
	echo "Valid devices: ${VALID_DEVICES[*]}"
    echo "Only non-negative numbers (>= 0) are allowed for the device MK"
	echo "Example: $0 KDAC 2"
	exit 1
fi

# Validate device and mark
is_valid=false
for device in "${VALID_DEVICES[@]}"; do
	if [ "$device" == "$SELECTED_DEVICE" ]; then
		is_valid=true
		break
	fi
done
if [[ "$SELECTED_MK" =~ ^[0-9]+$ ]]; then
	is_valid=true
fi

# Handle result
if [ "$is_valid" = true ]; then
	# Build and flash for selected hardware
	# Update serial number in JSON file
	make clean
	make DEVICE_NAME="DEV_$SELECTED_DEVICE" DEVICE_MK="$SELECTED_MK"
    make flash
else
    echo "Invalid input: $SELECTED_DEVICE $SELECTED_MK"
	echo "Usage: $0 <device> <mark>"
	echo "Valid devices: ${VALID_DEVICES[*]}"
    echo "Only non-negative numbers (>= 0) are allowed for the device MK"
	echo "Example: $0 KDAC 2"
	exit 1
fi
