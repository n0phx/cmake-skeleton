project(game LANGUAGES CXX)

set(GAME_SOURCES
    game/main.cpp)

source_group(TREE ${PROJECT_SOURCE_DIR} FILES ${GAME_SOURCES})

add_executable(${PROJECT_NAME} ${GAME_SOURCES})

target_link_libraries(${PROJECT_NAME} PRIVATE ${ENGINE_TARGET})
