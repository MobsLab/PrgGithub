UMazeEpoch = or(SessionEpoch.Hab,SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre4);

% Cond Epoch
CondEpoch = or(SessionEpoch.Cond1,SessionEpoch.Cond2);
CondEpoch = or(CondEpoch,SessionEpoch.Cond3);
CondEpoch = or(CondEpoch,SessionEpoch.Cond4);

% After Conditioning
AfterConditioningEpoch = or(SessionEpoch.TestPost1,SessionEpoch.TestPost2);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost3);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost4);

% Locomotion threshold
VtsdSmoothed  = tsd(Range(Vtsd),movmedian(Data(Vtsd),5));
LocomotionEpoch = thresholdIntervals(VtsdSmoothed,3,'Direction','Above');

% Get resulting epoch
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
CondEpochMoving = and(CondEpoch,LocomotionEpoch);
CondEpochFreeze = and(CondEpoch,FreezeAccEpoch);
AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);


%% Plot
A = [55,56,71];

for i=1:length(A)
    try
    [mapE{i},mapSE{i},statsE{i}] = PlaceField_DB(Restrict(S{A(i)},UMazeEpoch),...
        Restrict(CleanAlignedXtsd,UMazeEpoch),Restrict(CleanAlignedYtsd,UMazeEpoch),...
        'threshold',0.5,'size',75,'smoothing',2.5,'plotresults',0);
    
    [mapCM{i},mapSCM{i},statsCM{i}] = PlaceField_DB(Restrict(S{A(i)},CondEpochMoving),...
        Restrict(CleanAlignedXtsd,CondEpochMoving),Restrict(CleanAlignedYtsd,CondEpochMoving),...
        'threshold',0.5,'size',75,'smoothing',2.5,'plotresults',0);
    
    [mapCF{i},mapSCF{i},statsCF{i}] = PlaceField_DB(Restrict(S{A(i)},CondEpochFreeze),...
        Restrict(CleanAlignedXtsd,CondEpochFreeze),Restrict(CleanAlignedYtsd,CondEpochFreeze),...
        'threshold',0.5,'size',75,'smoothing',2.5,'plotresults',0);
    
    [mapP{i},mapSP{i},statsP{i}] = PlaceField_DB(Restrict(S{A(i)},AfterConditioningMovingEpoch),...
        Restrict(CleanAlignedXtsd,AfterConditioningMovingEpoch),Restrict(CleanAlignedYtsd,AfterConditioningMovingEpoch),...
        'threshold',0.5,'size',75,'smoothing',2.5,'plotresults',0);
    catch
        mapE{i} = [];
        mapSE{i} = [];
        statsE{i} = [];
        
        mapCM{i} = [];
        mapSCM{i} = [];
        statsCM{i} = [];
        
        mapCF{i} = [];
        mapSCF{i} = [];
        statsCF{i} = [];
        
        mapP{i} = [];
        mapSP{i} = [];
        statsP{i} = [];
    end
end
close all




for i=1:length(A)
    figure
    subplot(1,4,1)
    imagesc(mapE{i}.rate)
    axis xy
    set(gca,'XTickLabel',{},'YTickLabel',{})
    title('Exploration')
    subplot(1,4,2)
    imagesc(mapCM{i}.rate)
    axis xy
    set(gca,'XTickLabel',{},'YTickLabel',{})
    title('CondMov')
    subplot(1,4,3)
    imagesc(mapCF{i}.rate)
    axis xy
    set(gca,'XTickLabel',{},'YTickLabel',{})
    title('CondFreeze')
    subplot(1,4,4)
    imagesc(mapP{i}.rate)
    axis xy
    set(gca,'XTickLabel',{},'YTickLabel',{})
    title('Post')
end