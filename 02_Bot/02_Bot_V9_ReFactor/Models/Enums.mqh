#pragma once

enum TRADE_MODE
{
   BUY_ONLY = 0,
   SELL_ONLY,
   BOTH_SIDE
};

enum EA_STATE
{
   EA_IDLE = 0,
   EA_BUILD_S1,
   EA_MANAGE_S1,
   EA_BUILD_S2,
   EA_FROZEN
};

enum ORDER_LAYER
{
   LAYER_S1 = 0,
   LAYER_S2
};

enum DIRECTION
{
   DIR_BUY = 0,
   DIR_SELL
};