#ifndef CANDLE_CACHE_ENGINE_MQH

    int m_cache_size;

    datetime m_last_bar_time;

    MqlRates m_rates[];

public:

    void Configure(string symbol,
                   ENUM_TIMEFRAMES tf,
                   int cache_size)
    {
        m_symbol = symbol;
        m_tf = tf;
        m_cache_size = cache_size;
    }

    virtual bool Initialize()
    {
        SetName("CandleCacheEngine");

        ArraySetAsSeries(m_rates,
                         true);

        return LoadRates();
    }

    bool LoadRates()
    {
        int copied = CopyRates(m_symbol,
                               m_tf,
                               0,
                               m_cache_size,
                               m_rates);

        if(copied <= 0)
            return false;

        m_last_bar_time = m_rates[0].time;

        return true;
    }

    bool IsNewBar()
    {
        datetime current_bar = iTime(m_symbol,
                                     m_tf,
                                     0);

        return current_bar != m_last_bar_time;
    }
    virtual void Update()
    {
        if(IsNewBar())
        {
            LoadRates();
        }
    }

    int Size()
    {
        return ArraySize(m_rates);
    }

    const MqlRates& GetCandle(int index)
    {
        return m_rates[index];
    }

    const MqlRates& GetRates()
    {
        return m_rates[0];
    }
};

#endif