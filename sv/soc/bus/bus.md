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
| 0x1000040        | Reserved                         | 4096         |
