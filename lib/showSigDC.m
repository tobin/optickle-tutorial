function showSigDC(opt, sigDC)

if length(sigDC) ~= opt.Nprobe,
    error('This opt and sigDC don''t seem to go together');
end

for sn=1:opt.Nprobe,
    fprintf('% 8s:\t%d W\n', getProbeName(opt, sn), sigDC(sn));
end
