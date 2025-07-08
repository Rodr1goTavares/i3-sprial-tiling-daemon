CC = gcc
CFLAGS = -O2 -Wall -Wextra -pedantic -std=c11
TARGET = i3std
SRC = i3std.c
BUILD_DIR = build

$(BUILD_DIR)/$(TARGET): $(SRC)
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/$(TARGET) $(SRC)

.PHONY: clean run

clean:
	rm -rf $(BUILD_DIR)

run: $(BUILD_DIR)/$(TARGET)
	./$(BUILD_DIR)/$(TARGET)

