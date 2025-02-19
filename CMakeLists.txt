cmake_minimum_required(VERSION 3.27) # visual studio 2022 cmake @ 17/24

#################
### Variables ###
#################

set(MANDEL_PROJECT_NAME
    MandelQT
)
set(MANDEL_SOURCE_DIR
    src
)
set(MANDEL_SOURCE
    ${MANDEL_SOURCE_DIR}/main.cpp
)
set(MANDEL_LIBRARIES_DIR
    libs
)
set(MANDEL_LIBRARIES 
    MandelbrotEngineAVX2
)
project(${MANDEL_PROJECT_NAME})

###############
### Project ###
###############

add_executable(${PROJECT_NAME} ${MANDEL_SOURCE})

foreach(LIBRARY ${MANDEL_LIBRARIES})
    add_subdirectory("${MANDEL_LIBRARIES_DIR}/${LIBRARY}")
endforeach(LIBRARY)
target_link_libraries(${PROJECT_NAME} ${MANDEL_LIBRARIES})

include_directories(vcpkg_installed/x64-windows/include/Qt6/QtCore)

####################
### Dependencies ###
####################

# https://cmake.org/cmake/help/latest/command/find_package.html
set(PACKAGES_MODULES # packages without CONFIG looking for Find<PackageName>.cmake
        
)

set(PACKAGES_CONFIG # packages with CONFIG looking for file <PackageName>Config.cmake
    Qt6
    Qt6Widgets
    Qt6Gui
)

set(PACKAGES_PROVIDES # items the packages provide to be linked
    Qt6::Core
    Qt6::Widgets
    Qt6::Gui
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