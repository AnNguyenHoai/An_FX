#ifndef LIQUIDITY_ENGINE_MQH
#define LIQUIDITY_ENGINE_MQH

#include "EngineBase.mqh"

#include "StructureEngine.mqh"

#include "EqualHighDetector.mqh"
#include "EqualLowDetector.mqh"

#include "SweepDetector.mqh"

#include "LiquidityRanking.mqh"

#include "../Models/LiquidityZone.mqh"
#include "../Models/SweepEvent.mqh"

class CLiquidityEngine : public CEngineBase
{
private:

    CStructureEngine* m_structure;

    CCandleCacheEngine* m_cache;

    CEqualHighDetector m_equal_high_detector;

    CEqualLowDetector m_equal_low_detector;

    CSweepDetector m_sweep_detector;

    CLiquidityRanking m_ranking;

    LiquidityZone m_zones[];

    SweepEvent m_sweeps[];

    datetime m_last_processed_bar;

private:

    bool ZoneExists(LiquidityZone zone)
    {
        for(int i = 0; i < ArraySize(m_zones); i++)
        {
            if(!m_zones[i].valid)
                continue;

            if(m_zones[i].type != zone.type)
                continue;

            double distance_upper =
                MathAbs(m_zones[i].upper_price -
                        zone.upper_price) / _Point;

            double distance_lower =
                MathAbs(m_zones[i].lower_price -
                        zone.lower_price) / _Point;

            if(distance_upper <= 2 &&
               distance_lower <= 2)
            {
                return true;
            }
        }

        return false;
    }
    void AddZone(LiquidityZone zone)
    {
        if(ZoneExists(zone))
            return;

        int size = ArraySize(m_zones);

        ArrayResize(m_zones,
                    size + 1);

        zone.id = size;

        zone.created_time = TimeCurrent();

        zone.updated_time = TimeCurrent();

        zone.state = LIQUIDITY_ACTIVE;

        zone.valid = true;

        m_zones[size] = zone;
    }

    void AddSweep(SweepEvent event)
    {
        int size = ArraySize(m_sweeps);

        ArrayResize(m_sweeps,
                    size + 1);

        m_sweeps[size] = event;
    }

    void CleanupZones()
    {
        for(int i = ArraySize(m_zones) - 1;
            i >= 0;
            i--)
        {
            if(m_zones[i].state == LIQUIDITY_INVALIDATED ||
               m_zones[i].state == LIQUIDITY_EXPIRED)
            {
                ArrayRemove(m_zones,
                            i,
                            1);
            }
        }
    }

    void UpdateZoneState()
    {
        const MqlRates &rates[] = m_cache->GetRates();

        double close_price = rates[1].close;

        for(int i = 0; i < ArraySize(m_zones); i++)
        {
            if(!m_zones[i].valid)
                continue;

            if(m_zones[i].state != LIQUIDITY_ACTIVE)
                continue;

            //==============================================
            // Buy-side liquidity invalidation
            //==============================================

            if(m_zones[i].type == BUY_SIDE_LIQUIDITY)
            {
                if(close_price >
                   m_zones[i].upper_price)
                {
                    m_zones[i].state =
                        LIQUIDITY_INVALIDATED;
                }
            }

            //==============================================
            // Sell-side liquidity invalidation
            //==============================================

            if(m_zones[i].type == SELL_SIDE_LIQUIDITY)
            {
                if(close_price <
                   m_zones[i].lower_price)
                {
                    m_zones[i].state =
                        LIQUIDITY_INVALIDATED;
                }
            }
        }
    }
    void DetectLiquidityZones()
    {
        const MqlRates &rates[] =
            m_cache->GetRates();

        //==============================================
        // Equal High
        //==============================================

        LiquidityZone high_zone =
            m_equal_high_detector.Detect(
                rates,
                m_structure->GetLastHigh(),
                m_structure->GetPreviousHigh());

        if(high_zone.valid)
        {
            high_zone.strength =
                m_ranking.Rank(high_zone);

            AddZone(high_zone);
        }

        //==============================================
        // Equal Low
        //==============================================

        LiquidityZone low_zone =
            m_equal_low_detector.Detect(
                rates,
                m_structure->GetLastLow(),
                m_structure->GetPreviousLow());

        if(low_zone.valid)
        {
            low_zone.strength =
                m_ranking.Rank(low_zone);

            AddZone(low_zone);
        }
    }

    void DetectSweeps()
    {
        const MqlRates &rates[] =
            m_cache->GetRates();

        for(int i = 0; i < ArraySize(m_zones); i++)
        {
            if(!m_zones[i].valid)
                continue;

            if(m_zones[i].state !=
               LIQUIDITY_ACTIVE)
            {
                continue;
            }

            SweepEvent event =
                m_sweep_detector.Detect(
                    rates,
                    m_zones[i]);

            if(event.confirmed)
            {
                event.zone_id =
                    m_zones[i].id;

                AddSweep(event);

                m_zones[i].state =
                    LIQUIDITY_SWEPT;

                m_zones[i].swept = true;

                m_zones[i].swept_time =
                    TimeCurrent();
            }
        }
    }

public:

    void Configure(CStructureEngine* structure,
                   CCandleCacheEngine* cache,
                   double tolerance_points,
                   double volume_multiplier)
    {
        m_structure = structure;

        m_cache = cache;

        m_equal_high_detector.Configure(
            tolerance_points);

        m_equal_low_detector.Configure(
            tolerance_points);

        m_sweep_detector.Configure(
            volume_multiplier);
    }

    virtual bool Initialize()
    {
        SetName("LiquidityEngine");

        m_last_processed_bar = 0;

        ArrayResize(m_zones,
                    0);

        ArrayResize(m_sweeps,
                    0);

        return true;
    }

    virtual void Update()
    {
        if(m_cache->Size() < 50)
            return;

        const MqlRates &latest =
            m_cache->GetCandle(0);

        if(latest.time ==
           m_last_processed_bar)
        {
            return;
        }

        m_last_processed_bar =
            latest.time;

        ExecuteLiquidityAnalysis();
    }

    void ExecuteLiquidityAnalysis()
    {
        DetectLiquidityZones();

        DetectSweeps();

        UpdateZoneState();

        CleanupZones();
    }

    int GetZoneCount()
    {
        return ArraySize(m_zones);
    }

    LiquidityZone GetZone(int index)
    {
        return m_zones[index];
    }

    int GetSweepCount()
    {
        return ArraySize(m_sweeps);
    }

    SweepEvent GetSweep(int index)
    {
        return m_sweeps[index];
    }
};

#endif