# cp /root/videzzo/videzzo_qemu/out-san/qemu-videzzo-arm-target-videzzo-fuzz-pl041 .
# cp -r pc-bios /root/videzzo/videzzo_qemu/out-san/pc-bios .
ASAN_OPTIONS=detect_leaks=0 \
DEFAULT_INPUT_MAXSIZE=10000000 \
gdb --args \
    ./qemu-videzzo-arm-target-videzzo-fuzz-pl041 \
    -max_len=10000000 -detect_leaks=0 \
    crash-df71750b92bb03b6e9a6c02c19c6e468cdff8eba.minimized
