import math, wave, array
rate=44100
samples=array.array('h')
for i in range(rate*15):
    t=i/rate
    chord=[(130.81,164.81,196),(110,130.81,164.81),(87.31,130.81,174.61),(98,146.83,196)][min(int(t/4),3)]
    fade=min(t/1,1)*min((15-t)/1.1,1)
    pad=sum(math.sin(2*math.pi*f*t)*.045+math.sin(2*math.pi*f*2*t)*.018 for f in chord)
    phase=t%.5
    kick=math.sin(2*math.pi*(48*phase+35*.03*(1-math.exp(-phase/.03))))*math.exp(-phase*18)*.19
    note=[523.25,659.25,783.99,987.77][int(t*4)%4]
    arp=math.sin(2*math.pi*note*t)*math.exp(-(t%.25)*17)*.035
    hit=sum(math.sin(2*math.pi*(400+1400*(t-c))*t)*math.exp(-max(t-c,0)*13)*.035 if 0<t-c<.4 else 0 for c in [4,8,12])
    value=max(-.95,min(.95,(pad+kick+arp+hit)*fade))
    samples.append(int(value*32767))
with wave.open('work/launch-film/score.wav','wb') as out:
    out.setnchannels(1);out.setsampwidth(2);out.setframerate(rate);out.writeframes(samples.tobytes())
print('Original electronic score: 15 seconds')
