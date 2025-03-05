#!/bin/bash
#
# R Jesse Chaney
# 

CLASS=cs205
#TERM=fall2024
LAB=Lab4
PROG1=part1
PROG2=part2
PROG3=part3
PROG4=part4
#JDIR=~rchaney/Classes/${CLASS}/Labs/src/nasm_parts
JDIR=~rchaney/Classes/${CLASS}/Labs/${LAB}
SDIR=${PWD}
B_STATE=0


VERBOSE=0
TOTAL_POINTS=7
TOTAL_AVAIL=225
EC_AVAIL=30
CLEANUP=1
TEST_COUNT=0
SLEEP_TIME=1
LEAKS=0
LEAKS_FOUND=0
NOLEAKS="All heap blocks were freed -- no leaks are possible"

DIFF=diff
BASE_DIFF_OPTIONS="-w"
#TRY_AGAIN_DIFF_OPTIONS="-w "
TIME_OUT=5s
TIME_OUT_KILL=10s
FILE_HOST=ada

SCRIPT=$0

show_help()
{
    echo "${SCRIPT}"
    echo "    -C : do not delete all the various test files. Automatic if a test fails."
    echo "    -v : provide some verbose output. Currently, this does nothing...  :-("
    echo "    -x : see EVERYTHING that is going one. LOTS of output. Hard to understand."
    echo "    -h : print this AMAZING help text."
}

build()
{
    echo "################################################################"
    echo "  Building..."

    make -k clean all > /dev/null 2> Sb.log

    if [ ! -x ${PROG1} ]
    then
        echo "  *** Did not build ${PROG1}!!!"
    else
        echo "    Build successful"
    fi
    if [ ! -x ${PROG2} ]
    then
        echo "  *** Did not build ${PROG2}!!!"
    else
        echo "    Build successful"
    fi
    if [ ! -x ${PROG3} ]
    then
        echo "  *** Did not build ${PROG3}!!!"
    else
        echo "    Build successful"
    fi
    if [ ! -x ${PROG4} ]
    then
        echo "  *** Did not build ${PROG4}!!!"
    else
        echo "    Build successful"
    fi
#    ((TOTAL_POINTS+=1))

    echo -e "\n"
}

test1()
{
    echo -e "\n\n** Testing Part1"
    
    JPROG=${JDIR}/${PROG1}
    SPROG=${SDIR}/${PROG1}

    if [ ! -x ${SPROG} ]
    then
        echo "${PROG1} does not exist. Nothing to test."
        return 0
    fi
    
    ${JPROG} > J1.out 2> J1.err
    timeout -k ${TIME_OUT_KILL} ${TIME_OUT} ${SPROG} > S1.out 2> S1.err

    STATUS=$?
    if [ ${STATUS} -ge 124 ]
    then
        echo "################################################################"
        echo "  Your program timed out."
        echo "    Test of ${PROG1} stops here."
        echo "################################################################"
        return 0
    fi
    if [ ${STATUS} -eq 0 ]
    then
        echo "  Running '${DIFF} ${BASE_DIFF_OPTIONS} S1.out J1.out'"
        ${DIFF} ${BASE_DIFF_OPTIONS} S1.out J1.out > T1.out 2> T1.err

        RES=$?
        if [ ${RES} -eq 0 ]
        then
            ((TOTAL_POINTS+=25))
            echo "  FILES ARE THE SAME!!!  : TOTAL_POINTS = ${TOTAL_POINTS}"
        else
            CLEANUP=0
            echo "  *** Output files differ. :-("
            echo "      No points for this one."
            echo "      ${DIFF} ${BASE_DIFF_OPTIONS} S1.out J1.out"
        fi
    else
        echo "################################################################"
        echo "  Your program exited with an error ${STATUS}."
        echo "    Test of ${PROG1} stops here."
        echo "################################################################"
        return 0
    fi
    echo "   Points so far     ${TOTAL_POINTS}  of a possible ${TOTAL_AVAIL}"
    echo -e "** Testing Part1 done"
}

