#ifndef STRUCTURE_ENGINE_MQH
    CTrendAnalyzer m_trend_analyzer;

    SwingPoint m_last_high;
    SwingPoint m_prev_high;

    SwingPoint m_last_low;
    SwingPoint m_prev_low;

    BOSSignal m_last_bos;

    TrendState m_trend_state;

    datetime m_last_processed_bar;

    int m_swing_length;

public:

    void Configure(CCandleCacheEngine* cache,
                   int swing_length)
    {
        m_cache = cache;

        m_swing_length = swing_length;

        m_swing_detector.Configure(swing_length);
    }

    virtual bool Initialize()
    {
        SetName("StructureEngine");

        m_last_high = CreateEmptySwing();
        m_prev_high = CreateEmptySwing();

        m_last_low = CreateEmptySwing();
        m_prev_low = CreateEmptySwing();

        m_last_bos = CreateEmptyBOS();

        m_trend_state = CreateEmptyTrendState();

        m_last_processed_bar = 0;

        return true;
    }

        AnalyzeBOS();

        AnalyzeTrend();
    }

    void AnalyzeRecentSwing(int index)
    {
        const MqlRates &rates[] = m_cache->GetRates();

        SwingPoint high =
            m_swing_detector.DetectSwingHigh(rates,
                                             index);

        if(high.is_valid)
        {
            m_prev_high = m_last_high;
            m_last_high = high;
        }

        SwingPoint low =
            m_swing_detector.DetectSwingLow(rates,
                                            index);

        if(low.is_valid)
        {
            m_prev_low = m_last_low;
            m_last_low = low;
        }
    }

    void AnalyzeBOS()
    {
        const MqlRates &rates[] = m_cache->GetRates();

        m_last_bos =
            m_bos_detector.DetectBOS(rates,
                                     m_last_high,
                                     m_last_low);
    }

    void AnalyzeTrend()
    {
        m_trend_state =
            m_trend_analyzer.Analyze(m_last_high,
                                     m_prev_high,
                                     m_last_low,
                                     m_prev_low);
    }

    SwingPoint GetLastHigh()
    {
        return m_last_high;
    }

    SwingPoint GetPreviousHigh()
    {
        return m_prev_high;
    }

    SwingPoint GetLastLow()
    {
        return m_last_low;
    }

    SwingPoint GetPreviousLow()
    {
        return m_prev_low;
    }

    BOSSignal GetLastBOS()
    {
        return m_last_bos;
    }

    TrendState GetTrendState()
    {
        return m_trend_state;
    }
};

#endif    