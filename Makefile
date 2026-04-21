.PHONY: flash flash-s3 logs logs-s3 compile compile-s3 clean dashboard

ESPHOME := venv/bin/esphome
DEVKITC := firmware/esp32-devkitc/lamp.yaml
S3      := firmware/esp32-s3/lamp.yaml

flash:
	$(ESPHOME) run $(DEVKITC)

flash-s3:
	$(ESPHOME) run $(S3)

logs:
	$(ESPHOME) logs $(DEVKITC)

logs-s3:
	$(ESPHOME) logs $(S3)

compile:
	$(ESPHOME) compile $(DEVKITC)

compile-s3:
	$(ESPHOME) compile $(S3)

clean:
	$(ESPHOME) clean $(DEVKITC)
	$(ESPHOME) clean $(S3)

dashboard:
	$(ESPHOME) dashboard .