test2()
{
    echo -e "\n\n** Testing Part2"
    JPROG=${JDIR}/${PROG2}
    SPROG=${SDIR}/${PROG2}

    if [ ! -x ${SPROG} ]
    then
        echo "${PROG2} does not exist. Nothing to test."
        return 0
    fi

    ${JPROG} > J2.out 2> J2.err
    timeout -k ${TIME_OUT_KILL} ${TIME_OUT} ${SPROG} > S2.out 2> S2.err

    STATUS=$?
    if [ ${STATUS} -ge 124 ]
    then
        echo "################################################################"
        echo "  Your program timed out."
        echo "    Test of ${PROG2} stops here."
        echo "################################################################"
        return 0
    fi
    if [ ${STATUS} -eq 0 ]
    then
        echo "  Running '${DIFF} ${BASE_DIFF_OPTIONS} S2.out J2.out'"
        ${DIFF} ${BASE_DIFF_OPTIONS} S2.out J2.out > T2.out 2> T2.err

        RES=$?
        if [ ${RES} -eq 0 ]
        then
            ((TOTAL_POINTS+=25))
            echo "  FILES ARE THE SAME!!!  : TOTAL_POINTS = ${TOTAL_POINTS}"
        else
            CLEANUP=0
            echo "  *** Output files differ. :-("
            echo "      No points for this one."
            echo "      ${DIFF} ${BASE_DIFF_OPTIONS} S2.out J2.out"
        fi
    else
        echo "################################################################"
        echo "  Your program exited with an error ${STATUS}."
        echo "    Test of ${PROG2} stops here."
        echo "################################################################"
        return 0
    fi
    echo "   Points so far     ${TOTAL_POINTS}  of a possible ${TOTAL_AVAIL}"
    echo -e "** Testing Part2 done"
}

create_test_ip()
{
    echo -e "\tSeed = \n\tArray size = \n\tMod = \n" > ip_values.txt

    echo -e "-1\n-1\n-1\n" > ip_0.txt

    echo -e "0\n0\n0\n" > ip_1.txt
    
    echo -e "3\n4\n100\n" > ip_2.txt

    echo -e "27\n25\n21\n" > ip_3.txt

    echo -e "256\n101\n500\n" > ip_4.txt

    echo -e "9\n1003\n5000\n" > ip_5.txt

    echo -e "19\n30071\n5301\n" > ip_6.txt

    echo -e "19036\n205\n333\n" > ip_7.txt

    echo -e "430936\n1037\n2307\n" > ip_8.txt
}

test3()
{
    echo -e "\n\n** Testing Part3"

    JPROG=${JDIR}/${PROG3}
    SPROG=${SDIR}/${PROG3}

    if [ ! -x ${SPROG} ]
    then
        echo "${PROG3} does not exist. Nothing to test."
        return 0
    fi

    BPOINTS=6
    create_test_ip
    for BTEST in {0..8}
    do
        paste ip_values.txt ip_${BTEST}.txt
        
        ${JPROG} < ip_${BTEST}.txt > J3_s${BTEST}.out 2> J3_s${BTEST}.err
        timeout -k ${TIME_OUT_KILL} ${TIME_OUT} ${SPROG} < ip_${BTEST}.txt > S3_s${BTEST}.out 2> S3_s${BTEST}.err

        STATUS=$?
        if [ ${STATUS} -ge 124 ]
        then
            echo "################################################################"
            echo "  Your program timed out."
            #echo "    Test of ${PROG3} stops here."
            echo "################################################################"
            CLEANUP=0
            continue
            #return 0
        fi
        if [ ${STATUS} -eq 0 ]
        then
            ${DIFF} ${BASE_DIFF_OPTIONS} S3_s${BTEST}.out J3_s${BTEST}.out > T3_s${BTEST}.out 2> T3_s${BTEST}.err

            RES=$?
            if [ ${RES} -eq 0 ]
            then
                ((TOTAL_POINTS+=BPOINTS))
                echo "  FILES ARE THE SAME!!!  : TOTAL_POINTS = ${TOTAL_POINTS}"
                echo "      Tested S3_s${BTEST}.out J3_s${BTEST}.out"
            else
                # test did not match.
                CLEANUP=0
                echo "  *** Output files differ. :-("
                echo "      No points for this one."
                echo "      ${DIFF} ${BASE_DIFF_OPTIONS} S3_s${BTEST}.out J3_s${BTEST}.out"
            fi

            # valgrind is not available for 32-bit applications on ada.
            # set -x
            valgrind ${SPROG} < ip_${BTEST}.txt 2> V3_s${BTEST}.log > /dev/null
            STATUS=$?
            if [ ${STATUS} -ne 0 ]
            then
                echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
                echo "  *** valgrind was very unhappy with your program!"
                echo "      That counts as leaks!"
                cowsay -d "valgrind very unhappy"
                echo "      Input : ip_${BTEST}.txt"
                paste ip_values.txt ip_${BTEST}.txt
                LEAKS_FOUND=1
                CLEANUP=0
            fi
            LEAKS=$(grep "${NOLEAKS}" V3_s${BTEST}.log | wc -l)
            if [ ${LEAKS} -eq 1 ]
            then
                echo -e "    No leaks found. Excellent!!!"
            else
                echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
                echo "  *** Leaks found! That is a 20% deduction."
                echo "      Check for not freeing allocated memory."
                cowsay -d "Leaks found!!!"
                LEAKS_FOUND=1
                CLEANUP=0
            fi
        else
            echo "################################################################"
            echo "  Your program exited with an error ${STATUS}."
            #echo "    Test of ${PROG3} stops here."
            echo "################################################################"
            CLEANUP=0
            #return 0
        fi
    done

    echo "   Points so far     ${TOTAL_POINTS}  of a possible ${TOTAL_AVAIL}"
    echo -e "** Testing Part3 done"
}

