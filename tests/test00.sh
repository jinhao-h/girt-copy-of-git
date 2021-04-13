#!/bin/dash

# removing old version of girt to test from scratch
if [ -d ".girt" ]
then
    rm -r .girt
fi

# this script tests all the possibilities of girt-init
# test if initialising using girt-init works
output1=$(./girt-init)
if [ "$output1" = "Initialized empty girt repository in .girt" ]
then
    echo "test00 part 1 success"
else 
    echo "test00 part 1 failed"
fi

# test if correct error message is outputed if girt repo already exists
output2=$(./girt-init)
if [ "$output2" = "girt-init: error: .girt already exists" ]
then
    echo "test00 part 2 success"
else 
    echo "test00 part 2 failed"
fi
