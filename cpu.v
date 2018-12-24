module rom1r(addr_r, data_r);
  parameter ADDR_WIDTH = 8;
  parameter DATA_WIDTH = 8;
  input [ADDR_WIDTH - 1 : 0] addr_r;
  output [DATA_WIDTH - 1 : 0] data_r;
  reg [DATA_WIDTH - 1 : 0] mem [0 : (1<<ADDR_WIDTH) - 1];
  initial $readmemh("rom.txt", mem, 0, (1<<ADDR_WIDTH) - 1);
  assign data_r = mem[addr_r];
endmodule

module ram1r1w(write, addr_w, data_w, addr_r, data_r);
  parameter ADDR_WIDTH = 8;
  parameter DATA_WIDTH = 8;
  input write;
  input [ADDR_WIDTH - 1 : 0] addr_r, addr_w;
  output [DATA_WIDTH - 1 : 0] data_r;
  input [DATA_WIDTH - 1 : 0] data_w;
  reg [DATA_WIDTH - 1 : 0] mem [0 : (1<<ADDR_WIDTH) - 1];
//  initial $readmemh("ram.txt", mem, 0, (1<<ADDR_WIDTH) - 1);
  assign data_r = mem[addr_r];
  always @ (posedge write) mem[addr_w] <= data_w;
endmodule

module cpu(clk, reset, port);
  parameter WIDTH = 8;
  parameter RAM_SIZE = 8;
  parameter ROM_SIZE = 8;

  parameter PC  = 0;
  parameter CG  = 1;
  parameter TST = 2;
  parameter ADD = 3;
  parameter SUB = 4;
  parameter PORT = 5;
  
  input clk, reset;
  output [WIDTH-1 : 0] port;

  wire [WIDTH-1 : 0] addr_r, addr_w, data_r, data_w, data;
  
  reg [WIDTH-1 : 0] reg_pc;
  reg [WIDTH-1 : 0] reg_reg;
  reg [WIDTH-1 : 0] reg_port;
  assign port = reg_port;

  rom1r rom(reg_pc, {addr_w, addr_r});
  defparam rom.ADDR_WIDTH = ROM_SIZE;
  defparam rom.DATA_WIDTH = RAM_SIZE * 2;

  ram1r1w ram (clk, addr_w, data_w, addr_r, data_r);
  defparam ram.ADDR_WIDTH = RAM_SIZE;
  defparam ram.DATA_WIDTH = WIDTH;

  assign data   = (addr_r == PC)   ? reg_pc + 1 : 
                  (addr_r == PORT) ? reg_port : 
                   data_r;

  assign data_w = (addr_w == CG)  ? addr_r : 
                  (addr_w == TST) ? |data  : 
                  (addr_w == ADD) ? data + reg_reg : 
                  (addr_w == SUB) ? data - reg_reg : 
                   data;

  always @ (posedge clk) begin
    if (reset) begin
      reg_pc <= 0;
    end else begin
      reg_reg <= data_w;
      if (addr_w == PC) begin
        reg_pc <= data_w; 
      end else begin
        reg_pc <= reg_pc  + (((addr_w == TST) & data_w[0]) ? 2 : 1);
        case (addr_w)
          PORT: reg_port <= data_w;
        endcase
      end
    end
  end
endmodule