#!/bin/dash

# removing old version of girt to test from scratch
if [ -d ".girt" ]
then
    rm -r .girt
fi

# this script tests all the possibilities of girt-add
# test if running girt-add without a girt repo is accounted for
echo "hello" > a
output1=$(./girt-add a)
if [ "$output1" = "girt-add: error: girt repository directory .girt not found" ]
then
    echo "test01 part 1 success"
else
    echo "test01 part 1 failed"
fi

# test if running girt-add with no arguments is accounted for
./girt-init > /dev/null
output2=$(./girt-add)
if [ "$output2" = "usage: girt-add <filenames>" ]
then
    echo "test01 part 2 success"
else
    echo "test01 part 2 failed"
fi

# test if trying to add a file that doesn't exist in curr directory is accounted for
output3=$(./girt-add b)
if [ "$output3" = "girt-add: error: can not open 'b'" ]
then
    echo "test01 part 3 success"
else
    echo "test01 part 3 failed"
fi

# test if adding a file to index works
./girt-add a
output4=$(./girt-show :a)
if [ "$output4" = "hello" ]
then
    echo "test01 part 4 success"
else
    echo "test01 part 4 failed"
fi

# test that successfully running girt-add on a file also adds it to status.txt
output5=$(cat ".girt/status.txt")
if [ "$output5" = "a" ]
then
    echo "test01 part 5 success"
else
    echo "test01 part 5 failed"
fi

# test if removing a file from index by doing rm and then girt-add works
rm a
./girt-add a
output6=$(./girt-show :a)
if [ "$output6" = "girt-show: error: 'a' not found in index" ]
then
    echo "test01 part 6 success"
else
    echo "test01 part 6 failed"
fi

# test if adding multiple files works
echo "hello" > a
echo "hello2" > b
./girt-add a b
output7_1=$(./girt-show :a)
output7_2=$(./girt-show :b)
if [ "$output7_1" = "hello" ] && [ "$output7_2" = "hello2" ]
then
    echo "test01 part 7 success"
else
    echo "test01 part 7 failed"
fi

# making sure to remove all test files created
rm a b

