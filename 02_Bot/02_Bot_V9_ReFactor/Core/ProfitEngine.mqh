#pragma once

#include "../Models/BasketState.mqh"

#include "../Models/S1Grid.mqh"

#include "../Models/S2Grid.mqh"

#include "../Risk/LotCalculator.mqh"

#include "../Execution/OrderManager.mqh"

class CProfitEngine
{
private:

   BasketState* m_basket;

   S1Grid* m_s1;

   S2Grid* m_s2;

   CLotCalculator* m_calculator;

   COrderManager* m_orderManager;

public:

   CProfitEngine()
   {
      m_basket = NULL;

      m_s1 = NULL;

      m_s2 = NULL;

      m_calculator = NULL;

      m_orderManager = NULL;
   }
   void Initialize(
      BasketState& basket,
      S1Grid& s1,
      S2Grid& s2,
      CLotCalculator& calculator,
      COrderManager& orderManager)
   {
      m_basket = &basket;

      m_s1 = &s1;

      m_s2 = &s2;

      m_calculator = &calculator;

      m_orderManager = &orderManager;
   }
   int BuildBasket(
      PositionInfo basket[])
   {
      int count = 0;
      for(int i=0;
          i<m_s1->maxOrders;
          i++)
      {
         if(!m_s1->orders[i].active)
            continue;

         basket[count++] =
            m_s1->orders[i];
      }
      for(int i=0;
          i<m_s1->maxOrders;
          i++)
      {
         if(!m_s1->orders[i].active)
            continue;

         basket[count++] =
            m_s1->orders[i];
      }
      for(int i=0;
          i<m_s2->maxOrders;
          i++)
      {
         if(!m_s2->orders[i].active)
            continue;

         basket[count++] =
            m_s2->orders[i];
      }
      return count;
   }
   double TotalProfit()
   {
      PositionInfo basket[200];

      int count =
         BuildBasket(
            basket);
   double S2Profit()
   {
      double profit = 0.0;
      for(int i=0;
          i<m_s2->maxOrders;
          i++)
      {
         if(!m_s2->orders[i].active)
            continue;
         if(
            !PositionSelectByTicket(
               m_s2->orders[i].ticket))
         {
            continue;
         }
         profit +=
            PositionGetDouble(
               POSITION_PROFIT);
      }
      return profit;
   }
   double TotalLot()
   {
      PositionInfo basket[200];

      int count =
         BuildBasket(
            basket);
      return
         m_calculator
         ->
         CalculateTotalLot(
            basket,
            count);
   }
   int ActiveS1()
   {
      int count = 0;

      for(int i=0;
          i<m_s1->maxOrders;
          i++)
      {
         if(m_s1->orders[i].active)
            count++;
      }

      return count;
   }
   int ActiveS2()
   {
      int count = 0;

      for(int i=0;
          i<m_s2->maxOrders;
          i++)
      {
         if(m_s2->orders[i].active)
            count++;
      }

      return count;
   }
   void Refresh()
   {
      m_basket->totalProfit =
         TotalProfit();
      m_basket->totalLot =
         TotalLot();
      m_basket->activeS1 =
         ActiveS1();
      m_basket->activeS2 =
         ActiveS2();
      m_basket->coverActive =
         (
            ActiveS2()
            >
            0
         );
   }
   bool IsTargetReached()
   {
      Refresh();
      return
         (
            m_basket->totalProfit
            >=
            m_basket->targetProfit
         );
   }
   void CloseAllS2()
   {
      for(int i=0;
          i<m_s2->maxOrders;
          i++)
      {
         if(!m_s2->orders[i].active)
            continue;
         m_orderManager
         ->
         ClosePosition(
            m_s2->orders[i].ticket);
         m_s2->orders[i].Reset();
      }
   }
   void Manage()
   {
      Refresh();
      if(
         IsTargetReached())
      {
         CloseAllS2();
      }
   }
};

