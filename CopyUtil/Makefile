# Makefile for CopyUtil

# Compiler settings
CC = gcc
CFLAGS = -Wall -Wextra -O2

# Source files
SRCS = src/main.c src/argparse.c src/filematch.c src/filecopy.c src/error.c src/progress.c
OBJS = $(patsubst src/%.c,src/obj/%.o,$(SRCS))

# Output executable
TARGET = copyutil.exe

# Default target
all: $(TARGET)

# Linking
$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET) -lshlwapi

# Compiling
src/obj/%.o: src/%.c
	@mkdir -p src\obj
	$(CC) $(CFLAGS) -c $< -o $@

# Create directories if they don't exist
dirs:
	@mkdir -p src\obj

# Clean
clean:
	@del /Q /F $(TARGET) src\obj\*.o 2>nul || true

.PHONY: all clean dirs