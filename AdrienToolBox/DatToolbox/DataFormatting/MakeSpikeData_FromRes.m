function MakeSpikeData_FromRes(shanks)

% MakeSpikeData_FromRes
% 
% construct a tsdArray of spike timing and save it in Analysis/SpiekData.mat
% Adrien Peyrache, 2011

fbasename = extractfbasename(pwd);

%muaFile = [analysisDir filesep 'MUAData.mat'];

[S,shank,cellIx ] = LoadSpikeData(fbasename,shanks);

fprintf('      Number of Cells: %d\n',length(S))
SaveAnalysis(pwd,'SpikeData.mat',{S,shank,cellIx},{'S','shank','cellIx'});
%save(muaFile,'MUA');