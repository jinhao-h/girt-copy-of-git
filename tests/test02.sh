#!/bin/dash

# removing old version of girt to test from scratch
if [ -d ".girt" ]
then
    rm -r .girt
fi

# this script tests all the possibilities of girt-commit with -m only
# test if running girt-commit without a girt repo is accounted for
output1=$(./girt-commit -m "test")
if [ "$output1" = "girt-commit: error: girt repository directory .girt not found" ]
then
    echo "test02 part 1 success"
else
    echo "test02 part 1 failed"
fi

# test if running girt-commit without any girt-add first is accounted for
./girt-init > /dev/null
output2=$(./girt-commit -m "test")
if [ "$output2" = "nothing to commit" ]
then
    echo "test02 part 2 success"
else
    echo "test02 part 2 failed"
fi

# test if running girt-commit with incorrect arguments is accounted for
echo "hello" > a
./girt-add a
output3=$(./girt-commit -n "test")
if [ "$output3" = "usage: girt-commit [-a] -m commit-message" ]
then
    echo "test02 part 3 success"
else
    echo "test02 part 3 failed"
fi

# test if running girt-commit successfully with one added file works
# NOTE: only testing if commit file is created. Commit message is tested 
# in another script (test03.sh) for log
output4_1=$(./girt-commit -m "first commit")
output4_2=$(./girt-show 0:a)
if [ "$output4_1" = "Committed as commit 0" ] && [ "$output4_2" = "hello" ]
then
    echo "test02 part 4 success"
else
    echo "test02 part 4 failed"
fi

# test for trying to commit again when there are no staged changes in index
output5=$(./girt-commit -m "second commit")
if [ "$output5" = "nothing to commit" ]
then
    echo "test02 part 5 success"
else
    echo "test02 part 5 failed"
fi

# test adding multiple files and committing again as second commit
echo "hello2" > b
echo "hello3" > c
./girt-add b c
output6_1=$(./girt-commit -m "second commit")
output6_2=$(./girt-show 1:b)
output6_3=$(./girt-show 1:c)
if [ "$output6_1" = "Committed as commit 1" ] && [ "$output6_2" = "hello2" ] && [ "$output6_3" = "hello3" ]
then
    echo "test02 part 6 success"
else
    echo "test02 part 6 failed"
fi

# test if applying girt-add on a rm and then committing works
rm a
./girt-add a
output7_1=$(./girt-commit -m "third commit")
output7_2=$(./girt-show 2:a)
if [ "$output7_1" = "Committed as commit 2" ] && [ "$output7_2" = "girt-show: error: 'a' not found in commit 2" ]
then
    echo "test02 part 7 success"
else
    echo "test02 part 7 failed"
fi

# making sure to remove all test files created
rm b c

