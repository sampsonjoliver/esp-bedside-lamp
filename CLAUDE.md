# Bedside Lamp — Project Context

## Overview

DIY bedside lamp controlled via ESPHome, integrated with Home Assistant over Wi-Fi. Two microcontroller variants are being developed — they share common firmware components but have separate board configs.

**Status: Early prototype.** Touch input wired and tested. LED strip and rotary encoder not yet wired.

## Intended Behaviour

- **Touch plate:** cycles through brightness presets → dim → medium → bright → off
- **Encoder turn:** fine-grained brightness adjustment
- **Encoder click:** TBD
- **LED:** SK6812 WWA strip (Warm White + White + Amber), 1 metre, warm bedside ambiance

## Boards

| Board | Config | Context |
|-------|--------|---------|
| ESP32-DevKitC V4 (WROOM-32D) | [`firmware/esp32-devkitc/`](firmware/esp32-devkitc/) | Active prototype |
| ESP32-S3 | [`firmware/esp32-s3/`](firmware/esp32-s3/) | Skeleton — not yet wired |

Board-specific GPIO assignments, constraints, and pin references live in each board's `CLAUDE.md`.

## Project Structure

- `firmware/` — ESPHome device configs; shared components in `common/`, one subdirectory per board
- `hardware/` — CAD files for 3D printing the enclosure
- `secrets.yaml` — not committed; holds wifi/API credentials

## ESPHome Notes

- Shared components in `firmware/common/` are pulled in via ESPHome `packages`
- `secrets.yaml` lives at repo root — always run `esphome` from repo root
- Framework: `esp-idf` on both boards
