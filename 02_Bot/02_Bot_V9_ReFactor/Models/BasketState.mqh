#pragma once

struct BasketState
{
   double totalProfit;

   double totalLot;

   double targetProfit;

   int activeS1;

   int activeS2;

   bool coverActive;

   void Reset()
   {
      totalProfit = 0;

      totalLot = 0;

      targetProfit = 0;

      activeS1 = 0;

      activeS2 = 0;

      coverActive = false;
   }
};