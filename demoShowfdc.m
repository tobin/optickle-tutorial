opt = optFP;
f = logspace(log10(0.1), log10(7000), 101);
[fDC, sigDC, sigAC] = tickle(opt, [], f);

showfDC(opt, fDC)

showsigDC(opt, sigDC)