# Out of bounds write in ati_2d_blt()

With the patch
https://lore.kernel.org/qemu-devel/20210906153103.1661195-1-philmd@redhat.com/,
I still can trigger another out-of-bounds write.



## More details

### Hypervisor, hypervisor version, upstream commit/tag, host

qemu, 7.0.94, 9a99f964b152f8095949bbddca7841744ad418da, Ubuntu 20.04

### VM architecture, device, device type

i386, ati, display

### Bug Type: Out-of-bounds Write

### Stack traces, crash details

```
root@7e126d11f8d1:~/videzzo/videzzo_qemu/out-san# DEFAULT_INPUT_MAXSIZE=10000000 /root/videzzo/videzzo_qemu/out-san/qemu-videzzo-i386-target-videzzo-fuzz-ati  -max_len=10000000 -detect_leaks=0 /root/videzzo/videzzo_qemu/out-san/poc-qemu-videzzo-i386-target-videzzo-fuzz-ati-crash-03fba6b48f66f3e5fd4c78c14d35f0c0b71064a0.minimized
==15151==WARNING: ASan doesn't fully support makecontext/swapcontext functions and may produce false positives in some cases!
INFO: found LLVMFuzzerCustomMutator (0x5577eb150810). Disabling -len_control by default.
INFO: Running with entropic power schedule (0xFF, 100).
INFO: Seed: 731252283
INFO: Loaded 1 modules   (423518 inline 8-bit counters): 423518 [0x5577ed7db000, 0x5577ed84265e), 
INFO: Loaded 1 PC tables (423518 PCs): 423518 [0x5577ed163ee0,0x5577ed7da4c0), 
/root/videzzo/videzzo_qemu/out-san/qemu-videzzo-i386-target-videzzo-fuzz-ati: Running 1 inputs 1 time(s) each.
INFO: Reading pre_seed_input if any ...
INFO: Executing pre_seed_input if any ...
Matching objects by name , *ati.mmregs*
This process will fuzz the following MemoryRegions:
  * ati.mmregs[0] (size 4000)
This process will fuzz through the following interfaces:
  * clock_step, EVENT_TYPE_CLOCK_STEP, 0xffffffff +0xffffffff, 255,255
  * ati.mmregs, EVENT_TYPE_MMIO_READ, 0xe1000000 +0x4000, 1,4
  * ati.mmregs, EVENT_TYPE_MMIO_WRITE, 0xe1000000 +0x4000, 1,4
INFO: A corpus is not provided, starting from an empty corpus
30/08/2022 18:36:51 ConnectClientToTcpAddr6: getaddrinfo (Name or service not known)
#2      INITED cov: 4 ft: 5 corp: 1/1b exec/s: 0 rss: 191Mb
Running: /root/videzzo/videzzo_qemu/out-san/poc-qemu-videzzo-i386-target-videzzo-fuzz-ati-crash-03fba6b48f66f3e5fd4c78c14d35f0c0b71064a0.minimized
30/08/2022 18:36:51 VNC server supports protocol version 3.8 (viewer 3.8)
30/08/2022 18:36:51 We have 1 security types to read
30/08/2022 18:36:51 0) Received security type 1
30/08/2022 18:36:51 Selecting security type 1 (0/1 in the list)
30/08/2022 18:36:51 Selected Security Scheme 1
30/08/2022 18:36:51 No authentication needed
30/08/2022 18:36:51 VNC authentication succeeded
30/08/2022 18:36:51 Desktop name "QEMU"
30/08/2022 18:36:51 Connected to VNC server, using protocol version 3.8
30/08/2022 18:36:51 VNC server default format:
30/08/2022 18:36:51   32 bits per pixel.
30/08/2022 18:36:51   Least significant byte first in each pixel.
30/08/2022 18:36:51   TRUE colour: max red 255 green 255 blue 255, shift red 16 green 8 blue 0
AddressSanitizer:DEADLYSIGNAL
=================================================================
==15151==ERROR: AddressSanitizer: SEGV on unknown address 0x7f8eac200000 (pc 0x7f8ed4b7c0fb bp 0x0000ac1ffef4 sp 0x7ffd754cb638 T0)
==15151==The signal is caused by a WRITE memory access.
    #0 0x7f8ed4b7c0fb  (/lib/x86_64-linux-gnu/libpixman-1.so.0+0x6e0fb)
    #1 0x7f8ed4b60d0d  (/lib/x86_64-linux-gnu/libpixman-1.so.0+0x52d0d)
    #2 0x7f8ed4b197de in pixman_fill (/lib/x86_64-linux-gnu/libpixman-1.so.0+0xb7de)
    #3 0x5577e80aaa54 in ati_2d_blt /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/display/ati_2d.c:186:9
    #4 0x5577e80934e9 in ati_mm_write /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/display/ati.c:832:9
    #5 0x5577ea0df613 in memory_region_write_accessor /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/memory.c:492:5
    #6 0x5577ea0def51 in access_with_adjusted_size /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/memory.c:554:18
    #7 0x5577ea0dd85c in memory_region_dispatch_write /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/memory.c:1514:16
    #8 0x5577ea16828e in flatview_write_continue /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/physmem.c:2825:23
    #9 0x5577ea15660b in flatview_write /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/physmem.c:2867:12
    #10 0x5577ea1560c8 in address_space_write /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/physmem.c:2963:18
    #11 0x5577e7928e3b in qemu_writel /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/videzzo/videzzo_qemu.c:1072:5
    #12 0x5577e79272b7 in dispatch_mmio_write /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/videzzo/videzzo_qemu.c:1196:28
    #13 0x5577eb14c1cf in videzzo_dispatch_event /root/videzzo/videzzo.c:1122:5
    #14 0x5577eb14354b in __videzzo_execute_one_input /root/videzzo/videzzo.c:272:9
    #15 0x5577eb143420 in videzzo_execute_one_input /root/videzzo/videzzo.c:313:9
    #16 0x5577e792fe7c in videzzo_qemu /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/videzzo/videzzo_qemu.c:1471:12
    #17 0x5577eb150ab2 in LLVMFuzzerTestOneInput /root/videzzo/videzzo.c:1891:18
    #18 0x5577e781273d in fuzzer::Fuzzer::ExecuteCallback(unsigned char*, unsigned long) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerLoop.cpp:589:17
    #19 0x5577e77f54c4 in fuzzer::RunOneTest(fuzzer::Fuzzer*, char const*, unsigned long) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerDriver.cpp:323:21
    #20 0x5577e780043e in fuzzer::FuzzerDriver(int*, char***, int (*)(unsigned char*, unsigned long)) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerDriver.cpp:882:19
    #21 0x5577e77eca46 in main /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerMain.cpp:20:30
    #22 0x7f8ed2f8f082 in __libc_start_main /build/glibc-SzIz7B/glibc-2.31/csu/../csu/libc-start.c:308:16
    #23 0x5577e77eca9d in _start (/root/videzzo/videzzo_qemu/out-san/qemu-videzzo-i386-target-videzzo-fuzz-ati+0x265ba9d)

AddressSanitizer can not provide additional info.
SUMMARY: AddressSanitizer: SEGV (/lib/x86_64-linux-gnu/libpixman-1.so.0+0x6e0fb) 
==15151==ABORTING
MS: 0 ; base unit: 0000000000000000000000000000000000000000
0x1,0x9,0xe4,0x16,0x0,0xe1,0x0,0x0,0x0,0x0,0x1,0x0,0x0,0x0,0xb5,0xc3,0x4c,0x28,0x0,0x0,0x0,0x0,0x1,0x9,0xc4,0x16,0x0,0xe1,0x0,0x0,0x0,0x0,0x2,0x0,0x0,0x0,0xc2,0xc5,0xc1,0x3c,0x0,0x0,0x0,0x0,0x1,0x9,0x38,0x14,0x0,0xe1,0x0,0x0,0x0,0x0,0x4,0x0,0x0,0x0,0xc2,0x62,0xd0,0x5b,0x0,0x0,0x0,0x0,0x1,0x9,0x3c,0x14,0x0,0xe1,0x0,0x0,0x0,0x0,0x4,0x0,0x0,0x0,0xc2,0x62,0xd0,0x5b,0x0,0x0,0x0,0x0,
\x01\x09\xe4\x16\x00\xe1\x00\x00\x00\x00\x01\x00\x00\x00\xb5\xc3L(\x00\x00\x00\x00\x01\x09\xc4\x16\x00\xe1\x00\x00\x00\x00\x02\x00\x00\x00\xc2\xc5\xc1<\x00\x00\x00\x00\x01\x098\x14\x00\xe1\x00\x00\x00\x00\x04\x00\x00\x00\xc2b\xd0[\x00\x00\x00\x00\x01\x09<\x14\x00\xe1\x00\x00\x00\x00\x04\x00\x00\x00\xc2b\xd0[\x00\x00\x00\x00
30/08/2022 18:36:52 VNC server closed connection
```

## Existing patches

https://github.com/qemu/qemu/commit/205ccfd7a5ec86bd9a5678b8bd157562fc9a1643

## Contact

Let us know if I need to provide more information.
