# ESP32 DevKitC GPIO Reference

Source: `esp32d-typec-pin-diagram.webp` (Espressif official pin definition diagram)

## Board Specs

| | |
|-|-|
| CPU | 32-bit Xtensa dual-core @ 240 MHz |
| Wi-Fi | 802.11 b/g/n 2.4 GHz |
| Bluetooth | 4.2 BR/EDR and BLE |
| SRAM | 520 KB (16 KB cache) |
| ROM | 448 KB |
| GPIOs | 34 total |
| ADC | 12-bit, 2 × SAR (ADC1 + ADC2) |
| Interfaces | 4× SPI, 3× UART, 2× I2C, 2× I2S, 1× host SD/eMMC/SDIO |
| PWM | LED PWM controller |
| Other | RMT, touch sensor, Ethernet MAC |

---

## Pin Table

| Pin | GPIO State¹ | Alternate Functions | Notes |
|-----|-------------|---------------------|-------|
| **3V3** | PWR | — | 3.3 V output |
| **5V** | PWR | — | 5 V output (from USB) |
| **GND** | GND | — | Ground |
| **EN** | — | — | Chip enable (active high) |
| **GPIO0** | OD/IE/WPU | RTC, ADC2_1, TOUCH1, BOOT | Strapping pin — LOW at boot = flash mode |
| **GPIO1** | OD/IE/WPU | U0TXD, SERIAL_TX | UART0 TX — used for flashing/logging |
| **GPIO2** | OD/IE/WPD | RTC, ADC2_2, TOUCH2 | Strapping pin; must be HIGH or floating at boot |
| **GPIO3** | OD/IE/WPU | U0RXD, SERIAL_RX | UART0 RX — used for flashing/logging |
| **GPIO4** | OD/IE/WPD | RTC, ADC2_0, TOUCH0 | Safe general-purpose GPIO |
| **GPIO5** | OD/IE/WPU | VSPI_SS, SDIO | SPI chip select |
| **GPIO6** | OD/IE/WPU | SCK | ⚠️ Shared with internal flash — do not use |
| **GPIO7** | OD/IE/WPU | D0 | ⚠️ Shared with internal flash — do not use |
| **GPIO8** | OD/IE/WPU | D1 | ⚠️ Shared with internal flash — do not use |
| **GPIO9** | OD/IE/WPU | D2 | ⚠️ Shared with internal flash — do not use |
| **GPIO10** | OD/IE/WPU | D3 | ⚠️ Shared with internal flash — do not use |
| **GPIO11** | OD/IE/WPU | CMD | ⚠️ Shared with internal flash — do not use |
| **GPIO12** | OD/IE/WPD | MTDI, HSPI_MISO, TOUCH5, ADC2_5, RTC, VDD_FLASH | Strapping pin — affects flash voltage; avoid |
| **GPIO13** | OD/IE/WPD | MTCK, HSPI_MOSI, TOUCH4, ADC2_4, RTC | Safe general-purpose GPIO |
| **GPIO14** | OD/IE/WPU | MTMS, TOUCH6, ADC2_6, RTC | Safe general-purpose GPIO |
| **GPIO15** | OD/IE/WPU | MTDO, HSPI_SS, TOUCH3, ADC2_3, RTC, LOG | Strapping pin; outputs log messages at boot |
| **GPIO16** | OD/IE | — | Clean GPIO, RMT-capable — good for addressable LEDs |
| **GPIO17** | OD/IE | — | Clean GPIO — good for encoder CLK |
| **GPIO18** | OD/IE | VSPI_SCK | SPI clock; usable as GPIO |
| **GPIO19** | OD/IE | VSPI_MISO | SPI MISO; usable as GPIO |
| **GPIO21** | OD/IE | WIRE_SDA | I2C SDA |
| **GPIO22** | OD/IE | WIRE_SCL | I2C SCL |
| **GPIO23** | OD/IE | VSPI_MOSI, WIRE_MOSI | SPI MOSI; usable as GPIO |
| **GPIO25** | OD/ID | DAC_1, ADC2_8, RTC | DAC output channel 1 |
| **GPIO26** | OD/ID | DAC_2, ADC2_9, RTC | DAC output channel 2 |
| **GPIO27** | OD/ID | TOUCH7, ADC2_7, RTC | Touch-capable GPIO |
| **GPIO32** | OD/ID | TOUCH9, ADC1_4, RTC, 32K_XP | Touch-capable; ADC1 (works alongside Wi-Fi) |
| **GPIO33** | OD/ID | TOUCH8, ADC1_5, RTC, 32K_XN | Touch-capable; ADC1 (works alongside Wi-Fi) |
| **GPIO34** | Input only | ADC1_6, RTC | Input only — no internal pull-up/pull-down |
| **GPIO35** | Input only | VDET_2, ADC1_7, RTC | Input only — no internal pull-up/pull-down |
| **GPIO36** | Input only | ADC1_0, RTC, S_VP | Input only — no internal pull-up/pull-down |
| **GPIO39** | Input only | ADC1_3, RTC, S_VN | Input only — no internal pull-up/pull-down |

---

## GPIO State Legend

| Code | Meaning |
|------|---------|
| WPU | Weak Pull-up (Internal) |
| WPD | Weak Pull-down (Internal) |
| PU | Pull-up (External) |
| IE | Input Enable (After Reset) |
| ID | Input Disabled (After Reset) |
| OE | Output Enable (After Reset) |
| OD | Output Disabled (After Reset) |

---

## Quick Reference: Pins to Avoid

| Pin(s) | Reason |
|--------|--------|
| GPIO6–11 | Shared with internal SPI flash — will crash the chip |
| GPIO0 | Strapping pin: LOW at boot triggers flash mode |
| GPIO2 | Strapping pin; must be HIGH or floating at boot |
| GPIO12 | Strapping pin: HIGH at boot changes flash voltage (3.3 V → 1.8 V) |
| GPIO15 | Strapping pin: LOW silences boot log output |
| GPIO1, GPIO3 | UART0 TX/RX — needed for serial flashing and ESPHome logging |
| GPIO34–39 | Input-only — cannot drive output |

---

## Quick Reference: Good Pins for This Project

| Use | Recommended Pin | Why |
|-----|----------------|-----|
| SK6812 data (RMT) | GPIO16 | Clean, RMT-capable, no conflicts |
| Rotary encoder CLK | GPIO17 | Clean GPIO |
| Rotary encoder DT | GPIO18 | Clean GPIO |
| Rotary encoder button | GPIO19 | Clean GPIO |
| Copper touch plate | GPIO4 | TOUCH0, already in prototype |
