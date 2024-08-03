#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vpimc.h"
#include "Vpimc___024root.h"

#define MAX_SIM_ITER 100

int main(int argc, char** argv, char** env) {
    Vpimc *pimc = new Vpimc;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    pimc->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    pimc->notify = 1;
    pimc->irq_in = 0b00000010;  /* Pulse IRQ line high */

    for (int i = 0; i < MAX_SIM_ITER; ++i) {
        if (i == 5) {
            pimc->irq_in = 0b00000000;
        }

        pimc->clk ^= 1;
        pimc->eval();
        m_trace->dump(i);
    }

    m_trace->close();
    delete pimc;
    exit(EXIT_SUCCESS);
}

