
database -open -shm -into waves.shm waves -default

probe -create -database waves -all -depth all top

probe -create -database waves top_tb.dut.dut_top_assert -assertdebug -transaction
