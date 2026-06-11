#ifndef LIQUIDITY_RANKING_MQH
#define LIQUIDITY_RANKING_MQH

class CLiquidityRanking
{
public:

    ENUM_LIQUIDITY_STRENGTH Rank(LiquidityZone zone)
    {
        if(zone.touch_count >= 5)
            return LIQUIDITY_EXTREME;

        if(zone.touch_count >= 4)
            return LIQUIDITY_STRONG;

        if(zone.touch_count >= 3)
            return LIQUIDITY_MEDIUM;

        return LIQUIDITY_WEAK;
    }
};

#endif