# git pull
# git checkout -b virtio-blk-00
# ./configure --target-list=x86_64-softmmu --enable-debug --disable-pie
# make
gdb --args ../../../qemu/build/qemu-system-x86_64 \
    -M q35 -m 1G \
    -kernel ../../../buildroot-2022.02.4/output/images/bzImage \
    -drive file=../../../buildroot-2022.02.4/output/images/rootfs.ext2,if=virtio,format=raw \
    -append "root=/dev/vdb console=ttyS0" \
    -net nic,model=virtio -net user \
    -device virtio-blk,drive=disk0 \
    -drive file=null-co://,id=disk0,if=none,format=raw \
    -nographic
