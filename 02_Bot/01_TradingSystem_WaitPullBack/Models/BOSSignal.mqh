#ifndef MODEL_BOS_SIGNAL_MQH
    BOS_QUALITY_STRONG,

    BOS_QUALITY_EXTREME
};

//+------------------------------------------------------------------+
//| BOSSignal                                                        |
//+------------------------------------------------------------------+

struct BOSSignal
{
    ENUM_BOS_DIRECTION direction;

    ENUM_BOS_TYPE type;

    ENUM_BOS_QUALITY quality;

    datetime break_time;

    double break_price;

    double candle_close;

    double displacement_size;

    double volume_ratio;

    bool confirmed;

    bool liquidity_sweep;

    bool valid;
};

//+------------------------------------------------------------------+
//| CreateEmptyBOS                                                   |
//+------------------------------------------------------------------+

BOSSignal CreateEmptyBOS()
{
    BOSSignal bos;

    bos.direction = BOS_NONE;

    bos.type = BOS_STANDARD;

    bos.quality = BOS_QUALITY_WEAK;

    bos.break_time = 0;

    bos.break_price = 0;

    bos.candle_close = 0;

    bos.displacement_size = 0;

    bos.volume_ratio = 0;

    bos.confirmed = false;

    bos.liquidity_sweep = false;

    bos.valid = false;

    return bos;
}

#endif