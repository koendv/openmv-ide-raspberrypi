#! /bin/sh

sudo apt-get install -y libpng* libusb-1.0 python-pip
sudo pip install pyusb

cat > /tmp/50-openmv.rules.$$ <<EOD
# OpenMV
# If you share your linux system with other users, or just don't like the
# idea of write permission for everybody, you can replace MODE:="0666" with
# OWNER:="yourusername" to create the device owned by you, or with
# GROUP:="somegroupname" and mange access using standard unix groups.
ATTRS{idVendor}=="1209", ATTRS{idProduct}=="abd1", ENV{ID_MM_DEVICE_IGNORE}="1"
ATTRS{idVendor}=="1209", ATTRS{idProduct}=="abd1", ENV{MTP_NO_PROBE}="1"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="openmvdfu"
KERNEL=="ttyACM*", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="abd1", MODE:="0666", SYMLINK+="openmvcam"
EOD

sudo cp /tmp/50-openmv.rules.$$ /etc/udev/rules.d/50-openmv.rules
sudo udevadm control --reload-rules

