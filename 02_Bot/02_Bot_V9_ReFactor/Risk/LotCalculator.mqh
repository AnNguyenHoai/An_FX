#pragma once

#include "../Models/PositionInfo.mqh"
#include "../Models/Constants.mqh"

class CLotCalculator
{
private:

   double m_targetProfit;

public:

   CLotCalculator()
   {
      m_targetProfit = 0;
   }

   void Initialize(
      const double targetProfit)
   {
      m_targetProfit =
         targetProfit;
   }
   void SetTargetProfit(
      const double profit)
   {
      m_targetProfit =
         profit;
   }
   double GetTargetProfit() const
   {
      return
         m_targetProfit;
   }
   double CalculateBasketProfit(
      PositionInfo positions[],
      const int count)
   {
      double totalProfit = 0.0;
      for(int i=0;i<count;i++)
      {
         if(!positions[i].active)
            continue;
         if(!PositionSelectByTicket(
               positions[i].ticket))
         {
            continue;
         }
         totalProfit +=
            PositionGetDouble(
               POSITION_PROFIT);
      }

      return totalProfit;
   }
   double CalculateTotalLot(
      PositionInfo positions[],
      const int count)
   {
      double totalLot = 0.0;
      for(int i=0;i<count;i++)
      {
         if(!positions[i].active)
            continue;

         totalLot +=
            positions[i].lot;
      }

      return totalLot;
   }
   double CalculateCoverLot(
      PositionInfo positions[],
      const int count,
      const double pullbackValue,
      const double currentPrice,
      const DIRECTION direction)
   {
      double totalProfit = 0.0;
      for(int i=0;i<count;i++)
      {
         if(!positions[i].active)
            continue;
         if(!PositionSelectByTicket(
               positions[i].ticket))
         {
            continue;
         }
         double openPrice =
            PositionGetDouble(
               POSITION_PRICE_OPEN);

         double volume =
            PositionGetDouble(
               POSITION_VOLUME);
         if(direction == DIR_BUY)
         {
            double futurePrice =
               currentPrice
               +
               pullbackValue;
            double profit =
               (
                  futurePrice
                  -
                  openPrice
               )
               *
               volume
               *
               100;

            totalProfit +=
               profit;
         }
         else
         {
            double futurePrice =
               currentPrice
               -
               pullbackValue;
            double profit =
               (
                  openPrice
                  -
                  futurePrice
               )
               *
               volume
               *
               100;

            totalProfit +=
               profit;
         }
      }
      if(totalProfit >= m_targetProfit)
      {
         return 0.0;
      }
      double coverLot =
         MathAbs(
            totalProfit
            -
            m_targetProfit
         )
         /
         pullbackValue
         /
         100.0;
      coverLot =
         NormalizeDouble(
            coverLot,
            2);
      if(coverLot < 0.01)
         coverLot = 0.01;
      return coverLot;
   }
};