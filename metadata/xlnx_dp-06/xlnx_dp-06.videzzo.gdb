DEFAULT_INPUT_MAXSIZE=10000000 \
gdb --args \
    ./qemu-videzzo-aarch64-target-videzzo-fuzz-xlnx-dp \
    -max_len=10000000 -detect_leaks=0 \
    ./crash-c15714102f0b894dea5c22f38852311567380926.minimized
