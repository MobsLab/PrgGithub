function data = LoadData(datasets,matFile,var)

data = [];

for ii=1:length(datasets)

    fbasename = datasets{ii};
    fname = [fbasename filesep];
    analysisDir = [fname 'Analysis'];
    resFile = [analysisDir filesep matFile];
    load(resFile,var);
    eval(['t = ' var ';']);
    data = [data;t];
    
end

