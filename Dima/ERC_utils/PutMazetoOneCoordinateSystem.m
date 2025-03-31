%%% PutMazetoOneCoordinateSystem

Dir = PathForExperimentsERC_Dima('TestPost');
% Dir = RestrictPathForExperiment(Dir,'nMice', [711 712 714 742]);
Dir = RestrictPathForExperiment(Dir,'nMice', 977);

for i = 1:length(Dir.path)
    for k = 1:length(Dir.path{i})
        cd(Dir.path{i}{k});
        load behavResources.mat
%         if ~(exist('AlignedXtsd','var'))
            
            [AlignedXtsd,AlignedYtsd,ZoneEpochAligned,XYOutput] = MorphMazeToSingleShape_EmbReact_DB(Xtsd,Ytsd,...
                Zone{1},ref,Ratio_IMAonREAL);
            
            [CleanAlignedXtsd,CleanAlignedYtsd,CleanZoneEpochAligned,XYOutput] = MorphMazeToSingleShape_EmbReact_DB(Xtsd,Ytsd,...
                Zone{1},ref,Ratio_IMAonREAL);
%         end
        save('behavResources.mat', 'AlignedXtsd', 'AlignedYtsd', 'ZoneEpochAligned', 'XYOutput',...,
            'CleanAlignedXtsd','CleanAlignedYtsd','CleanZoneEpochAligned', '-append');
        
        close all
        clearvars -except Dir i k
    end
end