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

	cl_object _ECL_INIT_JACK_();

	void str_to_dsp(std::string dsp_str);

	cl_object _ECL_STR_TO_DSP_(cl_object dsp_str);

	void connect_dsp();

	cl_object _ECL_CONNECT_DSP_();

	void play();

	cl_object _ECL_PLAY_();

	void stop();

	cl_object _ECL_STOP_();

	void load_ecl_bindings();
}
#endif // __FAUST_H__
