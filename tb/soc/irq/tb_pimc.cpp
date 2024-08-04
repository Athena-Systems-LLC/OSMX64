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

#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vpimc.h"
#include "Vpimc___024root.h"

#define MAX_SIM_ITER 100

int main(int argc, char** argv, char** env) {
    Vpimc *pimc = new Vpimc;
    vluint64_t posedge_cnt = 0;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    pimc->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    pimc->notify = 1;

    for (int i = 0; i < MAX_SIM_ITER; ++i) {
        pimc->clk ^= 1;
        pimc->eval();

        if (pimc->clk == 1) {
            ++posedge_cnt;

            /* Pulse IRQ line 3 high some cycles */
            if (posedge_cnt == 5) {
                pimc->irq_in |= (1 << 3);
            } else if (posedge_cnt == 9) {
                pimc->irq_in &= ~(1 << 3);
            }

            /* ACK IRQ */
            if (posedge_cnt == 13) {
                pimc->irqack = 1;
            } else if (posedge_cnt == 17) {
                pimc->irqack = 0;
            }

            /* Mask IRQ line 0 */
            if (posedge_cnt == 15) {
                pimc->mmio_addr = 0x1000;
                pimc->mmio_wdata |= (1 << 8);
                pimc->mmio_we = 1;
                pimc->mmio_re = 0;
            } else if (posedge_cnt == 18) {
                pimc->mmio_we = 0;
                pimc->mmio_wdata = 0;
            }

            /* Pulse IRQ line 0 high some cycles */
            if (posedge_cnt == 19) {
                pimc->irq_in |= (1 << 0);
            } else if (posedge_cnt == 23) {
                pimc->irq_in &= ~(1 << 0);
            }
        }

        m_trace->dump(i);
    }

    m_trace->close();
    delete pimc;
    exit(EXIT_SUCCESS);
}

