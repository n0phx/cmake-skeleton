#include "engine/engine.h"

#pragma warning(push)
#pragma warning(disable : 4365)
#include <iostream>
#include <stdexcept>
#pragma warning(pop)


int main(int argc, char* argv[])
{
    try
    {
        engine::Engine engine_instance;
        engine_instance.run();
    }
    catch (const std::runtime_error& e)
    {
        std::cout << e.what() << std::endl;
    }
    return 0;
}
