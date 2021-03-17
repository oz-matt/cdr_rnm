#!/bin/sh
cd ../sim;
rm -rf xcelium.d/
xrun $1 -access +rw -incdir ../src ../src/cf.scs /opt/cadence/XCELIUM1803/tools/affirma_ams/etc/dms/EE_pkg.sv ../top.sv;
