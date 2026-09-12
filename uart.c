#include <stdint.h>

#define UART0_BASE 0x4000C000U

#define UARTDR     (*(volatile uint32_t *)(UART0_BASE + 0x000))
#define UARTFR     (*(volatile uint32_t *)(UART0_BASE + 0x018))

#define UARTFR_TXFF (1U << 5)

static void uart_putc(char c)
{
    /* Wait while TX FIFO is full */
    while (UARTFR & UARTFR_TXFF)
        ;

    UARTDR = (uint32_t)c;
}

void uart_puts(const char *s)
{
    while (*s)
    {
        if (*s == '\n')
            uart_putc('\r');

        uart_putc(*s++);
    }
}