%% Michelson example
% This example builds a simple Michelson interferometer and then uses
% sweepLinear to show the Michelson fringes as one of the optics is swept
% through a few wavelengths' displacement.

% create a model 

vFrf = 0;
opt = Optickle(vFrf);

% laser power
Pin = 10;

opt = addSource(opt, 'laser', sqrt(Pin));

opt = addBeamSplitter(opt, 'BS', 45, 0, 0.5);
opt = addMirror(opt, 'EX', 0, 0);
opt = addMirror(opt, 'EY', 0, 0);
opt = addSink(opt, 'AS');
opt = addSink(opt, 'REFL');


Lx = 1.0;
Ly = 5.0;

% Add links


opt = addLink(opt, 'laser', 'out', 'BS', 'frA', 1.0);

opt = addLink(opt, 'BS',  'frA', 'EY',   'fr',  Ly);
opt = addLink(opt, 'EY',  'fr',  'BS',   'frB', Ly);

opt = addLink(opt, 'BS',  'frB', 'REFL', 'in',  0);

opt = addLink(opt, 'BS',  'bkA', 'EX',   'fr',  Lx);
opt = addLink(opt, 'EX',  'fr',  'BS',   'bkB', Lx);

opt = addLink(opt, 'BS',  'bkB', 'AS',   'in',  0);

opt = addProbeIn(opt, 'REFL_DC', 'REFL', 'in', 0, 0);
opt = addProbeIn(opt, 'AS_DC',   'AS',   'in', 0, 0);

%% sweepLinear
pos = zeros(opt.Ndrive, 1);
nEXdrive = getDriveNum(opt, 'EX');
pos(nEXdrive) = opt.lambda/2;
Npos = 101;
[pos, sigDC] = sweepLinear(opt, pos, -pos, Npos);

nREFLprobe = getProbeNum(opt, 'REFL_DC');
nASprobe = getProbeNum(opt, 'AS_DC');

plot(pos(nEXdrive,:)/opt.lambda, sigDC(nASprobe, :), ...
     pos(nEXdrive,:)/opt.lambda, sigDC(nREFLprobe, :));
legend('AS DC', 'REFL DC');
xlabel('EX mirror displacement (wavelengths)');
ylabel('Power [Watts]');
title('Michelson fringes');