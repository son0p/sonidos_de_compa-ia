188.00 => float root;
SinOsc sines[8];
Pan2 panning[8];
Envelope envelopes[8];
NRev reverbs[8];
1000.0 => float clusterWidth; // slider
for(0 => int i; i < sines.cap(); i++)
{
 sines[i] => envelopes[i] => reverbs[i] => panning[i] => dac;
 .01 => sines[i].gain;
  root => sines[i].freq;
  envelopes[i].keyOn();
  0.1 => reverbs[i].mix;
}
while(true)
{
  Math.random2(0,7) => int selSine;
  Math.random2f(root-clusterWidth,root+clusterWidth) => sines[selSine].freq;
  Math.random2f(-1, 1) => panning[selSine].pan;
  200::ms => now;
}
while(true){10::ms => now;}
