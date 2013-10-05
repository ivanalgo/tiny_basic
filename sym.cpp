#include <map>
#include <string>
#include <iostream>

#include "sym.hpp"

using namespace std;

map<string, unsigned int> symtab;

void set_var_value(const string &name, unsigned int value)
{
	symtab[name] = value;
}

int get_var_value(const string &name, unsigned int *ret)
{
	*ret = symtab[name];

	return 0;
}

unsigned int *get_var_address(const string &name)
{
	return &symtab[name];	
}
