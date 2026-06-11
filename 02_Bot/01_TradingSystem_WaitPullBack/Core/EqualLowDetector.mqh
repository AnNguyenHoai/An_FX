#ifndef EQUAL_LOW_DETECTOR_MQH
#define EQUAL_LOW_DETECTOR_MQH

#include "TimelineValidator.mqh"

#include "../Models/LiquidityZone.mqh"
#include "../Models/SwingPoint.mqh"

class CEqualLowDetector
{
private:

    double m_tolerance_points;

    CTimelineValidator m_validator;

public:

    void Configure(double tolerance_points)
    {
        m_tolerance_points = tolerance_points;
    }

    bool IsEqualLow(double low1,
                    double low2)
    {
        double distance =
            MathAbs(low1 - low2) / _Point;

        return distance <= m_tolerance_points;
    }

    LiquidityZone Detect(const MqlRates &rates[],
                         SwingPoint swing1,
                         SwingPoint swing2)
    {
        LiquidityZone zone =
            CreateEmptyLiquidityZone();

        if(!swing1.is_valid ||
           !swing2.is_valid)
        {
            return zone;
        }

        if(swing1.type != SWING_LOW ||
           swing2.type != SWING_LOW)
        {
            return zone;
        }

        if(!IsEqualLow(swing1.price,
                       swing2.price))
        {
            return zone;
        }

        if(!m_validator.ValidateEqualLow(
                rates,
                swing1,
                swing2,
                m_tolerance_points))
        {
            return zone;
        }

        zone.type = SELL_SIDE_LIQUIDITY;

        zone.upper_price =
            MathMax(swing1.price,
                    swing2.price);

        zone.lower_price =
            MathMin(swing1.price,
                    swing2.price);

        zone.average_price =
            (zone.upper_price +
             zone.lower_price) / 2.0;

        zone.zone_size_points =
            (zone.upper_price -
             zone.lower_price) / _Point;

        zone.touch_count = 2;

        zone.total_volume =
            swing1.volume + swing2.volume;

        zone.average_volume =
            zone.total_volume / 2.0;

        zone.valid = true;

        return zone;
    }
};

#endif