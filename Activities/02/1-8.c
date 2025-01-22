#include <stdio.h>

    int
main(int argc, char *argv[])
{
    char blank = ' '; //\x20
    char newline = '\n'; //\x0A
    char tab = '\t'; //\x09
    char input;
    int blanks = 0;
    int newlines = 0;
    int tabs = 0;
    // while((input = getchar()) != EOF){
    while((scanf("%c", &input) != EOF)){
        if (input == blank) ++blanks;
        else if (input == tab) ++tabs;
        else if (input == newline) ++newlines;
    }
    printf("Number of tabs:\t\t%d\n", tabs);
    printf("Number of blanks:\t%d\n", blanks);
    printf("Number of newlines:\t%d\n", newlines);
    return 0;
}

