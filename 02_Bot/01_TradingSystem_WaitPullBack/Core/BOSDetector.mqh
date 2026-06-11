#ifndef BOS_DETECTOR_MQH
#define BOS_DETECTOR_MQH

#include "../Models/BOSSignal.mqh"
#include "../Models/SwingPoint.mqh"

class CBOSDetector
{
public:

    BOSSignal DetectBOS(const MqlRates &rates[],
                        SwingPoint last_high,
                        SwingPoint last_low)
    {
        BOSSignal bos = CreateEmptyBOS();

        double confirmed_close = rates[1].close;

        if(last_high.is_valid)
        {
            if(confirmed_close > last_high.price)
            {
                bos.valid = true;

                bos.confirmed = true;

                bos.direction = BOS_UP;

                bos.break_price = last_high.price;

                bos.break_time = rates[1].time;

                bos.candle_close = confirmed_close;

                return bos;
            }
        }

        if(last_low.is_valid)
        {
            if(confirmed_close < last_low.price)
            {
                bos.valid = true;

                bos.confirmed = true;

                bos.direction = BOS_DOWN;

                bos.break_price = last_low.price;

                bos.break_time = rates[1].time;

                bos.candle_close = confirmed_close;

                return bos;
            }
        }

        return bos;
    }
};

#endif