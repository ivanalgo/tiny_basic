#ifndef _SYM_H
#define _SYM_H

#include <string>
using namespace std;

void set_var_value(const string &name, unsigned int value);
int get_var_value(const string &name, unsigned int *ret);
unsigned int *get_var_address(const string &name);

#endif

