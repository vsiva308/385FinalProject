//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module fighter (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, onexsig, oneysig, twoxsig, twoysig;
	logic [7:0] keycode_0, keycode_1, keycode_2, keycode_3;
	logic [7:0] akuma_hbar, ryu_hbar;
	logic [3:0] RyuIndex, AkumaIndex;
	logic Akumahit, Ryuhit, Akumapunch, Ryupunch, RyuJump, AkumaJump, RyuCrouch, AkumaCrouch, Ryublock, Akumablock;
	logic RyuLeft, RyuRight, AkumaLeft, AkumaRight;
	int AkumaKB, RyuKB;
	int XDist;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);
	
	assign XDist = twoxsig - onexsig;

	//Our A/D converter is only 12 bit
//	assign VGA_R = Red[3:0];
//	assign VGA_B = Blue[3:0];
//	assign VGA_G = Green[3:0];
	
	
	finalsoc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_0_export(keycode_0),
		.keycode_1_export(keycode_1),
		.keycode_2_export(keycode_2),
		.keycode_3_export(keycode_3)
	 );


//instantiate a vga_controller, ball, and color_mapper here with the ports.
	vga_controller vc(
		.Clk(MAX10_CLK1_50),
		.Reset(Reset_h),
		.hs(VGA_HS), //out
		.vs(VGA_VS),
		.pixel_clk(VGA_Clk),
		.blank(blank),
		.sync(sync),
		.DrawX(drawxsig),
		.DrawY(drawysig)
	);
	
	health_bar ryu_health (
		.Clk(VGA_VS),
		.Reset(Reset_h),
		.hit(Ryuhit),
		.block(Ryublock),
		.health(ryu_hbar)
	);
	
	health_bar akuma_health (
		.Clk(VGA_VS),
		.Reset(Reset_h),
		.hit(Akumahit),
		.block(Akumablock),
		.health(akuma_hbar)
	);

	ryu ryu_movement(
		.Reset(Reset_h),
		.frame_clk(VGA_VS),
		.keycode_0(keycode_0),
		.keycode_1(keycode_1),
		.keycode_2(keycode_2),
		.keycode_3(keycode_3),
		.XDist(XDist),
		.Ryu_Knockback(RyuKB),
		.RyuX(onexsig),
		.RyuY(oneysig),
		.RyuJump(RyuJump),
		.RyuCrouch(RyuCrouch),
		.RyuLeft(RyuLeft),
		.RyuRight(RyuRight)
	);
	
	akuma akuma_movement(
		.Reset(Reset_h),
		.frame_clk(VGA_VS),
		.keycode_0(keycode_0),
		.keycode_1(keycode_1),
		.keycode_2(keycode_2),
		.keycode_3(keycode_3),
		.XDist(XDist),
		.Akuma_Knockback(AkumaKB),
		.AkumaX(twoxsig),
		.AkumaY(twoysig),
		.AkumaJump(AkumaJump),
		.AkumaCrouch(AkumaCrouch),
		.AkumaLeft(AkumaLeft),
		.AkumaRight(AkumaRight)
	);
	
	punch punch_control(
		.Reset(Reset_h),
		.frame_clk(VGA_VS),
		.keycode_0(keycode_0),
		.keycode_1(keycode_1),
		.keycode_2(keycode_2),
		.keycode_3(keycode_3),
		.XDist(XDist),
		.P1Ypos(oneysig),
		.P2Ypos(twoysig),
		.P1Xpos(onexsig),
		.P2Xpos(twoxsig),
		.Ryu_Knockback(RyuKB),
		.Akuma_Knockback(AkumaKB),
		.PunchP1(Ryupunch),
		.PunchP2(Akumapunch),
		.hitP1(Ryuhit),
		.hitP2(Akumahit),
		.crouchP1(RyuCrouch),
		.crouchP2(AkumaCrouch),
		.blockP1(Ryublock),
		.blockP2(Akumablock),
		.RyuLeft(RyuLeft)
	);
	
	color_mapper cm(
		.RyuX(onexsig), 
		.RyuY(oneysig),
		.AkumaX(twoxsig), 
		.AkumaY(twoysig), 
		.DrawX(drawxsig), 
		.DrawY(drawysig),
		.RyuHealth(ryu_hbar),
		.AkumaHealth(akuma_hbar),
		.RyuIndex(RyuIndex),
		.AkumaIndex(AkumaIndex),
		.blank(blank),
		.vga_clk(VGA_Clk),
		.Red(VGA_R), 
		.Green(VGA_G), 
		.Blue(VGA_B)
		);
		
	spriteMux ryuMux(
		.punch(Ryupunch),
		.jump(RyuJump),
		.crouch(RyuCrouch),
		.left(RyuLeft),
		.right(RyuRight),
		.death(1'b0),
		.spriteIndex(RyuIndex)
	);
		
	spriteMux akumaMux(
		.punch(Akumapunch),
		.jump(AkumaJump),
		.crouch(AkumaCrouch),
		.left(AkumaLeft),
		.right(AkumaRight),
		.death(1'b0),
		.spriteIndex(AkumaIndex)
	);	

endmodule
