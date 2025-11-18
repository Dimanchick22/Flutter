# Project-level configuration.
cmake_minimum_required(VERSION 3.10)
project(planner_plus LANGUAGES CXX)

set(BINARY_NAME "planner_plus")
set(APPLICATION_ID "com.plannerplus.planner_plus")

# Flutter engine.
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")

# System-level dependencies.
find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK REQUIRED IMPORTED_TARGET gtk+-3.0)

# Configure build.
include(${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cmake)

# Application executable.
add_executable(${BINARY_NAME}
  "main.cc"
  "my_application.cc"
  ${FLUTTER_LIBRARY}
  ${PLUGIN_BUNDLED_LIBRARIES}
)

# List of absolute paths to libraries that should be bundled with the application.
set(planner_plus_bundled_libraries
  ""
  PARENT_SCOPE
)

target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::GTK)
target_link_libraries(${BINARY_NAME} PRIVATE flutter)
target_link_libraries(${BINARY_NAME} PRIVATE ${plugin_libraries})

# Copy flutter library and other needed files to app bundle.
install(FILES ${FLUTTER_LIBRARY} DESTINATION .)
