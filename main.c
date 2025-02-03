#include "stm32f4xx.h"

int main(void)
{
  // Description: Test GPIO

  // Enable clock for GPIOD
  RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOD, ENABLE);

  // Configure all relevant pins as output
  GPIO_InitTypeDef GPIO_InitStruct;
  GPIO_InitStruct.GPIO_Pin  = GPIO_Pin_12 | GPIO_Pin_13 | GPIO_Pin_14 | GPIO_Pin_15;
  GPIO_InitStruct.GPIO_Mode = GPIO_Mode_OUT;
  GPIO_InitStruct.GPIO_Speed = GPIO_Speed_2MHz;
  GPIO_InitStruct.GPIO_OType = GPIO_OType_PP;
  GPIO_InitStruct.GPIO_PuPd = GPIO_PuPd_NOPULL;
  GPIO_Init(GPIOD, &GPIO_InitStruct);

  // Set all pins to LOW explicitly
  GPIO_ResetBits(GPIOD, GPIO_Pin_12 | GPIO_Pin_13 | GPIO_Pin_14 | GPIO_Pin_15);

  while(1)
  {
    // Toggle only Pin 13 (red LED)
    GPIO_SetBits(GPIOD, GPIO_Pin_13);
    for (long i = 0; i < SystemCoreClock / 30; i++)
    {
      __NOP();
    }
    GPIO_ResetBits(GPIOD, GPIO_Pin_13);
    for (long i = 0; i < SystemCoreClock / 30; i++)
    {
      __NOP();
    }
  }

  return 0;
}
