#!/bin/bash

# R Jesse Chaney
# rchaney@pdx.edu
# 

CLASS=cs205
TERM=w25
LAB=Lab3
JDIR=~rchaney/Classes/${CLASS}/Labs/${LAB}
#JDIR=~rchaney/Classes/${CLASS}/Labs/src/sieve
#DATA_DIR=/disk/scratch/rchaney/cs205/Labs/sieve-gzip-5
DATA_DIR=/disk/scratch/rchaney/Classes/${CLASS}/Labs/${LAB}

VERBOSE=0
TOTAL_POINTS=0
VIEW_POINTS=0
CLEANUP=1
FILE_HOST=ada
BIG_TEST=1

SLEEP_TIME=30
#TIME_OUT=5m
TIME_OUT=18m
TIME_OUT_KILL=20m
#MEM_THRESHOLD=4
#MEM_THRESHOLD=2.1
MEM_THRESHOLD=1.1
#COMPRESSION=-9
COMPRESSION=-5
GZIP="gzip ${COMPRESSION}"
ZCAT=zcat
DIFF=zdiff
SUM=md5sum
NOLEAKS="All heap blocks were freed -- no leaks are possible"
LEAKS_FOUND=0
NO_ALLOCS=0
ALLOCS=0
ALLOC_BYTES=0

PROG1=sieve-8
PROG2=view_long

NICE=nice

COWSAY=/usr/games/cowsay

# in the event that games in not in the PATH
PATH+=${PATH}:/usr/games

SCRIPT=$0

show_help()
{
    echo "${SCRIPT}"
    echo "    -B : skip the 5-billion test."
    echo "    -C : do not delete all the various test files. Automatic if a test fails."
    echo "    -v : provide some verbose output. Currently, this does nothing...  :-("
    echo "    -x : see EVERYTHING that is going one. LOTS of output. Hard to understand."
    echo "    -h : print this AMAZING help text."
}

build()
{
    make clean > /dev/null 2> /dev/null
    make clean all > /dev/null 2> /dev/null
    
    if [ ! -x ${PROG1} -o ! -x ${PROG2} ]
    then
        echo "Did not build!!!"
        echo "  Exiting with 0 points"
        exit 2
    fi

    ln -sf ${DATA_DIR}/primes*.{txt,gz} .
    ln -sf ${DATA_DIR}/composites*.{txt,gz} .
}

prime_text()
{
    echo "Testing text primes"
    for UB in 100 1000 100000 1000000 10000000
    do
        if [ ! -f ./primes_${UB}.txt.gz ]
        then
            echo "***** File missing ./primes_${UB}.txt.gz"
        fi
        ${NICE} ./${PROG1} -u ${UB} | ${GZIP} > s_primes1_${UB}.txt.gz
        ${NICE} ./${PROG1} -ccpu ${UB} | ${GZIP} > s_primes2_${UB}.txt.gz

        S_SUM1=$(${SUM} s_primes1_${UB}.txt.gz | cut -f 1 -d ' ')
        J_SUM1=$(${SUM} primes_${UB}.txt.gz | cut -f 1 -d ' ')
        
        #${DIFF} s_primes1_${UB}.txt.gz ./primes_${UB}.txt.gz > /dev/null 2> /dev/null
        #if [ $? -eq 0 ]
        if [ ${S_SUM1} = ${J_SUM1} ]
        then
            ((TOTAL_POINTS+=3))
            echo "  Primes equal using upper bound: ${UB}: TOTAL_POINTS=${TOTAL_POINTS}"
        else
            echo "  ** Primes differ: ${DIFF} -y s_primes1_${UB}.txt.gz ./primes_${UB}.txt.gz"
            CLEANUP=0
        fi

        S_SUM2=$(${SUM} s_primes2_${UB}.txt.gz | cut -f 1 -d ' ') 
        
        #${DIFF} s_primes2_${UB}.txt.gz ./primes_${UB}.txt.gz > /dev/null 2> /dev/null
        #if [ $? -eq 0 ]
        if [ ${S_SUM1} = ${J_SUM1} ]
        then
            ((TOTAL_POINTS+=6))
            echo "  Primes equal using -ccpu ${UB}: TOTAL_POINTS=${TOTAL_POINTS}"
        else
            echo "  ** Primes differ using -ccpu ${UB}: ${DIFF} -y s_primes1_${UB}.txt.gz ./primes_${UB}.txt.gz"
            CLEANUP=0
        fi
    done
}

