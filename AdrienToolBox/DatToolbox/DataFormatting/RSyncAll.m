function RSyncAll(datasets,animal)

% USAGE:
%     RSyncAll(datasets,animal)

for ii=1:length(datasets)
    eval(['!rsync -xPrlt --chmod=g+X,Dg+s,o-rwx -p ' datasets{ii} ' peyraa01@fen.nyumc.org:/ifs/data/neuroscience/AdrienData/RecordingData/' animal '/'])
end