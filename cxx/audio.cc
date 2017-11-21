//IMPLEMENTATION GENERATED WITH CM-IFS
#include "audio.h"

void GeorgAudio::updateDsp(dsp* new_dsp)
{
	for(int i = 0; i < new_dsp->getNumInputs(); i = i + 1) {
		char buf[256];
		snprintf(buf, 256, "in_%d", i);
		jack_port_unregister(fClient, fInputPorts[i]);
		fInputPorts[i] = jack_port_register(fClient, buf, JACK_DEFAULT_AUDIO_TYPE, JackPortIsInput, 0);
	}
	for(int i = 0; i < new_dsp->getNumOutputs(); i = i + 1) {
		char buf[256];
		snprintf(buf, 256, "out_%d", i);
		jack_port_unregister(fClient, fOutputPorts[i]);
		fOutputPorts[i] = jack_port_register(fClient, buf, JACK_DEFAULT_AUDIO_TYPE, JackPortIsOutput, 0);
	}
	delete fDSP;
	fDSP = new_dsp;
	fDSP->init(jack_get_sample_rate(fClient));
}