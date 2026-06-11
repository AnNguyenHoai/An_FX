#pragma once

#include "ZoneManager.mqh"
class CEmergencyManager
{
private:

   double m_breakDistance;

   CZoneManager *m_zone;

public:

   CEmergencyManager()
   {
      m_breakDistance = 0;
      m_zone = NULL;
   }
   void Initialize(
      CZoneManager &zone,
      const double breakDistance)
   {
      m_zone = &zone;

      m_breakDistance =
         breakDistance;
   }
   double CurrentPrice()
   {
      double bid =
         SymbolInfoDouble(
            Symbol(),
            SYMBOL_BID);

      double ask =
         SymbolInfoDouble(
            Symbol(),
            SYMBOL_ASK);

      return (bid+ask)*0.5;
   }
   bool IsBuyEmergency()
   {
      if(m_zone == NULL)
         return false;

      double trigger =
         m_zone->ZoneLow()
         -
         m_breakDistance;

      return
         CurrentPrice()
         <
         trigger;
   }
   bool IsSellEmergency()
   {
      if(m_zone == NULL)
         return false;

      double trigger =
         m_zone->ZoneHigh()
         +
         m_breakDistance;

      return
         CurrentPrice()
         >
         trigger;
   }
   bool IsEmergency(
      const DIRECTION direction)
   {
      if(direction == DIR_BUY)
         return IsBuyEmergency();

      return IsSellEmergency();
   }
};