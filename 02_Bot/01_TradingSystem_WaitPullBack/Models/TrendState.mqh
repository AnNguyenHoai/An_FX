#ifndef MODEL_TREND_STATE_MQH
#define MODEL_TREND_STATE_MQH

//+------------------------------------------------------------------+
//| ENUM_MARKET_TREND                                                |
//+------------------------------------------------------------------+

enum ENUM_MARKET_TREND
{
    TREND_UNKNOWN,

    TREND_BULLISH,

    TREND_BEARISH,

    TREND_RANGE
};

//+------------------------------------------------------------------+
//| ENUM_STRUCTURE_CONTEXT                                           |
//+------------------------------------------------------------------+

enum ENUM_STRUCTURE_CONTEXT
{
    STRUCTURE_CONTEXT_NONE,

    STRUCTURE_CONTEXT_INTERNAL,

    STRUCTURE_CONTEXT_EXTERNAL
};

//+------------------------------------------------------------------+
//| ENUM_MARKET_PHASE                                                |
//+------------------------------------------------------------------+

enum ENUM_MARKET_PHASE
{
    MARKET_PHASE_UNKNOWN,

    MARKET_PHASE_ACCUMULATION,

    MARKET_PHASE_MANIPULATION,

    MARKET_PHASE_EXPANSION,

    MARKET_PHASE_DISTRIBUTION
};

//+------------------------------------------------------------------+
//| ENUM_STRUCTURE_CONTROL                                           |
//+------------------------------------------------------------------+

enum ENUM_STRUCTURE_CONTROL
{
    CONTROL_NONE,

    CONTROL_BUYERS,

    CONTROL_SELLERS,

    CONTROL_BALANCED
};

//+------------------------------------------------------------------+
//| ENUM_STRUCTURE_QUALITY                                           |
//+------------------------------------------------------------------+

enum ENUM_STRUCTURE_QUALITY
{
    STRUCTURE_QUALITY_WEAK,

    STRUCTURE_QUALITY_MEDIUM,

    STRUCTURE_QUALITY_STRONG,

    STRUCTURE_QUALITY_EXTREME
};

//+------------------------------------------------------------------+
//| TrendState                                                       |
//+------------------------------------------------------------------+

struct TrendState
{
    //==============================================================
    // Core Trend
    //==============================================================

    ENUM_MARKET_TREND trend;

    ENUM_STRUCTURE_CONTEXT structure_context;

    ENUM_MARKET_PHASE market_phase;

    ENUM_STRUCTURE_CONTROL control;

    ENUM_STRUCTURE_QUALITY quality;

    //==============================================================
    // Structure Information
    //==============================================================

    bool bullish_structure;

    bool bearish_structure;

    bool ranging_structure;

    bool internal_conflict;

    bool structure_breaking;

    bool liquidity_driven;

    //==============================================================
    // BOS Statistics
    //==============================================================

    int bullish_bos_count;

    int bearish_bos_count;

    int bullish_choch_count;

    int bearish_choch_count;

    //==============================================================
    // Strength Metrics
    //==============================================================

    double trend_strength;

    double bullish_strength;

    double bearish_strength;

    double displacement_strength;

    double momentum_strength;

    //==============================================================
    // Market Control
    //==============================================================

    bool buyers_in_control;

    bool sellers_in_control;

    bool equilibrium;

    //==============================================================
    // Structure State
    //==============================================================

    bool protected_high_active;

    bool protected_low_active;

    bool liquidity_taken;

    bool sweep_detected;

    bool valid;

    //==============================================================
    // Price References
    //==============================================================

    double protected_high;

    double protected_low;

    double equilibrium_price;

    double dealing_range_high;

    double dealing_range_low;

    //==============================================================
    // Timing
    //==============================================================

    datetime created_time;

    datetime updated_time;

    datetime last_bos_time;

    datetime last_choch_time;
};

//+------------------------------------------------------------------+
//| CreateEmptyTrendState                                            |
//+------------------------------------------------------------------+

TrendState CreateEmptyTrendState()
{
    TrendState state;

    //==============================================================
    // Core Trend
    //==============================================================

    state.trend = TREND_UNKNOWN;

    state.structure_context = STRUCTURE_CONTEXT_NONE;

    state.market_phase = MARKET_PHASE_UNKNOWN;

    state.control = CONTROL_NONE;

    state.quality = STRUCTURE_QUALITY_WEAK;

    //==============================================================
    // Structure Information
    //==============================================================

    state.bullish_structure = false;

    state.bearish_structure = false;

    state.ranging_structure = true;

    state.internal_conflict = false;

    state.structure_breaking = false;

    state.liquidity_driven = false;

    //==============================================================
    // BOS Statistics
    //==============================================================

    state.bullish_bos_count = 0;

    state.bearish_bos_count = 0;

    state.bullish_choch_count = 0;

    state.bearish_choch_count = 0;

    //==============================================================
    // Strength Metrics
    //==============================================================

    state.trend_strength = 0.0;

    state.bullish_strength = 0.0;

    state.bearish_strength = 0.0;

    state.displacement_strength = 0.0;

    state.momentum_strength = 0.0;

    //==============================================================
    // Market Control
    //==============================================================

    state.buyers_in_control = false;

    state.sellers_in_control = false;

    state.equilibrium = true;

    //==============================================================
    // Structure State
    //==============================================================

    state.protected_high_active = false;

    state.protected_low_active = false;

    state.liquidity_taken = false;

    state.sweep_detected = false;

    state.valid = false;

    //==============================================================
    // Price References
    //==============================================================

    state.protected_high = 0.0;

    state.protected_low = 0.0;

    state.equilibrium_price = 0.0;

    state.dealing_range_high = 0.0;

    state.dealing_range_low = 0.0;

    //==============================================================
    // Timing
    //==============================================================

    state.created_time = 0;

    state.updated_time = 0;

    state.last_bos_time = 0;

    state.last_choch_time = 0;

    return state;
}

#endif