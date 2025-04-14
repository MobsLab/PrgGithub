cd /Da  cdcdcdcdcdcdfunction NyuFenKlustakwikBatch(fbasename,jobname,shank,varargin)
% function run_batch_script(jobName, owner, matlab_command)
% creates and submits to Nyu Fen a simple batch script with a matlab
% command.

if ~isempty(varargin)
    if length(varargin)>1
        error('Too many arguments !')
    end
    timeFet = varargin{1};
    if timeFet~=1 && timeFet~=0
        error('timeFet argument should be logical ! see help for details')
    end
else
    timeFet = 0;
end

OwnerEmail = 'adrien.peyrache@gmail.com';
syst = LoadXml(fbasename);
shank = shank(:)';

for ii=shank
    
    features = repmat('1',[1 3*length(syst.ElecGp{ii})]);
    if timeFet
        features = [features '00001'];
    else
        features = [features '00000'];
    end
    fname = fullfile('./', sprintf('%s.sh',[fbasename '-' num2str(shank(ii)) '.bash']));
    fid = fopen(fname,'w');
    if fid==-1,
       error('Could not open file %s for writing.',fname);
    end

    fprintf(fid, sprintf('###################### genreic_klustakwik.bash ################################\n'));
    fprintf(fid, sprintf('#!/bin/bash\n\n'));
    fprintf(fid, sprintf('#$ -M %s\n',OwnerEmail));
    fprintf(fid, sprintf('#$ -cwd\n'));
    fprintf(fid, sprintf('#$ -V\n'));
    fprintf(fid, sprintf('#$ -N %s-%d\n',jobname,ii));
    fprintf(fid, sprintf('#$ -S /bin/bash\n\n'));
    fprintf(fid, sprintf('~/KlustaKwik/KlustaKwik %s %d -MinClusters 15 -MaxClusters 40 -UseFeatures %s\n',fbasename,ii,features));
    fprintf(fid, sprintf('###########################################################################\n'));

    fclose(fid);

    % run external command
    system(sprintf('qsub %s;',fname));
    
end