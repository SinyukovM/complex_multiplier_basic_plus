`timescale 1ns / 1ps

module top_mult_hard(
  input logic clk_i,
  input logic srst_i,
  input logic [17:0] data_a_i_i,
  input logic [17:0] data_a_q_i,
  input logic [17:0] data_b_i_i, // 2 целые + 16 дробные
  input logic [17:0] data_b_q_i,
  output logic [17:0] data_i_o, 
  output logic [17:0] data_q_o 
    );
  
  // Аналогично базовому заданию top_mult

  logic signed [35:0] real_1, real_2, imag_1, imag_2;

  assign real_1 = $signed(data_a_i_i) * $signed(data_b_i_i);
  assign real_2 = $signed(data_a_q_i) * $signed(data_b_q_i);
  assign imag_1 = $signed(data_a_i_i) * $signed(data_b_q_i);
  assign imag_2 = $signed(data_a_q_i) * $signed(data_b_i_i);

  /* Редактированный блок с учётом масштабирования - сдвиг вправо на 16 бит
  Округление - + 0.5 для округления к ближайшему целому 
  */
  
  always_ff @(posedge clk_i) begin
    if (srst_i) begin 
      data_i_o <= 18'b0;
      data_q_o <= 18'b0;
    end else begin
      // real
      data_i_o <= ((real_1 - real_2) + (1 << 15)) >>> 16;

      // imag
      data_q_o <= ((imag_1 + imag_2) + (1 << 15)) >>> 16;
    end
  end

endmodule
      