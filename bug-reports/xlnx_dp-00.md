# Abort in xlnx_dp_aux_set_command()

# Abort when runs into unsupported AUXCommand in xlnx_dp_aux_set_command

When fuzzing the xlnx-dp, we found a crash in xlnx_dp_aux_set_command. When the
command leads to the default branch, xlxn-dp will abort and then crash.

```
// xlnx_dp_aux_set_command
static void xlnx_dp_aux_set_command(XlnxDPState *s, uint32_t value)
{
     AUXCommand cmd = (value & AUX_COMMAND_MASK) >> AUX_COMMAND_SHIFT;
    switch (cmd) {
    case READ_AUX:
    case READ_I2C:
    case READ_I2C_MOT:
        // omit
        break;
    case WRITE_AUX:
    case WRITE_I2C:
        // omit
        break;
    case WRITE_I2C_STATUS:
        qemu_log_mask(LOG_UNIMP, "xlnx_dp: Write i2c status not implemented\n");
        break;
    default:
        error_report("%s: invalid command: %u", __func__, cmd);
        abort(); // <- crash here
    }
}
```

## More details

### Hypervisor, hypervisor version, upstream commit/tag, host

qemu, 7.0.91, c669f22f1a47897e8d1d595d6b8a59a572f9158c, Ubuntu 20.04

### VM architecture, device, device type

aarch64, xlnx_dp, display

### Bug Type: Abort

### Stack traces, crash details

