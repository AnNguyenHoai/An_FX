#ifndef CHART_DRAWER_MQH
#define CHART_DRAWER_MQH

class CChartDrawer
{
public:

    void DrawHorizontalLine(string name,
                            double price,
                            color clr)
    {
        if(ObjectFind(0, name) < 0)
        {
            ObjectCreate(0,
                         name,
                         OBJ_HLINE,
                         0,
                         0,
                         price);
        }

        ObjectSetDouble(0,
                        name,
                        OBJPROP_PRICE,
                        price);

        ObjectSetInteger(0,
                         name,
                         OBJPROP_COLOR,
                         clr);
    }
};

#endif