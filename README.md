# mpu6050-i2c
Simple tool to poll JSON data from MPU-6050 module (for Linux).

# Install

## Download and install

Download and install the dependency: [i2c-ctl](https://github.com/jetibest/i2c-ctl-linux/).

```sh
git clone https://github.com/jetibest/mpu6050-i2c && cd mpu6050-i2c/ && ./install.sh
```

## Enable I2C for Linux

Load the proper modules for I2C.
On RPi you must add `dtparam=i2c_arm=on` to `/boot/config.txt` (`i2c_arm` is GPIO2 and GPIO3, I2C bus 1: `/dev/i2c-1`).
Ensure to load `i2c-dev` as well: `[sudo] modprobe i2c-dev`.

## Example usage

```sh
mpu6050-i2c /dev/i2c-1
```

Note: Any configuration changes to `mpu6050-i2c.sh`, requires `./install.sh` to be executed again.
