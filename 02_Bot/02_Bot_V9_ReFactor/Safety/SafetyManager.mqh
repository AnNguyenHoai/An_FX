#pragma once

#include "ZoneManager.mqh"
#include "EmergencyManager.mqh"
#include "FreezeManager.mqh"

class CSafetyManager
{
private:

   CZoneManager      *m_zone;

   CEmergencyManager *m_emergency;

   CFreezeManager    *m_freeze;

public:

   CSafetyManager()
   {
      m_zone = NULL;
      m_emergency = NULL;
      m_freeze = NULL;
   }
   void Initialize(
      CZoneManager &zone,
      CEmergencyManager &emergency,
      CFreezeManager &freeze)
   {
      m_zone      = &zone;
      m_emergency = &emergency;
      m_freeze    = &freeze;
   }
   bool CanOpenS1(
      const DIRECTION direction)
   {
      if(m_freeze->IsFrozen())
         return false;

      if(!m_zone->IsInsideZone())
         return false;

      if(m_emergency->IsEmergency(direction))
         return false;

      return true;
   }
   bool CanOpenS2(
      const DIRECTION direction)
   {
      if(m_freeze->IsFrozen())
         return false;

      if(m_emergency->IsEmergency(direction))
         return false;

      return true;
   }
};