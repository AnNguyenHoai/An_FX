#ifndef TIMELINE_VALIDATOR_MQH
#define TIMELINE_VALIDATOR_MQH

#include "../Models/SwingPoint.mqh"

class CTimelineValidator
{
public:

    bool ValidateEqualHigh(const MqlRates &rates[],
                           SwingPoint swing1,
                           SwingPoint swing2,
                           double tolerance)
    {
        int start = MathMin(swing1.index,
                            swing2.index);

        int end = MathMax(swing1.index,
                          swing2.index);

        double level = MathMax(swing1.price,
                               swing2.price);

        for(int i = start + 1;
            i < end;
            i++)
        {
            if(rates[i].close >
               level + tolerance * _Point)
            {
                return false;
            }
        }

        return true;
    }
   bool ValidateEqualLow(const MqlRates &rates[],
                          SwingPoint swing1,
                          SwingPoint swing2,
                          double tolerance)
    {
        int start = MathMin(swing1.index,
                            swing2.index);

        int end = MathMax(swing1.index,
                          swing2.index);

        double level = MathMin(swing1.price,
                               swing2.price);

        for(int i = start + 1;
            i < end;
            i++)
        {
            if(rates[i].close <
               level - tolerance * _Point)
            {
                return false;
            }
        }

        return true;
    }
};

#endif