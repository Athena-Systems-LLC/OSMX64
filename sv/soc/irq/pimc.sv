/*
 * Copyright (c) 2024-2025 Ian Marco Moffett and the Osmora Team.
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
 * 3. Neither the name of Hyra nor the names of its
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
        parameter IRQTAB_ENTSIZE = 32,
        parameter IRQTAB_MMIOBASE = 48'h1000000
    ) (
        input wire clk,         /* 50 MHz */
        input logic [IRQ_PIN_COUNT-1:0] irq_in,
        input logic irqack,

        /* MMIO interface */
        input logic [47:0] mmio_addr,
        input logic [31:0] mmio_wdata,
        output logic [31:0] mmio_rdata,
        input wire mmio_re,
        input wire mmio_we,

        output logic notify,
        output logic [7:0] lineno,
        output logic [7:0] processor_id
    );

    integer i;
    bit accept;
    bit irqmask;
    reg [IRQTAB_ENTSIZE - 1:0] irqtab[IRQ_PIN_COUNT];

    initial begin
        for (i = 0; i < IRQ_PIN_COUNT; i = i + IRQTAB_ENTSIZE) begin
          irqtab[i] = 32'b0;
        end

        mmio_rdata = 32'b0;
    end

    always @(posedge clk) begin
        /* Handle MMIO reads */
        if (mmio_re) begin
            case (mmio_addr)
                IRQTAB_MMIOBASE: mmio_rdata <= irqtab[0];
                IRQTAB_MMIOBASE + 4: mmio_rdata <= irqtab[1];
                IRQTAB_MMIOBASE + 8: mmio_rdata <= irqtab[2];
                IRQTAB_MMIOBASE + 12: mmio_rdata <= irqtab[3];
                IRQTAB_MMIOBASE + 16: mmio_rdata <= irqtab[4];
                IRQTAB_MMIOBASE + 20: mmio_rdata <= irqtab[5];
                IRQTAB_MMIOBASE + 24: mmio_rdata <= irqtab[6];
                IRQTAB_MMIOBASE + 28: mmio_rdata <= irqtab[7];
                IRQTAB_MMIOBASE + 32: mmio_rdata <= irqtab[8];
                IRQTAB_MMIOBASE + 36: mmio_rdata <= irqtab[9];
                IRQTAB_MMIOBASE + 40: mmio_rdata <= irqtab[10];
                IRQTAB_MMIOBASE + 44: mmio_rdata <= irqtab[11];
                IRQTAB_MMIOBASE + 48: mmio_rdata <= irqtab[12];
                IRQTAB_MMIOBASE + 52: mmio_rdata <= irqtab[13];
                IRQTAB_MMIOBASE + 56: mmio_rdata <= irqtab[14];
                IRQTAB_MMIOBASE + 60: mmio_rdata <= irqtab[15];
            endcase
        end

        /* Handle MMIO writes */
        if (mmio_we) begin
            case (mmio_addr)
                IRQTAB_MMIOBASE: irqtab[0] <= mmio_wdata;
                IRQTAB_MMIOBASE + 4: irqtab[1] <= mmio_wdata;
                IRQTAB_MMIOBASE + 8: irqtab[2] <= mmio_wdata;
                IRQTAB_MMIOBASE + 12: irqtab[3] <= mmio_wdata;
                IRQTAB_MMIOBASE + 16: irqtab[4] <= mmio_wdata;
                IRQTAB_MMIOBASE + 20: irqtab[5] <= mmio_wdata;
                IRQTAB_MMIOBASE + 24: irqtab[6] <= mmio_wdata;
                IRQTAB_MMIOBASE + 28: irqtab[7] <= mmio_wdata;
                IRQTAB_MMIOBASE + 32: irqtab[8] <= mmio_wdata;
                IRQTAB_MMIOBASE + 36: irqtab[9] <= mmio_wdata;
                IRQTAB_MMIOBASE + 40: irqtab[10] <= mmio_wdata;
                IRQTAB_MMIOBASE + 44: irqtab[11] <= mmio_wdata;
                IRQTAB_MMIOBASE + 48: irqtab[12] <= mmio_wdata;
                IRQTAB_MMIOBASE + 52: irqtab[13] <= mmio_wdata;
                IRQTAB_MMIOBASE + 56: irqtab[14] <= mmio_wdata;
                IRQTAB_MMIOBASE + 60: irqtab[15] <= mmio_wdata;
            endcase
        end

        if (irqack == 1'b1) begin
            lineno <= 8'b0;
            notify <= 1'b1;
            processor_id <= 8'b0;
        end else begin
            for (i = 0; i < IRQ_PIN_COUNT; i = i + 1) begin
                /* IRQ should be dropped if masked */
                irqmask <= irqtab[i * IRQTAB_ENTSIZE][8];
                accept <= (irqmask == 1'b0 && notify == 1'b1);
                if (irq_in[i] == 1'b1 && accept == 1'b1) begin
                    lineno <= i[7:0];
                    notify <= 1'b0;
                    processor_id <= irqtab[i * IRQTAB_ENTSIZE][7:0];
                end
            end
        end
    end
endmodule