prime_text_random()
{
    echo "Random testing text primes"
    for I in 1 2 3 4 5
    do
        #local UB=${RANDOM}
        local UB=$(shuf -i 31656-32707 -n 1)
        # if [ ! -f ./primes_${UB}.txt.gz ]
        # then
        #     echo "***** File missing ./primes_${UB}.txt.gz"
        # fi
        local S1=rs_primes1_${UB}.txt
        local S2=rs_primes2_${UB}.txt
        local FAKE_UB1=""
        local FAKE_UB2=""
        for J in 1 2 3 4 5
        do
            local UB1=$(shuf -i 3000-60000 -n 1)
            local UB2=$(shuf -i 50000-800000 -n 1)
            FAKE_UB1="${FAKE_UB1} -u ${UB1}"
            FAKE_UB2="${FAKE_UB2} -u ${UB2}"
        done
        ${NICE} ./${PROG1} ${FAKE_UB1} -pu ${UB} > ${S1}
        ${NICE} ./${PROG1} ${FAKE_UB2} -cu ${UB} > ${S2}

        local J1=rj_primes1_${UB}.txt
        local J2=rj_primes2_${UB}.txt
        ${NICE} ${JDIR}/${PROG1} ${FAKE_UB1} -pu ${UB} > ${J1}
        ${NICE} ${JDIR}/${PROG1} ${FAKE_UB2} -cu ${UB} > ${J2}

        ${DIFF} ${S1} ${J1} > /dev/null 2> /dev/null
        if [ $? -eq 0 ]
        then
            ((TOTAL_POINTS+=5))
            echo "  Primes equal using ${FAKE_UB1} -pu ${UB}: TOTAL_POINTS=${TOTAL_POINTS}"
        else
            echo "  ** Primes differ using ${FAKE_UB1} -pu ${UB}: ${DIFF} ${S1} ${J1}"
            CLEANUP=0
        fi

        ${DIFF} ${S2} ${J2} > /dev/null 2> /dev/null
        if [ $? -eq 0 ]
        then
            ((TOTAL_POINTS+=4))
            echo "  Primes equal using ${FAKE_UB2} -cu ${UB}: TOTAL_POINTS=${TOTAL_POINTS}"
        else
            echo "  ** Primes differ using ${FAKE_UB2} -cu ${UB} : ${DIFF} -y ${S2} ${J2}"
            CLEANUP=0
        fi
    done
}

prime_bin()
{
    echo "Testing binary primes"
    for UB in 100 1000 100000 10000000 100000000
    do
        if [ ! -f ./primes_${UB}.bin.gz ]
        then
            echo "***** File missing ./primes_${UB}.bin.gz"
        fi
        ${NICE} ./${PROG1} -bu ${UB} | ${GZIP} > s_primes1_${UB}.bin.gz
        ${NICE} ./${PROG1} -bcpcpcpcpcpc -cccu ${UB} -c -cp | ${GZIP} > s_primes2_${UB}.bin.gz

        S_SUM1=$(${SUM} s_primes1_${UB}.bin.gz | cut -f 1 -d ' ')
        J_SUM1=$(${SUM} ./primes_${UB}.bin.gz | cut -f 1 -d ' ')
        if [ ${S_SUM1} = ${J_SUM1} ]
        then
            ((TOTAL_POINTS+=4))
            echo "  Primes equal with -bu ${UB}: TOTAL_POINTS=${TOTAL_POINTS}"
        else
            echo "  ** Primes differ with -bu ${UB} ${SUM} s_primes1_${UB}.bin.gz ./primes_${UB}.bin.gz"
            CLEANUP=0
        fi

        S_SUM2=$(${SUM} s_primes2_${UB}.bin.gz | cut -f 1 -d ' ')
        if [ ${S_SUM2} = ${J_SUM1} ]
        then
            ((TOTAL_POINTS+=6))
            echo "  Primes equal with -bcu ${UB} -p: TOTAL_POINTS=${TOTAL_POINTS}"
        else
            echo "  ** Primes differ with -bcpcpcpcpcpc -cccu ${UB} -c -cp : ${SUM} s_primes2_${UB}.bin.gz ./composites_${UB}.bin.gz"
            CLEANUP=0
        fi
    done
}

