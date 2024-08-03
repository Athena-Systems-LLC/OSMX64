/*
 * Copyright (c) 2024 Athena Systems LLC and Ian Marco Moffett
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the copyright holder nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

 /*
  * Description: Platform Interrupt Message Controller
  * Author: Ian Moffett
  */

module pimc #(
        parameter IRQ_PIN_COUNT = 16,
        parameter IRQTAB_ENTSIZE = 8
    ) (
        input wire clk,         /* 50 MHz */
        input logic [IRQ_PIN_COUNT-1:0] irq_in,
        input logic irqack,
        output logic notify,
        output logic [7:0] lineno
    );

    integer i;

    always @(posedge clk) begin
        if (irqack == 1'b1) begin
            lineno <= 8'b0;
            notify <= 1'b1;
        end else begin
            for (i = 0; i < IRQ_PIN_COUNT; i = i + 1) begin
               if (irq_in[i] == 1'b1 && notify == 1'b1) begin
                    lineno <= i;
                    notify <= 1'b0;
                end
            end
        end
    end
endmodule
