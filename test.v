`include "cpu.v"

module test();

reg clk;
reg reset;
wire [7:0] port; 

cpu c(clk, reset, port);

initial
begin
  $dumpfile("test.vcd");
//  $dumpvars(0, c);
/*  $display("time\tc r po | PC Aw Ar Dr D_ Dw RE | M0 M1 M2 M3 M4 M5 M6 M7\n");
  $monitor("%g\t%b %b %02h | %02h %02h %02h %02h %02h %02h %02h | %02h %02h %02h %02h %02h %02h %02h %02h",
            $time, clk, reset, port,
            c.reg_pc, c.addr_r, c.addr_w, c.data_r, c.data, c.data_w, c.reg_reg,
            c.ram.mem[0], c.ram.mem[1], c.ram.mem[2], c.ram.mem[3], c.ram.mem[4], c.ram.mem[5], c.ram.mem[6], c.ram.mem[7]
          );
*/
  reset <= 1;
  clk <= 0;
  #4 reset <= 0;
  #150 $finish;
end

always #1 clk <= !clk;

endmodule