#ifndef TIMEFRAME_ENGINE_MQH
#define TIMEFRAME_ENGINE_MQH

#include "EngineBase.mqh"

class CTimeframeEngine : public CEngineBase
{
private:

    ENUM_TIMEFRAMES m_htf;

    ENUM_TIMEFRAMES m_ltf;

public:

    void Configure(ENUM_TIMEFRAMES htf,
                   ENUM_TIMEFRAMES ltf)
    {
        m_htf = htf;
        m_ltf = ltf;
    }

    ENUM_TIMEFRAMES GetHTF()
    {
        return m_htf;
    }

    ENUM_TIMEFRAMES GetLTF()
    {
        return m_ltf;
    }
};

#endif