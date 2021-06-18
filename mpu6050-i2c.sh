#!/bin/bash

# Read values into JSON, from I2C Slave Device: MPU-6050
# Depends on i2c-ctl: https://github.com/jetibest/i2c-ctl-linux

I2C_SLAVE_ADDRESS="0x68"

# MPU-6050 specific register definitions:
PWR_M1="0x6b"
PWR_M2="0x6c"
CONF_R="0x1a"
G_CONF="0x1b"
A_CONF="0x1c"
XA_MSB="0x3b"
XA_LSB="0x3c"
YA_MSB="0x3d"
YA_LSB="0x3e"
ZA_MSB="0x3f"
ZA_LSB="0x40"
TEMP_M="0x41"
TEMP_L="0x42"
XG_MSB="0x43"
XG_LSB="0x44"
YG_MSB="0x45"
YG_LSB="0x46"
ZG_MSB="0x47"
ZG_LSB="0x48"

mpu6050_set()
{
    i2c-ctl "$dev" @"$I2C_SLAVE_ADDRESS" set "$1" "$2"
}
mpu6050_get()
{
    arr=()
    while [ -n "$1" ]
    do
        arr+=("get" "$1")
        shift
    done
    
    i2c-ctl --format $'%02hhd\n' "$dev" @"$I2C_SLAVE_ADDRESS" "${arr[@]}"
}

# first argument is path to local I2C device (master), defaults to /dev/i2c-1 (i2c_arm on RPi)
dev="${1:-/dev/i2c-1}"

# set update interval in seconds:
interval_s="0.5"

# exit whenever any error occurs:
set -e

# reset device, and wait for reset:
mpu6050_set $PWR_M1 0x80
sleep 0.1

# start device, and wait for start:
mpu6050_set $PWR_M1 0x00
sleep 0.1

# configure device:
mpu6050_set $CONF_R 0x01
mpu6050_set $G_CONF 0x00
mpu6050_set $A_CONF 0x10

echo "note: Reading from MPU-6050 every $interval_s seconds. Use CTRL+C (interrupt signal) to stop..." >&2

while true
do
    values=($(mpu6050_get "$XA_MSB" "$XA_LSB" "$YA_MSB" "$YA_LSB" "$ZA_MSB" "$ZA_LSB" "$TEMP_M" "$TEMP_L" "$XG_MSB" "$XG_LSB" "$YG_MSB" "$YG_LSB" "$ZG_MSB" "$ZG_LSB"))
    
    echo "{\"accelerometer\": {\"x\": $(( ${values[0]} * 256 + ${values[1]} )), \"y\": $(( ${values[2]} * 256 + ${values[3]} )), \"z\": $(( ${values[4]} * 256 + ${values[5]} ))}, \"temperature\": $(( ${values[6]} * 256 + ${values[7]} )), \"gyroscope\": {\"x\": $(( ${values[8]} * 256 + ${values[9]} )), \"y\": $(( ${values[10]} * 256 + ${values[11]} )), \"z\": $(( ${values[12]} * 256 + ${values[13]} ))}}"
    
    sleep "$interval_s"
done

