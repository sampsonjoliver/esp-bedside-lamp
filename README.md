# esp-bedside-lamp

## Getting Started

Install esphome:

```bash
python3 -m venv venv
source venv/bin/activate
pip install esphome
```

Deploy and run changes:
`esphome run lamp.yaml`

## Useful Commands

- View Logs: `esphome logs my_device.yaml` (Great for debugging code snippets).
- Validate YAML: `esphome config my_device.yaml` (Checks for syntax errors without compiling).
- Clean Build: `esphome clean my_device.yaml` (If things get "janky" with the cache).
- Set up additional device: `esphome wizard my_device.yaml`
