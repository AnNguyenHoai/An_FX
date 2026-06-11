#ifndef MARKET_DATA_ENGINE_MQH
#define MARKET_DATA_ENGINE_MQH

#include "EngineBase.mqh"

class CMarketDataEngine : public CEngineBase
{
private:

    string m_symbol;

    double m_bid;
    double m_ask;
    double m_spread;

public:

    void Configure(string symbol)
    {
        m_symbol = symbol;
    }

    virtual bool Initialize()
    {
        SetName("MarketDataEngine");

        return true;
    }

    virtual void Update()
    {
        m_bid = SymbolInfoDouble(m_symbol,
                                 SYMBOL_BID);

        m_ask = SymbolInfoDouble(m_symbol,
                                 SYMBOL_ASK);

        m_spread = (m_ask - m_bid) / _Point;
    }

    double GetBid()
    {
        return m_bid;
    }

    double GetAsk()
    {
        return m_ask;
    }

    double GetSpread()
    {
        return m_spread;
    }
};

#endif