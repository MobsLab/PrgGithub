%% Load data
% mice = [797 798 828 861 882 905 906 911 912 977 994 1117 1124 1161 1162 1168 1182 1186 1199];
% Dir = PathForExperimentsERC_Dima('UMazePAG');
% Dir = RestrictPathForExperiment(Dir, 'nMice', mice);

mice = 1183;
Dir = PathForExperimentsERC('Novel');
Dir = RestrictPathForExperiment(Dir, 'nMice', mice);

for imouse = 1:length(Dir.path)
    
    cd(Dir.path{imouse}{1});
    load('behavResources.mat');
    mkdir('Old');
    movefile('behavResources.mat', [pwd '/Old']);
    
    %% Create info
    Info.Align = true;
    Info.Clean = true;
    
    %% Create a backup old variables
    Old.Xtsd = Xtsd;
    Old.Ytsd = Ytsd;
    Old.Vtsd = Vtsd;
    Old.CleanXtsd = CleanXtsd;
    Old.CleanYtsd = CleanYtsd;
    Old.CleanVtsd = CleanVtsd;
    Old.PosMat = PosMat;
    Old.CleanPosMat = CleanPosMat;
    Old.CleanPosMatInit = CleanPosMatInit;
    Old.AlignedXtsd = AlignedXtsd;
    Old.AlignedYtsd = AlignedYtsd;
    Old.CleanAlignedXtsd = CleanAlignedXtsd;
    Old.CleanAlignedYtsd = CleanAlignedYtsd;
    Old.CleanZoneEpoch = CleanZoneEpoch;
    Old.CleanZoneEpochAligned = CleanZoneEpochAligned;
    Old.CleanZoneIndices = CleanZoneIndices;
    Old.ZoneEpoch = ZoneEpoch;
    Old.ZoneEpochAligned = ZoneEpochAligned;
    Old.ZoneIndices = ZoneIndices;
    
    Old.LinearDist = LinearDist;
    Old.CleanLinearDist = CleanLinearDist;
    
    Old.behavResources = behavResources;
    
    %% Remove all unneccessary vars
    clear Xtsd Ytsd Vtsd CleanXtsd CleanYtsd CleanVtsd PosMat CleanPosMat CleanPosMatInit
    clear AlignedXtsd AlignedYtsd CleanAlignedXtsd CleanAlignedYtsd CleanZoneEpoch
    clear CleanZoneEpochAligned ZoneEpoch ZoneEpochAligned ZoneIndices
    clear LinearDist CleanLinearDist CleanZoneIndices
    clear behavResources
    
    %% Substitute stand-alone variables
    Xtsd = Old.CleanXtsd;
    Ytsd = Old.CleanYtsd;
    AlignedXtsd = Old.CleanAlignedXtsd;
    AlignedYtsd = Old.CleanAlignedYtsd;
%     AlignedXtsd = Old.AlignedXtsd; % for Sam
%     AlignedYtsd = Old.AlignedYtsd;  % for Sam
    Vtsd = Old.CleanVtsd;
    
    PosMat = Old.CleanPosMat;
    ZoneIndices = Old.CleanZoneIndices;
    ZoneEpoch = Old.CleanZoneEpoch;
    LinearDist = Old.CleanLinearDist;
    
    %% behavResources
    behavResources = struct('SessionName', {Old.behavResources.SessionName});
    for ifield = 1:length(behavResources)
        behavResources(ifield).ref = Old.behavResources(ifield).ref;
        behavResources(ifield).mask = Old.behavResources(ifield).mask;
        behavResources(ifield).Ratio_IMAonREAL = Old.behavResources(ifield).Ratio_IMAonREAL;
        behavResources(ifield).BW_threshold = Old.behavResources(ifield).BW_threshold;
        behavResources(ifield).smaller_object_size = Old.behavResources(ifield).smaller_object_size;
        behavResources(ifield).sm_fact = Old.behavResources(ifield).sm_fact;
        behavResources(ifield).strsz = Old.behavResources(ifield).strsz;
        behavResources(ifield).SrdZone = Old.behavResources(ifield).SrdZone;
        behavResources(ifield).th_immob = Old.behavResources(ifield).th_immob;
        behavResources(ifield).thtps_immob = Old.behavResources(ifield).thtps_immob;
        behavResources(ifield).frame_limits = Old.behavResources(ifield).frame_limits;
        behavResources(ifield).Zone = Old.behavResources(ifield).Zone;
        behavResources(ifield).ZoneLabels = Old.behavResources(ifield).ZoneLabels;
        behavResources(ifield).delStim = Old.behavResources(ifield).delStim;
        behavResources(ifield).delStimreturn = Old.behavResources(ifield).delStimreturn;
        behavResources(ifield).DiodMask = Old.behavResources(ifield).DiodMask;
        behavResources(ifield).DiodThresh = Old.behavResources(ifield).DiodThresh;
        
        behavResources(ifield).PosMat = Old.behavResources(ifield).CleanPosMat;
        behavResources(ifield).PosMatInit = Old.behavResources(ifield).PosMatInit;
        behavResources(ifield).im_diff = Old.behavResources(ifield).im_diff;
        behavResources(ifield).im_diffInit = Old.behavResources(ifield).im_diffInit;
        behavResources(ifield).Imdifftsd = Old.behavResources(ifield).Imdifftsd;
        behavResources(ifield).Xtsd = Old.behavResources(ifield).CleanXtsd;
        behavResources(ifield).Ytsd = Old.behavResources(ifield).CleanYtsd;
        behavResources(ifield).AlignedXtsd = Old.behavResources(ifield).CleanAlignedXtsd;
        behavResources(ifield).AlignedYtsd = Old.behavResources(ifield).CleanAlignedYtsd;
%         behavResources(ifield).AlignedXtsd = Old.behavResources(ifield).AlignedXtsd;
%         behavResources(ifield).AlignedYtsd = Old.behavResources(ifield).AlignedYtsd;
        behavResources(ifield).Vtsd = Old.behavResources(ifield).CleanVtsd;
        behavResources(ifield).GotFrame = Old.behavResources(ifield).GotFrame;
        behavResources(ifield).ZoneIndices = Old.behavResources(ifield).CleanZoneIndices;
        behavResources(ifield).MouseTemp = Old.behavResources(ifield).MouseTemp;
        behavResources(ifield).FreezeEpoch = Old.behavResources(ifield).FreezeEpoch;
        behavResources(ifield).ZoneEpoch = Old.behavResources(ifield).CleanZoneEpoch;
        behavResources(ifield).LinearDist = Old.behavResources(ifield).CleanLinearDist;
    end
    clear ifield
    
    %% Save
    save('behavResources.mat', '-regexp', '^(?!(Dir|mice|imouse|Old)$).');
    clearvars -except Dir mice imouse
end