#!/bin/sh
cd ../sim;
rm -rf xcelium.d/ .simvision/ waves.shm/ xrun.key
xrun -uvmnocdnsextra -uvmhome $UVM_HOME -64BIT -errormax 5 -linedebug -assert -l compile.log -nowarn NSVCER -nowarn DSEMEL -nowarn SPDUSD -access +rwc $2 $3 $4 -incdir /opt/cadence/XCELIUM1803/tools/amsd/wrealSamples/wrealModels/pll -incdir /opt/cadence/XCELIUM1803/tools/affirma_ams/etc/dms/EE_pkg_examples -incdir ../dut -incdir ../dut/vams -incdir ../dut/bind -incdir ../env -incdir ../tests $UVM_HOME/src/uvm_macros.svh /ws/examples/SVRNM_dx/common/packages/mymath_pkg.sv /opt/cadence/XCELIUM1803/tools.lnx86/affirma_ams/etc/dms/cds_rnm_pkg.sv -f ../sim/files_assert.f ../dut/top_dut.sv ../dut/top_tb.sv +define+$1 -timescale 1ns/1ps -amsconnrules Cust_full_fast +UVM_TESTNAME=top_test -clean;
