# Device Memory Map

Device memory begins at physical address `0x1000000`, below is a table showing which devices
each range is assigned to.

| Physical Address | Device                           | Size (bytes) |
| ---------------- | -------------------------------- | ------------ |
| 0x1000000        | PIMC IRQ Table (pin 0)           | 4            |
| 0x1000004        | PIMC IRQ Table (pin 1)           | 4            |
| 0x1000008        | PIMC IRQ Table (pin 2)           | 4            |
| 0x100000C        | PIMC IRQ Table (pin 3)           | 4            |
| 0x1000010        | PIMC IRQ Table (pin 4)           | 4            |
| 0x1000014        | PIMC IRQ Table (pin 5)           | 4            |
| 0x1000018        | PIMC IRQ Table (pin 6)           | 4            |
| 0x100001C        | PIMC IRQ Table (pin 7)           | 4            |
| 0x1000020        | PIMC IRQ Table (pin 8)           | 4            |
| 0x1000024        | PIMC IRQ Table (pin 9)           | 4            |
| 0x1000028        | PIMC IRQ Table (pin 10)          | 4            |
| 0x100002C        | PIMC IRQ Table (pin 11)          | 4            |
| 0x1000030        | PIMC IRQ Table (pin 12)          | 4            |
| 0x1000034        | PIMC IRQ Table (pin 13)          | 4            |
| 0x1000038        | PIMC IRQ Table (pin 14)          | 4            |
| 0x100003C        | PIMC IRQ Table (pin 15)          | 4            |
| 0x1000040        | Reserved                         | 256          |
| 0x1000140        | Generic DMA Source (channel 0)   | 8            |
| 0x1000148        | Generic DMA Dest (channel 0)     | 8            |
| 0x1000150        | Generic DMA Size (channel 0)     | 2            |
| 0x1000152        | Generic DMA Control (channel 0)  | 1            |
| 0x1000153        | Generic DMA Source (channel 1)   | 8            |
| 0x100015B        | Generic DMA Dest (channel 1)     | 8            |
| 0x1000163        | Generic DMA Size (channel 1)     | 2            |
| 0x1000165        | Generic DMA Control (channel 1)  | 1            |
| 0x1000166        | Generic DMA Source (channel 2)   | 8            |
| 0x100015B        | Generic DMA Dest (channel 2)     | 8            |
| 0x1000163        | Generic DMA Size (channel 2)     | 2            |
| 0x1000165        | Generic DMA Control (channel 2)  | 1            |
| 0x1000166        | Generic DMA Source (channel 3)   | 8            |
| 0x100016E        | Generic DMA Dest (channel 3)     | 8            |
| 0x1000176        | Generic DMA Size (channel 3)     | 2            |
| 0x1000178        | Generic DMA Control (channel 3)  | 1            |
