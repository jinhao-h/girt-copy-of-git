#!/bin/dash

# removing old version of girt to test from scratch
if [ -d ".girt" ]
then
    rm -r .girt
fi

# this script tests all the possibilities of girt-rm with --force and --cached --force
# test if running girt-rm without a girt repo is accounted for
output1_1=$(./girt-rm --force a)
output1_2=$(./girt-rm --force --cached a)
if [ "$output1_1" = "girt-rm: error: girt repository directory .girt not found" ] && [ "$output1_2" = "girt-rm: error: girt repository directory .girt not found" ]
then
    echo "test06 part 1 success"
else
    echo "test06 part 1 failed"
fi

# test if running rm with no girt-add first is accounted for
./girt-init > /dev/null
touch a
output2_1=$(./girt-rm --force a)
output2_2=$(./girt-rm --force --cached a)
if [ "$output2_1" = "girt-rm: error: 'a' is not in the girt repository" ] && [ "$output2_2" = "girt-rm: error: 'a' is not in the girt repository" ]
then
    echo "test06 part 2 success"
else
    echo "test06 part 2 failed"
fi

# test if running rm with no matching filename in index is accounted for
./girt-add a
output3_1=$(./girt-rm --force b)
output3_2=$(./girt-rm --force --cached b)
if [ "$output3_1" = "girt-rm: error: 'b' is not in the girt repository" ] && [ "$output3_2" = "girt-rm: error: 'b' is not in the girt repository" ]
then
    echo "test06 part 3 success"
else
    echo "test06 part 3 failed"
fi

# test if running rm --force with matching filename in index and working works
./girt-rm --force a
output4=$(./girt-show :a)
if [ "$output4" = "girt-show: error: 'a' not found in index" ] && [ ! -f a ]
then
    echo "test06 part 4 success"
else
    echo "test06 part 4 failed"
fi

# test if running rm --force --cached with matching filename in index and working works
touch a
./girt-add a
./girt-rm --force --cached a
output5=$(./girt-show :a)
if [ "$output5" = "girt-show: error: 'a' not found in index" ] && [ -f a ]
then
    echo "test06 part 5 success"
else
    echo "test06 part 5 failed"
fi

# test if running rm --force with matching filename in index but diff file in working works
touch a
./girt-add a
echo "hello" > a
./girt-rm --force a
output6=$(./girt-show :a)
if [ "$output6" = "girt-show: error: 'a' not found in index" ] && [ ! -f a ]
then
    echo "test06 part 6 success"
else
    echo "test06 part 6 failed"
fi

# test if running rm --force --cached with matching filename in index but diff in working works
touch a
./girt-add a
echo "hello" > a
./girt-rm --force --cached a
output7_1=$(./girt-show :a)
output7_2=$(cat a)
if [ "$output7_1" = "girt-show: error: 'a' not found in index" ] && [ "$output7_2" = "hello" ]
then
    echo "test06 part 7 success"
else
    echo "test06 part 7 failed"
fi

# test if running rm --force with matching filename in index but no working works
touch a
./girt-add a
rm a
./girt-rm --force a
output8=$(./girt-show :a)
if [ "$output8" = "girt-show: error: 'a' not found in index" ] && [ ! -f a ]
then
    echo "test06 part 8 success"
else
    echo "test06 part 8 failed"
fi

# test if running rm --force --cached with matching filename in index but no working works
touch a
./girt-add a
rm a
./girt-rm --force --cached a
output9=$(./girt-show :a)
if [ "$output9" = "girt-show: error: 'a' not found in index" ] && [ ! -f a ]
then
    echo "test06 part 9 success"
else
    echo "test06 part 9 failed"
fi

# test if running rm --force with matching filename in index and repo works
touch a
./girt-add a
./girt-commit -m "first commit" > /dev/null
./girt-rm --force a
output10=$(./girt-show :a)
if [ "$output10" = "girt-show: error: 'a' not found in index" ] && [ ! -f a ]
then
    echo "test06 part 10 success"
else
    echo "test06 part 10 failed"
fi

# test if running rm --force --cached with matching in index and repo works
touch a
./girt-add a
./girt-commit -m "first commit" > /dev/null
./girt-rm --force --cached a
output11=$(./girt-show :a)
if [ "$output11" = "girt-show: error: 'a' not found in index" ] && [ -f a ]
then
    echo "test06 part 11 success"
else
    echo "test06 part 11 failed"
fi

# test if running rm --force with non-matching filename in index and repo works
touch a
./girt-add a
./girt-commit -m "first commit" > /dev/null
echo "hello" > a
./girt-add a
./girt-rm --force a
output12=$(./girt-show :a)
if [ "$output12" = "girt-show: error: 'a' not found in index" ] && [ ! -f a ]
then
    echo "test06 part 12 success"
else
    echo "test06 part 12 failed"
fi

# test if running rm --force --cached with matching in index and repo works
touch a
./girt-add a
./girt-commit -m "first commit" > /dev/null
echo "hello" > a
./girt-add a
./girt-rm --force --cached a
output13_1=$(./girt-show :a)
output13_2=$(cat a)
if [ "$output13_1" = "girt-show: error: 'a' not found in index" ] && [ "$output13_2" = "hello" ]
then
    echo "test06 part 13 success"
else
    echo "test06 part 13 failed"
fi

# test if running rm --force with multiple files all matching to index
touch a
touch b
./girt-add a b
./girt-rm --force a b
output14_1=$(./girt-show :a)
output14_2=$(./girt-show :b)
if [ "$output14_1" = "girt-show: error: 'a' not found in index" ] && [ "$output14_2" = "girt-show: error: 'b' not found in index" ] && [ ! -f a ] && [ ! -f b ]
then
    echo "test06 part 14 success"
else
    echo "test06 part 14 failed"
fi

# test if running rm --force --cached with multiple files all matching to index
touch a
touch b
./girt-add a b
./girt-rm --force --cached a b
output15_1=$(./girt-show :a)
output15_2=$(./girt-show :b)
if [ "$output15_1" = "girt-show: error: 'a' not found in index" ] && [ "$output15_2" = "girt-show: error: 'b' not found in index" ] && [ -f a ] && [ -f b ]
then
    echo "test06 part 15 success"
else
    echo "test06 part 15 failed"
fi

# test if running rm --force with multiple files with one not matching to index
echo "hello" > a
touch b
./girt-add a
output16_1=$(./girt-rm --force a b)
output16_2=$(./girt-show :a)
if [ "$output16_1" = "girt-rm: error: 'b' is not in the girt repository" ] && [ "$output16_2" = "hello" ]
then
    echo "test06 part 16 success"
else
    echo "test06 part 16 failed"
fi

# test if running rm --force --cached with multiple files with one not matching to index
echo "hello" > a
touch b
./girt-add a
output17_1=$(./girt-rm --force --cached a b)
output17_2=$(./girt-show :a)
if [ "$output17_1" = "girt-rm: error: 'b' is not in the girt repository" ] && [ "$output17_2" = "hello" ] && [ -f a ]
then
    echo "test06 part 17 success"
else
    echo "test06 part 17 failed"
fi

# making sure to remove all test files created
rm a b
