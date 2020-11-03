# raspberry pi openmv-ide

Building and packaging the [openmv-ide](https://github.com/openmv/openmv-ide) on the raspberry pi for *raspios-buster-arm64*

![](screenshot.png) 

## Installation

Download the binary from [releases](https://github.com/koendv/openmv-ide-raspberrypi/releases) and install:

```
apt-get update
apt-get install p7zip-full
mkdir -p /opt/openmv-ide
cd /opt/openmv-ide
7z x openmv-ide-linux-arm64-2.6.6-installer-archive.7z
```

To run, type:
```
$ /opt/openmv-ide/bin/openmvide
```

## Building

Install prerequisites:
```
sudo apt-get update
sudo apt-get install qt5-default qtbase5-private-dev qtdeclarative5-dev libqt5serialport5-dev qttools5-dev-tools chrpath p7zip-full
```
Clone sources:
```
mkdir src
cd src
git clone --recursive https://github.com/openmv/openmv-ide.git
```
Remove nag screens:
```
cd ~/src/openmv-ide/qt-creator/
wget https://raw.githubusercontent.com/koendv/openmv-ide-raspberrypi/main/openmv-ide.patch
patch -p1 < openmv-ide.patch
```
Build:
```
cd ~/src/openmv-ide
./make.py
```
## Hardware

Notes about the camera hardware I'm using with OpenMV.

- [camera](https://www.aliexpress.com/item/1005001475058305.html) with lcd screen. Runs micropython.
- How to [install the lcd](https://m.bilibili.com/video/av286164536)
- camera [firmware](https://gitee.com/WeAct-TC/MiniSTM32H7xx/tree/master/SDK/openmv/Firmwares/)
- [tool](https://gitee.com/WeAct-TC/MiniSTM32H7xx/tree/master/Soft) to upload firmware to the camera
- [3d-printable box](https://github.com/koendv/weact-mini-stm32h7xx-box/) for the camera

*not truncated*
