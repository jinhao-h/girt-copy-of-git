#!/bin/dash

# removing old version of girt to test from scratch
if [ -d ".girt" ]
then
    rm -r .girt
fi

# this script tests all the possibilities of girt-rm with --cached only
# test if running girt-rm without a girt repo is accounted for
output1=$(./girt-rm --cached a)
if [ "$output1" = "girt-rm: error: girt repository directory .girt not found" ]
then
    echo "test07 part 1 success"
else
    echo "test07 part 1 failed"
fi

# test if running rm with no girt-add first is accounted for
./girt-init > /dev/null
touch a
output2=$(./girt-rm --cached a)
if [ "$output2" = "girt-rm: error: 'a' is not in the girt repository" ]
then
    echo "test07 part 2 success"
else
    echo "test07 part 2 failed"
fi

# test if running rm with no matching filename in index is accounted for
./girt-add a
output3=$(./girt-rm --cached b)
if [ "$output3" = "girt-rm: error: 'b' is not in the girt repository" ]
then
    echo "test07 part 3 success"
else
    echo "test07 part 3 failed"
fi

# test if running rm --cached with matching filename in index and working works
./girt-rm --cached a
output4=$(./girt-show :a)
if [ "$output4" = "girt-show: error: 'a' not found in index" ] && [ -f a ]
then
    echo "test07 part 4 success"
else
    echo "test07 part 4 failed"
fi

# test if running rm --cached with matching filename in index but diff file in working works
touch a
./girt-add a
echo "hello" > a
output5=$(./girt-rm --cached a)
if [ "$output5" = "girt-rm: error: 'a' in index is different to both to the working file and the repository" ]
then
    echo "test07 part 5 success"
else
    echo "test07 part 5 failed"
fi

# test if running rm --cached with matching filename in index but no working works
touch a
./girt-add a
rm a
./girt-rm --cached a
output6=$(./girt-show :a)
if [ "$output6" = "girt-show: error: 'a' not found in index" ] && [ ! -f a ]
then
    echo "test07 part 6 success"
else
    echo "test07 part 6 failed"
fi

# test if running rm --cached with matching in index and repo works
touch a
./girt-add a
./girt-commit -m "first commit" > /dev/null
./girt-rm --cached a
output7=$(./girt-show :a)
if [ "$output7" = "girt-show: error: 'a' not found in index" ] && [ -f a ]
then
    echo "test07 part 7 success"
else
    echo "test07 part 7 failed"
fi

# test if running rm --cached with matching in index and repo works
touch a
./girt-add a
./girt-commit -m "first commit" > /dev/null
echo "hello" > a
./girt-add a
echo "hello2" > a
output8_1=$(./girt-rm --cached a)
output8_2=$(./girt-show :a)
output8_3=$(cat a)
if [ "$output8_1" = "girt-rm: error: 'a' in index is different to both to the working file and the repository" ] && [ "$output8_2" = "hello" ] && [ "$output8_3" = "hello2" ]
then
    echo "test07 part 8 success"
else
    echo "test07 part 8 failed"
fi

# test if running rm --cached with multiple files all matching to index
touch a
touch b
./girt-add a b
./girt-rm --cached a b
output9_1=$(./girt-show :a)
output9_2=$(./girt-show :b)
if [ "$output9_1" = "girt-show: error: 'a' not found in index" ] && [ "$output9_2" = "girt-show: error: 'b' not found in index" ] && [ -f a ] && [ -f b ]
then
    echo "test07 part 9 success"
else
    echo "test07 part 9 failed"
fi

# test if running rm --force --cached with multiple files with one not matching to index
echo "hello" > a
touch b
./girt-add a
output10_1=$(./girt-rm --cached a b)
output10_2=$(./girt-show :a)
if [ "$output10_1" = "girt-rm: error: 'b' is not in the girt repository" ] && [ "$output10_2" = "hello" ] && [ -f a ]
then
    echo "test07 part 10 success"
else
    echo "test07 part 10 failed"
fi

# making sure to remove all test files created
rm a b
