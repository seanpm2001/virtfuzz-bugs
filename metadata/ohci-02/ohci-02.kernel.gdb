# git pull
# git checkout -b ohci-02
# ./configure --target-list=x86_64-softmmu --enable-debug --disable-pie --enable-sanitizers
# make
gdb --args ../../../qemu/build/qemu-system-x86_64 \
    -M q35 -m 1G \
    -kernel ../../../buildroot-2022.02.4/output/images/bzImage \
    -drive file=../../../buildroot-2022.02.4/output/images/rootfs.ext2,if=virtio,format=raw \
    -append "root=/dev/vda console=ttyS0" \
    -net nic,model=virtio -net user \
    -usb \
    -device pci-ohci,num-ports=6 \
    -drive file=null-co://,if=none,format=raw,id=disk0 \
    -device usb-storage,port=1,drive=disk0 \
    -nographic
