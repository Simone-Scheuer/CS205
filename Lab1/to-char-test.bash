#!/bin/bash
#
# R Jesse Chaney
# rchaney@pdx.edu

PROG=to-char
POINTS=0
CLEANUP=1
WARNINGS=0
#DIFF_OPTIONS="-B -w -i"
DIFF_OPTIONS=""
LAB=Lab1
CLASS=cs205
GCC_FLAGS="-g3 -O0 -Wall -Werror"
NUM_TESTS=9

SDIR=.
JDIR=~rchaney/Classes/${CLASS}/Labs/${LAB}
#JDIR=~rchaney/Classes/${CLASS}/Labs/src/to-char

while getopts "xCh" opt
do
    case $opt in
        x)
            # If you really, really, REALLY want to watch what is going on.
            echo "Hang on for a wild ride."
            set -x
            ;;
        C)
            # Skip removal of data files
            CLEANUP=0
            ;;
        h)
            echo $(basename $0)
            echo "  -C   : don't delete the output files"
            echo "  -x   : show LOTS of detail about everything going on"
            echo "  -h   : show command line options to this script"
            exit 0
            ;;
        \?)
            echo "Invalid option" >&2
            echo ""
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

if [ ! -e ${PROG}.c ]
then
    echo "No ${PROG}.c exists. Cannot continue."
    exit 1
fi


rm -f ${PROG}-out.log ${PROG}-warn.log
#make clean
#make clean all
#make ${PROG} 2> ${PROG}-warn.log > ${PROG}-out.log

echo "Compiling with gcc flags: ${GCC_FLAGS}"
gcc ${GCC_FLAGS} -o ${PROG} ${PROG}.c 2> ${PROG}-warn.log > ${PROG}-out.log


if [ $? -ne 0 ]
then
    echo "compilation failed"
    echo "zero points"
    cat ${PROG}-out.log ${PROG}-warn.log
    exit 1
else
    NUM_BYTES=$(wc -c < ${PROG}-warn.log)
    if [ ${NUM_BYTES} -ne 0 ]
    then
        WARNINGS=1
        echo "  --- You have compiler warning messages. That is -20 percent!"
    else
        echo "  +++ You have no compiler warning messages. Good job."
        ((POINTS+=10))
    fi
fi

for I in $(shuf -i 1-${NUM_TESTS} -n ${NUM_TESTS})
do
    ${SDIR}/${PROG} < ${JDIR}/${PROG}-${I}.txt > S-toch${I}.out
    ${JDIR}/${PROG} < ${JDIR}/${PROG}-${I}.txt > J-toch${I}.out

    diff ${DIFF_OPTIONS} S-toch${I}.out J-toch${I}.out > /dev/null
    if [ $? -eq 0 ]
    then
        ((POINTS+=10))
        echo "  +++ ${PROG} on test file ${PROG}-${I}.txt is good +++"
    else
        echo "  --- ${PROG} on test file ${PROG}-${I}.txt is sad  ---"
        echo "    try this: diff ${DIFF_OPTIONS} -y S-toch${I}.out J-toch${I}.out"
        CLEANUP=0
    fi
done

echo "You have ${POINTS} points out of 100"
if [ ${WARNINGS} -ne 0 ]
then
    POINTS=$(echo ${POINTS}*.8 | bc)
    echo "But, you have compiler warnings"
    echo "  So, you get this many points ${POINTS}"
fi

if [ ${CLEANUP} -eq 1 ]
then
    rm -f [JS]-toch[1-${NUM_TESTS}].out ${PROG}-out.log ${PROG}-warn.log
    rm -f ${PROG} ${PROG}.o
fi
