#ifndef MODEL_LIQUIDITY_STATE_MQH
#define MODEL_LIQUIDITY_STATE_MQH

//+------------------------------------------------------------------+
//| ENUM_LIQUIDITY_STATE                                             |
//+------------------------------------------------------------------+

enum ENUM_LIQUIDITY_STATE
{
    LIQUIDITY_CREATED,

    LIQUIDITY_ACTIVE,

    LIQUIDITY_SWEPT,

    LIQUIDITY_INVALIDATED,

    LIQUIDITY_EXPIRED
};

//+------------------------------------------------------------------+
//| ENUM_LIQUIDITY_TYPE                                              |
//+------------------------------------------------------------------+

enum ENUM_LIQUIDITY_TYPE
{
    LIQUIDITY_NONE,

    BUY_SIDE_LIQUIDITY,

    SELL_SIDE_LIQUIDITY,

    INTERNAL_LIQUIDITY,

    EXTERNAL_LIQUIDITY
};

//+------------------------------------------------------------------+
//| ENUM_LIQUIDITY_STRENGTH                                          |
//+------------------------------------------------------------------+

enum ENUM_LIQUIDITY_STRENGTH
{
    LIQUIDITY_WEAK,

    LIQUIDITY_MEDIUM,

    LIQUIDITY_STRONG,

    LIQUIDITY_EXTREME
};

#endif