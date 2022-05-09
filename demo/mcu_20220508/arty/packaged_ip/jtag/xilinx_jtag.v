
module xilinx_jtag(
		   input  clk,
		   input  rst_n,

		   output reset,
		   output TCK,
		   output TDI,
		   output TMS,
		   input  TDO,
		   output sel1,
		   output sel2
		   );

   wire 		  tck_internal;

   BUFG tck_buf(
		.I (tck_internal),
		.O (TCK)
		);

   BSCANE2 #(
	     .DISABLE_JTAG("FALSE"),
	     .JTAG_CHAIN(3)
	     )
   bscane2_user3(
		 .DRCK (),
		 .RESET (reset),
		 .RUNTEST (),
		 .CAPTURE (),
		 .SEL (sel1),
		 .SHIFT (),
		 .TCK (tck_internal),
		 .TDI (TDI),
		 .TMS (TMS),
		 .UPDATE (),
		 .TDO (TDO)
		 );

   BSCANE2 #(
	     .DISABLE_JTAG("FALSE"),
	     .JTAG_CHAIN(2)
	     )
   bscane2_user2(
		 .DRCK (),
		 .RESET (),
		 .RUNTEST (),
		 .CAPTURE (),
		 .SEL (sel2),
		 .SHIFT (),
		 .TCK (),
		 .TDI (),
		 .TMS (),
		 .UPDATE (),
		 .TDO (TDO)
		 );

endmodule
