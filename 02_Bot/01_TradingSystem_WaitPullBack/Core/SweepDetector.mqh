#ifndef SWEEP_DETECTOR_MQH
#define SWEEP_DETECTOR_MQH

class CSweepDetector
{
private:

    double m_volume_multiplier;

public:

    void Configure(double volume_multiplier)
    {
        m_volume_multiplier = volume_multiplier;
    }

    double CalculateAverageVolume(const MqlRates &rates[],
                                  int period)
    {
        double total = 0;

        for(int i = 2; i < period + 2; i++)
        {
            total += rates[i].tick_volume;
        }

        return total / period;
    }

    SweepEvent Detect(const MqlRates &rates[],
                      LiquidityZone zone)
    {
        SweepEvent event;

        event.type = SWEEP_NONE;
        event.confirmed = false;

        if(!zone.valid)
            return event;

        double candle_high = rates[1].high;
        double candle_low  = rates[1].low;
        double candle_close = rates[1].close;

        double avg_volume =
            CalculateAverageVolume(rates,
                                   20);

        bool high_volume =
            rates[1].tick_volume >
            avg_volume * m_volume_multiplier;

        // Buy-side sweep
        if(zone.type == BUY_SIDE_LIQUIDITY)
        {
            if(candle_high > zone.upper_price &&
               candle_close < zone.upper_price &&
               high_volume)
            {
                event.type = SWEEP_BUY_SIDE;
                event.sweep_price = candle_high;
                event.sweep_time = rates[1].time;
                event.confirmed = true;

                return event;
            }
        }

        // Sell-side sweep
        if(zone.type == SELL_SIDE_LIQUIDITY)
        {
            if(candle_low < zone.lower_price &&
               candle_close > zone.lower_price &&
               high_volume)
            {
                event.type = SWEEP_SELL_SIDE;
                event.sweep_price = candle_low;
                event.sweep_time = rates[1].time;
                event.confirmed = true;

#endif