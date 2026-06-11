#pragma once

#include "../Execution/OrderManager.mqh"

class CFreezeManager
{
private:

   double m_freezeLot;

   COrderManager *m_orderManager;

public:

   CFreezeManager()
   {
      m_freezeLot = 0.01;

      m_orderManager = NULL;
   }
   
   void Initialize(
      COrderManager &manager,
      const double freezeLot)
   {
      m_orderManager =
         &manager;

      m_freezeLot =
         freezeLot;
   }
   bool IsFrozen()
   {
      if(m_orderManager == NULL)
         return false;

      return
         m_orderManager
         ->
         IsFreezeSignalPresent(
            m_freezeLot);
   }
   bool CanOpenNewOrder()
   {
      return
         !IsFrozen();
   }
};