% Construct the enhanced LIGO Optickle model
par = paramL1;
par = paramEligo_00(par);

opt = optEligo(par);
opt = probesEligo_00(opt, par);

% opt2dot !
opt2dot(opt, 'demo.dot');

% Run GraphViz on the file we made
system('dot -Tpdf demo.dot > demo.dot.pdf');
