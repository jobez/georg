#include <ecl/ecl.h>
#include <iostream>
#include <fstream>
#include "faust.h"
#include "ecl-helpers.h"
//IMPLEMENTATION GENERATED WITH CM-IFS
#include "ecl-root.h"
namespace ecl_root
{

	void initialize_ecl(int argc, char* argv[])
	{
		cl_boot(argc, argv);
		atexit(cl_shutdown);
		faust::load_ecl_bindings();
		ecl_helpers::call_lisp("(load \"dream.lisp\")");
	}
}