#!/bin/sh

# get file name of the listindex
if [ $# -lt 1 ]; then
    printf "arguments missing: \$listindex \n"
    exit 1
fi
listindex=$1

# check if list file exists
if [ ! -f $listindex ];
then
    printf "no such list index: $listindex \n"
    exit 2
fi

# call process
count=0
count_call=0
for listname in `cat $listindex`
do
    count=`expr $count + 1`
    if [ -f $listname ];
    then
        ./down_album.sh $listname
        count_call=`expr $count_call + 1`
    fi
done

# status
echo ${0##*/} "finished"
echo "total:" $count
echo "call:" $count_call
