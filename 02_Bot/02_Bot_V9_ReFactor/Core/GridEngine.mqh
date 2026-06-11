#pragma once

#include "../Models/S1Grid.mqh"
#include "../Execution/OrderManager.mqh"
#include "../Safety/SafetyManager.mqh"

class CGridEngine
{
private:

   S1Grid* m_grid;

   COrderManager* m_orderManager;

   CSafetyManager* m_safety;

   DIRECTION m_direction;

public:

   CGridEngine()
   {
      m_grid = NULL;

      m_orderManager = NULL;

      m_safety = NULL;

      m_direction = DIR_BUY;
   }
   void Initialize(
      S1Grid& grid,
      COrderManager& orderManager,
      CSafetyManager& safety,
      DIRECTION direction)
   {
      m_grid = &grid;

      m_orderManager = &orderManager;

      m_safety = &safety;

      m_direction = direction;
   }
   void CreateAnchor()
   {
      if(m_grid == NULL)
         return;
      double bid =
         SymbolInfoDouble(
            Symbol(),
            SYMBOL_BID);

      double ask =
         SymbolInfoDouble(
            Symbol(),
            SYMBOL_ASK);
      m_grid->anchorPrice =
         (bid + ask) * 0.5;
   }
   double LevelPrice(
      const int level)
   {
      if(m_direction == DIR_BUY)
      {
         return
            m_grid->anchorPrice
            -
            (
               level
               *
               m_grid->step
            );
      }
      return
         m_grid->anchorPrice
         +
         (
            level
            *
            m_grid->step
         );
   }
   int ActiveOrderCount()
   {
      int count = 0;
      for(int i=0;
          i<m_grid->maxOrders;
          i++)
      {
         if(m_grid->orders[i].active)
            count++;
      }
      return count;
   }
   bool IsGridFull()
   {
      return
         ActiveOrderCount()
         >=
         m_grid->maxOrders;
   }
   void BuildInitialGrid()
   {
      if(m_grid == NULL)
         return;

      if(m_orderManager == NULL)
         return;
      if(!m_safety->CanOpenS1(
            m_direction))
      {
         return;
      }
      if(m_grid->anchorPrice == 0)
      {
         CreateAnchor();
      }
      for(int level=0;
          level<m_grid->maxOrders;
          level++)
      {
         if(m_grid->orders[level].active)
            continue;
         double entry =
            LevelPrice(level);
         if(m_direction == DIR_BUY)
         {
            double tp =
               entry
               +
               m_grid->tp;
            ulong ticket=0;
            bool ok =
               m_orderManager
               ->
               OpenBuyLimit(
                  m_grid->lot,
                  entry,
                  tp,
                  ticket);
            if(ok)
            {
               m_grid->orders[level].ticket =
                  ticket;

               m_grid->orders[level].lot =
                  m_grid->lot;

               m_grid->orders[level].openPrice =
                  entry;

               m_grid->orders[level].tpPrice =
                  tp;

               m_grid->orders[level].level =
                  level;

               m_grid->orders[level].active =
                  true;
            }
         }
         else
         {
            double tp =
               entry
               -
               m_grid->tp;
            ulong ticket = 0;
            bool ok =
               m_orderManager
               ->
               OpenSellLimit(
                  m_grid->lot,
                  entry,
                  tp,
                  ticket);
            if(ok)
            {
               m_grid->orders[level].ticket =
                  ticket;

               m_grid->orders[level].lot =
                  m_grid->lot;

               m_grid->orders[level].openPrice =
                  entry;

               m_grid->orders[level].tpPrice =
                  tp;

               m_grid->orders[level].level =
                  level;

               m_grid->orders[level].active =
                  true;
            }
         }
      }
   }
   void RebuildMissingLevels()
   {
      if(m_grid == NULL)
         return;
      for(int level=0;
          level<m_grid->maxOrders;
          level++)
      {
         if(m_grid->orders[level].active)
         {
            if(
               PositionSelectByTicket(
                  m_grid->orders[level].ticket))
            {
               continue;
            }
            m_grid->orders[level].Reset();
         }
         double entry =
            LevelPrice(level);
         double currentPrice =
            (
               SymbolInfoDouble(
                  Symbol(),
                  SYMBOL_BID)
               +
               SymbolInfoDouble(
                  Symbol(),
                  SYMBOL_ASK)
            ) * 0.5;
         if(
            MathAbs(
               currentPrice
               -
               entry)
            >
            m_grid->step
         )
         {
            continue;
         }
         if(!m_safety->CanOpenS1(
               m_direction))
         {
            continue;
         }
         ulong ticket = 0;
         if(m_direction == DIR_BUY)
         {
            double tp =
               entry + m_grid->tp;

            if(
               m_orderManager
               ->
               OpenBuyLimit(
                  m_grid->lot,
                  entry,
                  tp,
                  ticket))
            {
               m_grid->orders[level].ticket =
                  ticket;

               m_grid->orders[level].lot =
                  m_grid->lot;

               m_grid->orders[level].openPrice =
                  entry;

               m_grid->orders[level].tpPrice =
                  tp;

               m_grid->orders[level].level =
                  level;

               m_grid->orders[level].active =
                  true;
            }
         }
   bool NeedCover()
   {
      if(!IsGridFull())
         return false;
      double lastLevelPrice =
         LevelPrice(
            m_grid->maxOrders - 1);
      if(m_direction == DIR_BUY)
      {
         return
            SymbolInfoDouble(
               Symbol(),
               SYMBOL_BID)
            <
            (
               lastLevelPrice
               -
               m_grid->step
            );
      }
      return
         SymbolInfoDouble(
            Symbol(),
            SYMBOL_ASK)
         >
         (
            lastLevelPrice
            +
            m_grid->step
         );
   }
};