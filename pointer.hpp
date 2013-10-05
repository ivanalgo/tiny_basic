#ifndef _POINTER_H
#define _POINTER_H

template<class T>
class pointer {
public:
	pointer() {
		new_one();
	}

	pointer(T *obj) {
		new_one(obj);
	}

	pointer(const pointer<T> &p) {
		assign(p);
	}

	pointer<T> & operator=(pointer<T> p) {
		deref();
		return assign(p);
	}

	T * operator->() {
		return _obj;
	}

	~pointer() {
		deref();
	}

private:
	T *_obj;
	unsigned int *_ref;

private:
	void new_one(T *obj = NULL) {
		_obj = obj;
		_ref = new unsigned int(1); 
	}

	void deref() {
		if (--(*_ref) == 0) {
			if (_obj) delete _obj;
			delete _ref;
		}

		_obj = NULL;
		_ref = NULL;
	}

	pointer<T> & assign(const pointer<T> &p) {

		_obj = p._obj;
		_ref = p._ref;

		(*_ref)++;

		return *this;
	}
};

#endif
