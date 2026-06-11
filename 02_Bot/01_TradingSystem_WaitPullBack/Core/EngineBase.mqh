#ifndef ENGINE_BASE_MQH
#define ENGINE_BASE_MQH

enum ENUM_ENGINE_STATE
{
    ENGINE_INITIALIZING,
    ENGINE_RUNNING,
    ENGINE_ERROR,
    ENGINE_DISABLED
};

class CEngineBase
{
protected:

    string m_name;

    bool m_enabled;

    ENUM_ENGINE_STATE m_state;

public:

    CEngineBase()
    {
        m_enabled = true;
        m_state = ENGINE_INITIALIZING;
    }

    virtual ~CEngineBase() {}

    virtual bool Initialize()
    {
        m_state = ENGINE_RUNNING;
        return true;
    }

    virtual void Update()
    {
    }

    virtual void Shutdown()
    {
    }

    void SetName(string name)
    {
        m_name = name;
    }

    string GetName()
    {
        return m_name;
    }

    bool IsEnabled()
    {
        return m_enabled;
    }

    void SetEnabled(bool enabled)
    {
        m_enabled = enabled;
    }
};

#endif