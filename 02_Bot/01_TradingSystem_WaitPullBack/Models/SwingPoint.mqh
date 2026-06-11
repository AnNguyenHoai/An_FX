#ifndef MODEL_SWING_POINT_MQH
#define MODEL_SWING_POINT_MQH

enum ENUM_SWING_TYPE
{
    SWING_NONE,
    SWING_HIGH,
    SWING_LOW
};

enum ENUM_SWING_STRENGTH
{
    SWING_WEAK,
    SWING_MEDIUM,
    SWING_STRONG,
    SWING_EXTREME
};

struct SwingPoint
{
    int index;

    datetime time;

    double price;

    ENUM_SWING_TYPE type;

    ENUM_SWING_STRENGTH strength;

    bool is_valid;

    bool is_confirmed;

    long volume;
};

SwingPoint CreateEmptySwing()
{
    SwingPoint swing;

    swing.index = -1;
    swing.time = 0;
    swing.price = 0;

    swing.type = SWING_NONE;

    swing.strength = SWING_WEAK;

    swing.is_valid = false;

    swing.is_confirmed = false;

    swing.volume = 0;

    return swing;
}

#endif