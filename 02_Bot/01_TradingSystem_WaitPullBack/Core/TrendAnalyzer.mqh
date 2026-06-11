#ifndef TREND_ANALYZER_MQH
#define TREND_ANALYZER_MQH

#include "../Models/TrendState.mqh"
#include "../Models/SwingPoint.mqh"

class CTrendAnalyzer
{
public:

    TrendState Analyze(SwingPoint last_high,
                       SwingPoint prev_high,
                       SwingPoint last_low,
                       SwingPoint prev_low)
    {
        TrendState state = CreateEmptyTrendState();

        if(!last_high.is_valid ||
           !prev_high.is_valid ||
           !last_low.is_valid ||
           !prev_low.is_valid)
        {
            return state;
        }

        state.valid = true;

        if(last_high.price > prev_high.price &&
           last_low.price > prev_low.price)
        {
            state.trend = TREND_BULLISH;

            state.bullish_structure = true;

            state.buyers_in_control = true;

            state.control = CONTROL_BUYERS;
        }
        else if(last_high.price < prev_high.price &&
                last_low.price < prev_low.price)
        {
            state.trend = TREND_BEARISH;

            state.bearish_structure = true;

            state.sellers_in_control = true;

            state.control = CONTROL_SELLERS;
        }
        else
        {
            state.trend = TREND_RANGE;

            state.ranging_structure = true;

            state.equilibrium = true;

            state.control = CONTROL_BALANCED;
        }

        state.updated_time = TimeCurrent();

        return state;
    }
};

#endif