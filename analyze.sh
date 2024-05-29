#!/bin/bash

NOALIAS_SUCCESS=0
NOALIAS_FAILURE=0
MUSTALIAS_SUCCESS=0
MUSTALIAS_FAILURE=0
MAYALIAS_SUCCESS=0
MAYALIAS_FAILURE=0

declare -A OPTIONS
OPTIONS=(
    ["basic_c_tests"]="wpa -ander -stat=false"
    ["basic_cpp_tests"]="wpa -ander -stat=false"
    ["fs_tests"]="wpa -fspta -stat=false"
    ["cs_tests"]="dvf -cxt -print-pts=false -stat=false"
    ["path_tests"]=""
    ["complex_tests"]="wpa -ander -stat=false"
    ["mta"]=""
    ["mem_leak"]="saber -leak -valid-tests -mempar=inter-disjoint -stat=false"
    ["double_free"]="saber -dfree -valid-tests -stat=false"
)


FOLDERS="basic_c_tests basic_cpp_tests fs_tests cs_tests"
# double_free"

for folder in $FOLDERS;
do
  for tc in $(find ./test_cases_bc/$folder -name '*.bc');
  do
    rm -f .output
    echo $tc
    ${OPTIONS[$folder]} $tc >> .output 2>> .output
    echo SUCCESS: $(cat .output | grep -c -E '(SUCCESS|EXPECTED-FAILURE)')
    echo FAILURE: $(cat .output | grep -v EXPECTED-FAILURE | grep -c FAILURE)
    NOALIAS_SUCCESS=$(expr $NOALIAS_SUCCESS + $(cat .output | grep -E '(SUCCESS|EXPECTED-FAILURE)' | grep NOALIAS | wc -l))
    NOALIAS_FAILURE=$(expr $NOALIAS_FAILURE + $(cat .output | grep FAILURE | grep -v 'EXPECTED-FAILURE' | grep NOALIAS | wc -l))
    MAYALIAS_SUCCESS=$(expr $MAYALIAS_SUCCESS + $(cat .output | grep -E '(SUCCESS|EXPECTED-FAILURE)' | grep MAYALIAS | wc -l))
    MAYALIAS_FAILURE=$(expr $MAYALIAS_FAILURE + $(cat .output | grep FAILURE | grep -v 'EXPECTED-FAILURE' | grep MAYALIAS | wc -l))
    MUSTALIAS_SUCCESS=$(expr $MUSTALIAS_SUCCESS + $(cat .output | grep -E '(SUCCESS|EXPECTED-FAILURE)' | grep MUSTALIAS | wc -l))
    MUSTALIAS_FAILURE=$(expr $MUSTALIAS_FAILURE + $(cat .output | grep FAILURE | grep -v 'EXPECTED-FAILURE' | grep MUSTALIAS | wc -l))
    cat .output | grep -E '(SUCCESS|EXPECTED-FAILURE)'
    cat .output | grep FAILURE | grep -v 'EXPECTED-FAILURE'
  done
done

MUSTALIAS_PERCENTAGE=$(awk "BEGIN {printf \"%.4f\", $MUSTALIAS_SUCCESS / $(expr $MUSTALIAS_SUCCESS + $MUSTALIAS_FAILURE)}")
echo MUSTALIAS: $MUSTALIAS_PERCENTAGE
echo MUSTALIAS Success: $MUSTALIAS_SUCCESS
echo MUSTALIAS Failure: $MUSTALIAS_FAILURE

MAYALIAS_PERCENTAGE=$(awk "BEGIN {printf \"%.4f\", $MAYALIAS_SUCCESS / $(expr $MAYALIAS_SUCCESS + $MAYALIAS_FAILURE)}")
echo MAYALIAS: $MAYALIAS_PERCENTAGE
echo MAYALIAS Success: $MAYALIAS_SUCCESS
echo MAYALIAS Failure: $MAYALIAS_FAILURE

NOALIAS_PERCENTAGE=$(awk "BEGIN {printf \"%.4f\", $NOALIAS_SUCCESS / $(expr $NOALIAS_SUCCESS + $NOALIAS_FAILURE)}")
echo NOALIAS: $NOALIAS_PERCENTAGE
echo NOALIAS Success: $NOALIAS_SUCCESS
echo NOALIAS Failure: $NOALIAS_FAILURE
