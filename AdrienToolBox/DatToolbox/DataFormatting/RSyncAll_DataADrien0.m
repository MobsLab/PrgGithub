function RSyncAll(datasets,animal)

% USAGE:
%     RSyncAll(datasets,animal)

for ii=1:length(datasets)
    eval(['!rsync -xPrlt --chmod=g+X,Dg+s,o-rwx -p ' datasets{ii} ' /DataAdrien0/RecordingData/' animal '/'])
end