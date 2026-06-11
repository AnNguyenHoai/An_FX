#pragma once

#include "PositionInfo.mqh"

struct S1Grid
{
   double anchorPrice;

   int maxOrders;

   double step;

   double tp;

   double lot;

   PositionInfo orders[MAX_S1_ORDERS];

   void Reset()
   {
      anchorPrice = 0;

      maxOrders = 0;

      step = 0;

      tp = 0;

      lot = 0;

      for(int i=0;i<MAX_S1_ORDERS;i++)
      {
         orders[i].Reset();
      }
   }
};