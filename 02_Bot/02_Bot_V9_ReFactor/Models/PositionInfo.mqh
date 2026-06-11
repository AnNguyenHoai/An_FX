#pragma once

struct PositionInfo
{
   ulong ticket;

   double lot;

   double openPrice;

   double tpPrice;

   int level;

   ORDER_LAYER layer;

   bool active;

   void Reset()
   {
      ticket = 0;

      lot = 0.0;

      openPrice = 0.0;

      tpPrice = 0.0;

      level = 0;

      layer = LAYER_S1;

      active = false;
   }
};