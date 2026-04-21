# Circuit Diagram

```mermaid
flowchart TD
    USBC["USB-C PD Decoy\n(5V input)"]

    subgraph POWER ["5V Rail"]
        CAP1["100µF electrolytic\n(bulk smoothing)"]
    end

    subgraph ESP ["ESP32-DevKitC V4"]
        VIN["VIN"]
        CAP2["100nF ceramic\n(decoupling)"]
        GPIO16["GPIO16"]
        GPIO4["GPIO4"]
        GPIO17["GPIO17 (CLK)"]
        GPIO18["GPIO18 (DT)"]
        GPIO19["GPIO19 (BTN)"]
        GND_ESP["GND"]
    end

    subgraph STRIP ["SK6812 WWA Strip (1m)"]
        VCC1["VCC (start)"]
        DAT["Data"]
        GND1["GND (start)"]
        VCC2["VCC (end)"]
        GND2["GND (end)"]
    end

    RES["1MΩ resistor"]
    TOUCH["Copper Touch Plate"]

    subgraph ENC ["Rotary Encoder (EC11)"]
        CLK["CLK"]
        DT["DT"]
        BTN["BTN"]
        GND_ENC["GND"]
    end

    GND_COMMON["Common GND"]

    USBC --> POWER
    POWER --> VIN
    POWER --> VCC1
    POWER --> VCC2
    CAP1 --- GND_COMMON

    VIN --- CAP2
    CAP2 --- GND_ESP

    GPIO16 --> DAT
    GPIO4 --> RES --> TOUCH

    GPIO17 --- CLK
    GPIO18 --- DT
    GPIO19 --- BTN

    GND_ESP --- GND_COMMON
    GND1 --- GND_COMMON
    GND2 --- GND_COMMON
    GND_ENC --- GND_COMMON
```

## Wiring Summary

### Power

| From | To | Wire |
|------|----|------|
| USB-C PD decoy 5V | ESP32 VIN | Red |
| USB-C PD decoy 5V | SK6812 VCC (start) | Red |
| USB-C PD decoy 5V | SK6812 VCC (end) | Red |
| USB-C PD decoy GND | Common GND | White |
| Common GND | ESP32 GND | White |
| Common GND | SK6812 GND (start) | White |
| Common GND | SK6812 GND (end) | White |
| Common GND | Encoder GND | White |

### Signals

| From | To | Via | Notes |
|------|----|-----|-------|
| ESP32 GPIO16 | SK6812 Data | Green | RMT data line |
| ESP32 GPIO4 | Copper touch plate | 1MΩ resistor | Static protection |
| Encoder CLK | ESP32 GPIO17 | — | Internal pull-up enabled |
| Encoder DT | ESP32 GPIO18 | — | Internal pull-up enabled |
| Encoder BTN | ESP32 GPIO19 | — | Internal pull-up enabled |

### Decoupling Capacitors

| Capacitor | Placement | Purpose |
|-----------|-----------|---------|
| 100µF electrolytic | 5V/GND near LED strip VCC | Absorbs current spikes when LEDs switch |
| 100nF ceramic | ESP32 VIN/GND | Suppresses high-frequency noise |

## Notes

- 100µF electrolytic cap: across 5V/GND near LED strip input — absorbs current spikes when LEDs switch
- 100nF ceramic cap: across ESP32 VIN/GND — suppresses high-frequency noise
- 1MΩ resistor: in series between GPIO4 and touch plate — protects pin from static discharge
- Encoder CLK/DT/BTN use ESP32 internal pull-ups (configured in ESPHome)
- SK6812 powered at both ends to avoid voltage drop across 1m strip
