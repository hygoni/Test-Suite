#!/bin/bash

RETDEC=/home/hyeyoo/lifting/retdec-install/bin/retdec-decompiler

FOLDERS="basic_c_tests basic_cpp_tests fs_tests cs_tests double_free"
for folder in $FOLDERS;
do
  for tc in $(find test_cases_bc/$folder -name '*.bc');
  do
    # Determine the compiler based on the file extension
    if [[ $tc == *.c.bc ]]; then
      echo clang $tc -o ${tc%.bc} -I.
      clang $tc -o ${tc%.bc} > /dev/null
    elif [[ $tc == *.cpp.bc ]]; then
      echo clang++ $tc -o ${tc%.bc} -I.
      clang++ $tc -o ${tc%.bc} > /dev/null
    fi
    $RETDEC ${tc%.bc}
  done
done
