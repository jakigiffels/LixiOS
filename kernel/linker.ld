# Linker Script für den Kernel
ENTRY(kernel_main)

SECTIONS {
    . = 0x100000;  # Startadresse für den Kernel
    .text : {
        *(.text)
    }
    .data : {
        *(.data)
    }
    .bss : {
        *(.bss)
    }
}