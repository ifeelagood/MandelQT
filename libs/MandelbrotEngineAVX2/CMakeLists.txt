cmake_minimum_required(VERSION 3.27)

#################
### Variables ###
#################

set(PROJECT_NAME
    libMandelbrotEngineAVX2
)
set(LIBRARY_NAME
    MandelbrotEngineAVX2
)
set(LIBRARY_HEADERS_DIR
    include/${LIBRARY_NAME}
)
set(LIBRARY_HEADERS
    ${LIBRARY_HEADERS_DIR}/escape_time_avx2.h
    ${LIBRARY_HEADERS_DIR}/MandelbrotEngineAVX2.h
)
set(LIBRARY_SOURCE_DIR
    src
)
set(LIBRARY_SOURCE
    ${LIBRARY_SOURCE_DIR}/escape_time_avx2.asm
)

# enable microsoft masm assembler and set source file properties

enable_language(C ASM_MASM)
set_source_files_properties(${LIBRARY_SOURCE_DIR}/escape_time_avx2.asm PROPERTIES LANGUAGE ASM_MASM)


###############
### Library ###
###############

project(${PROJECT_NAME})

add_library(${LIBRARY_NAME} STATIC
    ${LIBRARY_HEADERS}
    ${LIBRARY_SOURCE}
)

target_include_directories(${LIBRARY_NAME} PRIVATE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/${LIBRARY_NAME}>
    $<INSTALL_INTERFACE:include/${LIBRARY_NAME}>
)

target_include_directories(${LIBRARY_NAME} PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)

set_target_properties(${LIBRARY_NAME} PROPERTIES LINKER_LANGUAGE CXX)

####################
### Dependencies ###
####################

# https://cmake.org/cmake/help/latest/command/find_package.html
set(PACKAGES_MODULES # packages without CONFIG looking for Find<PackageName>.cmake
        
)

set(PACKAGES_CONFIG # packages with CONFIG looking for file <PackageName>Config.cmake

)

set(PACKAGES_PROVIDES # items the packages provide to be linked

)

foreach(PACKAGE ${PACKAGES_MODULES})
    find_package(${PACKAGE} REQUIRED)
endforeach(PACKAGE)

foreach(PACKAGE ${PACKAGES_CONFIG})
    find_package(${PACKAGE} CONFIG REQUIRED)
endforeach(PACKAGE)

foreach(LIBRARY ${PACKAGES_PROVIDES})
    target_link_libraries(${PROJECT_NAME} ${LIBRARY})
endforeach(LIBRARY)