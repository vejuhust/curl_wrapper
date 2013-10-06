#!/bin/sh

# get name of directory to split
if [ $# -lt 1 ]; then
    printf "arguments missing: \$dirname \n"
    exit 1
fi
dirname=$1

# check if list file exists
if [ ! -d $dirname ];
then
    printf "no such directory: $dirname \n"
    exit 2
fi

# move files
dirlimit=200
count=0
count_file=0
count_dir=0
for line in `ls $dirname`
do
    count=`expr $count + 1`
    count_file=`expr $count_file + 1`

    if [ $count_file -eq 1 ];
    then
        count_dir=`expr $count_dir + 1`
        newdirname=$(printf "%s_%.2d" $dirname $count_dir)
        mkdir $newdirname
    fi

    if [ $count_file -ge $dirlimit ];
    then
        count_file=0
    fi

    mv $dirname/$line $newdirname/$line
done

# status
echo "dir:" $count
echo "file:" $count_file
