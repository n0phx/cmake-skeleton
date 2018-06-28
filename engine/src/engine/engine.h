#pragma once

namespace engine
{

class Engine
{
public:
    Engine() = default;

    ~Engine() = default;

    Engine(const Engine&) = delete;
    Engine& operator=(const Engine&) = delete;

    Engine(Engine&&) = default;
    Engine& operator=(Engine&&) = default;

    void run();
};

}  // namespace engine
