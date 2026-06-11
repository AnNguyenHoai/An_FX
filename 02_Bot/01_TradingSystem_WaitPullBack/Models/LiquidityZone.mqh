#ifndef MODEL_LIQUIDITY_ZONE_MQH
    ENUM_LIQUIDITY_STATE state;

    datetime created_time;

    datetime updated_time;

    datetime swept_time;

    double upper_price;

    double lower_price;

    double average_price;

    double zone_size_points;

    int touch_count;

    int sweep_count;

    bool valid;

    bool swept;

    bool protected_zone;

    bool internal_zone;

    long total_volume;

    double average_volume;
};

//+------------------------------------------------------------------+
//| CreateEmptyLiquidityZone                                         |
//+------------------------------------------------------------------+

LiquidityZone CreateEmptyLiquidityZone()
{
    LiquidityZone zone;

    zone.id = -1;

    zone.type = LIQUIDITY_NONE;

    zone.strength = LIQUIDITY_WEAK;

    zone.state = LIQUIDITY_CREATED;

    zone.created_time = 0;

    zone.updated_time = 0;

    zone.swept_time = 0;

    zone.upper_price = 0;

    zone.lower_price = 0;

    zone.average_price = 0;

    zone.zone_size_points = 0;

    zone.touch_count = 0;

    zone.sweep_count = 0;

    zone.valid = false;

    zone.swept = false;

    zone.protected_zone = false;

    zone.internal_zone = false;

    zone.total_volume = 0;

    zone.average_volume = 0;

    return zone;
}

#endif