prime_5b()
{
    if [ ${BIG_TEST} -eq 1 ]
    then
        local B5_BEGIN=$(date)
        
        local UB=5000000000
        echo "Testing binary primes ub = ${UB}  that is 5 billion (with a B)"
        echo "    Be patient, this will take a while... like 10 minutes..."
        echo "    It will be automatically killed after ${TIME_OUT} (which is bad)."
        ###timeout -k ${TIME_OUT_KILL} ${TIME_OUT} ./${PROG1} -bu ${UB} | ${GZIP} > s_primes1_${UB}.bin.gz &
        ${NICE} timeout -k ${TIME_OUT_KILL} ${TIME_OUT} bash -c "./${PROG1} -bu ${UB} | ${GZIP} > s_primes1_${UB}.bin.gz" &
        #./${PROG1} -bu ${UB} | ${GZIP} > s_primes1_${UB}.bin.gz &
        #BG=$!

        # finding the pid of the sieve process (with the timeout as a background process)
        # was MUCH messier than I thought it should be, but was managed.
        #jobs -p
        local TO=$(jobs -p)
        #TO=$!
        # gets pid of the bash sub-shell
        local BP=$(ps -ef | grep ${TO} | awk -v TO=${TO} '{if ($3 == TO) print $2;}')
        # gets the pid of sieve
        local BG=$(ps -ef | grep ${BP} | grep sieve | awk -v TO=${BP} '{if ($3 == TO) print $2;}')
        #echo "sieve PID=${BG}  timeout=${TO}"

        #ps -ef | grep ${TO}
        
        #kill ${BG}
        #exit

        sleep ${SLEEP_TIME}

        # finding out how much memory, as a % of total memory, was messier than
        # i thought it should be, but it worked out.
        # I sort of hate using ps with 2 different type of command line args,
        # but life is sometimes hard.
        local MEM=$(ps augx | grep ${BG} | grep -v grep | awk '{print $4;}')
        #MEM=$(ps -elf | g ${BG} | g -v grep | awk '{print $10;}')
        echo -e "\tUsing memory: ${MEM}"

        #echo "PID = ${BG}  memory is ${MEM}"
        local OVER=$(echo ${MEM} | awk -v THRES=${MEM_THRESHOLD} '{if ( $1 > THRES ) print 1; else print 0;}')
        if [ ${OVER} -gt 0 ]
        then
            echo "  **********************************"
            echo "  *** You are using too much memory."
            echo "        ${MEM}% on ada. You should not be over ${MEM_THRESHOLD}%"
            echo "  **********************************"
        else
            echo "    You are efficiently using memory. Wooo Hooo!!!"
            ((TOTAL_POINTS+=30))
            echo "  Efficient memory use with -bu ${UB}: TOTAL_POINTS=${TOTAL_POINTS}"
        fi

        wait ${TO}
        local EV=$?
        #echo "exit value ${EV}   ${TIME_OUT}    ${TIME_OUT_KILL}"
        if [ ${EV} -ge 124 ]
        then
            echo "  **** Ohhh.. A timeout on ./${PROG1} -bu ${UB}. That is not good. ****"
            echo "       It waited ${TIME_OUT}."
        fi
        if [ ! -f ./primes_${UB}.bin.gz ]
        then
            echo "***** File missing ./primes_${UB}.bin.gz"
        fi
        local S_SUM1=$(${SUM} s_primes1_${UB}.bin.gz | cut -f 1 -d ' ')
        local J_SUM1=$(${SUM} ./primes_${UB}.bin.gz | cut -f 1 -d ' ')

        local B5_END=$(date)
        if [ ${S_SUM1} = ${J_SUM1} ]
        then
            ((TOTAL_POINTS+=29))
            echo "  Primes equal with -bu ${UB}: TOTAL_POINTS=${TOTAL_POINTS}"
        else
            echo "  ** Primes differ with -bu ${UB}: ${SUM} s_primes1_${UB}.bin.gz ./primes_${UB}.bin.gz"
            CLEANUP=0
        fi
        echo "    5b test begun ${B5_BEGIN}"
        echo "    5b test end   ${B5_END}"
    else
        echo "################################################"
        echo "################################################"
        echo "Skipping the big test..."
        echo "################################################"
        echo "################################################"
    fi
}

