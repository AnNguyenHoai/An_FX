#pragma once

struct GridLevel
{
   double price;

   bool active;

   ulong ticket;

   void Reset()
   {
      price = 0.0;

      active = false;

      ticket = 0;
   }
};