DEFAULT_INPUT_MAXSIZE=10000000 \
gdb --args \
    ./qemu-videzzo-aarch64-target-videzzo-fuzz-xlnx-dp \
    -max_len=10000000 -detect_leaks=0 \
    ./poc-qemu-videzzo-aarch64-target-videzzo-fuzz-xlnx-dp-crash-8070de484ac8d4d9bfff9b439311058e05b8b40f.minimized
