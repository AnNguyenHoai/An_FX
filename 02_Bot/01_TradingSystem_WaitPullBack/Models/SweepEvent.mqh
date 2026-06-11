#ifndef MODEL_SWEEP_EVENT_MQH
//| ENUM_SWEEP_QUALITY                                               |
//+------------------------------------------------------------------+

enum ENUM_SWEEP_QUALITY
{
    SWEEP_WEAK,

    SWEEP_MEDIUM,

    SWEEP_STRONG,

    SWEEP_EXTREME
};

//+------------------------------------------------------------------+
//| SweepEvent                                                       |
//+------------------------------------------------------------------+

struct SweepEvent
{
    int zone_id;

    ENUM_SWEEP_TYPE type;

    ENUM_SWEEP_QUALITY quality;

    datetime sweep_time;

    double sweep_price;

    double rejection_size;

    double rejection_ratio;

    double volume_ratio;

    bool displacement_confirmation;

    bool valid;

    bool confirmed;
};

//+------------------------------------------------------------------+
//| CreateEmptySweepEvent                                            |
//+------------------------------------------------------------------+

SweepEvent CreateEmptySweepEvent()
{
    SweepEvent event;

    event.zone_id = -1;

    event.type = SWEEP_NONE;

    event.quality = SWEEP_WEAK;

    event.sweep_time = 0;

    event.sweep_price = 0;

    event.rejection_size = 0;

    event.rejection_ratio = 0;

    event.volume_ratio = 0;

    event.displacement_confirmation = false;

    event.valid = false;

    event.confirmed = false;

    return event;
}

#endif