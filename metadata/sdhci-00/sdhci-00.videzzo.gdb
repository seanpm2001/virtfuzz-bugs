DEFAULT_INPUT_MAXSIZE=10000000 \
gdb --args ./qemu-videzzo-i386-target-videzzo-fuzz-sdhci-v3 \
    -max_len=10000000 \
    -detect_leaks=0 \
    ./poc-qemu-videzzo-i386-target-videzzo-fuzz-sdhci-v3-crash-c756d97d60ad4f08f32c7c149ae5149392f1a2ac.minimized
