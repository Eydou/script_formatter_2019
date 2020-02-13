#!/usr/bin/env bash
##
## EPITECH PROJECT, 2020
## script.
## File description:
## script.
##

COMM="FALSE"
OUT="FALSE"
INDENT="FALSE"
HEADER="FALSE"
EXPAND="FALSE"
SPACE="FALSE"

function ordinal_nbr () {
    case "$1" in
        *1[0-9] | *[04-9]) echo "$1"th;;
        *1) echo "$1"st;; 
        *2) echo "$1"nd;;
        *3) echo "$1"rd;;
    esac
}

print_header() {
    DAY=$(date +'%d')
    ORDAY=$(ordinal_nbr $DAY)
    MONTHY=$(date +'%B, %Y')
    DATE="$ORDAY $MONTHY"
    sed -i '2i\'"\n" $FILE
    sed -i '3i\'"#+-+-ѕcrιpт_ғorмaттer-+-+" $FILE
    sed -i '4i\'"#|" $FILE
    sed -i '4i\'"#+" $FILE
    if [ $OUT = "TRUE" ]; then
        sed -i '5i\'"#| $NAMEOUT" $FILE
        else
        sed -i '5i\'"#| no filename" $FILE
    fi
    sed -i '6i\'"#+ $DATE" $FILE
    if [ $COMM = "FALSE" ]; then
        sed -i '8i\'"#|" $FILE
        else
        sed -i '8i\'"#+$comment" $FILE
    fi
    sed -i '9i\'"#+-+-+-+-+-+  +-+-+-+-+-+" $FILE
}

condition_indentation() {
    count=1
    count_space=0
    count_indentation=0
    NB_LINE=$(wc -l $FILE | awk '{ print $1 }')
    NB_SPACE=$(printf %${NB_INDENT}s | tr " " " ")
    NRL_SPACE=$(printf "        ")
    COND=0
        for ((i=1; i != $NB_LINE + 1; i++)); do
            count_for=$(sed "${i}q;d" $FILE | grep -w "for" | wc -l)
            count_if=$(sed "${i}q;d" $FILE | grep -w "if" | wc -l)
            count_fi=$(sed "${i}q;d" $FILE | grep -w "fi" | wc -l)
            count_done=$(sed "${i}q;d" $FILE | grep -w "done" | wc -l)
            count_then=$(sed "${i}q;d" $FILE | grep -w "then" | wc -l)
            count_do=$(sed "${i}q;d" $FILE| grep -w "do" | wc -l)
            count_bracket=$(sed "${i}q;d" $FILE | grep -w "{" | wc -l)
            count_2=$(sed "${i}q;d" $FILE | grep -w "}" | wc -l)
            if [ $count_for -ge 1 ]; then
                count_indentation=$((count_indentation+1))
                count_for=$((0))
                if [ $count_indentation -ge 2 ]; then
                    count=$((count+1))
                    count_indentation=$((count_indentation-1))
                fi
            elif [ $count_if -ge 1 ]; then
                count_indentation=$((count_indentation+1))
                count_if=$((0))
                if [ $count_indentation -ge 2 ]; then
                    count=$((count+1))
                    count_indentation=$((count_indentation-1))
                fi
            elif [ $count_bracket -ge 1 ]; then
                count_indentation=$((count_indentation+1))
                count_bracket=$((0))
                if [ $count_indentation -ge 2 ]; then
                    count=$((count+1))
                    count_indentation=$((count_indentation-1))
                fi
            elif [ $count_2 -ge 1 ]; then
                count=$((count-1))
                count_2=$((0))
                if [ $count_indentation -gt 0 ]; then
                        count_indentation=$((count_indentation-1))
                fi
            elif [ $count_fi -ge 1 ]; then
                count=$((count-1))
                count_fi=$((0))
                if [ $count_indentation -gt 0 ]; then
                        count_indentation=$((count_indentation-1))
                fi
            elif [ $count_done -ge 1 ]; then
                count=$((count-1))
                count_done=$((0))
                if [ $count_indentation -gt 0 ]; then
                        count_indentation=$((count_indentation-1))
                fi
            elif [ $count_do -ge 1 ]; then
                count=$((count))
                count_do=$((0))
                count_indentation=$((count_indentation+1))
            elif [ $count_then -ge 1 ]; then
                count=$((count))
                count_then=$((0))
                count_indentation=$((count_indentation+1))
            elif [ $count_indentation -ge 1 ]; then
                count=$((count+1))
                count_indentation=$((0))
            fi
            for ((a=0; a < count - 1; a++)); do
                if [ $COND -gt "-1" ] && [ $count -gt "1" ] && [ $INDENT = "FALSE" ]; then
                    count_space=$((count - 1))
                    my_space=$(yes "$NRL_SPACE" | head -n $count_space | tr -d '\n')
                    sed -i "${i}s/^/\t/" $FILE
                    sed -i 's/        /\t/g' $FILE
                elif [ $COND -gt "-1" ] && [ $count -gt "1" ] && [ $INDENT = "TRUE" ]; then
                count_space=$((count - 1))
                my_space=$(yes "$NB_SPACE" | head -n $count_space | tr -d '\n')
                    sed -i "${i}s/^/${my_space}/" $FILE
                    sed -i 's/        /\t/g' $FILE
                fi
            done
            if [ $count -gt "1" ]; then
                COND=$((COND+1))
        fi
    done
    if [ $SPACE = "TRUE" ]; then
        sed -i 's/\t/        /g' $FILE
    fi
}

