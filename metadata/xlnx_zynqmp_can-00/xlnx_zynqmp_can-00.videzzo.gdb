DEFAULT_INPUT_MAXSIZE=10000000 \
gdb --args \
    qemu-videzzo-aarch64-target-videzzo-fuzz-xlnx-zynqmp-can \
    -max_len=10000000 -detect_leaks=0 \
    poc-qemu-videzzo-aarch64-target-videzzo-fuzz-xlnx-zynqmp-can-crash-97ef02583c679111ba6ad823f573f139fac7c72e.minimized
