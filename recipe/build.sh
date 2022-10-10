#!/usr/bin/env bash

set -e


if [ $(uname) == Linux ]; then
  # Kindly guide to conda's OpenGL...
  PLATFORM_OPTIONS="-D OPENGL_opengl_LIBRARY:PATH=${BUILD_PREFIX}/${HOST}/sysroot/usr/lib64/libGL.so \
  -D OPENGL_gl_LIBRARY:PATH=${BUILD_PREFIX}/${HOST}/sysroot/usr/lib64/libGL.so \
  -D OPENGL_glu_LIBRARY:PATH=${PREFIX}/lib/libGLU.so"
else
  PLATFORM_OPTIONS="-D GDAL_INCLUDE_DIR=${PREFIX}/include"
fi


# We need to create an out of source build
cd $SRC_DIR

mkdir -p build && cd build

CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY" \
cmake ${CMAKE_ARGS} .. -G"Ninja" -DCMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX="${PREFIX}" \
  -D Python3_FIND_STRATEGY="LOCATION" \
  -D Python3_EXECUTABLE="${PYTHON}" \
  -D PYTHON_EXECUTABLE="${PYTHON}" \
  -D Python_ROOT_DIR="${PREFIX}/bin" \
  -D Python3_ROOT_DIR="${PREFIX}/bin" \
  -D PCRASTER_WITH_FLAGS_NATIVE=OFF \
  -D PCRASTER_PYTHON_INSTALL_DIR=${SP_DIR} \
  $PLATFORM_OPTIONS

cmake --build . --target all

cmake --build . --target install
