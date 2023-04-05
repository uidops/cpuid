SRC = ./cpuid.s
AS ?= clang
LD ?= ld.lld
TARGET = cpuid
LIBS = -lc

.PHONY: clean test all

all: $(TARGET)

$(TARGET): $(SRC)
	$(AS) -c -o $(TARGET).o $(SRC)
	$(LD) -o $(TARGET) -dynamic-linker /lib/ld-musl-x86_64.so.1 -L/usr/lib $(TARGET).o $(LIBS)

install:
	mkdir -p $(PREFIX)/bin
	cp -f $(TARGET) $(PREFIX)/bin
	chmod +x $(PREFIX)/bin/$(TARGEt)

uninstall:
	rm -f $(PREFIX)/bin/$(TARGET)

clean:
	rm -f $(TARGET) $(TARGET).o

test:
	./$(TARGET)

