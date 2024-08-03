# Platform Interrupt Message Controller (PIMC)

The PIMC is responsible for receiving Interrupt Requests (IRQs) from peripherals
and routing them to a processor. There can be several peripherals in the system,
each connected to their respective IRQ lines.

## PIMC Signals

| Signal      | Purpose                     |
| ----------  | --------------------------- |
| IRQACK      | Interrupt acknowledgement   |
| LINENO[7:0] | IRQ line to be serviced     |
| NOTIFY#     | Signals an active IRQ       |
| CLK         | PIMC Clock                  |

## PIMC Startup State

| Signal      | State     |
| ----------  | --------  |
| IRQACK      | LOW (0)   |
| LINENO[7:0] | UNDEFINED |
| NOTIFY#     | UNDEFINED |

## PIMC Initialization Process

During system startup, LINENO[7:0] and NOTIFY# will be in an undefined state. Stage 1 firmware
is responsible for initializing the PIMC before it is ready for operation. The PIMC is initialized
by pulsing IRQACK high for exactly one clock cycle. It is recommended that IRQACK should be left high
for at least 2 ms.

As soon as a rising edge of the PIMC CLK signal occurs with IRQACK pulled high, NOTIFY# is pulled high
and LINENO[7:0] becomes zero.
