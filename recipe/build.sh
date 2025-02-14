#!/usr/bin/env bash
set -e


# We need to create an out of source build
cd $SRC_DIR

mkdir -p build && cd build

CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY" \
cmake ${CMAKE_ARGS} .. -G"Ninja" -DCMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX="${PREFIX}" \
  -D Python3_FIND_STRATEGY="LOCATION" \
  -D Python3_EXECUTABLE="${PYTHON}" \
  -D Python3_ROOT_DIR="${PREFIX}/bin" \
  -D PCRASTER_WITH_FLAGS_NATIVE=OFF \
  -D PCRASTER_PYTHON_INSTALL_DIR=${SP_DIR}

cmake --build . --target all --parallel ${CPU_COUNT}

cmake --build . --target install
