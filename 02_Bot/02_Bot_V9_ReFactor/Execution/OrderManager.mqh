#pragma once

#include <Trade/Trade.mqh>

#include "../Models/Enums.mqh"
#include "../Models/Constants.mqh"
#include "../Models/PositionInfo.mqh"

class COrderManager
{
private:

   CTrade m_trade;

   long   m_magic;

public:

   COrderManager()
   {
      m_magic = 0;
   }

   void Initialize(long magic)
   {
      m_magic = magic;

      m_trade.SetExpertMagicNumber(m_magic);
   }

   long Magic() const
   {
      return m_magic;
   }
   bool OpenBuy(
      const double lot,
      const double tpPrice,
      ulong &ticket)
   {
      ticket = 0;

      double ask =
         SymbolInfoDouble(
            Symbol(),
            SYMBOL_ASK);

      bool result =
         m_trade.Buy(
            lot,
            Symbol(),
            ask,
            0.0,
            tpPrice);

      if(!result)
         return false;

      ticket =
         m_trade.ResultOrder();

      return true;
   }
   bool OpenSell(
      const double lot,
      const double tpPrice,
      ulong &ticket)
   {
      ticket = 0;

      double bid =
         SymbolInfoDouble(
            Symbol(),
            SYMBOL_BID);

      bool result =
         m_trade.Sell(
            lot,
            Symbol(),
            bid,
            0.0,
            tpPrice);

      if(!result)
         return false;

      ticket =
         m_trade.ResultOrder();

      return true;
   }
   bool OpenBuyLimit(
      const double lot,
      const double entryPrice,
      const double tpPrice,
      ulong &ticket)
   {
      ticket = 0;

      bool result =
         m_trade.BuyLimit(
            lot,
            entryPrice,
            Symbol(),
            0.0,
            tpPrice);

      if(!result)
         return false;

      ticket =
         m_trade.ResultOrder();

      return true;
   }
   bool OpenSellLimit(
      const double lot,
      const double entryPrice,
      const double tpPrice,
      ulong &ticket)
   {
      ticket = 0;

      bool result =
         m_trade.SellLimit(
            lot,
            entryPrice,
            Symbol(),
            0.0,
            tpPrice);

      if(!result)
         return false;

      ticket =
         m_trade.ResultOrder();

      return true;
   }
   bool ClosePosition(
      const ulong ticket)
   {
      if(ticket == 0)
         return false;

      return
         m_trade.PositionClose(
            ticket);
   }
   bool IsMyPosition(
      const ulong ticket)
   {
      if(!PositionSelectByTicket(ticket))
         return false;

      long magic =
         PositionGetInteger(
            POSITION_MAGIC);

      return
         magic == m_magic;
   }
   int CountPositions()
   {
      int count = 0;

      for(int i=PositionsTotal()-1;i>=0;i--)
      {
         ulong ticket =
            PositionGetTicket(i);

         if(!PositionSelectByTicket(ticket))
            continue;

         if(!IsMyPosition(ticket))
            continue;

         count++;
      }

      return count;
   }
   int CountBuyPositions()
   {
      int count = 0;

      for(int i=PositionsTotal()-1;i>=0;i--)
      {
         ulong ticket =
            PositionGetTicket(i);

         if(!PositionSelectByTicket(ticket))
            continue;

         if(!IsMyPosition(ticket))
            continue;

         ENUM_POSITION_TYPE type =
            (ENUM_POSITION_TYPE)
            PositionGetInteger(
               POSITION_TYPE);

         if(type == POSITION_TYPE_BUY)
            count++;
      }

      return count;
   }
   int CountSellPositions()
   {
      int count = 0;

      for(int i=PositionsTotal()-1;i>=0;i--)
      {
         ulong ticket =
            PositionGetTicket(i);

         if(!PositionSelectByTicket(ticket))
            continue;

         if(!IsMyPosition(ticket))
            continue;

         ENUM_POSITION_TYPE type =
            (ENUM_POSITION_TYPE)
            PositionGetInteger(
               POSITION_TYPE);

         if(type == POSITION_TYPE_SELL)
            count++;
      }

      return count;
   }
   double CalculateTotalProfit()
   {
      double profit = 0.0;

      for(int i=PositionsTotal()-1;i>=0;i--)
      {
         ulong ticket =
            PositionGetTicket(i);

         if(!PositionSelectByTicket(ticket))
            continue;

         if(!IsMyPosition(ticket))
            continue;

         profit +=
            PositionGetDouble(
               POSITION_PROFIT);
      }

      return profit;
   }
   double CalculateTotalLot()
   {
      double lot = 0.0;

      for(int i=PositionsTotal()-1;i>=0;i--)
      {
         ulong ticket =
            PositionGetTicket(i);

         if(!PositionSelectByTicket(ticket))
            continue;

         if(!IsMyPosition(ticket))
            continue;

         lot +=
            PositionGetDouble(
               POSITION_VOLUME);
      }

      return lot;
   }
   void CloseAll()
   {
      for(int i=PositionsTotal()-1;i>=0;i--)
      {
         ulong ticket =
            PositionGetTicket(i);

         if(!PositionSelectByTicket(ticket))
            continue;

         if(!IsMyPosition(ticket))
            continue;

         m_trade.PositionClose(ticket);
      }
   }
   bool IsFreezeSignalPresent(
      const double freezeLot)
   {
      for(int i=PositionsTotal()-1;i>=0;i--)
      {
         ulong ticket =
            PositionGetTicket(i);

         if(!PositionSelectByTicket(ticket))
            continue;

         double lot =
            PositionGetDouble(
               POSITION_VOLUME);

         if(
            MathAbs(
               lot-freezeLot)
            <
            FREEZE_EPSILON)
         {
            return true;
         }
      }

      return false;
   }
};