#pragma once

#include "../Models/S2Grid.mqh"

#include "../Models/BasketState.mqh"

#include "../Risk/LotCalculator.mqh"

#include "../Execution/OrderManager.mqh"

#include "../Safety/SafetyManager.mqh"

#include "GridEngine.mqh"


class CCoverEngine
{
private:

   S2Grid* m_grid;

   BasketState* m_basket;

   CLotCalculator* m_lotCalculator;

   COrderManager* m_orderManager;

   CSafetyManager* m_safety;

   CGridEngine* m_s1Grid;

   DIRECTION m_direction;

   datetime m_lastCloseTime;

   int m_cooldownBars;

public:

   CCoverEngine()
   {
      m_grid = NULL;

      m_basket = NULL;

      m_lotCalculator = NULL;

      m_orderManager = NULL;

      m_safety = NULL;

      m_s1Grid = NULL;

      m_direction = DIR_BUY;

      m_lastCloseTime = 0;

      m_cooldownBars = 10;
   }
   void Initialize(
      S2Grid& grid,
      BasketState& basket,
      CLotCalculator& lotCalculator,
      COrderManager& orderManager,
      CSafetyManager& safety,
      CGridEngine& s1Grid,
      DIRECTION direction,
      int cooldownBars)
   {
      m_grid = &grid;

      m_basket = &basket;

      m_lotCalculator = &lotCalculator;

      m_orderManager = &orderManager;

      m_safety = &safety;

      m_s1Grid = &s1Grid;

      m_direction = direction;

      m_cooldownBars = cooldownBars;
   }
   int ActiveS2Count()
   {
      int count = 0;

      for(int i=0;i<m_grid->maxOrders;i++)
      {
         if(m_grid->orders[i].active)
            count++;
      }

      return count;
   }
   bool IsFull()
   {
      return
         ActiveS2Count()
         >=
         m_grid->maxOrders;
   }
   bool IsCooldownActive()
   {
      if(m_lastCloseTime == 0)
         return false;
      datetime currentBar =
         iTime(
            Symbol(),
            PERIOD_CURRENT,
            0);
      int barsPassed =
         Bars(
            Symbol(),
            PERIOD_CURRENT,
            m_lastCloseTime,
            currentBar);
      return
         barsPassed
         <
         m_cooldownBars;
   }
   double LevelPrice(
      const int level)
   {
      double lastS1 =
         m_s1Grid
         ->
         LevelPrice(
            m_s1Grid
            ->
            GetGrid()
            .maxOrders
            -
            1);
S1Grid& GetGrid()
{
   return *m_grid;
}
      if(m_direction == DIR_BUY)
      {
         return
            lastS1
            -
            (
               (level+1)
               *
               m_grid->step
            );
      }
      return
         lastS1
         +
         (
            (level+1)
            *
            m_grid->step
         );
   }
   bool NeedCover()
   {
      if(IsCooldownActive())
         return false;
      if(!m_s1Grid->NeedCover())
         return false;
      if(!m_safety->CanOpenS2(
            m_direction))
      {
         return false;
      }
      if(IsFull())
         return false;
      return true;
   }
   int BuildBasket(
      PositionInfo basket[])
   {
      int index = 0;
      S1Grid& s1 =
         m_s1Grid->GetGrid();
      for(int i=0;
          i<s1.maxOrders;
          i++)
      {
         if(!s1.orders[i].active)
            continue;

         basket[index++] =
            s1.orders[i];
      }
      for(int i=0;
          i<m_grid->maxOrders;
          i++)
      {
         if(!m_grid->orders[i].active)
            continue;

         basket[index++] =
            m_grid->orders[i];
      }
      return index;
   }
   bool OpenCoverOrder()
   {
      if(!NeedCover())
         return false;
      int level =
         ActiveS2Count();
      double entry =
         LevelPrice(level);
      PositionInfo basket[200];

      int basketCount =
         BuildBasket(
            basket);
      double currentPrice =
         (
            SymbolInfoDouble(
               Symbol(),
               SYMBOL_BID)
            +
            SymbolInfoDouble(
               Symbol(),
               SYMBOL_ASK)
         )
         * 0.5;
      double lot =
         m_lotCalculator
         ->
         CalculateCoverLot(
            basket,
            basketCount,
            m_grid->step,
            currentPrice,
            m_direction);
      if(lot <= 0.0)
         return false;
      ulong ticket = 0;

      bool result = false;
      if(m_direction == DIR_BUY)
      {
         result =
            m_orderManager
            ->
            OpenBuy(
               lot,
               0,
               ticket);
      }
      else
      {
         result =
            m_orderManager
            ->
            OpenSell(
               lot,
               0,
               ticket);
      }
      if(result)
      {
         m_grid->orders[level].ticket =
            ticket;

         m_grid->orders[level].lot =
            lot;

         m_grid->orders[level].openPrice =
            currentPrice;

         m_grid->orders[level].level =
            level;

         m_grid->orders[level].active =
            true;
      }
      return result;
   }
   double BasketProfit()
   {
      PositionInfo basket[200];

      int count =
         BuildBasket(
            basket);
      return
         m_lotCalculator
         ->
         CalculateBasketProfit(
            basket,
            count);
   }
   bool IsTargetReached()
   {
      return
         BasketProfit()
         >=
         m_basket
         ->
         targetProfit;
   }
   void CloseAllS2()
   {
      for(int i=0;
          i<m_grid->maxOrders;
          i++)
      {
         if(!m_grid->orders[i].active)
            continue;
         m_orderManager
         ->
         ClosePosition(
            m_grid->orders[i].ticket);
         m_grid->orders[i].Reset();
      }
      m_lastCloseTime =
         TimeCurrent();
   }
   void Manage()
   {
      if(NeedCover())
      {
         OpenCoverOrder();
      }
      if(IsTargetReached())
      {
         CloseAllS2();
      }
   }
};