#ifndef _SYNTAX_H
#define _SYNTAX_H

#include <exception>
#include <string>
#include <iostream>

#include "pointer.hpp"
#include "sym.hpp"

using namespace std;

class syntax_node {
public:
	virtual unsigned int eval() { throw exception(); }
	virtual unsigned int *leval() { throw exception(); }
	virtual void exec() { throw exception(); }
	virtual ~syntax_node() {}
};

class var_node: public syntax_node {
public:
	var_node(string name): _name(name) {}

	unsigned int eval() {
		unsigned int val;
		get_var_value(_name, &val);

		return val;
	}

	unsigned int *leval() {
		return get_var_address(_name);		
	}

private:
	string _name;
};

class imm_node: public syntax_node {
public:
	imm_node(unsigned int value): _value(value) {}

	unsigned int eval() {
		return _value;
	}

private:
	unsigned int _value;
};

class arith_expr_node: public syntax_node {
public:
	arith_expr_node(pointer<syntax_node> left, char op, pointer<syntax_node> right):
		_left(left), _op(op), _right(right) {}

	unsigned int eval() {
		unsigned int lval = _left->eval();
		unsigned int rval = _right->eval();

		switch(_op) {
		  case '+':
			return lval + rval;
			break;
		  case '-':
			return lval - rval;
		}
	}
	
private:
	pointer<syntax_node> _left;
	char _op;
	pointer<syntax_node> _right;
};

class logic_expr_node: public syntax_node {
public:
	typedef enum { logic_equal, logic_nequal } logic_t;

public:
	logic_expr_node(pointer<syntax_node> left, logic_t op, pointer<syntax_node> right):
		_left(left), _op(op), _right(right) {}

	unsigned int eval() {
		unsigned int lval = _left->eval();
		unsigned int rval = _right->eval();

		switch(_op) {
		  case logic_equal:
		  	return lval == rval;
			break;

		  case logic_nequal:
			return lval != rval;
			break;
		}
	}	

private:
	pointer<syntax_node> _left;
	logic_t _op;
	pointer<syntax_node> _right;
};

class assign_node: public syntax_node {
public:
	assign_node(pointer<syntax_node> var, pointer<syntax_node> expr):
		_var(var), _expr(expr) {}

	void exec() {
		*_var->leval() = _expr->eval();
	}

private:
	pointer<syntax_node> _var;
	pointer<syntax_node> _expr;
};

class if_else_node: public syntax_node {
public:
	if_else_node(pointer<syntax_node> cond, pointer<syntax_node> tstat, 
		pointer<syntax_node> fstat = pointer<syntax_node>(new dummy_node())):
		_cond(cond), _tstat(tstat), _fstat(fstat) {}

	void exec() {
		if (_cond->eval()) {
			_tstat->exec();
		} else {
			_fstat->exec();
		}
	}

private:
	pointer<syntax_node> _cond;
	pointer<syntax_node> _tstat;
	pointer<syntax_node> _fstat;

private:
	class dummy_node: public syntax_node {
		void exec() {}
	};
};

class print_node: public syntax_node {
public:
	print_node(pointer<syntax_node> var): _var(var) {}
	void exec() {
		cout << _var->eval() << endl;
	}

private:
	pointer<syntax_node> _var;
};

class while_node: public syntax_node {
public:
	while_node(pointer<syntax_node> cond, pointer<syntax_node> assign):
		_cond(cond), _assign(assign) {}

	void exec() {
		while(_cond->eval()) {
			_assign->exec();
		}
	}

private:
	pointer<syntax_node> _cond;
	pointer<syntax_node> _assign;
};

#endif
