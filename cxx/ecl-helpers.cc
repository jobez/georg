//IMPLEMENTATION GENERATED WITH CM-IFS
#include "ecl-helpers.h"
namespace ecl_helpers
{

	std::string cl_str_to_str(cl_object cl_str)
	{
		int j = cl_str->string.dim;
		ecl_character* selv = cl_str->string.self;
		std::string str { "" };
		for(int i = 0; i < j; i = i + 1) {
			str += (*(selv+i));
		}
		return str;
	}

	void call_lisp(const std::string &call)
	{
		cl_eval(c_string_to_object(call.c_str()));
	}
}