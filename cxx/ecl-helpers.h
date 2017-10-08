#ifndef __ECL_HELPERS_H__
#define __ECL_HELPERS_H__
//INTERFACE GENERATED WITH CM-IFS
#include <ecl/ecl.h>
#include <iostream>
#include <fstream>
namespace ecl_helpers
{

	std::string cl_str_to_str(cl_object cl_str);

	void call_lisp(const std::string &call);
}
#endif // __ECL_HELPERS_H__
