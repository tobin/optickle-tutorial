function opt2dot(opt, filename)
% Produce a GraphViz .dot file from an Optickle model.

% The .dot format is documented here:
% http://www.graphviz.org/Documentation/dotguide.pdf

isPDF = 0;

if nargin < 2
    fid = 1;
else
    if strcmpi(filename(end-3:end),'.pdf')
        isPDF = 1;
        pdffilename = filename;
        filename = [filename(1:end-4),'.dot'];
    end
    fid = fopen(filename, 'w');
end

% suppress optickle's warnings, if optickle set a warning id, 
% we wouldn't need to set all off
warning('off','all');

fprintf(fid, 'digraph G {\n');
% output the optics (graph nodes)
for snOptic=1:opt.Noptic,
    optic = opt.optic{snOptic};
    fprintf(fid, '    "%s"', optic.name);
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
    fprintf(fid, '     "%s" -> "%s" [label="%s&rarr;%s"];\n', ...
        getOpticName(opt, src_sn), getOpticName(opt, snk_sn), ...
        opt.optic{src_sn}.outNames{src_port}{1}, ...
        opt.optic{snk_sn}.inNames{snk_port}{1});
end
% To-do: Draw the probes
fprintf(fid, '}\n');

% now turn warnings back on
warning('on','all');

if fid ~= 1
    fclose(fid);
end

if isPDF
    system(['dot -Tpdf ',filename,' > ',pdffilename]);
end

end