composite_text()
{
    #set -x
    echo "Testing text composites"
    for UB in 100 1000 100000 1000000 10000000
    do
        if [ ! -f ./composites_${UB}.txt.gz ]
        then
            echo "***** File missing ./composites_${UB}.txt.gz"
        fi
        ${NICE} ./${PROG1} -u${UB} -c | ${GZIP} > s_composites1_${UB}.txt.gz
        ${NICE} ./${PROG1} -u${UB} -ppppppcpc -pc -c | ${GZIP} > s_composites2_${UB}.txt.gz

        S_SUM1=$(${SUM} s_composites1_${UB}.txt.gz | cut -f 1 -d ' ')
        J_SUM1=$(${SUM} composites_${UB}.txt.gz | cut -f 1 -d ' ')

        #${DIFF} s_composites1_${UB}.txt.gz ./composites_${UB}.txt.gz > /dev/null 2> /dev/null
        #if [ $? -eq 0 ]
        if [ ${S_SUM1} = ${J_SUM1} ]
        then
            ((TOTAL_POINTS+=3))
            echo "  Composites equal using: -u${UB} -c: TOTAL_POINTS=${TOTAL_POINTS}"
        else
            echo "  ** Composites differ using -u${UB} -c: ${DIFF} -y s_composites1_${UB}.txt.gz ./composites_${UB}.txt.gz"
            CLEANUP=0
        fi

        S_SUM2=$(${SUM} s_composites2_${UB}.txt.gz | cut -f 1 -d ' ')
        #${DIFF} s_composites2_${UB}.txt.gz ./composites_${UB}.txt.gz > /dev/null 2> /dev/null
        #if [ $? -eq 0 ]
        if [ ${S_SUM2} = ${J_SUM1} ]
        then
            ((TOTAL_POINTS+=6))
            echo "  Composites equal using: -u${UB} -pc upper bound: TOTAL_POINTS=${TOTAL_POINTS}"
        else
            echo "  ** Composites differ using: -u${UB} -ppppppcpc -pc -c : ${DIFF} -y s_composites1_${UB}.txt.gz ./composites_${UB}.txt.gz"
            CLEANUP=0
        fi
    done
}

composite_bin()
{
    echo "Testing binary composites"
    local ARGS1="-bcu"
    #local ARGS2="-bpcpcpcpcpcc -p -pppc"
    for UB in 100 1000 100000 10000000 #100000000
    do
        # This is sort of evil. I feel bad about it.
        local LONG_ARG=$(echo bpcpcpcpcpcc | fold -w1 | shuf | tr -d '\n')
        #echo "***** LONG_ARG=${LONG_ARG} *****"
        local ARGS2="-${LONG_ARG} -p -${LONG_ARG}pppc"
        if [ ! -f composites_${UB}.bin.gz ]
        then
            echo "***** File missing ./composites_${UB}.bin.gz"
        fi
        ${NICE} ./${PROG1} ${ARGS1} ${UB} | ${GZIP} > s_composites1_${UB}.bin.gz
        ${NICE} ./${PROG1} -u ${UB} ${ARGS2} | ${GZIP} > s_composites2_${UB}.bin.gz

        local S_SUM1=$(${SUM} s_composites1_${UB}.bin.gz | cut -f 1 -d ' ')
        local J_SUM1=$(${SUM} ./composites_${UB}.bin.gz | cut -f 1 -d ' ')
        if [ ${S_SUM1} = ${J_SUM1} ]
        then
            ((TOTAL_POINTS+=4))
            echo "  Composites equal with ${ARGS1} ${UB}: TOTAL_POINTS=${TOTAL_POINTS}"
        else
            echo "  ** Composites differ with ${ARGS1} ${UB}: ${SUM} s_composites1_${UB}.bin.gz ./composites_${UB}.bin.gz"
            CLEANUP=0
        fi

        local S_SUM2=$(${SUM} s_composites2_${UB}.bin.gz | cut -f 1 -d ' ')
        if [ ${S_SUM2} = ${J_SUM1} ]
        then
            ((TOTAL_POINTS+=6))
            echo "  Composites equal with -u ${UB} ${ARGS2}: TOTAL_POINTS=${TOTAL_POINTS}"
        else
            echo "  ** Composites differ with -u ${UB} ${ARGS2}: ${SUM} s_composites2_${UB}.bin.gz ./composites_${UB}.bin.gz"
            CLEANUP=0
        fi
    done
}

