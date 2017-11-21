#ifndef __AUDIO_H__
#define __AUDIO_H__
//INTERFACE GENERATED WITH CM-IFS
#include <faust/audio/jack-dsp.h>

class GeorgAudio
 : public jackaudio_midi
{
public:

	void updateDsp(dsp* new_dsp);
};
#endif // __AUDIO_H__