test4()
{
    echo -e "\n\n** Testing Part4"
    JPROG=${JDIR}/${PROG4}
    SPROG=${SDIR}/${PROG4}

    if [ ! -x ${SPROG} ]
    then
        echo "${PROG4} does not exist. Nothing to test."
        return 0
    fi

#    B_STATE=0
    BPOINTS=7
    create_test_ip
    for BTEST in 1 2 3 4 5 6
    do
        ${JPROG} < ip_${BTEST}.txt > J4_s${BTEST}.out 2> J4_s${BTEST}.err
        timeout -k ${TIME_OUT_KILL} ${TIME_OUT} ${SPROG} < ip_${BTEST}.txt > S4_s${BTEST}.out 2> S4_s${BTEST}.err
        STATUS=$?
        if [ ${STATUS} -eq 124 ]
        then
            echo "################################################################"
            echo "  Your program timed out."
            #echo "    Test of ${PROG4} stops here."
            echo "################################################################"
            CLEANUP=0
            continue
            #return 0
        fi
        if [ ${STATUS} -eq 0 ]
        then
            ${DIFF} ${BASE_DIFF_OPTIONS} S4_s${BTEST}.out J4_s${BTEST}.out > T4_s${BTEST}.out 2> T4_s${BTEST}.err

            paste ip_values.txt ip_${BTEST}.txt
            RES=$?
            if [ ${RES} -eq 0 ]
            then
                ((TOTAL_POINTS+=BPOINTS))
                echo "  FILES ARE THE SAME!!!  : TOTAL_POINTS = ${TOTAL_POINTS}"
                echo "      Tested S4_s${BTEST}.out J4_s${BTEST}.out"
            else
                CLEANUP=0
                echo "  *** Output files differ. :-("
                echo "      No points for this one."
                echo "      ${DIFF} ${BASE_DIFF_OPTIONS} S4_s${BTEST}.out J4_s${BTEST}.out"
            fi

            # valgrind is not available for 32-bit applications on ada.
            # valgrind ${SPROG} < ${IP_FILE} 2> V4_s${BTEST}.log > /dev/null
            # STATUS=$?
            # if [ ${STATUS} -ne 0 ]
            # then
            #     echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
            #     echo "  *** valgrind was very unhappy with your program!"
            #     echo "      That counts as leaks!"
            #     cowsay -d "valgrind very unhappy"
            #     echo "      Input : ${IP_FILE}"
            #     paste ip_values.txt ip_${BTEST}.txt
            #     LEAKS_FOUND=1
            #     CLEANUP=0
            # fi
            # LEAKS=$(grep "${NOLEAKS}" V4_s${BTEST}.log | wc -l)
            # if [ ${LEAKS} -eq 1 ]
            # then
            #     echo -e "    No leaks found. Excellent!!!"
            # else
            #     echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
            #     echo "  *** Leaks found! That is a 20% deduction."
            #     echo "      Check for not freeing allocated memory."
            #     cowsay -d "Leaks found!!!"
            #     LEAKS_FOUND=1
            #     CLEANUP=0
            # fi
        else
            echo "################################################################"
            echo "  Your program exited with an error ${STATUS}."
            #echo "    Test of ${PROG4} stops here."
            echo "################################################################"
            paste ip_values.txt ip_${BTEST}.txt
            CLEANUP=0
            #return 0
        fi
    done

    RPOINTS=8
    create_test_ip
    for RTEST in 1 2 3 4 5 6 7 8 9
    do
        SEED=$((RANDOM%5000))
        ASIZE=${RANDOM}
        MOD=$((RANDOM%500))

        echo -e "\tSeed = ${SEED}\n\tArray size = ${ASIZE}\n\tMod = ${MOD}\n"
        echo -e "${SEED}\n${ASIZE}\n${MOD}\n" > rip_${RTEST}.txt
        #echo -e "${ASIZE}\n${SEED}\n${MOD}\n" > rip_${RTEST}b.txt

        ${JPROG} < rip_${RTEST}.txt > J4_s${RTEST}.out 2> J4_s${RTEST}.err
        timeout -k ${TIME_OUT_KILL} ${TIME_OUT} ${SPROG} < rip_${RTEST}.txt > S4_s${RTEST}.out 2> S4_s${RTEST}.err

        STATUS=$?
        if [ ${STATUS} -eq 124 ]
        then
            echo "################################################################"
            echo "  Your program timed out."
            #echo "    Test of ${PROG4} stops here."
            echo "################################################################"
            CLEANUP=0
            continue
            #return 0
        fi
        if [ ${STATUS} -eq 0 ]
        then
            ${DIFF} ${BASE_DIFF_OPTIONS} S4_s${RTEST}.out J4_s${RTEST}.out > T4r_s${RTEST}.out 2> T4r_s${RTEST}.err

            RES=$?
            if [ ${RES} -eq 0 ]
            then
                ((TOTAL_POINTS+=RPOINTS))
                echo "  FILES ARE THE SAME!!!  : TOTAL_POINTS = ${TOTAL_POINTS}"
                echo "      Tested S4_s${RTEST}.out J4_s${RTEST}.out"
            else
                CLEANUP=0
                echo "  *** Output files differ. :-("
                echo "      No points for this one."
                echo "      ${DIFF} ${BASE_DIFF_OPTIONS} S4_s${RTEST}.out J4_s${RTEST}.out"
            fi
        else
            echo "################################################################"
            echo "  Your program exited with an error ${STATUS}."
            #echo "    Test of ${PROG4} stops here."
            echo "################################################################"
            CLEANUP=0
            #return 0
        fi
    done
    echo "   Points so far     ${TOTAL_POINTS}  of a possible ${TOTAL_AVAIL}"
    echo -e "** Testing Part4 done"
}


