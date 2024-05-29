#!/bin/bash

rm -rf test_cases_bc
bash ./generate_bc.sh
bash ./analyze.sh

echo Lifting in 5 seconds...
sleep 1
echo Lifting in 4 seconds...
sleep 1
echo Lifting in 3 seconds...
sleep 1
echo Lifting in 2 seconds...
sleep 1
echo Lifting in 1 seconds...
sleep 1

# Lift everything
bash ./lift.sh
bash ./analyze.sh

