function opt2dot(opt, filename)
% Produce a GraphViz .dot file from an Optickle model.

% The .dot format is documented here:
% http://www.graphviz.org/Documentation/dotguide.pdf

if nargin < 2
    fid = 1;
else
    fid = fopen(filename, 'w');
end

fprintf(fid, 'digraph G {\n');
% output the optics (graph nodes)
for snOptic=1:opt.Noptic,
    optic = opt.optic{snOptic};
    fprintf(fid, '    %s', optic.name);
    switch class(optic)
        case 'Sink',
            fprintf(fid, ' [shape=box]');
    end
    fprintf(fid, ';\n');
end
% output the links (graph edges)
for snLink=1:opt.Nlink,
    [src_name, src_sn, src_port] = getSourceName(opt, snLink);
    [snk_name, snk_sn, snk_port] = getSinkName(opt, snLink);
    fprintf(fid, '     %s -> %s [label="%s>%s"];\n', ...
        getOpticName(opt, src_sn), getOpticName(opt, snk_sn), ...
        opt.optic{src_sn}.outNames{src_port}{1}, ...
        opt.optic{snk_sn}.inNames{snk_port}{1});
end
fprintf(fid, '}\n');

if fid ~= 1
    fclose(fid);
end
end
