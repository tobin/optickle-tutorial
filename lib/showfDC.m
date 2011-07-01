function showfDC(opt, fDC)

vFrf = get(opt, 'vFrf');

fprintf('% 30s | ','');
for jj=1:length(vFrf)
    if vFrf(jj)==0
        fprintf('  DC     ');
    else
        [prefix, val] = metricize(vFrf(jj));
        fprintf('%+3.0f %sHz  ',val, prefix);
    end
end
fprintf('\n%s\n', [ repmat('-', 1, 31) '+' repmat('-', 1, 10*length(vFrf))]);

for ii=1:opt.Nlink,
    label = sprintf('%s --> %s', ...
        getSourceName(opt, ii), getSinkName(opt, ii));
    if length(label) > 29
        label = label((end-29):end);
    end
    fprintf('% 30s | ', label);
    for jj=1:length(vFrf),
        amp = abs(fDC(ii,jj))^2;
        [prefix, val] = metricize(amp);
        fprintf('%3.0f %sW   ', val, prefix);
    end
    fprintf('\n');
    
end

end


function [prefix, val] = metricize(val)

% check for non-positive frequencies
if val < 0
    lf = log10(-val);
else
    lf = log10(val);
end

if lf > 9
    prefix = 'G';
    val = val / 1e9;
elseif lf > 6
    prefix = 'M';
    val = val / 1e6;
elseif lf > 3
    prefix = 'k';
    val = val / 1000;
elseif (lf > 0) || (lf == -inf)
    prefix = ' ';
elseif lf > -3
    prefix = 'm';
    val = val * 1000;
elseif lf > -6
    prefix = 'μ';
    val = val * 1e6;
elseif lf > -9
    prefix = 'n';
    val = val * 1e9;
else
    prefix = 'p';
    val = val * 1e12;
end
end
