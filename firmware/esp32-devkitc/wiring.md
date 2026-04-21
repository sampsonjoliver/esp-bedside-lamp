# Wiring Plan

## Connector Standard

All internal connections use **JST-SM** (the connector type pre-fitted on the SK6812 WWA strip).

Buy JST-SM pre-crimped pigtail assortment (2, 3, 4-pin) — search AliExpress "JST SM pigtail pre-crimped".

**Wire gauge:** 22 AWG for 5V power runs, 26 AWG for all signal wires.

## Component Terminations

| Component | Existing termination | Conversion |
|-----------|---------------------|------------|
| PD decoy | Rising cage clamps | Screw 22 AWG wire directly into clamps — cage clamp is the termination. No JST needed here. |
| ESP32 | Through-holes (solder direct, not header pins) | Solder 26 AWG wires to the relevant through-holes. Terminate each group with JST-SM female on the other end. |
| SK6812 WWA strip | JST-SM male (pre-fitted) | Buy matching JST-SM 3-pin female pigtail — plug straight in, no modification needed. |
| Rotary encoder | Bare metal prongs | Solder 26 AWG wires to each prong (CLK, DT, BTN, GND). Terminate with JST-SM 4-pin female. |
| Copper touch plate | Bare copper disk | Solder single 26 AWG wire to disk. Run 1MΩ resistor inline. Terminate with JST-SM 2-pin female (signal + GND). |

## ESP32 Through-Holes to Solder

| Through-hole | Function | Wire to |
|-------------|----------|---------|
| VIN | 5V power in | PD decoy 5V |
| GND | Ground | Common GND |
| GPIO4 | Touch plate signal | 1MΩ → touch plate |
| GPIO16 | SK6812 data | Strip data pin |
| GPIO17 | Encoder CLK | Encoder CLK prong |
| GPIO18 | Encoder DT | Encoder DT prong |
| GPIO19 | Encoder button | Encoder BTN prong |