view_long()
{
    echo "Testing ${PROG2}"
    #set -x
    for UB in 100 1000 100000
    #for UB in 100000
    do
        ${ZCAT} s_primes1_${UB}.bin.gz | ./${PROG2} | ${DIFF} - ./primes_${UB}.txt.gz > /dev/null 2> /dev/null
        if [ $? -eq 0 ]
        then
            ((VIEW_POINTS+=8))
            echo "  ${PROG2} success 1: ${UB}: VIEW_POINTS=${VIEW_POINTS}"
        else
            echo "  ** ${PROG2} failed 1: ${UB}: VIEW_POINTS=${VIEW_POINTS}"
            CLEANUP=0
        fi

        ${NICE} ${ZCAT} s_primes1_${UB}.bin.gz > s_primes1_${UB}.bin
        ${NICE} ./${PROG2} s_primes1_${UB}.bin | ${DIFF} - ./primes_${UB}.txt.gz > /dev/null 2> /dev/null
        if [ $? -eq 0 ]
        then
            ((VIEW_POINTS+=8))
            echo "  ${PROG2} success 2: ${UB}: VIEW_POINTS=${VIEW_POINTS}"
        else
            echo "  ** ${PROG2} failed 2: ${UB}: VIEW_POINTS=${VIEW_POINTS}"
            CLEANUP=0
        fi
    done

    ${NICE} ./${PROG2} s_primes1_100.bin s_primes1_1000.bin > s_primes1_100_1000.txt
    ${NICE} cat primes_100.txt primes_1000.txt | diff s_primes1_100_1000.txt -
    if [ $? -eq 0 ]
    then
        ((VIEW_POINTS+=12))
        echo "  ${PROG2} success 3: s_primes1_100.bin s_primes1_1000.bin: VIEW_POINTS=${VIEW_POINTS}"
    else
        echo "  ** ${PROG2} failed 3: s_primes1_100.bin s_primes1_1000.bin: VIEW_POINTS=${VIEW_POINTS}"
        CLEANUP=0
    fi
}

valgrind_check()
{
    local LOG=$1
    shift
    local ARGS=$*

    #echo "valgrid log file ${LOG}"
    #echo "valgrid args ${ARGS}"
    
    local LEAKS=$(grep "${NOLEAKS}" ${LOG} | wc -l)
    ALLOCS=$(grep "bytes allocated" ${LOG} | awk '{print $9;}' | sed 's/,//g')
    ((ALLOCS+=100))
    #ALLOC_BYTES=$(echo ${ALLOCS} | awk '{print $1 / 8;}')
    if [ ${LEAKS} -eq 1 ]
    then
        if [ ${ALLOCS} -eq 0 ]
        then
            echo "  *** You are not allocating memory for the array of bits. ***"
            echo "      That is a 20% deduction."
            ${COWSAY} -f daemon "Trying to trick me..."
            NO_ALLOCS=1
        else
            ALLOC_BYTES=$(echo ${ALLOCS} | awk '{print int($1 / 8 + 0.5);}')
            SHOULD_ALLOC=$(echo ${UB} | awk '{print int($1 / 8 + 0.5);}')
            #echo "*** ALLOCS ${ALLOCS}    ${ALLOC_BYTES}   ${SHOULD_ALLOC}***"
            if [ ${ALLOCS} -lt ${SHOULD_ALLOC} ]
            then
                grep "bytes allocated" ${LOG}
                echo "  *** You are not allocating memory correctly. Do it correctly."
                echo "      This is a 20% deduction."
                LEAKS_FOUND=1
            else
                echo -e "  No leaks found! : ${ARGS} "
                echo    "  Excellent!!!"
                #${COWSAY} -f tux -w "No Leaks"
            fi
        fi
        
    else
        if [ ${LEAKS_FOUND} -eq 0 ]
        then
            echo "  *** Leaks found : ${ARGS}"
            echo "      That is a 20% deduction."
            echo "      Check for not freeing allocated memory."
            ${COWSAY} -d "Udderly awful"
            LEAKS_FOUND=1
            CLEANUP=0
        else
            echo "  *** Leaks found : ${ARGS}"
        fi
    fi
}

