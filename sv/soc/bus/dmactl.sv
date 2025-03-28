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
 * Description: Generic DMA Controller
 * Author: Ian Moffett
 */

module dmactl #(
        /* MMIO bases for DMA channels */
        parameter C0_MMIO_BASE = 48'h1000140,
        parameter C1_MMIO_BASE = 48'h1000153,
        parameter C2_MMIO_BASE = 48'h1000166,
        parameter C3_MMIO_BASE = 48'h100016E,

        /* Channel control bits */
        parameter CCTL_START = 0,
        parameter CCTL_WRITE = 1
    ) (
        input wire clk,

        /* MMIO interface */
        input logic [47:0] mmio_addr,
        input logic [63:0] mmio_wdata,
        output logic [63:0] mmio_rdata,
        input wire mmio_re,
        input wire mmio_we,

        /* Memory bus interface */
        output wire mbus_re,
        output wire mbus_we,
        output logic [47:0] mbus_addr,
        output logic [63:0] mbus_wdata,
        input logic [63:0] mbus_rdata
    );

    /* Channel 0 register set */
    reg [63:0] c0_src;
    reg [63:0] c0_dest;
    reg [63:0] c0_rdata;
    reg [15:0] c0_size;
    reg [7:0] c0_ctl;

    /* Channel 1 register set */
    reg [63:0] c1_src;
    reg [63:0] c1_dest;
    reg [63:0] c1_rdata;
    reg [15:0] c1_size;
    reg [7:0] c1_ctl;

    /* Channel 2 register set */
    reg [63:0] c2_src;
    reg [63:0] c2_dest;
    reg [63:0] c2_rdata;
    reg [15:0] c2_size;
    reg [7:0] c2_ctl;

    /* Channel 3 register set */
    reg [63:0] c3_src;
    reg [63:0] c3_dest;
    reg [63:0] c3_rdata;
    reg [15:0] c3_size;
    reg [7:0] c3_ctl;

    initial begin
        c0_src = 64'b0;
        c0_dest = 64'b0;
        c0_rdata = 64'b0;
        c0_size = 16'b0;
        c0_ctl  = 8'b0;

        c1_src = 64'b0;
        c1_dest = 64'b0;
        c1_rdata = 64'b0;
        c1_size = 16'b0;
        c1_ctl  = 8'b0;

        c2_src = 64'b0;
        c2_dest = 64'b0;
        c2_rdata = 64'b0;
        c2_size = 16'b0;
        c2_ctl  = 8'b0;

        c3_src = 64'b0;
        c3_dest = 64'b0;
        c3_rdata = 64'b0;
        c3_size = 16'b0;
        c3_ctl  = 8'b0;

        mmio_rdata = 64'b0;
        mbus_addr = 48'b0;
        mbus_re = 1'b0;
        mbus_we = 1'b0;
        mbus_wdata = 64'b0;
    end

    task channel_rw;
        input [63:0] c_inbuf;
        input [47:0] c_src;
        input [47:0] c_dest;
        input [15:0] c_size;
        input [7:0] c_ctl;

        if (c_ctl[CCTL_WRITE] == 1'b1 && c_size < 8) begin
            /* Prepare to read data into buffer register */
            mbus_addr <= c_src[47:0];
            mbus_we <= 1'b0;
            mbus_re <= 1'b1;

            @(posedge clk);
            c_inbuf = mbus_rdata;
            mbus_re <= 1'b0;

            /* Write data to dest */
            mbus_addr <= c_dest[47:0];
            mbus_wdata <= c_inbuf & (1 << (c_size * 8)) - 1;
            mbus_we <= 1'b1;

            @(posedge clk);
            mbus_we <= 1'b0;
        end
    endtask

    always @(posedge clk) begin
        /* Handle MMIO reads */
        if (mmio_re) begin
            case (mmio_addr)
                /* Channel 0 */
                C0_MMIO_BASE: mmio_rdata <= c0_src;
                C0_MMIO_BASE + 8: mmio_rdata <= c0_dest;
                C0_MMIO_BASE + 16: mmio_rdata <= { 48'b0, c0_size[15:0] };
                C0_MMIO_BASE + 18: mmio_rdata <= { 56'b0, c0_ctl[7:0] };

                /* Channel 1 */
                C1_MMIO_BASE: mmio_rdata <= c1_src;
                C1_MMIO_BASE + 8: mmio_rdata <= c1_dest;
                C1_MMIO_BASE + 16: mmio_rdata <= { 48'b0, c1_size[15:0] };
                C1_MMIO_BASE + 18: mmio_rdata <= { 56'b0, c1_ctl[7:0] };

                /* Channel 2 */
                C2_MMIO_BASE: mmio_rdata <= c2_src;
                C2_MMIO_BASE + 8: mmio_rdata <= c2_dest;
                C2_MMIO_BASE + 16: mmio_rdata <= { 48'b0, c2_size[15:0] };
                C2_MMIO_BASE + 18: mmio_rdata <= { 56'b0, c2_ctl[7:0] };

                /* Channel 3 */
                C3_MMIO_BASE: mmio_rdata <= c3_src;
                C3_MMIO_BASE + 8: mmio_rdata <= c3_dest;
                C3_MMIO_BASE + 16: mmio_rdata <= { 48'b0, c3_size[15:0] };
                C3_MMIO_BASE + 18: mmio_rdata <= { 56'b0, c3_ctl[7:0] };
            endcase
        end

        /* Handle MMIO writes */
        if (mmio_we) begin
            case (mmio_addr)
                /* Channel 0 */
                C0_MMIO_BASE: c0_src <= mmio_wdata;
                C0_MMIO_BASE + 8: c0_dest <= mmio_wdata;
                C0_MMIO_BASE + 16: c0_size <= mmio_wdata[15:0];
                C0_MMIO_BASE + 18: c0_ctl <= mmio_wdata[7:0];

                /* Channel 1 */
                C1_MMIO_BASE: c1_src <= mmio_wdata;
                C1_MMIO_BASE + 8: c1_dest <= mmio_wdata;
                C1_MMIO_BASE + 16: c1_size <= mmio_wdata[15:0];
                C1_MMIO_BASE + 18: c1_ctl <= mmio_wdata[7:0];

                /* Channel 2 */
                C2_MMIO_BASE: c2_src <= mmio_wdata;
                C2_MMIO_BASE + 8: c2_dest <= mmio_wdata;
                C2_MMIO_BASE + 16: c2_size <= mmio_wdata[15:0];
                C2_MMIO_BASE + 18: c2_ctl <= mmio_wdata[7:0];

                /* Channel 3 */
                C3_MMIO_BASE: c3_dest <= mmio_wdata;
                C3_MMIO_BASE + 8: c3_dest <= mmio_wdata;
                C3_MMIO_BASE + 16: c3_size <= mmio_wdata[15:0];
                C3_MMIO_BASE + 18: c3_ctl <= mmio_wdata[7:0];
            endcase

            if (c0_ctl[CCTL_START] == 1'b1) begin
                channel_rw(c0_rdata, c0_src[47:0], c0_dest[47:0], c0_size, c0_ctl);
                c0_ctl[CCTL_START] <= 1'b0;
            end

            if (c1_ctl[CCTL_START] == 1'b1) begin
                channel_rw(c1_rdata, c1_src[47:0], c1_dest[47:0], c1_size, c1_ctl);
                c1_ctl[CCTL_START] <= 1'b0;
            end

            if (c2_ctl[CCTL_START] == 1'b1) begin
                channel_rw(c2_rdata, c2_src[47:0], c2_dest[47:0], c2_size, c2_ctl);
                c2_ctl[CCTL_START] <= 1'b0;
            end

            if (c3_ctl[CCTL_START] == 1'b1) begin
                channel_rw(c3_rdata, c3_src[47:0], c3_dest[47:0], c3_size, c3_ctl);
                c3_ctl[CCTL_START] <= 1'b0;
            end
        end
    end
endmodule
