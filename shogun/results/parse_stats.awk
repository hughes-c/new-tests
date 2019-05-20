BEGIN {
   l2Loads = 0;
   l2Stores = 0;
   hbmLoads = 0;
   hbmStores = 0;

   cycleTime = 1/clock;
   totalTime = cycleTime * cycles;
}


/l2gcache/{
   numElements = split($0, a, ",");

   if( match(a[2], "GetS_recv") )
   {
      l2Loads = l2Loads + a[7];
   }
   else if( match(a[2], "GetX_recv" ) )
   {
      l2Stores = l2Stores + a[7];
   }
}

/hbm_/{
   numElements = split($0, a, ",");

   if( match(a[2], "received_GetSX") )
   {
   }
   else if( match(a[2], "received_GetS") )
   {
      hbmLoads = hbmLoads + a[7];
   }
   else if( match(a[2], "received_GetX" ) )
   {
      hbmStores = hbmStores + a[7];
   }
}

END {
   printf( "All done!\n" );
   printf( "Clock:  %5.4e  Cycle Time: %5.4e  Cycles: %5.4e  Kernel Time: %5.4e\n", clock, cycleTime, cycles, totalTime);
   printf( "%d %d\n", l2Loads, l2Loads * dataSize);
   printf( "%d %d\n", l2Stores, l2Stores * dataSize);
   printf( "%d %d\n", hbmLoads, hbmLoads * dataSize);
   printf( "%d %d\n", hbmStores, hbmStores * dataSize);

   l2_ld_bw = (l2Loads*32)/totalTime;
   l2_st_bw = (l2Stores*32)/totalTime;

   hbm_ld_bw = (hbmLoads*32)/totalTime;
   hbm_st_bw = (hbmStores*32)/totalTime;

   printf( "L2 Loads %d; Stores %d; LD BW %e GB/s; ST BW %e GB/s\n", l2Loads, l2Stores, l2_ld_bw, l2_st_bw/1e9);
   printf( "HBM Loads %d; Stores %d; LD BW %d GB/s; ST BW %d GB/s\n", hbmLoads, hbmStores, hbm_ld_bw/1e9, hbm_st_bw/1e9);
   printf( "\n" );
}
