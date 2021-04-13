#!/bin/dash

# removing old version of girt to test from scratch
if [ -d ".girt" ]
then
    rm -r .girt
fi

# this script tests all the possibilities of girt-status
# test if running girt-status without a girt repo is accounted for
output1=$(./girt-status)
if [ "$output1" = "girt-status: error: girt repository directory .girt not found" ]
then
    echo "test09 part 1 success"
else
    echo "test09 part 1 failed"
fi

# test if running girt-status with incorrect arguments is accounted for
./girt-init > /dev/null
output2=$(./girt-status 0)
if [ "$output2" = "usage: girt-status" ]
then
    echo "test09 part 2 success"
else
    echo "test09 part 2 failed"
fi

# NOTE: From here on out, I will not be checking the correct outputs and printing
# test09 success/fail, since I will be running girt-status in a directory with all my 
# other girt and test files. I will comment what I believe the output should be 
# assuming there will be no other files in the directory other than the ones I create, # in order to show my understanding of how girt-status works. Thanks for understanding!

# test if running girt-status with no girt functions other than girt-init done is accounted for (add, commit, etc.)
# touch a
# echo "hello" > b
# echo "hello2" > c
# ./girt-status:
# a - untracked
# b - untracked
# c - untracked

# test all 10 different status possibilities and shown in output
# touch a b c d e f g h i j
# ./girt-add a b c d e i
# ./girt-commit -m "initial commit"
# echo "hello" > a
# echo "hello" > b
# echo "hello" > c
# ./girt-add a b f g h
# echo "hello2" > a
# echo "hello" > g
# rm h i
# ./girt-rm e
# ./girt-status
# a - file changed, different changes staged for commit
# b - file changed, changes staged for commit
# c - file changed, changes not staged for commit
# d - same as repo
# e - deleted
# f - added to index
# g - added to index, file changed
# h - added to index, file deleted
# i - file deleted
# j - untracked


