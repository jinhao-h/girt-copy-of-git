#!/bin/dash

# removing old version of girt to test from scratch
if [ -d ".girt" ]
then
    rm -r .girt
fi

# this script tests all the possibilities of girt-commit with -a
# test if running girt-commit without a girt repo is accounted for
output1=$(./girt-commit -a -m "test")
if [ "$output1" = "girt-commit: error: girt repository directory .girt not found" ]
then
    echo "test05 part 1 success"
else
    echo "test05 part 1 failed"
fi

# test if running girt-commit -a without any girt-add first is accounted for
./girt-init > /dev/null
output2=$(./girt-commit -a -m "test")
if [ "$output2" = "nothing to commit" ]
then
    echo "test05 part 2 success"
else
    echo "test05 part 2 failed"
fi

# test if calling girt-commit with just -a is accounted for
echo "hello" > a
./girt-add a
output3=$(./girt-commit -a "test")
if [ "$output3" = "usage: girt-commit [-a] -m commit-message" ]
then
    echo "test05 part 3 success"
else
    echo "test05 part 3 failed"
fi

# test if calling girt-commit with -m -a is accounted for
echo "hello" > a
./girt-add a
output4=$(./girt-commit -m -a "test")
if [ "$output4" = "usage: girt-commit [-a] -m commit-message" ]
then
    echo "test05 part 4 success"
else
    echo "test05 part 4 failed"
fi

# test if a is removed from curr directory then calling -a removes it from index
rm a
output5_1=$(./girt-show :a)
output5_2=$(./girt-commit -a -m "first commit")
output5_3=$(./girt-show :a)
if [ "$output5_1" = "hello" ] && [ "$output5_2" = "nothing to commit" ] && [ "$output5_3" = "girt-show: error: 'a' not found in index" ]
then
    echo "test05 part 5 success"
else
    echo "test05 part 5 failed"
fi

# test if a is same in curr directory and index
# NOTE: only testing if commit file is created. Commit message is tested 
# in another script (test03.sh) for log
echo "hello" > a
./girt-add a
output6_1=$(./girt-commit -a -m "first commit")
output6_2=$(./girt-show :a)
if [ "$output6_1" = "Committed as commit 0" ] && [ "$output6_2" = "hello" ]
then
    echo "test05 part 6 success"
else
    echo "test05 part 6 failed"
fi

# test if a is different in curr directory than to index
echo "hello2" > a
output7_1=$(./girt-commit -a -m "second commit")
output7_2=$(./girt-show :a)
if [ "$output7_1" = "Committed as commit 1" ] && [ "$output7_2" = "hello2" ]
then
    echo "test05 part 7 success"
else
    echo "test05 part 7 failed"
fi

# test if some fies are different from curr direectory to index, while other 
# files remain the same
touch b
touch c
./girt-add b c
echo "hello3" > b
echo "hello4" > c
echo "hello5" > d
./girt-add d
output8_1=$(./girt-commit -a -m "third commit")
output8_2=$(./girt-show :a)
output8_3=$(./girt-show :b)
output8_4=$(./girt-show :c)
output8_5=$(./girt-show :d)
if [ "$output8_1" = "Committed as commit 2" ] && [ "$output8_2" = "hello2" ] && [ "$output8_3" = "hello3" ] && [ "$output8_4" = "hello4" ] && [ "$output8_5" = "hello5" ]
then
    echo "test05 part 8 success"
else
    echo "test05 part 8 failed"
fi

# making sure to remove all test files created
rm a b c d



