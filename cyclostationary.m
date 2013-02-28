%% Cyclostationary shot noise
%
% This script demonstrates an effect of cyclostationary shot noise.  The
% two RF sidebands at +/- fmod interfere to create a power modulation at
% 2fmod with perfect fringe contrast.  When we demodulate this signal at
% fmod, we find that the I quadrature is noisier than the Q quadrature.
%
% Reference: Niebauer, http://link.aps.org/doi/10.1103/PhysRevA.43.5022
% page 5022
%
% Tobin Fricke 2011-08-23

fmod = 10e6;
vFrf = [-2 -1 0 1 2] * fmod;
opt = Optickle(vFrf);

opt = addSource(opt, 'laser', [0 1 0 1 0]);

opt = addSink(opt, 'sink');

opt = addLink(opt, 'laser', 'out', 'sink', 'in', 0);

opt = addProbeIn(opt, 'I', 'sink', 'in', fmod, 0);
opt = addProbeIn(opt, 'Q', 'sink', 'in', fmod, 90);
opt = addProbeIn(opt, 'DC', 'sink', 'in', 0, 0);


f = linspace(0, 1000, 101);

[fDC, sigDC, sigAC, mMech, noiseAC, noiseMech] = tickle(opt, [], f);

nIprobe = getProbeNum(opt, 'I');
nQprobe = getProbeNum(opt, 'Q');
nDCprobe = getProbeNum(opt, 'DC');

plot(f, noiseAC(nDCprobe,:), ...
     f, noiseAC(nIprobe,:), ...
     f, noiseAC(nQprobe,:));
 
P = sigDC(nDCprobe);
expected_shot_noise = sqrt(2 * opt.h * (opt.c/opt.lambda) * P)
hold all
plot(f,  expected_shot_noise * ones(size(f)), 'o', ...
     f,  sqrt(1/4) * expected_shot_noise * ones(size(f)), 'o', ...
     f,  sqrt(3/4) * expected_shot_noise * ones(size(f)), 'o');
hold off
legend('DC', 'I', 'Q');
ylabel('W / rtHz');
xlabel('Hz');