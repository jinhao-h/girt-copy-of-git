#!/bin/dash

# removing old version of girt to test from scratch
if [ -d ".girt" ]
then
    rm -r .girt
fi

# this script tests all the possibilities of girt-rm without --force nor --cached
# test if running girt-rm without a girt repo is accounted for
output1=$(./girt-rm a)
if [ "$output1" = "girt-rm: error: girt repository directory .girt not found" ]
then
    echo "test08 part 1 success"
else
    echo "test08 part 1 failed"
fi

# test if running rm with no girt-add first is accounted for
./girt-init > /dev/null
touch a
output2=$(./girt-rm a)
if [ "$output2" = "girt-rm: error: 'a' is not in the girt repository" ]
then
    echo "test08 part 2 success"
else
    echo "test08 part 2 failed"
fi

# test if running rm with no matching filename in index is accounted for
./girt-add a
output3=$(./girt-rm b)
if [ "$output3" = "girt-rm: error: 'b' is not in the girt repository" ]
then
    echo "test08 part 3 success"
else
    echo "test08 part 3 failed"
fi

# test if running rm with matching filename in index and working works
output4=$(./girt-rm a)
if [ "$output4" = "girt-rm: error: 'a' has staged changes in the index" ]
then
    echo "test08 part 4 success"
else
    echo "test08 part 4 failed"
fi

# test if running rm with non-matching filename in index and working works
echo "hello" > a
output5=$(./girt-rm a)
if [ "$output5" = "girt-rm: error: 'a' has staged changes in the index" ]
then
    echo "test08 part 5 success"
else
    echo "test08 part 5 failed"
fi

# test if running rm with matching filename in index and no working file
rm a
./girt-rm a
output6=$(./girt-show :a)
if [ "$output6" = "girt-show: error: 'a' not found in index" ]
then
    echo "test08 part 6 success"
else
    echo "test08 part 6 failed"
fi

# test if running rm with repo different while index and working are matching
touch a
./girt-add a
./girt-commit -m "first commit" > /dev/null
echo "hello" > a
./girt-add a
output7=$(./girt-rm a)
if [ "$output7" = "girt-rm: error: 'a' has staged changes in the index" ]
then
    echo "test08 part 7 success"
else
    echo "test08 part 7 failed"
fi

# test if running rm with repo same to index while working are different
rm a
touch a
./girt-add a
./girt-commit -m "first commit" > /dev/null
echo "hello" > a
output8=$(./girt-rm a)
if [ "$output8" = "girt-rm: error: 'a' in the repository is different to the working file" ]
then
    echo "test08 part 8 success"
else
    echo "test08 part 8 failed"
fi

# test if running rm with repo same to working while index are different
rm a
touch a
./girt-add a
./girt-commit -m "first commit" > /dev/null
echo "hello" > a
./girt-add a
rm a
touch a
output9=$(./girt-rm a)
if [ "$output9" = "girt-rm: error: 'a' in index is different to both to the working file and the repository" ]
then
    echo "test08 part 9 success"
else
    echo "test08 part 9 failed"
fi

# test if running rm with repo, working and index all different
rm a
touch a
./girt-add a
./girt-commit -m "first commit" > /dev/null
echo "hello" > a
./girt-add a
rm a
echo "hello2" > a
output10=$(./girt-rm a)
if [ "$output10" = "girt-rm: error: 'a' in index is different to both to the working file and the repository" ]
then
    echo "test08 part 10 success"
else
    echo "test08 part 10 failed"
fi

# test if running rm with repo, working and index all same
rm a
touch a
./girt-add a
./girt-commit -m "first commit" > /dev/null
./girt-rm a
output11=$(./girt-show :a)
if [ "$output11" = "girt-show: error: 'a' not found in index" ] && [ ! -f a ]
then
    echo "test08 part 11 success"
else
    echo "test08 part 11 failed"
fi

# test if running rm with repo and index same and no working
touch a
./girt-add a
./girt-commit -m "first commit" > /dev/null
rm a
./girt-rm a
output12=$(./girt-show :a)
if [ "$output12" = "girt-show: error: 'a' not found in index" ] && [ ! -f a ]
then
    echo "test08 part 12 success"
else
    echo "test08 part 12 failed"
fi

# test if running rm with repo and index different and no working
# according to 2041 girt even if repo and index diff, if there is no working file girt-rm a will work
touch a
./girt-add a
./girt-commit -m "first commit" > /dev/null
echo "hello" > a
./girt-add a
rm a
./girt-rm a
output13=$(./girt-show :a)
if [ "$output13" = "girt-show: error: 'a' not found in index" ] && [ ! -f a ]
then
    echo "test08 part 13 success"
else
    echo "test08 part 13 failed"
fi

# test if running rm with multiple files all matching to index
touch a
touch b
./girt-add a b
./girt-commit -m "first commit" > /dev/null
./girt-rm a b
output14_1=$(./girt-show :a)
output14_2=$(./girt-show :b)
if [ "$output14_1" = "girt-show: error: 'a' not found in index" ] && [ "$output14_2" = "girt-show: error: 'b' not found in index" ] && [ ! -f a ] && [ ! -f b ]
then
    echo "test08 part 14 success"
else
    echo "test08 part 14 failed"
fi

# test if running rm with multiple files with one not matching to index
echo "hello" > a
touch c
./girt-add a
./girt-commit -m "first commit" > /dev/null
output15_1=$(./girt-rm a c)
output15_2=$(./girt-show :a)
if [ "$output15_1" = "girt-rm: error: 'c' is not in the girt repository" ] && [ "$output15_2" = "hello" ] && [ -f a ]
then
    echo "test08 part 15 success"
else
    echo "test08 part 15 failed"
fi

# making sure to remove all test files created
rm a c
