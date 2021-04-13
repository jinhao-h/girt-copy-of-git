#!/bin/dash

# removing old version of girt to test from scratch
if [ -d ".girt" ]
then
    rm -r .girt
fi

# this script tests all the possibilities of girt-show
# test if running girt-show without a girt repo is accounted for
output1=$(./girt-show)
if [ "$output1" = "girt-show: error: girt repository directory .girt not found" ]
then
    echo "test04 part 1 success"
else
    echo "test04 part 1 failed"
fi

# test if running girt-log with incorrect arguments is accounted for
./girt-init > /dev/null
output2=$(./girt-show)
if [ "$output2" = "usage: girt-show <commit>:<filename>" ]
then
    echo "test04 part 2 success"
else
    echo "test04 part 2 failed"
fi

# test if running girt-show for index with no girt-add filename done is accounted for
output3=$(./girt-show :a)
if [ "$output3" = "girt-show: error: 'a' not found in index" ]
then
    echo "test04 part 3 success"
else
    echo "test04 part 3 failed"
fi

# test to ensure girt-show works with file in index
echo "hello" > a
./girt-add a
output4=$(./girt-show :a)
if [ "$output4" = "hello" ]
then
    echo "test04 part 4 success"
else
    echo "test04 part 4 failed"
fi

# test if running girt-show with a non-valid commit number is accounted for
output5=$(./girt-show 0:a)
if [ "$output5" = "girt-show: error: unknown commit '0'" ]
then
    echo "test04 part 5 success"
else
    echo "test04 part 5 failed"
fi

# test if having a correct commit number but wrong filename is accounted for
./girt-commit -m "initial commit 0" > /dev/null
output6=$(./girt-show 0:b)
if [ "$output6" = "girt-show: error: 'b' not found in commit 0" ]
then
    echo "test04 part 6 success"
else
    echo "test04 part 6 failed"
fi

# test if having a correct commit number with correct filename works
output7=$(./girt-show 0:a)
if [ "$output7" = "hello" ]
then
    echo "test04 part 7 success"
else
    echo "test04 part 7 failed"
fi

# test if having correct commit number and filename with a number of different commits works
touch b
./girt-add b
./girt-commit -m "second commit 1" > /dev/null
echo "hello2" > c
./girt-add c
./girt-commit -m "third commit 2" > /dev/null
output8_1=$(./girt-show 1:a)
output8_2=$(./girt-show 2:c)
if [ "$output8_1" = "hello" ] && [ "$output8_2" = "hello2" ]
then
    echo "test04 part 8 success"
else
    echo "test04 part 8 failed"
fi

# test if running girt-log with incorrect commit_number:filename format is accounted for
output9=$(./girt-show 0a)
if [ "$output9" = "girt-show: error: invalid object 0a" ]
then
    echo "test04 part 9 success"
else
    echo "test04 part 9 failed"
fi

# making sure to remove all test files created
rm a b c

