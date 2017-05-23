#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <vector>
#include <queue>
#include <unistd.h>
#include <map>
#include <execinfo.h>
#include "log.h"
#include <vector>
using namespace std;

/*
 * 段错误
 */
void dump(int signo)
{
    void *array[10];
    size_t size;
    char **strings;
    size_t i;

    size = backtrace (array, 10);
    strings = backtrace_symbols (array, size);

    printf("Obtained %zd stack frames.\n", size);

    for (i = 0; i < size; i++)
        printf("%s\n", strings[i]);

    free (strings);

    exit(0);
}

void vector_swap()
{
    static vector<string> string_vector;
    for(int i = 0; i < 100; i++)
        string_vector.push_back("1234656789");

    string_vector.clear();
    vector<string>().swap(string_vector);
}