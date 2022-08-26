#!/bin/bash
export ASAN_OPTIONS=detect_leaks=0
export DEFAULT_INPUT_MAXSIZE=10000000
gdb --args \
    ./qemu-videzzo-i386-target-videzzo-fuzz-ohci ./crash-8cc902a05593b7cff5c12aedc22bd740ffcd824b  -max_len=10000000 -detect_leaks=0 -pre_seed_inputs=@ohci-02.videzzo.pre_seeds
