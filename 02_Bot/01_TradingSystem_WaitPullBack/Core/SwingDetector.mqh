#ifndef SWING_DETECTOR_MQH
#define SWING_DETECTOR_MQH

#include "../Models/SwingPoint.mqh"

class CSwingDetector
{
private:

    int m_swing_length;

public:

    void Configure(int swing_length)
    {
        m_swing_length = swing_length;
    }

    bool IsSwingHigh(const MqlRates &rates[],
                     int index)
    {
        double current_high = rates[index].high;

        for(int i = 1; i <= m_swing_length; i++)
        {
            if(rates[index - i].high >= current_high)
                return false;

            if(rates[index + i].high > current_high)
                return false;
        }

        return true;
    }

    bool IsSwingLow(const MqlRates &rates[],
                    int index)
    {
        double current_low = rates[index].low;

        for(int i = 1; i <= m_swing_length; i++)
        {
            if(rates[index - i].low <= current_low)
                return false;

            if(rates[index + i].low < current_low)
                return false;
        }

        return true;
    }
    SwingPoint DetectSwingHigh(const MqlRates &rates[],
                               int index)
    {
        SwingPoint swing = CreateEmptySwing();

        if(!IsSwingHigh(rates,
                        index))
        {
            return swing;
        }

        swing.index = index;

        swing.time = rates[index].time;

        swing.price = rates[index].high;

        swing.type = SWING_HIGH;

        swing.is_valid = true;

        swing.is_confirmed = true;

        swing.volume = rates[index].tick_volume;

        return swing;
    }

    SwingPoint DetectSwingLow(const MqlRates &rates[],
                              int index)
    {
        SwingPoint swing = CreateEmptySwing();

        if(!IsSwingLow(rates,
                       index))
        {
            return swing;
        }

        swing.index = index;

        swing.time = rates[index].time;

        swing.price = rates[index].low;

        swing.type = SWING_LOW;

        swing.is_valid = true;

        swing.is_confirmed = true;

        swing.volume = rates[index].tick_volume;

        return swing;
    }
};

#endif    