# Head UAF in usb_cancel_packet

## More technique details

### Hypervisor, hypervisor version, upstream commit/tag, host
qemu, 7.0.50, c669f22f1a47897e8d1d595d6b8a59a572f9158c, Ubuntu 20.04

### VM architecture, device, device type
i386, ohci, usb

### Bug Type: Heap UAF

### Stack traces, crash details

```
root@933c2b01a079:~/videzzo/videzzo_qemu/out-san# DEFAULT_INPUT_MAXSIZE=10000000 /root/videzzo/videzzo_qemu/out-san/qemu-videzzo-i386-target-videzzo-fuzz-ohci  -max_len=10000000 poc-qemu-videzzo-i386-target-videzzo-fuzz-ohci-crash-4707b65e8650a05d33feb91239ae40c80006d461
==154633==WARNING: ASan doesn't fully support makecontext/swapcontext functions and may produce false positives in some cases!
INFO: found LLVMFuzzerCustomMutator (0x557de9c547b0). Disabling -len_control by default.
INFO: Running with entropic power schedule (0xFF, 100).
INFO: Seed: 2574164221
INFO: Loaded 1 modules   (423101 inline 8-bit counters): 423101 [0x557dec2da000, 0x557dec3414bd), 
INFO: Loaded 1 PC tables (423101 PCs): 423101 [0x557debc64af0,0x557dec2d96c0), 
/root/videzzo/videzzo_qemu/out-san/qemu-videzzo-i386-target-videzzo-fuzz-ohci: Running 1 inputs 1 time(s) each.
INFO: Reading pre_seed_input if any ...
INFO: Executing pre_seed_input if any ...
Matching objects by name , *ohci*
This process will fuzz the following MemoryRegions:
  * ohci[0] (size 100)
This process will fuzz through the following interfaces:
  * clock_step, EVENT_TYPE_CLOCK_STEP, 0xffffffff +0xffffffff, 255,255
  * ohci, EVENT_TYPE_MMIO_READ, 0xe0000000 +0x100, 1,4
  * ohci, EVENT_TYPE_MMIO_WRITE, 0xe0000000 +0x100, 1,4
INFO: A corpus is not provided, starting from an empty corpus
#2      INITED cov: 3 ft: 4 corp: 1/1b exec/s: 0 rss: 193Mb
Running: poc-qemu-videzzo-i386-target-videzzo-fuzz-ohci-crash-4707b65e8650a05d33feb91239ae40c80006d461
i386: usb-msd: Bad CBW size
=================================================================
==154633==ERROR: AddressSanitizer: heap-use-after-free on address 0x60d000006640 at pc 0x557de77fe577 bp 0x7fff5746aa20 sp 0x7fff5746aa18
WRITE of size 8 at 0x60d000006640 thread T0
    #0 0x557de77fe576 in usb_cancel_packet /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/usb/core.c:522:5
    #1 0x557de788af61 in ohci_child_detach /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/usb/hcd-ohci.c:1740:9
    #2 0x557de7889a3d in ohci_detach /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/usb/hcd-ohci.c:1751:5
    #3 0x557de77eca21 in usb_detach /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/usb/core.c:70:5
    #4 0x557de77ecd51 in usb_port_reset /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/usb/core.c:79:5
    #5 0x557de788204a in ohci_roothub_reset /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/usb/hcd-ohci.c:314:13
    #6 0x557de78bb5d6 in ohci_set_ctl /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/usb/hcd-ohci.c:1336:9
    #7 0x557de78b5d2e in ohci_mem_write /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/usb/hcd-ohci.c:1591:9
    #8 0x557de8be4403 in memory_region_write_accessor /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/memory.c:492:5
    #9 0x557de8be3d41 in access_with_adjusted_size /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/memory.c:554:18
    #10 0x557de8be264c in memory_region_dispatch_write /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/memory.c:1514:16
    #11 0x557de8c6d07e in flatview_write_continue /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/physmem.c:2825:23
    #12 0x557de8c5b3fb in flatview_write /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/physmem.c:2867:12
    #13 0x557de8c5aeb8 in address_space_write /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/physmem.c:2963:18
    #14 0x557de643183b in qemu_writel /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/videzzo/videzzo_qemu.c:1067:5
    #15 0x557de642fcbe in dispatch_mmio_write /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/videzzo/videzzo_qemu.c:1160:28
    #16 0x557de9c5016f in videzzo_dispatch_event /root/videzzo/videzzo.c:1118:5
    #17 0x557de9c4744b in __videzzo_execute_one_input /root/videzzo/videzzo.c:256:9
    #18 0x557de9c47320 in videzzo_execute_one_input /root/videzzo/videzzo.c:297:9
    #19 0x557de643887c in videzzo_qemu /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/videzzo/videzzo_qemu.c:1435:12
    #20 0x557de9c54a52 in LLVMFuzzerTestOneInput /root/videzzo/videzzo.c:1883:18
    #21 0x557de631e73d in fuzzer::Fuzzer::ExecuteCallback(unsigned char*, unsigned long) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerLoop.cpp:589:17
    #22 0x557de631f3b6 in fuzzer::Fuzzer::TryDetectingAMemoryLeak(unsigned char*, unsigned long, bool) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerLoop.cpp:674:18
    #23 0x557de630152f in fuzzer::RunOneTest(fuzzer::Fuzzer*, char const*, unsigned long) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerDriver.cpp:328:31
    #24 0x557de630c43e in fuzzer::FuzzerDriver(int*, char***, int (*)(unsigned char*, unsigned long)) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerDriver.cpp:882:19
    #25 0x557de62f8a46 in main /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerMain.cpp:20:30
    #26 0x7f9a9f7c7082 in __libc_start_main /build/glibc-SzIz7B/glibc-2.31/csu/../csu/libc-start.c:308:16
    #27 0x557de62f8a9d in _start (/root/videzzo/videzzo_qemu/out-san/qemu-videzzo-i386-target-videzzo-fuzz-ohci+0x2655a9d)

0x60d000006640 is located 112 bytes inside of 136-byte region [0x60d0000065d0,0x60d000006658)
freed by thread T0 here:
    #0 0x557de63eba27 in __interceptor_free /root/llvm-project/compiler-rt/lib/asan/asan_malloc_linux.cpp:127:3
    #1 0x557de789cb89 in ohci_service_iso_td /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/usb/hcd-ohci.c:725:9
    #2 0x557de78918b1 in ohci_service_ed_list /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/usb/hcd-ohci.c:1115:21
    #3 0x557de7884689 in ohci_frame_boundary /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/usb/hcd-ohci.c:1181:9
    #4 0x557de9a0021e in timerlist_run_timers /root/videzzo/videzzo_qemu/qemu/build-san-6/../util/qemu-timer.c:576:9
    #5 0x557de9a0054c in qemu_clock_run_timers /root/videzzo/videzzo_qemu/qemu/build-san-6/../util/qemu-timer.c:590:12
    #6 0x557de8c92a44 in qtest_clock_warp /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/qtest.c:358:9
    #7 0x557de8c91916 in qtest_process_command /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/qtest.c:751:9
    #8 0x557de8c84f8d in qtest_process_inbuf /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/qtest.c:796:9
    #9 0x557de8c84caf in qtest_server_inproc_recv /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/qtest.c:927:9
    #10 0x557de95ea9c5 in send_wrapper /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/libqtest.c:1386:5
    #11 0x557de95e4c81 in qtest_sendf /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/libqtest.c:453:5
    #12 0x557de95e4e45 in qtest_clock_step /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/libqtest.c:810:5
    #13 0x557de64342c1 in dispatch_clock_step /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/videzzo/videzzo_qemu.c:1202:5
    #14 0x557de9c5016f in videzzo_dispatch_event /root/videzzo/videzzo.c:1118:5
    #15 0x557de9c4df1c in dispatch_group_event /root/videzzo/videzzo.c:1013:9
    #16 0x557de9c5016f in videzzo_dispatch_event /root/videzzo/videzzo.c:1118:5
    #17 0x557de9c4744b in __videzzo_execute_one_input /root/videzzo/videzzo.c:256:9
    #18 0x557de9c47320 in videzzo_execute_one_input /root/videzzo/videzzo.c:297:9
    #19 0x557de643887c in videzzo_qemu /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/videzzo/videzzo_qemu.c:1435:12
    #20 0x557de9c54a52 in LLVMFuzzerTestOneInput /root/videzzo/videzzo.c:1883:18
    #21 0x557de631e73d in fuzzer::Fuzzer::ExecuteCallback(unsigned char*, unsigned long) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerLoop.cpp:589:17
    #22 0x557de631f3b6 in fuzzer::Fuzzer::TryDetectingAMemoryLeak(unsigned char*, unsigned long, bool) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerLoop.cpp:674:18
    #23 0x557de630152f in fuzzer::RunOneTest(fuzzer::Fuzzer*, char const*, unsigned long) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerDriver.cpp:328:31
    #24 0x557de630c43e in fuzzer::FuzzerDriver(int*, char***, int (*)(unsigned char*, unsigned long)) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerDriver.cpp:882:19
    #25 0x557de62f8a46 in main /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerMain.cpp:20:30
    #26 0x7f9a9f7c7082 in __libc_start_main /build/glibc-SzIz7B/glibc-2.31/csu/../csu/libc-start.c:308:16

previously allocated by thread T0 here:
    #0 0x557de63ebed7 in __interceptor_calloc /root/llvm-project/compiler-rt/lib/asan/asan_malloc_linux.cpp:154:3
    #1 0x7f9aa0a7eef0 in g_malloc0 (/lib/x86_64-linux-gnu/libglib-2.0.so.0+0x57ef0)
    #2 0x557de78918b1 in ohci_service_ed_list /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/usb/hcd-ohci.c:1115:21
    #3 0x557de7884689 in ohci_frame_boundary /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/usb/hcd-ohci.c:1181:9
    #4 0x557de9a0021e in timerlist_run_timers /root/videzzo/videzzo_qemu/qemu/build-san-6/../util/qemu-timer.c:576:9
    #5 0x557de9a0054c in qemu_clock_run_timers /root/videzzo/videzzo_qemu/qemu/build-san-6/../util/qemu-timer.c:590:12
    #6 0x557de8c92a44 in qtest_clock_warp /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/qtest.c:358:9
    #7 0x557de8c91916 in qtest_process_command /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/qtest.c:751:9
    #8 0x557de8c84f8d in qtest_process_inbuf /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/qtest.c:796:9
    #9 0x557de8c84caf in qtest_server_inproc_recv /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/qtest.c:927:9
    #10 0x557de95ea9c5 in send_wrapper /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/libqtest.c:1386:5
    #11 0x557de95e4c81 in qtest_sendf /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/libqtest.c:453:5
    #12 0x557de95e4e45 in qtest_clock_step /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/libqtest.c:810:5
    #13 0x557de64342c1 in dispatch_clock_step /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/videzzo/videzzo_qemu.c:1202:5
    #14 0x557de9c5016f in videzzo_dispatch_event /root/videzzo/videzzo.c:1118:5
    #15 0x557de9c4df1c in dispatch_group_event /root/videzzo/videzzo.c:1013:9
    #16 0x557de9c5016f in videzzo_dispatch_event /root/videzzo/videzzo.c:1118:5
    #17 0x557de9c4744b in __videzzo_execute_one_input /root/videzzo/videzzo.c:256:9
    #18 0x557de9c47320 in videzzo_execute_one_input /root/videzzo/videzzo.c:297:9
    #19 0x557de643887c in videzzo_qemu /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/videzzo/videzzo_qemu.c:1435:12
    #20 0x557de9c54a52 in LLVMFuzzerTestOneInput /root/videzzo/videzzo.c:1883:18
    #21 0x557de631e73d in fuzzer::Fuzzer::ExecuteCallback(unsigned char*, unsigned long) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerLoop.cpp:589:17
    #22 0x557de631f3b6 in fuzzer::Fuzzer::TryDetectingAMemoryLeak(unsigned char*, unsigned long, bool) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerLoop.cpp:674:18
    #23 0x557de630152f in fuzzer::RunOneTest(fuzzer::Fuzzer*, char const*, unsigned long) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerDriver.cpp:328:31
    #24 0x557de630c43e in fuzzer::FuzzerDriver(int*, char***, int (*)(unsigned char*, unsigned long)) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerDriver.cpp:882:19
    #25 0x557de62f8a46 in main /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerMain.cpp:20:30
    #26 0x7f9a9f7c7082 in __libc_start_main /build/glibc-SzIz7B/glibc-2.31/csu/../csu/libc-start.c:308:16

SUMMARY: AddressSanitizer: heap-use-after-free /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/usb/core.c:522:5 in usb_cancel_packet
Shadow bytes around the buggy address:
  0x0c1a7fff8c70: fd fd fd fd fd fd fd fd fd fd fd fd fd fa fa fa
  0x0c1a7fff8c80: fa fa fa fa fa fa fd fd fd fd fd fd fd fd fd fd
  0x0c1a7fff8c90: fd fd fd fd fd fd fd fa fa fa fa fa fa fa fa fa
  0x0c1a7fff8ca0: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c1a7fff8cb0: fd fa fa fa fa fa fa fa fa fa fd fd fd fd fd fd
=>0x0c1a7fff8cc0: fd fd fd fd fd fd fd fd[fd]fd fd fa fa fa fa fa
  0x0c1a7fff8cd0: fa fa fa fa fd fd fd fd fd fd fd fd fd fd fd fd
  0x0c1a7fff8ce0: fd fd fd fd fd fa fa fa fa fa fa fa fa fa fa fa
  0x0c1a7fff8cf0: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c1a7fff8d00: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c1a7fff8d10: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07 
  Heap left redzone:       fa
  Freed heap region:       fd
  Stack left redzone:      f1
  Stack mid redzone:       f2
  Stack right redzone:     f3
  Stack after return:      f5
  Stack use after scope:   f8
  Global redzone:          f9
  Global init order:       f6
  Poisoned by user:        f7
  Container overflow:      fc
  Array cookie:            ac
  Intra object redzone:    bb
  ASan internal:           fe
  Left alloca redzone:     ca
  Right alloca redzone:    cb
  Shadow gap:              cc
==154633==ABORTING
MS: 0 ; base unit: 0000000000000000000000000000000000000000
```

### Reproducer steps

DEFAULT_INPUT_MAXSIZE=10000000 /root/videzzo/videzzo_qemu/out-san/qemu-videzzo-i386-target-videzzo-fuzz-ohci  -max_len=10000000 poc-qemu-videzzo-i386-target-videzzo-fuzz-ohci-crash-4707b65e8650a05d33feb91239ae40c80006d461

## Contact

Let us know if I need to provide more information.