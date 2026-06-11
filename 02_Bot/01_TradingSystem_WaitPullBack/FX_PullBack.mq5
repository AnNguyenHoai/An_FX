#property strict
input double InpSweepVolumeMultiplier = 1.5;

input bool InpEnableDebug = true;

#include "Core/EngineManager.mqh"
#include "Core/MarketDataEngine.mqh"
#include "Core/CandleCacheEngine.mqh"
#include "Core/TimeframeEngine.mqh"
#include "Core/DebugEngine.mqh"
#include "Core/StructureEngine.mqh"
#include "Core/LiquidityEngine.mqh"

CEngineManager g_engine_manager;

CMarketDataEngine g_market_engine;
CCandleCacheEngine g_cache_engine;
CTimeframeEngine g_tf_engine;
CDebugEngine g_debug_engine;

CStructureEngine g_structure_engine;
CLiquidityEngine g_liquidity_engine;

int OnInit()
{
    g_debug_engine.Configure(InpEnableDebug);

    g_market_engine.Configure(_Symbol);

    g_cache_engine.Configure(_Symbol,
                             PERIOD_M1,
                             InpCacheSize);

    g_tf_engine.Configure(InpHTF,
                          InpLTF);

    g_structure_engine.Configure(&g_cache_engine,
                                 InpSwingLength);

    g_liquidity_engine.Configure(&g_structure_engine,
                                 &g_cache_engine,
                                 InpLiquidityTolerance,
                                 InpSweepVolumeMultiplier);

    g_engine_manager.Register(&g_debug_engine);
    g_engine_manager.Register(&g_market_engine);
    g_engine_manager.Register(&g_cache_engine);
    g_engine_manager.Register(&g_tf_engine);
    g_engine_manager.Register(&g_structure_engine);
    g_engine_manager.Register(&g_liquidity_engine);

    if(!g_engine_manager.InitializeAll())
    {
        Print("Engine initialization failed");
        return INIT_FAILED;
    }

    Print("FX PullBack initialized");

    return INIT_SUCCEEDED;
}

void OnTick()
{
    g_engine_manager.UpdateAll();
}

void OnDeinit(const int reason)
{
    g_engine_manager.ShutdownAll();
}