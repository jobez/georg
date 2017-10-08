//IMPLEMENTATION GENERATED WITH CM-IFS
#include "ecl-root.h"
#include "faust.h"
#include "ecl-helpers.h"
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