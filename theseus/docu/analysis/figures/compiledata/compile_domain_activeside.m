
bns = 51;
ll = 32;
rl = 47;

allt = [];
allp = [];
allg = [];
allf = [];
alle = [];
allc = [];
allfe = [];
allfc = [];
alla = [];
allw = [];
alln = {};





bp = '/Users/wmcfadden/activ_domain_ed/';
cd(bp);
files = dir;
files = {files.name};

for f = files
    if(strfind(f{1},'_scr') )
        code = strsplit(f{1},'_');
        if(exist([code{1} '_out.txt'],'file'))
            code = code{1}
            measure6
        end
    end
end

if(size(allt)>0)
    save('allmeas_activeside','allt','allp','allg','alla','allf','alle','allc','alln')
end