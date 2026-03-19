#include <stdint.h>

extern "C" void kernel_main() {
    // Einfache Ausgabe auf den Bildschirm (VGA-Textmodus)
    const char *message = "Welcome to LixiOS! (C++ Kernel)";
    volatile uint16_t *vga = (uint16_t*)0xB8000;
    
    for (int i = 0; message[i] != 0; i++) {
        vga[i] = (0x0F << 8) | message[i]; // Weiß auf Schwarz
    }
    
    // Endlosschleife
    while (1) {
        asm("hlt"); // CPU anhalten, um Energie zu sparen
    }
}