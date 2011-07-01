function showfDC(opt, fDC)
% SHOWFDC  Pretty-print the fDC matrix returned by Optickle
%
% Example:
%
% >> opt = optFP;
% >> [fDC, sigDC, sigAC, mMech, noiseAC, noiseMech] = tickle(opt, [], f);
% >> showfDC(opt, fDC)
%                                    | -20 MHz    DC     +20 MHz  
% -----------------------------------+------------------------------
%              Laser->out --> AM<-in |   0  W   100  W     0  W   
%                 AM->out --> PM<-in |   0  W   100  W     0 pW   
%               PM->out --> Mod1<-in |   0  W   100  W     0 pW   
%               Mod1->out --> IX<-bk | 990 mW    98  W   990 mW   
%                  IX->fr --> EX<-fr |  12 mW    12 kW    12 mW   
%                  EX->fr --> IX<-fr |  12 mW    12 kW    12 mW   
%                IX->bk --> REFL<-in | 990 mW    86  W   990 mW   
% TRANS_TELE->out --> TRANS_SMIR<-fr |  12 μW    12  W    12 μW   
%      TRANS_SMIR->fr --> TRANSa<-in |   6 μW     6  W     6 μW   
%      TRANS_SMIR->bk --> TRANSb<-in |   6 μW     6  W     6 μW   
%          EX->bk --> TRANS_TELE<-in |  12 μW    12  W    12 μW   
%   FlashLight->out --> FakeTele<-in |   0  W     0  W     1 pW   
%           FakeTele->out --> EX<-bk |   0  W     0  W     1 pW  
%
% Note that the field amplitudes are ignored; the values shown are the
% modulus squared of the field amplitudes.

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
