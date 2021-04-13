#!/bin/dash

# removing old version of girt to test from scratch
if [ -d ".girt" ]
then
    rm -r .girt
fi

# this script tests all the possibilities of girt-log
# test if running girt-log without a girt repo is accounted for
output1=$(./girt-log)
if [ "$output1" = "girt-log: error: girt repository directory .girt not found" ]
then
    echo "test03 part 1 success"
else
    echo "test03 part 1 failed"
fi

# test if running girt-log with incorrect arguments is accounted for
./girt-init > /dev/null
output2=$(./girt-log 0)
if [ "$output2" = "usage: girt-log" ]
then
    echo "test03 part 2 success"
else
    echo "test03 part 2 failed"
fi

# test to see if running girt-log with no commits works
./girt-log
if [ -f ".girt/log.txt" ]
then
    echo "test03 part 3 success"
else
    echo "test03 part 3 failed"
fi

# test if one commit works
touch a
./girt-add a
./girt-commit -m "first commit test" > /dev/null
output4=$(./girt-log)
if [ "$output4" = "0 first commit test" ]
then
    echo "test03 part 4 success"
else
    echo "test03 part 4 failed"
fi

# test if a failed commit is accounted for
./girt-commit -m "second commit test" > /dev/null
output5=$(./girt-log)
if [ "$output5" = "0 first commit test" ]
then
    echo "test03 part 5 success"
else
    echo "test03 part 5 failed"
fi

# test if multiple commits work and girt-log outputs in reverse chronological order of commits
touch b
./girt-add b
./girt-commit -m "second commit test" > /dev/null
touch c
./girt-add c
./girt-commit -m "third commit test" > /dev/null
output6=$(./girt-log)
if [ "$output6" = "2 third commit test
1 second commit test
0 first commit test" ]
then
    echo "test03 part 6 success"
else
    echo "test03 part 6 failed"
fi

# making sure to remove all test files created
rm a b c

