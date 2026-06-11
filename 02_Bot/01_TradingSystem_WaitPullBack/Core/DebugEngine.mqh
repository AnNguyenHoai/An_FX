#ifndef DEBUG_ENGINE_MQH
#define DEBUG_ENGINE_MQH

#include "EngineBase.mqh"

enum ENUM_LOG_LEVEL
{
    LOG_INFO,
    LOG_WARNING,
    LOG_ERROR,
    LOG_TRACE
};

class CDebugEngine : public CEngineBase
{
private:

    bool m_enabled_debug;

public:

    void Configure(bool enabled)
    {
        m_enabled_debug = enabled;
    }

    void Log(string text,
             ENUM_LOG_LEVEL level = LOG_INFO)
    {
        if(!m_enabled_debug)
            return;

        string prefix = "[INFO] ";

        switch(level)
        {
            case LOG_WARNING:
                prefix = "[WARNING] ";
                break;

            case LOG_ERROR:
                prefix = "[ERROR] ";
                break;

            case LOG_TRACE:
                prefix = "[TRACE] ";
                break;
        }

        Print(prefix + text);
    }
};

#endif