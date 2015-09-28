//Inspired in glissons of mitch.kaufman@

// Instantiate classes
ModesClass modesClass;

// notes
46 => int root;
// Seleccione un modo entre 1 y 16
modesClass.mode(16) @=> int notes[];

// ---- Cadenas de audio ----
// Tono dron alto
Step n => Envelope f => SinOsc c => NRev r1 => dac;
// Tono dron medio
Envelope e => blackhole;
100 => e.value;
SinOsc s => PRCRev r2 => dac;
n.next(1); // you need to put something in the envelope to have a value at the output
// Tono dron bajo (Nota raiz en un pedal de bajo con desplazamiento de fase)
SinOsc sawL => dac.left;
SinOsc sawR => Delay delayR => dac.right;
// Ruido blanco de fondo
Noise noiseL => HPF filterL => Pan2 noisePanL => NRev noiseRevL  => dac.left;
Noise noiseR => HPF filterR => Pan2 noisePanR => NRev noiseRevR =>  dac.right;
// Ticks --
// impulse to filter to dac
Impulse i => BiQuad g => Pan2 p => dac;
// set the filter's pole radius
.99 => g.prad;
// set equal gain zeros
1 => g.eqzs;
// set filter gain
.03 => g.gain;

// ---- Iniciar valores ----
Std.mtof(root-12) => sawL.freq;
Std.mtof(root-12) => sawR.freq;
sawL.gain(0.08);
sawR.gain(0.08);
delayR.max(100::ms);
c.gain(0.03);
f.value(100);
f.target(1000);
f.duration(0.25::second);
r1.mix(0.05);
noiseL.gain(0.005);
noiseR.gain(0.05);
noiseRevL.mix(0.1);
noiseRevR.mix(0.1);
filterL.Q(0.5);
filterR.Q(0.5);
filterL.freq(1000);
filterR.freq(1000);
r2.mix(0.3);
0.02 => s.gain;
100::ms => e.duration;

// ----- Funciones ----
fun void gliss(dur updateRate)
{
  while (1)
  {
    e.value() => s.freq;
    f.value() => c.freq;
    updateRate => now;
  }
}
fun void tick()
{
  while (true)
  {
    // set the current sample/impulse
    1.0 => i.next;
    // set filter resonant frequency
    Math.random2f( 250, 5000 ) => g.pfreq;
    // pan
    Math.random2f( -1, 1 ) => p.pan;
    Math.random2f( 0, 0.5 )::second => now;
  }
}
fun void tick2()
{
  while (true)
  {
    // set the current sample/impulse
    1.0 => i.next;
    // set filter resonant frequency
    Math.random2f( 100, 800 ) => g.pfreq;
    // pan
    Math.random2f( -1, 1 ) => p.pan;
    Math.random2f( 0, 3 )::second => now;
  }
}
fun void noisePlay(){
    while(true){
        Math.sin( now/16::second*2*3.14 ) => noisePanL.pan;
        Math.sin( now/16::second*2*3.14 ) => noisePanR.pan;
        (Std.fabs( Math.sin( now/16::second*2*3.14 )))::ms*8 => delayR.delay;
        Std.fabs( Math.sin(now/32::second*2*3.14 )) * 1000 => filterL.freq;
        Std.fabs( Math.sin(now/32::second*2*3.14 )) * 2000 => filterR.freq;
        Math.sin( now/2::second*0.02*3.1416 )/64 => noiseL.gain;
        Math.sin( now/2::second*0.02*3.1416 )/64 => noiseR.gain;
        0.005::second => now;
    }
}
fun void variationGains()
{
  while(true)
  {
    Math.sin( now/2::second*0.2*3.1416 )/32 => s.gain;
    Math.cos( now/2::second*0.02*3.1416 )/64 => c.gain;
    0.005::second => now;
  }
}

// --- Ejecución de funciones infinitas
spork ~gliss (100::samp);
spork ~tick();
spork ~tick2();
spork ~noisePlay();
spork ~variationGains();
while (1)
{
  Std.mtof(root + notes[Math.random2(0,notes.cap()-1)]) => e.target;
  Std.mtof(root + 24 + notes[Math.random2(0,notes.cap()-1)]) => f.target;
   2::second => now;
}