```
root@37d14d202b64:~/videzzo/videzzo_qemu/out-san# ./qemu-videzzo-aarch64-target-videzzo-fuzz-xlnx-dp crash-unsupported-auxcommand-in-xlnx_dp_aux_set_command
==620282==WARNING: ASan doesn't fully support makecontext/swapcontext functions and may produce false positives in some cases!
INFO: found LLVMFuzzerCustomMutator (0x561998b5a8f0). Disabling -len_control by default.
INFO: Running with entropic power schedule (0xFF, 100).
INFO: Seed: 750307424
INFO: Loaded 1 modules   (618189 inline 8-bit counters): 618189 [0x56199bcb0000, 0x56199bd46ecd), 
INFO: Loaded 1 PC tables (618189 PCs): 618189 [0x56199b340f20,0x56199bcafbf0), 
./qemu-videzzo-aarch64-target-videzzo-fuzz-xlnx-dp: Running 1 inputs 1 time(s) each.
INFO: Reading pre_seed_input if any ...
INFO: Executing pre_seed_input if any ...
INFO: -max_len is not provided; libFuzzer will not generate inputs larger than 4096 bytes
Matching objects by name , *.core*, *.v_blend*, *.av_buffer_manager*, *.audio*
This process will fuzz the following MemoryRegions:
  * xlnx.v-dp.av_buffer_manager[0] (size 238)
  * xlnx.v-dp.core[0] (size 3b0)
  * xlnx.v-dp.v_blend[0] (size 1e0)
  * xlnx.v-dp.audio[0] (size 50)
This process will fuzz through the following interfaces:
  * clock_step, EVENT_TYPE_CLOCK_STEP, 0xffffffff +0xffffffff, 255,255
  * xlnx.v-dp.core, EVENT_TYPE_MMIO_READ, 0xfd4a0000 +0x3b0, 4,4
  * xlnx.v-dp.core, EVENT_TYPE_MMIO_WRITE, 0xfd4a0000 +0x3b0, 4,4
  * xlnx.v-dp.v_blend, EVENT_TYPE_MMIO_READ, 0xfd4aa000 +0x1e0, 4,4
  * xlnx.v-dp.v_blend, EVENT_TYPE_MMIO_WRITE, 0xfd4aa000 +0x1e0, 4,4
  * xlnx.v-dp.av_buffer_manager, EVENT_TYPE_MMIO_READ, 0xfd4ab000 +0x238, 4,4
  * xlnx.v-dp.av_buffer_manager, EVENT_TYPE_MMIO_WRITE, 0xfd4ab000 +0x238, 4,4
  * xlnx.v-dp.audio, EVENT_TYPE_MMIO_READ, 0xfd4ac000 +0x50, 1,4
  * xlnx.v-dp.audio, EVENT_TYPE_MMIO_WRITE, 0xfd4ac000 +0x50, 1,4
INFO: A corpus is not provided, starting from an empty corpus
#2      INITED cov: 3 ft: 4 corp: 1/1b exec/s: 0 rss: 487Mb
Running: crash-unsupported-auxcommand-in-xlnx_dp_aux_set_command
aarch64: xlnx_dp_aux_set_command: invalid command: 14
==620282== ERROR: libFuzzer: deadly signal
    #0 0x561993f3b6ee in __sanitizer_print_stack_trace /root/llvm-project/compiler-rt/lib/asan/asan_stack.cpp:86:3
    #1 0x561993e8a361 in fuzzer::PrintStackTrace() /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerUtil.cpp:210:38
    #2 0x561993e63ba6 in fuzzer::Fuzzer::CrashCallback() (.part.0) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerLoop.cpp:235:18
    #3 0x561993e63c72 in fuzzer::Fuzzer::CrashCallback() /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerLoop.cpp:207:1
    #4 0x561993e63c72 in fuzzer::Fuzzer::StaticCrashSignalCallback() /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerLoop.cpp:206:19
    #5 0x7fd8e8a3341f  (/lib/x86_64-linux-gnu/libpthread.so.0+0x1441f)
    #6 0x7fd8e884500a in __libc_signal_restore_set /build/glibc-SzIz7B/glibc-2.31/signal/../sysdeps/unix/sysv/linux/internal-signals.h:86:3
    #7 0x7fd8e884500a in raise /build/glibc-SzIz7B/glibc-2.31/signal/../sysdeps/unix/sysv/linux/raise.c:48:3
    #8 0x7fd8e8824858 in abort /build/glibc-SzIz7B/glibc-2.31/stdlib/abort.c:79:7
    #9 0x561993f6bc3a in __wrap_abort /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/videzzo/less_crashes_wrappers.c:24:12
    #10 0x56199488d3e6 in xlnx_dp_aux_set_command /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/display/xlnx_dp.c:536:9
    #11 0x5619948899f2 in xlnx_dp_write /root/videzzo/videzzo_qemu/qemu/build-san-6/../hw/display/xlnx_dp.c:800:9
    #12 0x561997b0fa63 in memory_region_write_accessor /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/memory.c:492:5
    #13 0x561997b0f3a1 in access_with_adjusted_size /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/memory.c:554:18
    #14 0x561997b0dcc6 in memory_region_dispatch_write /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/memory.c:1514:16
    #15 0x561997b9be7e in flatview_write_continue /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/physmem.c:2825:23
    #16 0x561997b89fbb in flatview_write /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/physmem.c:2867:12
    #17 0x561997b89a78 in address_space_write /root/videzzo/videzzo_qemu/qemu/build-san-6/../softmmu/physmem.c:2963:18
    #18 0x561993f777db in qemu_writel /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/videzzo/videzzo_qemu.c:1050:5
    #19 0x561993f75c5e in dispatch_mmio_write /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/videzzo/videzzo_qemu.c:1143:28
    #20 0x561998b569cf in videzzo_dispatch_event /root/videzzo/videzzo.c:1117:5
    #21 0x561998b4da53 in __videzzo_execute_one_input /root/videzzo/videzzo.c:256:9
    #22 0x561998b4d8a0 in videzzo_execute_one_input /root/videzzo/videzzo.c:297:9
    #23 0x561993f7e81c in videzzo_qemu /root/videzzo/videzzo_qemu/qemu/build-san-6/../tests/qtest/videzzo/videzzo_qemu.c:1418:12
    #24 0x561998b5ab92 in LLVMFuzzerTestOneInput /root/videzzo/videzzo.c:1921:18
    #25 0x561993e646dd in fuzzer::Fuzzer::ExecuteCallback(unsigned char*, unsigned long) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerLoop.cpp:589:17
    #26 0x561993e47464 in fuzzer::RunOneTest(fuzzer::Fuzzer*, char const*, unsigned long) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerDriver.cpp:323:21
    #27 0x561993e523de in fuzzer::FuzzerDriver(int*, char***, int (*)(unsigned char*, unsigned long)) /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerDriver.cpp:882:19
    #28 0x561993e3e9e6 in main /root/llvm-project/compiler-rt/lib/fuzzer/FuzzerMain.cpp:20:30
    #29 0x7fd8e8826082 in __libc_start_main /build/glibc-SzIz7B/glibc-2.31/csu/../csu/libc-start.c:308:16
    #30 0x561993e3ea3d in _start (/root/videzzo/videzzo_qemu/out-san/qemu-videzzo-aarch64-target-videzzo-fuzz-xlnx-dp+0x3287a3d)

NOTE: libFuzzer has rudimentary signal handlers.
      Combine libFuzzer with AddressSanitizer or similar for better crash reports.
SUMMARY: libFuzzer: deadly signal
MS: 0 ; base unit: 0000000000000000000000000000000000000000
0x1,0x9,0x0,0x1,0x4a,0xfd,0x0,0x0,0x0,0x0,0x4,0x0,0x0,0x0,0x4,0x7e,0x0,0x0,0x0,0x0,0x0,0x0,
\x01\x09\x00\x01J\xfd\x00\x00\x00\x00\x04\x00\x00\x00\x04~\x00\x00\x00\x00\x00\x00
```

### Reproducer steps

``` bash
#!/bin/bash -x
cat << EOF | /path/to/qemu-system-aarch64 \
-machine xlnx-zcu102,accel=qtest -qtest stdio -monitor none -serial none \
-display none -nodefaults -qtest stdio
writel 0xfd4a0100 0x7e04
EOF
```

## Contact

Let us know if I need to provide more information.
