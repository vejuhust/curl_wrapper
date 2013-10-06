#!/bin/sh

# get file name of the list
if [ $# -lt 1 ]; then
    printf "arguments missing: \$listname \n"
    exit 1
fi
listname=$1

# check if list file exists
if [ ! -f $listname ];
then
    printf "no such list file: $listname \n"
    exit 2
fi

# remove repeated lines
tmplist=tmplist.tmp
awk '{ sub(/\r$/,""); print }' $listname | sort | uniq > $tmplist

# set limit of file numbers
limit=0
if [ $# -ge 2 ]; then
    limit=$2
    echo $limit
fi

# make directory
dirname=${listname%.*}
if [ ! -d $dirname ];
then
    mkdir $dirname
fi

# download process
count=0
count_down=0
count_skip=0
for line in `cat $tmplist`
do
    count=`expr $count + 1`
    filename=$dirname/${line##*/}

    if [ -f $filename ];
    then
        echo "existed " $filename
        count_skip=`expr $count_skip + 1`
    else
        curl $line -o $filename
        count_down=`expr $count_down + 1`
    fi

    if [ $count -eq $limit ];
    then
        break
    fi
done
rm -f $tmplist

# status
echo ${0##*/} "finished"
echo "scan:" $count
echo "down:" $count_down
echo "skip:" $count_skip
