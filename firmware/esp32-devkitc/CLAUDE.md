# ESP32-DevKitC V4 — Board Context

## Board Identity

| | |
|-|-|
| Board | ESP32-DevKitC V4 |
| Module | ESP32-WROOM-32D |
| USB-UART | CP2102 |
| Pins | 38 |
| ESPHome board target | `esp32dev` |
| Framework | `esp-idf` |

**No controllable onboard LED.** Only a 5V power indicator. GPIO2 in the prototype code does nothing useful on this board.

## GPIO Pin Assignments

| Pin | Function | Status |
|-----|----------|--------|
| GPIO4 | Copper touch plate (esp32_touch) | Prototype — in use |
| GPIO16 | SK6812 WWA data line (RMT) | Planned |
| GPIO17 | Rotary encoder CLK | Planned |
| GPIO18 | Rotary encoder DT | Planned |
| GPIO19 | Rotary encoder button | Planned |

Full pin reference: [`esp32-gpio-reference.md`](esp32-gpio-reference.md) — generated from [`esp32d-typec-pin-diagram.webp`](esp32d-typec-pin-diagram.webp).

## Key Constraints

- **GPIO6–11** shared with internal flash — never use as GPIO
- **GPIO0, GPIO2, GPIO12, GPIO15** are strapping pins — affect boot behaviour
- **GPIO1, GPIO3** are UART0 TX/RX — needed for flashing and ESPHome logs
- **GPIO34–39** are input-only — cannot drive output
- SK6812 requires an RMT-capable pin; GPIO16 is a clean choice
- Touch peripheral requires `esp32_touch` block; capacitive pins are TOUCH0–TOUCH9

## Flash Command

Run from repo root so `secrets.yaml` resolves:

```sh
esphome run firmware/esp32-devkitc/lamp.yaml
```
