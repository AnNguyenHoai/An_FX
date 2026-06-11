#ifndef ENGINE_MANAGER_MQH
#define ENGINE_MANAGER_MQH

#include "EngineBase.mqh"

class CEngineManager
{
private:

    CEngineBase* m_engines[];

public:

    void Register(CEngineBase* engine)
    {
        int size = ArraySize(m_engines);

        ArrayResize(m_engines,
                    size + 1);

        m_engines[size] = engine;
    }

    bool InitializeAll()
    {
        int total = ArraySize(m_engines);

        for(int i = 0; i < total; i++)
        {
            if(m_engines[i] == NULL)
                continue;

            if(!m_engines[i].Initialize())
            {
                Print("Initialize failed: ",
                      m_engines[i].GetName());

                return false;
            }
        }

        return true;
    }
    void UpdateAll()
    {
        int total = ArraySize(m_engines);

        for(int i = 0; i < total; i++)
        {
            if(m_engines[i] == NULL)
                continue;

            if(!m_engines[i].IsEnabled())
                continue;

            m_engines[i].Update();
        }
    }

    void ShutdownAll()
    {
        int total = ArraySize(m_engines);

        for(int i = 0; i < total; i++)
        {
            if(m_engines[i] == NULL)
                continue;

            m_engines[i].Shutdown();
        }
    }
};

#endif