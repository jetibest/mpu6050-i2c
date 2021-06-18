#!/bin/sh
cp mpu6050-i2c.sh /usr/local/bin/mpu6050-i2c && echo "Installation successful. Uninstall using: rm -f /usr/local/bin/mpu6050-i2c" >&2 || echo "Permission denied? Try to run as root: sudo $0" >&2
