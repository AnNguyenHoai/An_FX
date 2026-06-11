#pragma once

class CZoneManager
{
private:

   double m_zoneHigh;

   double m_zoneLow;

public:

   CZoneManager()
   {
      m_zoneHigh = 0;
      m_zoneLow  = 0;
   }

   void Initialize(
      const double zoneHigh,
      const double zoneLow)
   {
      m_zoneHigh = zoneHigh;
      m_zoneLow  = zoneLow;
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

      return (bid + ask) * 0.5;
   }
   bool IsInsideZone()
   {
      double price =
         CurrentPrice();

      return
      (
         price >= m_zoneLow
         &&
         price <= m_zoneHigh
      );
   }
   bool IsAboveZone()
   {
      return
         CurrentPrice()
         >
         m_zoneHigh;
   }
   bool IsBelowZone()
   {
      return
         CurrentPrice()
         <
         m_zoneLow;
   }
   double ZoneHigh()
   {
      return m_zoneHigh;
   }

   double ZoneLow()
   {
      return m_zoneLow;
   }
};