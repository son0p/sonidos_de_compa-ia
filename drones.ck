[330.00, 180, 443, 90, 150, 170] @=> float roots[];
roots[Math.random2(0, roots.cap()-1)] => float root;
SinOsc sines[8];
Pan2 panning[8];
Envelope envelopes[8];
NRev reverbs[8];
100.0 => float clusterWidth; // slider
for(0 => int i; i < sines.cap(); i++)
{
 sines[i] => envelopes[i] => reverbs[i] => panning[i] => dac;
 envelopes[i].keyOn();
 .01 => sines[i].gain;
  root => sines[i].freq;
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
