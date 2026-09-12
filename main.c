#include <stdint.h>

void uart_puts(const char *s);

volatile uint32_t test_value = 0;

int main(void)
{
    uart_puts("Hello from Cortex-M3!\n");

    test_value = 0x12345678;

    uart_puts("test_value initialized\n");

    while (1)
    {
        test_value++;
    }
}