#include <faust/dsp/dsp.h>
#include <faust/dsp/llvm-dsp.h>
#include <faust/audio/jack-dsp.h>
#include <ecl/ecl.h>
#include "ecl-helpers.h"
#ifndef __FAUST_H__
#define __FAUST_H__
//INTERFACE GENERATED WITH CM-IFS
namespace faust
{
	extern jackaudio audio;
	extern llvm_dsp_factory* dsp_factory;
	extern dsp* DSP;

	void init_jack();

	cl_object ECL_INIT_JACK();

	void str_to_dsp(std::string dsp_str);

	cl_object ECL_STR_TO_DSP(cl_object dsp_str);

	void connect_dsp();

	cl_object ECL_CONNECT_DSP();

	void play();

	cl_object ECL_PLAY();

	void stop();

	cl_object ECL_STOP();

	void load_ecl_bindings();
}
#endif // __FAUST_H__
