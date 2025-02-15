# ------------------------------------------------------------------------------

# set cmake version
cmake_minimum_required(VERSION 3.22)

# set project details
project(
  AOC
  VERSION 0.1
  DESCRIPTION "Advent of Code in C"
  LANGUAGES C
)

# enable compile command
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# configure executable directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

set(AOC_YEAR
    2015
    2016
    2017
    2018
    2019
    2020
    2021
    2022
    2023
    2024
    2025
)

set(AOC_DAYS
    01
    02
    03
    04
    05
    06
    07
    08
    09
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22
    23
    24
    25
)

foreach(YEAR ${AOC_YEAR})
  # target for every year
  add_custom_target(RUN_AOC_${YEAR})

  foreach(DAY ${AOC_DAYS})
    set(input_file ${CMAKE_CURRENT_SOURCE_DIR}/${YEAR}/input/day${DAY}.txt)
    set(src_file ${CMAKE_CURRENT_SOURCE_DIR}/${YEAR}/src/day${DAY}.c)
    set(exec_file AOC_${YEAR}_${DAY})

    if(EXISTS ${src_file})
      # executable + target for every day in year
      add_executable(${exec_file} ${src_file})
      add_custom_target(
        RUN_${exec_file}
        DEPENDS ${exec_file}
        COMMAND cat ${input_file} | xargs ./${exec_file}
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
      )

      # command + dependecies for every year target
      add_custom_command(
        TARGET RUN_AOC_${YEAR}
        COMMAND echo "AOC ${YEAR} Day ${DAY}"
        COMMAND cat ${input_file} | xargs ./${exec_file}
        WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
      )
      add_dependencies(RUN_AOC_${YEAR} ${exec_file})
    endif()
  endforeach()
endforeach()

# ------------------------------------------------------------------------------