valgrind_test()
{
    echo "Begin valgrind test"
    for UB in 10000 100000 1000000
    #for UB in 100000 1000000 10000000
    #for UB in 103004 1100007 1500003
    do
        if [ ! -f ./primes_${UB}.txt.gz ]
        then
            echo "***** File missing ./primes_${UB}.bin.gz"
        fi
        valgrind ./${PROG1} -u ${UB} > s_primes1_${UB}.txt 2> v-pu${UB}-t.err
        valgrind_check v-pu${UB}-t.err ./${PROG1} -u ${UB}
        
        valgrind ./${PROG1} -cu ${UB} > s_composites2_${UB}.txt 2> v-cu${UB}-t.err
        valgrind_check v-cu${UB}-t.err ./${PROG1} -cu ${UB}

        valgrind ./${PROG1} -bu ${UB} > s_primes1_${UB}.txt 2> v-pu${UB}-b.err
        valgrind_check v-pu${UB}-b.err ./${PROG1} -bu ${UB}
        
        valgrind ./${PROG1} -cbu ${UB} > s_composites2_${UB}.txt 2> v-cu${UB}-b.err
        valgrind_check v-cu${UB}-b.err ./${PROG1} -cbu ${UB}
    done

    if [ ${LEAKS_FOUND} -eq 0 ]
    then
        ${COWSAY} -f luke-koala "No leaks. The free is with you!"
    fi
}

while getopts "xvCBh" opt
do
    case $opt in
        B)
            # having this option will skip running the 5b test.
            # this will significantly reduce the total time for the
            # script, but will not test those features.
            BIG_TEST=0
            ;;
	    C)
	        # Skip removal of data files
	        CLEANUP=0
	        ;;
	    v)
	        # Print extra messages.
	        VERBOSE=1
	        ;;
	    x)
	        # If you really, really, REALLY want to watch what is going on.
	        echo "Hang on for a wild ride."
	        set -x
	        ;;
        h)
            show_help
            exit 0
            ;;
	    \?)
	        echo "Invalid option" >&2
	        echo ""
	        show_help
	        exit 1
	        ;;
	    :)
	        echo "Option -$OPTARG requires an argument." >&2
            show_help
	        exit 1
	        ;;
    esac
done

BDATE=$(date)

echo "################################################################"
echo "################################################################"
echo "Expect this to take 15-20 minutes for a complete set of tests!!!"
echo "    Begun at     ${BDATE}"
echo "################################################################"
echo "################################################################"
echo -e "\n"

trap "kill 0" EXIT
trap "exit" INT TERM ERR

HOST=$(hostname -s)
if [ ${HOST} != ${FILE_HOST} ]
then
    echo "This script MUST be run on ${FILE_HOST}"
    exit 1
fi

build

prime_text
composite_text

prime_bin
composite_bin

prime_text_random

prime_5b

# need to test for leaks
valgrind_test

view_long


if [ ${CLEANUP} -eq 1 ]
then
    echo "Cleaning up"
    rm -f s_primes* s_composites*
    rm -f rs_primes* rs_composites*
    rm -f rj_primes* rj_composites*
    rm -f v-*
fi

EDATE=$(date)

if [ ${LEAKS_FOUND} -ne 0 ]
then
    POINTS=$(echo ${TOTAL_POINTS} | awk '{print $1 * 0.2;}')
    echo -e "\n"
    echo "################################################################"
    echo "  Points lost to memory leaks: ${POINTS}"
    echo "################################################################"
    echo -e "\n"
    ((TOTAL_POINTS-=${POINTS}))
fi

if [ ${NO_ALLOCS} -ne 0 ]
then
    POINTS=$(echo ${TOTAL_POINTS} | awk '{print $1 * 0.2;}')
    echo -e "\n"
    echo "################################################################"
    echo "  Points lost to not allocating the array of bits: ${POINTS}"
    echo "################################################################"
    echo -e "\n"
    ((TOTAL_POINTS-=${POINTS}))
fi

echo -e "\n"
echo "Test begun at     ${BDATE}"
echo "Test completed at ${EDATE}"
echo -e "\n"

echo "*** sieve TOTAL_POINTS    = ${TOTAL_POINTS} ***"
echo "*** view_long VIEW_POINTS = ${VIEW_POINTS} ***"