while getopts "xvCBhZ" opt
do
    case $opt in
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
        Z)
            SLEEP_TIME=0
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
echo "    Begun at     ${BDATE}"
echo "################################################################"
echo "################################################################"
echo -e "\n"

PATH+=:/usr/games

trap "kill 0" EXIT
trap "exit" INT TERM ERR

HOST=$(hostname -s)
if [ ${HOST} != ${FILE_HOST} ]
then
    echo "This script MUST be run on ${FILE_HOST}"
    exit 1
fi

build

test1
test2
test3
test4

if [ ${CLEANUP} -ne 0 ]
then
    rm -f [JS]*.out [JS]*.err part*_diff.out part*_diff.err WARN*
    rm -f T[1-9]*.{out,err} Sb.log rip* ip* V[34]*.log
fi

if [ ${LEAKS_FOUND} -ne 0 ]
then
    POINTS=$(echo ${TOTAL_POINTS} | awk '{print int($1 * 0.2 + 0.5);}')
    echo -e "\n"
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    cowsay -f vader -d "Points lost to memory leaks: ${POINTS}"
    echo "      Check for not freeing allocated memory."
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    echo -e "\n"
    ((TOTAL_POINTS-=${POINTS}))
fi

EDATE=$(date)
echo -e "\n"
echo "################################################################"
echo "################################################################"
echo "    Completed at     ${EDATE}"
echo "    TOTAL_POINTS     ${TOTAL_POINTS}  of a possible ${TOTAL_AVAIL}"
#echo "    TEST_COUNT       ${TEST_COUNT}"
echo "################################################################"
echo "################################################################"
echo "    These are raw points. If you made errors in your code that do"
echo "    not adhere the assignment, points will be deducted by visual"
echo "    inspection of your code."
echo "################################################################"
echo "################################################################"
echo -e "\n"
