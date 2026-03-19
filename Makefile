# Makefile für LixiOS

# Tools
NASM = nasm
GCC = g++
LD = ld
QEMU = qemu-system-x86_64
VBOXMANAGE = VBoxManage

# Flags
CXXFLAGS = -m32 -ffreestanding -nostdlib -nodefaultlibs -fno-exceptions -fno-rtti -O2
LDFLAGS = -T kernel/linker.ld -m elf_i386

# Dateien
BOOT_SECTOR = boot/boot.bin
KERNEL_OBJ = kernel/kernel.o
KERNEL_BIN = kernel/kernel.bin
ISO_IMAGE = lixios.iso
VBOX_HDD = lixios.vdi

all: $(ISO_IMAGE)

# Bootsektor erstellen
boot/boot.bin: boot/boot.asm
	$(NASM) -f bin $< -o $@

# Kernel kompilieren
kernel/kernel.o: kernel/kernel.cpp
	$(GCC) $(CXXFLAGS) -c $< -o $@

# Kernel linken
kernel/kernel.bin: $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) $< -o kernel/kernel.elf
	objcopy -O binary kernel/kernel.elf $@

# ISO-Image erstellen
$(ISO_IMAGE): $(BOOT_SECTOR) $(KERNEL_BIN)
	mkdir -p iso/boot
	cp $< iso/boot/
	cp $(KERNEL_BIN) iso/boot/
	genisoimage -R -b boot/boot.bin -no-emul-boot -boot-load-size 4 -A os -input-charset utf8 -o $@ iso
	rm -rf iso

# VirtualBox Festplatte erstellen
$(VBOX_HDD):
	$(VBOXMANAGE) createmedium disk --filename $@ --size 10 --format VDI

# VirtualBox VM erstellen
create-vm:
	$(VBOXMANAGE) createvm --name "LixiOS" --ostype "Other" --register
	$(VBOXMANAGE) storagectl "LixiOS" --name "IDE Controller" --add ide
	$(VBOXMANAGE) storageattach "LixiOS" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium $(VBOX_HDD)
	$(VBOXMANAGE) modifyvm "LixiOS" --memory 128 --acpi off --ioapic off

# ISO in VirtualBox einbinden und starten
run-vbox: $(ISO_IMAGE) $(VBOX_HDD) create-vm
	$(VBOXMANAGE) storageattach "LixiOS" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $(ISO_IMAGE)
	$(VBOXMANAGE) startvm "LixiOS"

# Mit QEMU testen
run: $(ISO_IMAGE)
	$(QEMU) -cdrom $(ISO_IMAGE)

# Aufräumen
clean:
	rm -f $(BOOT_SECTOR) $(KERNEL_OBJ) $(KERNEL_BIN) $(ISO_IMAGE)