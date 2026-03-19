# LixiOS - Ein minimales Betriebssystem in C++

Dieses Projekt enthält den Quellcode für ein einfaches Betriebssystem mit Live-Boot-Funktion.

## Voraussetzungen
- NASM (Assembler)
- GCC (C++ Compiler)
- ld (Linker)
- genisoimage (für ISO-Erstellung)
- QEMU (zum Testen)
- VirtualBox (für VirtualBox-Unterstützung)

## Projektstruktur
- `boot/boot.asm`: Bootsektor in Assembler
- `kernel/kernel.cpp`: Minimaler C++ Kernel
- `kernel/linker.ld`: Linker-Skript für den Kernel
- `Makefile`: Build-Skript für ISO-Erstellung und VirtualBox-Integration

## Build-Anleitung
1. Klone das Repository:
   ```bash
   git clone https://github.com/jakigiffels/LixiOS.git
   cd LixiOS
   ```

2. Erstelle das ISO-Image:
   ```bash
   make
   ```

3. Teste mit QEMU:
   ```bash
   make run
   ```

4. Teste mit VirtualBox:
   ```bash
   make run-vbox
   ```

## VirtualBox-Einrichtung
Das Makefile erstellt automatisch eine VirtualBox-VM mit dem Namen "LixiOS" und bindet das ISO-Image als CD-ROM ein. Die VM hat 128 MB RAM und eine 10 MB Festplatte.

## Lizenz
Dieses Projekt steht unter der MIT-Lizenz.