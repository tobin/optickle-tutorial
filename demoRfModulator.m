%% RfModulator demo
% This demo includes just a laser, an RF modulator, and three probes (DC,
% I, and Q).  The purpose is to show the difference between fDC and sigDC.

%% Parameters
fmod  = 10e6;             % RF sideband frequency [Hz]
gamma = 0.34;             % Modulation depth [radians]
Pin = 10;                 % laser power [Watts]

%% Set up and run the Optickle model
vFrf = [-fmod 0 fmod];

opt = Optickle(vFrf);

opt = addSource(opt, 'Laser', [0 sqrt(Pin) 0]);
opt = addRfModulator(opt, 'RfMod', fmod, 1i*gamma);
opt = addSink(opt, 'Sink');

opt = addLink(opt, 'Laser', 'out', 'RfMod', 'in', 0);
opt = addLink(opt, 'RfMod', 'out', 'Sink', 'in',  0);

opt = addProbeIn(opt, 'DC', 'Sink', 'in', 0,    0);
opt = addProbeIn(opt, 'I',  'Sink', 'in', fmod, 0);
opt = addProbeIn(opt, 'Q',  'Sink', 'in', fmod, 90);

[fDC, sigDC] = tickle(opt);

%% Look at sigDC

sigDC

%%
% There is one row for each of the probes.  The DC probe sees 10 W (I'm not
% sure why it's not more exact), and the I and Q probes see nothing, since
% the RfModulator is producing phase modulation.
%
% Here's what the pretty-printer produces:

showsigDC(opt, sigDC);
 
%% Look at fDC

fDC

%%
% There is one row for each link, and there is one column for each RF field
% (-10 MHz, DC, +10 MHz).  The first row is the link between the laser and
% the modulator; the second is from the modulator to the sink. Because fDC
% sees the field amplitudes, these are complex numbers and have phase.  We
% see that the upper and lower sidebands have a phase of 90 degrees
% relative to the carrier--since they are phase modulation, and all the
% links in the model have length zero.
%
% Here's what the pretty-printer shows:

showfDC(opt, fDC);

%%
% The pretty-printer throws away the phase information and computes the
% modulus squared in "Watts".