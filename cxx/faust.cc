#include <faust/dsp/dsp.h>
#include <faust/dsp/llvm-dsp.h>
#include <faust/audio/jack-dsp.h>
#include <ecl/ecl.h>
#include "ecl-helpers.h"
//IMPLEMENTATION GENERATED WITH CM-IFS
#include "faust.h"
namespace faust
{
	jackaudio audio;
	llvm_dsp_factory* dsp_factory;
	dsp* DSP;

	void init_jack()
	{
		audio.init("booboo");
	}

	cl_object _ECL_INIT_JACK_()
	{
		init_jack();
		return ecl_make_integer(0);
	}

	void str_to_dsp(std::string dsp_str)
	{
		std::string error_msg;
		dsp_factory = createDSPFactoryFromString("titi", dsp_str, 0, 0, "", error_msg);
		std::cerr << error_msg << std::endl;
		std::cerr << dsp_str << std::endl;
		DSP = dsp_factory->createDSPInstance();
	}

	cl_object _ECL_STR_TO_DSP_(cl_object dsp_str)
	{
		str_to_dsp(ecl_helpers::cl_str_to_str(dsp_str));
		return ecl_make_integer(0);
	}

	void connect_dsp()
	{
		audio.setDsp(DSP);
	}

	cl_object _ECL_CONNECT_DSP_()
	{
		connect_dsp();
		return ecl_make_integer(0);
	}

	void play()
	{
		audio.start();
	}

	cl_object _ECL_PLAY_()
	{
		play();
		return ecl_make_integer(0);
	}

	void stop()
	{
		audio.stop();
	}

	cl_object _ECL_STOP_()
	{
		stop();
		return ecl_make_integer(0);
	}

	void load_ecl_bindings()
	{
		cl_def_c_function(c_string_to_object("|ecl-stop|"), ((cl_objectfn_fixed)_ECL_STOP_), 0);
		cl_def_c_function(c_string_to_object("|ecl-play|"), ((cl_objectfn_fixed)_ECL_PLAY_), 0);
		cl_def_c_function(c_string_to_object("|ecl-connect-dsp|"), ((cl_objectfn_fixed)_ECL_CONNECT_DSP_), 0);
		cl_def_c_function(c_string_to_object("|ecl-str-to-dsp|"), ((cl_objectfn_fixed)_ECL_STR_TO_DSP_), 1);
		cl_def_c_function(c_string_to_object("|ecl-init-jack|"), ((cl_objectfn_fixed)_ECL_INIT_JACK_), 0);
	}
}
