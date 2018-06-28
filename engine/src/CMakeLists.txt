project(engine LANGUAGES CXX)

set(OpenGL_GL_PREFERENCE GLVND)
find_package(OpenGL MODULE REQUIRED)

set(GLAD_PROFILE "core" CACHE STRING "" FORCE)
set(GLAD_API "gl=3.3" CACHE STRING "" FORCE)
set(GLAD_GENERATOR "c" CACHE STRING "" FORCE)
set(GLAD_EXTENSIONS "" CACHE STRING "" FORCE)
set(GLAD_SPEC "gl" CACHE STRING "" FORCE)
set(GLAD_NO_LOADER OFF CACHE BOOL "" FORCE)

set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)

add_subdirectory("${CMAKE_SOURCE_DIR}/ext/glad" ext/glad EXCLUDE_FROM_ALL)
add_subdirectory("${CMAKE_SOURCE_DIR}/ext/glfw" ext/glfw EXCLUDE_FROM_ALL)

set_target_properties(glad glad-generate-files glfw
                      PROPERTIES FOLDER ext)

set(ENGINE_SOURCES
    engine/engine.h
    engine/engine.cpp)

source_group(TREE ${PROJECT_SOURCE_DIR} FILES ${ENGINE_SOURCES})

add_library(${PROJECT_NAME} ${ENGINE_SOURCES})

target_link_libraries(${PROJECT_NAME}
    PRIVATE ${OPENGL_LIBRARY} glad glfw ${GLFW_LIBRARIES})
# GLAD when used as a submodule, doesn't seem to be exporting the include
# directories properly
target_include_directories(${PROJECT_NAME}
    PRIVATE ${GLAD_INCLUDE_DIRS}
    INTERFACE ${PROJECT_SOURCE_DIR})
