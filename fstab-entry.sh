#!/bin/bash
fstab=/etc/fstab

if ! grep "library-share" "$fstab";
# forgiving me for being a bit of over-rigorous, you might want to change this matching word, as below, 'poky-disc' merely a comment, not exactly a config line, so
then
    sudo su -c "echo '#library-share' >> /etc/fstab"
    sudo su -c "echo 'PARTUUID=aea59895-02 /mnt/library ext4 defaults, nofail 0 0' >> /etc/fstab"
else
    echo "Entry in fstab exists."
fi
