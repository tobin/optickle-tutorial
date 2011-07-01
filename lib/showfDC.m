function showfDC(opt, fDC)

vFrf = get(opt, 'vFrf');

% format the link labels
labels = cellfun(...
    @(link) sprintf('%s --> %s', ...
    getSourceName(opt, link), getSinkName(opt, link)), ...
    num2cell(1:opt.Nlink), 'UniformOutput', 0);

% how long is the longest label?
max_label_len = max(cellfun(@length, labels));

% how long do we want them to be?
label_len = max_label_len;

label_fmtstr = sprintf('%% %ds | ', label_len);

% print out the banner of frequency labels
fprintf(label_fmtstr,'');
for jj=1:length(vFrf)
    if vFrf(jj)==0
        fprintf('  DC     ');
    else
        [prefix, val] = metricize(vFrf(jj));
        fprintf('%+3.0f %sHz  ',val, prefix);
    end
end

% print out the "---+--------" line
fprintf('\n%s\n', [ repmat('-', 1, label_len + 1) '+' ...
    repmat('-', 1, 10*length(vFrf))]);

% print out the data for each link
for ii=1:opt.Nlink,
    label = labels{ii};
    % if the label is too long, truncate it
    if length(label) > label_len
        label = label((end-label_len+1):end);
    end
    % print out the link label
    fprintf(label_fmtstr, label);
    % print out the field amplitudes
    for jj=1:length(vFrf),
        amp = abs(fDC(ii,jj))^2;
        [prefix, val] = metricize(amp);
        fprintf('%3.0f %sW   ', val, prefix);
    end
    fprintf('\n');
end
end


function [prefix, val] = metricize(val)

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
