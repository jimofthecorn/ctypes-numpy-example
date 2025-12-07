#! /home/linuxbrew/.linuxbrew/bin/nu

const is_windows = $nu.os-info.name == 'windows'

if $is_windows {
    cmake -S . -B build
    cmake --build build --config Release
    cp build/cppref.lib cpp_ref/
    odin build . -build-mode:dll
} else {
    cmake -S . -B build -D"CMAKE_BUILD_TYPE=Release"
    cmake --build build
    cp build/libcppref.a cpp_ref/
    odin build . -build-mode:dll -extra-linker-flags:'-lstdc++'
}
