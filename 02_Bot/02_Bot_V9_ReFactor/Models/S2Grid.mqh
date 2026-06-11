#pragma once

#include "PositionInfo.mqh"

struct S2Grid
{
   int maxOrders;

   double step;

   PositionInfo orders[MAX_S2_ORDERS];

   void Reset()
   {
      maxOrders = 0;

      step = 0;

      for(int i=0;i<MAX_S2_ORDERS;i++)
      {
         orders[i].Reset();
      }
   }
};