condition_then_do() {
    if [ $EXPAND = "FALSE" ]; then
        sed -i 's/; then//g' $FILE
        sed -i -e 's/^\(if\).*$/&; then/g' $FILE
        sed -i '/^then/d' $FILE
        sed -i 's/; do//g' $FILE
        sed -i -e 's/^\(for\).*$/&; do/g' $FILE
    elif [ $EXPAND = "TRUE" ]; then
        sed -i '/; then/a \then' $FILE
        sed -i '/; do/a \do' $FILE
        sed -i 's/; then//g' $FILE
        sed -i 's/; do//g' $FILE
    fi
}

display() {
    sed -i 's/\<then\>/&\n/' $FILE
    sed -i 's/\<then\>/&\n/' $FILE
    sed -i 's/\<=do\>/&\n/' $FILE
    sed -i 's/\<=do\>/&\n/' $FILE
    sed -i 's/{/\n&\n/g' $FILE
    sed -i 's/}/\n&\n/g' $FILE
    sed -i 's/^ *//' $FILE
    sed -i 's/ function/\nfunction/' $FILE
    sed -i 's/ fi/\nfi/' $FILE
    condition_then_do
    sed -i 's/if/\nif/' $FILE
    sed -i 's/ fi/\nfi/' $FILE
    sed -i '/^$/d' $FILE
    condition_indentation
    sed -i -e '/^[[:blank:]]*$/d' $FILE
    sed -i 's/function/\nfunction/' $FILE
    sed -i 's/}/}\n/' $FILE
    if [ $HEADER = "TRUE" ] && [ $OUT = "FALSE" ]; then
        print_header
        cat .script
    fi
    if [ $HEADER = "FALSE" ] && [ $OUT = "FALSE" ]; then
        cat .script
    fi
    if [ $OUT = "TRUE" ]; then
        print_header
        cat .script > $NAMEOUT
    fi
}

options_script() {
    shift
    while getopts "hsi:eo:-:" OPT
        do
        case $OPT in
        -)
            case "${OPTARG}" in
            out=)
                echo "invalid argument"
                exit 84;;
            output=)
                echo "invalid argument"
                exit 84;;
            spaces=)
                echo "invalid argument"
                exit 84;;
            indentation=)
                echo "invalid argument"
                exit 84;;
            output=)
                echo "invalid argument"
                exit 84;;
                output=*)
                    NAMEOUT=${OPTARG#*=}
                    OUT="TRUE";;
                out=*)
                    NAMEOUT=${OPTARG#*=}
                    OUT="TRUE";;
                header)
                    HEADER="TRUE";;
                spaces)
                    SPACE="TRUE";;
                indentation=*)
                    NB_INDENT=${OPTARG#*=}
                    INDENT="TRUE";;
                expand)
                    EXPAND="TRUE";;
                *)
                    exit 84;;
            esac;;
        h)
            HEADER="TRUE";;
         s)
            SPACE="TRUE";;
         i)
             NB_INDENT=${OPTARG#*=}
                    INDENT="TRUE";;
         e)
             EXPAND="TRUE";;
         o)
             NAMEOUT=${OPTARG#*=}
                    OUT="TRUE";;
        *)
            exit 84;;
           esac
    done
    display
}

shebang() {
    line=$(head -n 1 $FILE)
    chara=$(echo -n $line | wc -c)
    CUT=${line:0:3}

    if [ $chara = "0" ]; then
        sed -i '1d' $FILE
        ex -sc '1i|#!/bin/sh' -cx $FILE
        return 0
    fi
    if [ $CUT = "#!/" ]; then
        if [ $line != "#!/bin/sh" ]; then
            sed -i '1d' $FILE
            sed -i '1i\'"#!/bin/sh" $FILE
            return 0
        fi
    else
        sed -i '1i\'"#!/bin/sh" $FILE
        return 0
    fi
}

comment_header() {
    NBR_LINE=$(wc -l $FILE | awk '{ print $1 }')
    line2=$(sed -n '2p' $FILE)
    comment=$(sed -n '2p' $FILE | cut -c2-)
    CUT2=${line2:0:1}
    if [ $NBR_LINE -gt "0" ]; then
        if [ $CUT2 = "#" ]; then
            sed -i '2d' $FILE
           COMM="TRUE"
        fi
    fi
}

help() {
    echo "Usage: script_formatter.sh in [-h] [-s] [-i nb_char] [-e] [-o out]
     in input file
    -h, --header              header generation
    -s, --spaces              force spaces instead of tabulations for indentation
    -i, --indentation=nb_char number of characters for indentation (8 by default)
    -e, --expand              force do and then keywords on new lines
    -o, --output=out          output file (stdout by default)"
}

main() {
    check=${1:0:1}
    if [ $check = "-" ]; then
        help
        exit 84
    fi
    if [ $# -lt 1 ]; then
        help
        exit 0
    fi
    if [ -e $1 ] && [ -f $1 ]; then
        cat $1 > .script
        FILE=.script
        comment_header
        shebang
        options_script "$@"
        rm .script
        exit 0
     elif [ $1 = "-help" ]; then
            help
     else
        echo "invalid file"
        exit 84
    fi
}

main "$@"