DEFAULT_INPUT_MAXSIZE=10000000 \
gdb --args \
    ./qemu-videzzo-arm-target-videzzo-fuzz-lan9118 \
    -max_len=10000000 -detect_leaks=0 \
    poc-qemu-videzzo-arm-target-videzzo-fuzz-lan9118-crash-563d033ca04f55f8e1119d81d40ce60d8989cef1.minimized
