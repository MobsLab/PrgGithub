smoo = 2.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% go to M711
cd('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated')
load('SpikeData.mat')
load('behavResources.mat')
load('Ripples.mat')
% 
mazeMap = [10 10; 10 80; 85 80; 85 10;  57 10; 57 65; 38 65; 38 10; 10 10];
% 
% Get ripples
ripts = ts(ripples(:,2)*1e4);

% % PosMatInit
% InitX = tsd(Range(Xtsd),PosMatInit(:,2));
% InitY = tsd(Range(Ytsd),PosMatInit(:,3));

%Split Hab in halves
st = Start(SessionEpoch.Hab);
en = End(SessionEpoch.Hab);
Hab1Half = intervalSet(st,((en-st)/2)+st);
Hab2Half = intervalSet(((en-st)/2)+st,en);

% BaselineExplo Epoch
UMazeEpoch = or(SessionEpoch.Hab,SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre4);

% Conditioning
ConditioningEpoch = or(SessionEpoch.Cond1,SessionEpoch.Cond2);
ConditioningEpoch = or(ConditioningEpoch,SessionEpoch.Cond3);
ConditioningEpoch = or(ConditioningEpoch,SessionEpoch.Cond4);

% After Conditioning
AfterConditioningEpoch = or(SessionEpoch.TestPost1,SessionEpoch.TestPost2);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost3);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost4);

% Locomotion threshold
LocomotionEpoch = thresholdIntervals(tsd(Range(Vtsd),movmedian(Data(Vtsd),5)),2.5,'Direction','Above');

% Get resulting epochs
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);
MovingHab1Half = and(LocomotionEpoch,Hab1Half);
MovingHab2Half = and(LocomotionEpoch,Hab2Half);
ConditioningMovingEpoch = and(LocomotionEpoch, ConditioningEpoch);
CoonditioningFreezingEpoch = and(FreezeAccEpoch, ConditioningEpoch);

% Found two place cells - 27 and 32
SelectedPlaceCells(1).name = 'Mouse711';

% PC1
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{27},UMazeMovingEpoch),...
    Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(1).BeforeCond.map{1} = map;
SelectedPlaceCells(1).BeforeCond.stats{1} = stats;
SelectedPlaceCells(1).BeforeCond.px{1} = px;
SelectedPlaceCells(1).BeforeCond.py{1} = py;
SelectedPlaceCells(1).BeforeCond.FR{1} = FR;
SelectedPlaceCells(1).BeforeCond.PrField{1} = PrField;
SelectedPlaceCells(1).BeforeCond.idtet{1} = cellnames{27};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{27},MovingHab1Half),...
    Restrict(AlignedXtsd, MovingHab1Half),...
    Restrict(AlignedYtsd, MovingHab1Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(1).Hab1Half.map{1} = map;
SelectedPlaceCells(1).Hab1Half.stats{1} = stats;
SelectedPlaceCells(1).Hab1Half.px{1} = px;
SelectedPlaceCells(1).Hab1Half.py{1} = py;
SelectedPlaceCells(1).Hab1Half.FR{1} = FR;
SelectedPlaceCells(1).Hab1Half.PrField{1} = PrField;
SelectedPlaceCells(1).Hab1Half.idtet{1} = cellnames{27};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{27},MovingHab2Half),...
    Restrict(AlignedXtsd, MovingHab2Half),...
    Restrict(AlignedYtsd, MovingHab2Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(1).Hab2Half.map{1} = map;
SelectedPlaceCells(1).Hab2Half.stats{1} = stats;
SelectedPlaceCells(1).Hab2Half.px{1} = px;
SelectedPlaceCells(1).Hab2Half.py{1} = py;
SelectedPlaceCells(1).Hab2Half.FR{1} = FR;
SelectedPlaceCells(1).Hab2Half.PrField{1} = PrField;
SelectedPlaceCells(1).Hab2Half.idtet{1} = cellnames{27};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{27},ConditioningMovingEpoch),...
    Restrict(AlignedXtsd, ConditioningMovingEpoch),...
    Restrict(AlignedYtsd, ConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(1).CondMov.map{1} = map;
SelectedPlaceCells(1).CondMov.stats{1} = stats;
SelectedPlaceCells(1).CondMov.px{1} = px;
SelectedPlaceCells(1).CondMov.py{1} = py;
SelectedPlaceCells(1).CondMov.FR{1} = FR;
SelectedPlaceCells(1).CondMov.PrField{1} = PrField;
SelectedPlaceCells(1).CondMov.idtet{1} = cellnames{27};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{27},CoonditioningFreezingEpoch),...
    Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
    Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(1).CondFreeze.map{1} = map;
SelectedPlaceCells(1).CondFreeze.stats{1} = stats;
SelectedPlaceCells(1).CondFreeze.px{1} = px;
SelectedPlaceCells(1).CondFreeze.py{1} = py;
SelectedPlaceCells(1).CondFreeze.FR{1} = FR;
SelectedPlaceCells(1).CondFreeze.PrField{1} = PrField;
SelectedPlaceCells(1).CondFreeze.idtet{1} = cellnames{27};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{27},AfterConditioningMovingEpoch),...
    Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(1).AfterCond.map{1} = map;
SelectedPlaceCells(1).AfterCond.stats{1} = stats;
SelectedPlaceCells(1).AfterCond.px{1} = px;
SelectedPlaceCells(1).AfterCond.py{1} = py;
SelectedPlaceCells(1).AfterCond.FR{1} = FR;
SelectedPlaceCells(1).AfterCond.PrField{1} = PrField;
SelectedPlaceCells(1).AfterCond.idtet{1} = cellnames{27};

% PC2
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{32},UMazeMovingEpoch),...
    Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(1).BeforeCond.map{2} = map;
SelectedPlaceCells(1).BeforeCond.stats{2} = stats;
SelectedPlaceCells(1).BeforeCond.px{2} = px;
SelectedPlaceCells(1).BeforeCond.py{2} = py;
SelectedPlaceCells(1).BeforeCond.FR{2} = FR;
SelectedPlaceCells(1).BeforeCond.PrField{2} = PrField;
SelectedPlaceCells(1).BeforeCond.idtet{2} = cellnames{32};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{32},MovingHab1Half),...
    Restrict(AlignedXtsd, MovingHab1Half),...
    Restrict(AlignedYtsd, MovingHab1Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(1).Hab1Half.map{2} = map;
SelectedPlaceCells(1).Hab1Half.stats{2} = stats;
SelectedPlaceCells(1).Hab1Half.px{2} = px;
SelectedPlaceCells(1).Hab1Half.py{2} = py;
SelectedPlaceCells(1).Hab1Half.FR{2} = FR;
SelectedPlaceCells(1).Hab1Half.PrField{2} = PrField;
SelectedPlaceCells(1).Hab1Half.idtet{2} = cellnames{32};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{32},MovingHab2Half),...
    Restrict(AlignedXtsd, MovingHab2Half),...
    Restrict(AlignedYtsd, MovingHab2Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(1).Hab2Half.map{2} = map;
SelectedPlaceCells(1).Hab2Half.stats{2} = stats;
SelectedPlaceCells(1).Hab2Half.px{2} = px;
SelectedPlaceCells(1).Hab2Half.py{2} = py;
SelectedPlaceCells(1).Hab2Half.FR{2} = FR;
SelectedPlaceCells(1).Hab2Half.PrField{2} = PrField;
SelectedPlaceCells(1).Hab2Half.idtet{2} = cellnames{32};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{32},ConditioningMovingEpoch),...
    Restrict(AlignedXtsd, ConditioningMovingEpoch),...
    Restrict(AlignedYtsd, ConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(1).CondMov.map{2} = map;
SelectedPlaceCells(1).CondMov.stats{2} = stats;
SelectedPlaceCells(1).CondMov.px{2} = px;
SelectedPlaceCells(1).CondMov.py{2} = py;
SelectedPlaceCells(1).CondMov.FR{2} = FR;
SelectedPlaceCells(1).CondMov.PrField{2} = PrField;
SelectedPlaceCells(1).CondMov.idtet{2} = cellnames{32};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{32},CoonditioningFreezingEpoch),...
    Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
    Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(1).CondFreeze.map{2} = map;
SelectedPlaceCells(1).CondFreeze.stats{2} = stats;
SelectedPlaceCells(1).CondFreeze.px{2} = px;
SelectedPlaceCells(1).CondFreeze.py{2} = py;
SelectedPlaceCells(1).CondFreeze.FR{2} = FR;
SelectedPlaceCells(1).CondFreeze.PrField{2} = PrField;
SelectedPlaceCells(1).CondFreeze.idtet{2} = cellnames{32};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{32},AfterConditioningMovingEpoch),...
    Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(1).AfterCond.map{2} = map;
SelectedPlaceCells(1).AfterCond.stats{2} = stats;
SelectedPlaceCells(1).AfterCond.px{2} = px;
SelectedPlaceCells(1).AfterCond.py{2} = py;
SelectedPlaceCells(1).AfterCond.FR{2} = FR;
SelectedPlaceCells(1).AfterCond.PrField{2} = PrField;
SelectedPlaceCells(1).AfterCond.idtet{2} = cellnames{32};

% Ripples during CondFreezing
if ~isempty(Data(Restrict(ripts,CoonditioningFreezingEpoch)))
    [map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB...
        (Restrict(ripts,CoonditioningFreezingEpoch),...
        Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
        Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
    SelectedPlaceCells(1).CondFreezeRipples.map = map;
    SelectedPlaceCells(1).CondFreezeRipples.stats = stats;
    SelectedPlaceCells(1).CondFreezeRipples.px = px;
    SelectedPlaceCells(1).CondFreezeRipples.py = py;
    SelectedPlaceCells(1).CondFreezeRipples.FR = FR;
    SelectedPlaceCells(1).CondFreezeRipples.PrField = PrField;
else
    SelectedPlaceCells(1).CondFreezeRipples.map = [];
    SelectedPlaceCells(1).CondFreezeRipples.stats = [];
    SelectedPlaceCells(1).CondFreezeRipples.px = [];
    SelectedPlaceCells(1).CondFreezeRipples.py = [];
    SelectedPlaceCells(1).CondFreezeRipples.FR = [];
    SelectedPlaceCells(1).CondFreezeRipples.PrField = [];
end

% Clear
clearvars -except SelectedPlaceCells smoo

%%%%%%%%%%%%%%%%%%%%%%%%%

%% go to M797
cd('/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated')
load('SpikeData.mat')
load('behavResources.mat')
load('Ripples.mat')
% Get ripples
ripts = ts(ripples(:,2)*1e4);

mazeMap = [24 15; 24 77; 87 77; 87 15; 62 15;  62 58; 46 58; 46 15; 24 15];

%Split Hab in halves
st = Start(SessionEpoch.Hab);
en = End(SessionEpoch.Hab);
Hab1Half = intervalSet(st,((en-st)/2)+st);
Hab2Half = intervalSet(((en-st)/2)+st,en);

% BaselineExplo Epoch
UMazeEpoch = or(SessionEpoch.Hab,SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre4);

% Conditioning
ConditioningEpoch = or(SessionEpoch.Cond1,SessionEpoch.Cond2);
ConditioningEpoch = or(ConditioningEpoch,SessionEpoch.Cond3);
ConditioningEpoch = or(ConditioningEpoch,SessionEpoch.Cond4);

% After Conditioning
AfterConditioningEpoch = or(SessionEpoch.TestPost1,SessionEpoch.TestPost2);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost3);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost4);

% Locomotion threshold
LocomotionEpoch = thresholdIntervals(tsd(Range(Vtsd),movmedian(Data(Vtsd),5)),2.5,'Direction','Above');

% Get resulting epochs
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);
MovingHab1Half = and(LocomotionEpoch,Hab1Half);
MovingHab2Half = and(LocomotionEpoch,Hab2Half);
ConditioningMovingEpoch = and(LocomotionEpoch, ConditioningEpoch);
CoonditioningFreezingEpoch = and(FreezeAccEpoch, ConditioningEpoch);

% Found one place cell - 12
SelectedPlaceCells(2).name = 'Mouse797';

% PC1
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{12},UMazeMovingEpoch),...
    Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(2).BeforeCond.map{1} = map;
SelectedPlaceCells(2).BeforeCond.stats{1} = stats;
SelectedPlaceCells(2).BeforeCond.px{1} = px;
SelectedPlaceCells(2).BeforeCond.py{1} = py;
SelectedPlaceCells(2).BeforeCond.FR{1} = FR;
SelectedPlaceCells(2).BeforeCond.PrField{1} = PrField;
SelectedPlaceCells(2).BeforeCond.idtet{1} = cellnames{12};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{12},Hab1Half),...
    Restrict(AlignedXtsd, MovingHab1Half),...
    Restrict(AlignedYtsd, MovingHab1Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(2).Hab1Half.map{1} = map;
SelectedPlaceCells(2).Hab1Half.stats{1} = stats;
SelectedPlaceCells(2).Hab1Half.px{1} = px;
SelectedPlaceCells(2).Hab1Half.py{1} = py;
SelectedPlaceCells(2).Hab1Half.FR{1} = FR;
SelectedPlaceCells(2).Hab1Half.PrField{1} = PrField;
SelectedPlaceCells(2).Hab1Half.idtet{1} = cellnames{12};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{12},MovingHab2Half),...
    Restrict(AlignedXtsd, MovingHab2Half),...
    Restrict(AlignedYtsd, MovingHab2Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(2).Hab2Half.map{1} = map;
SelectedPlaceCells(2).Hab2Half.stats{1} = stats;
SelectedPlaceCells(2).Hab2Half.px{1} = px;
SelectedPlaceCells(2).Hab2Half.py{1} = py;
SelectedPlaceCells(2).Hab2Half.FR{1} = FR;
SelectedPlaceCells(2).Hab2Half.PrField{1} = PrField;
SelectedPlaceCells(2).Hab2Half.idtet{1} = cellnames{12};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{12},ConditioningMovingEpoch),...
    Restrict(AlignedXtsd, ConditioningMovingEpoch),...
    Restrict(AlignedYtsd, ConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(2).CondMov.map{1} = map;
SelectedPlaceCells(2).CondMov.stats{1} = stats;
SelectedPlaceCells(2).CondMov.px{1} = px;
SelectedPlaceCells(2).CondMov.py{1} = py;
SelectedPlaceCells(2).CondMov.FR{1} = FR;
SelectedPlaceCells(2).CondMov.PrField{1} = PrField;
SelectedPlaceCells(2).CondMov.idtet{1} = cellnames{12};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{12},CoonditioningFreezingEpoch),...
    Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
    Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(2).CondFreeze.map{1} = map;
SelectedPlaceCells(2).CondFreeze.stats{1} = stats;
SelectedPlaceCells(2).CondFreeze.px{1} = px;
SelectedPlaceCells(2).CondFreeze.py{1} = py;
SelectedPlaceCells(2).CondFreeze.FR{1} = FR;
SelectedPlaceCells(2).CondFreeze.PrField{1} = PrField;
SelectedPlaceCells(2).CondFreeze.idtet{1} = cellnames{12};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{12},AfterConditioningMovingEpoch),...
    Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(2).AfterCond.map{1} = map;
SelectedPlaceCells(2).AfterCond.stats{1} = stats;
SelectedPlaceCells(2).AfterCond.px{1} = px;
SelectedPlaceCells(2).AfterCond.py{1} = py;
SelectedPlaceCells(2).AfterCond.FR{1} = FR;
SelectedPlaceCells(2).AfterCond.PrField{1} = PrField;
SelectedPlaceCells(2).AfterCond.idtet{1} = cellnames{12};

% Ripples during CondFreezing
if ~isempty(Data(Restrict(ripts,CoonditioningFreezingEpoch)))
    [map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB...
        (Restrict(ripts,CoonditioningFreezingEpoch),...
        Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
        Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
    SelectedPlaceCells(2).CondFreezeRipples.map = map;
    SelectedPlaceCells(2).CondFreezeRipples.stats = stats;
    SelectedPlaceCells(2).CondFreezeRipples.px = px;
    SelectedPlaceCells(2).CondFreezeRipples.py = py;
    SelectedPlaceCells(2).CondFreezeRipples.FR = FR;
    SelectedPlaceCells(2).CondFreezeRipples.PrField = PrField;
else
    SelectedPlaceCells(2).CondFreezeRipples.map = [];
    SelectedPlaceCells(2).CondFreezeRipples.stats = [];
    SelectedPlaceCells(2).CondFreezeRipples.px = [];
    SelectedPlaceCells(2).CondFreezeRipples.py = [];
    SelectedPlaceCells(2).CondFreezeRipples.FR = [];
    SelectedPlaceCells(2).CondFreezeRipples.PrField = [];
end

% Clear
clearvars -except SelectedPlaceCells smoo

%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% go to M798
cd('/media/nas5/ProjetERC2/Mouse-798/12112018/_Concatenated')
load('SpikeData.mat')
load('behavResources.mat')

% BaselineExplo Epoch
UMazeEpoch = or(SessionEpoch.Hab,SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre4);

% Locomotion threshold
LocomotionEpoch = thresholdIntervals(tsd(Range(Vtsd),movmedian(Data(Vtsd),5)),2.5,'Direction','Above');

% Get resulting epoch
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);

% Have not found place cells
SelectedPlaceCells(3).name = 'Mouse798';

% Clear
clearvars -except SelectedPlaceCells smoo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% go to M828
cd('/media/nas5/ProjetERC2/Mouse-828/20190305/_Concatenated')
load('SpikeData.mat')
load('behavResources.mat')

% BaselineExplo Epoch
UMazeEpoch = or(SessionEpoch.Hab,SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre4);

% Locomotion threshold
LocomotionEpoch = thresholdIntervals(tsd(Range(Vtsd),movmedian(Data(Vtsd),5)),3,'Direction','Above');

% Get resulting epoch
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);

% Have not found place cells
SelectedPlaceCells(4).name = 'Mouse828';

% Clear
clearvars -except SelectedPlaceCells smoo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% go to M861
cd('/media/nas5/ProjetERC2/Mouse-861/20190313/_Concatenated/')
load('SpikeData.mat')
load('behavResources.mat')

% BaselineExplo Epoch
UMazeEpoch = or(SessionEpoch.Hab,SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre4);

% Locomotion threshold
LocomotionEpoch = thresholdIntervals(tsd(Range(Vtsd),movmedian(Data(Vtsd),5)),3,'Direction','Above');

% Get resulting epoch
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);

% Have not found place cells
SelectedPlaceCells(5).name = 'Mouse861';

% Clear
clearvars -except SelectedPlaceCells smoo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% go to M882
cd('/media/nas5/ProjetERC2/Mouse-882/20190409/PAGexp/_Concatenated/')
load('SpikeData.mat')
load('behavResources.mat')

% BaselineExplo Epoch
UMazeEpoch = or(SessionEpoch.Hab,SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre4);

% Locomotion threshold
LocomotionEpoch = thresholdIntervals(tsd(Range(Vtsd),movmedian(Data(Vtsd),5)),3,'Direction','Above');

% Get resulting epoch
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);

% Have not found place cells
SelectedPlaceCells(6).name = 'Mouse882';

% Clear
clearvars -except SelectedPlaceCells smoo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% go to M905
cd('/media/nas5/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/')
load('SpikeData.mat')
load('behavResources.mat')

% BaselineExplo Epoch
UMazeEpoch = or(SessionEpoch.Hab,SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre4);

% Locomotion threshold
LocomotionEpoch = thresholdIntervals(tsd(Range(Vtsd),movmedian(Data(Vtsd),5)),3,'Direction','Above');

% Get resulting epoch
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);

% Have not found place cells
SelectedPlaceCells(7).name = 'Mouse905';

% Clear
clearvars -except SelectedPlaceCells smoo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% go to M906
cd('/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/')
load('SpikeData.mat')
load('behavResources.mat')
load('Ripples.mat')
% Get ripples
ripts = ts(ripples(:,2)*1e4);

mazeMap = [17 10; 17 85; 86 85; 86 10; 62 10; 62 66; 41 66; 41 10; 17 10];

%Split Hab in halves
st = Start(SessionEpoch.Hab);
en = End(SessionEpoch.Hab);
Hab1Half = intervalSet(st,((en-st)/2)+st);
Hab2Half = intervalSet(((en-st)/2)+st,en);

% BaselineExplo Epoch
UMazeEpoch = or(SessionEpoch.Hab,SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre4);

% Conditioning
ConditioningEpoch = or(SessionEpoch.Cond1,SessionEpoch.Cond2);
ConditioningEpoch = or(ConditioningEpoch,SessionEpoch.Cond3);
ConditioningEpoch = or(ConditioningEpoch,SessionEpoch.Cond4);

% AfterConditioning
AfterConditioningEpoch = or(SessionEpoch.TestPost1,SessionEpoch.TestPost2);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost3);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost4);

% Locomotion threshold
LocomotionEpoch = thresholdIntervals(tsd(Range(Vtsd),movmedian(Data(Vtsd),5)),3,'Direction','Above');

% Get resulting epochs
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);
MovingHab1Half = and(LocomotionEpoch,Hab1Half);
MovingHab2Half = and(LocomotionEpoch,Hab2Half);
ConditioningMovingEpoch = and(LocomotionEpoch, ConditioningEpoch);
CoonditioningFreezingEpoch = and(FreezeAccEpoch, ConditioningEpoch);

% Found four place cells - 17, 18, 19, and 27
SelectedPlaceCells(8).name = 'Mouse906';

% PC1
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{17},UMazeMovingEpoch),...
    Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).BeforeCond.map{1} = map;
SelectedPlaceCells(8).BeforeCond.stats{1} = stats;
SelectedPlaceCells(8).BeforeCond.px{1} = px;
SelectedPlaceCells(8).BeforeCond.py{1} = py;
SelectedPlaceCells(8).BeforeCond.FR{1} = FR;
SelectedPlaceCells(8).BeforeCond.PrField{1} = PrField;
SelectedPlaceCells(8).BeforeCond.idtet{1} = cellnames{17};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{17},MovingHab1Half),...
    Restrict(AlignedXtsd, MovingHab1Half),...
    Restrict(AlignedYtsd, MovingHab1Half), 'smoothing',2.5, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).Hab1Half.map{1} = map;
SelectedPlaceCells(8).Hab1Half.stats{1} = stats;
SelectedPlaceCells(8).Hab1Half.px{1} = px;
SelectedPlaceCells(8).Hab1Half.py{1} = py;
SelectedPlaceCells(8).Hab1Half.FR{1} = FR;
SelectedPlaceCells(8).Hab1Half.PrField{1} = PrField;
SelectedPlaceCells(8).Hab1Half.idtet{1} = cellnames{17};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{17},MovingHab2Half),...
    Restrict(AlignedXtsd, MovingHab2Half),...
    Restrict(AlignedYtsd, MovingHab2Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).Hab2Half.map{1} = map;
SelectedPlaceCells(8).Hab2Half.stats{1} = stats;
SelectedPlaceCells(8).Hab2Half.px{1} = px;
SelectedPlaceCells(8).Hab2Half.py{1} = py;
SelectedPlaceCells(8).Hab2Half.FR{1} = FR;
SelectedPlaceCells(8).Hab2Half.PrField{1} = PrField;
SelectedPlaceCells(8).Hab2Half.idtet{1} = cellnames{17};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{17},ConditioningMovingEpoch),...
    Restrict(AlignedXtsd, ConditioningMovingEpoch),...
    Restrict(AlignedYtsd, ConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).CondMov.map{1} = map;
SelectedPlaceCells(8).CondMov.stats{1} = stats;
SelectedPlaceCells(8).CondMov.px{1} = px;
SelectedPlaceCells(8).CondMov.py{1} = py;
SelectedPlaceCells(8).CondMov.FR{1} = FR;
SelectedPlaceCells(8).CondMov.PrField{1} = PrField;
SelectedPlaceCells(8).CondMov.idtet{1} = cellnames{17};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{17},CoonditioningFreezingEpoch),...
    Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
    Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).CondFreeze.map{1} = map;
SelectedPlaceCells(8).CondFreeze.stats{1} = stats;
SelectedPlaceCells(8).CondFreeze.px{1} = px;
SelectedPlaceCells(8).CondFreeze.py{1} = py;
SelectedPlaceCells(8).CondFreeze.FR{1} = FR;
SelectedPlaceCells(8).CondFreeze.PrField{1} = PrField;
SelectedPlaceCells(8).CondFreeze.idtet{1} = cellnames{17};

try
    [map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{17},...
        AfterConditioningMovingEpoch),Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
        Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
    SelectedPlaceCells(8).AfterCond.map{1} = map;
    SelectedPlaceCells(8).AfterCond.stats{1} = stats;
    SelectedPlaceCells(8).AfterCond.px{1} = px;
    SelectedPlaceCells(8).AfterCond.py{1} = py;
    SelectedPlaceCells(8).AfterCond.FR{1} = FR;
    SelectedPlaceCells(8).AfterCond.PrField{1} = PrField;
    SelectedPlaceCells(8).AfterCond.idtet{1} = cellnames{17};
catch
    SelectedPlaceCells(8).AfterCond.map{1} = [];
    SelectedPlaceCells(8).AfterCond.stats{1} = [];
    SelectedPlaceCells(8).AfterCond.px{1} = [];
    SelectedPlaceCells(8).AfterCond.py{1} = [];
    SelectedPlaceCells(8).AfterCond.FR{1} = [];
    SelectedPlaceCells(8).AfterCond.PrField{1} = [];
    SelectedPlaceCells(8).AfterCond.idtet{1} = cellnames{17};
end


% PC2
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{18},UMazeMovingEpoch),...
    Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).BeforeCond.map{2} = map;
SelectedPlaceCells(8).BeforeCond.stats{2} = stats;
SelectedPlaceCells(8).BeforeCond.px{2} = px;
SelectedPlaceCells(8).BeforeCond.py{2} = py;
SelectedPlaceCells(8).BeforeCond.FR{2} = FR;
SelectedPlaceCells(8).BeforeCond.PrField{2} = PrField;
SelectedPlaceCells(8).BeforeCond.idtet{2} = cellnames{18};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{18},MovingHab1Half),...
    Restrict(AlignedXtsd, MovingHab1Half),...
    Restrict(AlignedYtsd, MovingHab1Half), 'smoothing',2.5, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).Hab1Half.map{2} = map;
SelectedPlaceCells(8).Hab1Half.stats{2} = stats;
SelectedPlaceCells(8).Hab1Half.px{2} = px;
SelectedPlaceCells(8).Hab1Half.py{2} = py;
SelectedPlaceCells(8).Hab1Half.FR{2} = FR;
SelectedPlaceCells(8).Hab1Half.PrField{2} = PrField;
SelectedPlaceCells(8).Hab1Half.idtet{2} = cellnames{18};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{18},MovingHab2Half),...
    Restrict(AlignedXtsd, MovingHab2Half),...
    Restrict(AlignedYtsd, MovingHab2Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).Hab2Half.map{2} = map;
SelectedPlaceCells(8).Hab2Half.stats{2} = stats;
SelectedPlaceCells(8).Hab2Half.px{2} = px;
SelectedPlaceCells(8).Hab2Half.py{2} = py;
SelectedPlaceCells(8).Hab2Half.FR{2} = FR;
SelectedPlaceCells(8).Hab2Half.PrField{2} = PrField;
SelectedPlaceCells(8).Hab2Half.idtet{2} = cellnames{18};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{18},ConditioningMovingEpoch),...
    Restrict(AlignedXtsd, ConditioningMovingEpoch),...
    Restrict(AlignedYtsd, ConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).CondMov.map{2} = map;
SelectedPlaceCells(8).CondMov.stats{2} = stats;
SelectedPlaceCells(8).CondMov.px{2} = px;
SelectedPlaceCells(8).CondMov.py{2} = py;
SelectedPlaceCells(8).CondMov.FR{2} = FR;
SelectedPlaceCells(8).CondMov.PrField{2} = PrField;
SelectedPlaceCells(8).CondMov.idtet{2} = cellnames{18};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{18},CoonditioningFreezingEpoch),...
    Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
    Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).CondFreeze.map{2} = map;
SelectedPlaceCells(8).CondFreeze.stats{2} = stats;
SelectedPlaceCells(8).CondFreeze.px{2} = px;
SelectedPlaceCells(8).CondFreeze.py{2} = py;
SelectedPlaceCells(8).CondFreeze.FR{2} = FR;
SelectedPlaceCells(8).CondFreeze.PrField{2} = PrField;
SelectedPlaceCells(8).CondFreeze.idtet{2} = cellnames{18};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{18},AfterConditioningMovingEpoch),...
    Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).AfterCond.map{2} = map;
SelectedPlaceCells(8).AfterCond.stats{2} = stats;
SelectedPlaceCells(8).AfterCond.px{2} = px;
SelectedPlaceCells(8).AfterCond.py{2} = py;
SelectedPlaceCells(8).AfterCond.FR{2} = FR;
SelectedPlaceCells(8).AfterCond.PrField{2} = PrField;
SelectedPlaceCells(8).AfterCond.idtet{2} = cellnames{18};

% PC3
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,xScField,pfH,pf]=PlaceField_DB(Restrict(S{19},UMazeMovingEpoch),...
    Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).BeforeCond.map{3} = map;
SelectedPlaceCells(8).BeforeCond.stats{3} = stats;
SelectedPlaceCells(8).BeforeCond.px{3} = px;
SelectedPlaceCells(8).BeforeCond.py{3} = py;
SelectedPlaceCells(8).BeforeCond.FR{3} = FR;
SelectedPlaceCells(8).BeforeCond.PrField{3} = PrField;
SelectedPlaceCells(8).BeforeCond.idtet{3} = cellnames{19};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{19},MovingHab1Half),...
    Restrict(AlignedXtsd, MovingHab1Half),...
    Restrict(AlignedYtsd, MovingHab1Half), 'smoothing',2.5, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).Hab1Half.map{3} = map;
SelectedPlaceCells(8).Hab1Half.stats{3} = stats;
SelectedPlaceCells(8).Hab1Half.px{3} = px;
SelectedPlaceCells(8).Hab1Half.py{3} = py;
SelectedPlaceCells(8).Hab1Half.FR{3} = FR;
SelectedPlaceCells(8).Hab1Half.PrField{3} = PrField;
SelectedPlaceCells(8).Hab1Half.idtet{3} = cellnames{19};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{19},MovingHab2Half),...
    Restrict(AlignedXtsd, MovingHab2Half),...
    Restrict(AlignedYtsd, MovingHab2Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).Hab2Half.map{3} = map;
SelectedPlaceCells(8).Hab2Half.stats{3} = stats;
SelectedPlaceCells(8).Hab2Half.px{3} = px;
SelectedPlaceCells(8).Hab2Half.py{3} = py;
SelectedPlaceCells(8).Hab2Half.FR{3} = FR;
SelectedPlaceCells(8).Hab2Half.PrField{3} = PrField;
SelectedPlaceCells(8).Hab2Half.idtet{3} = cellnames{19};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{19},ConditioningMovingEpoch),...
    Restrict(AlignedXtsd, ConditioningMovingEpoch),...
    Restrict(AlignedYtsd, ConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).CondMov.map{3} = map;
SelectedPlaceCells(8).CondMov.stats{3} = stats;
SelectedPlaceCells(8).CondMov.px{3} = px;
SelectedPlaceCells(8).CondMov.py{3} = py;
SelectedPlaceCells(8).CondMov.FR{3} = FR;
SelectedPlaceCells(8).CondMov.PrField{3} = PrField;
SelectedPlaceCells(8).CondMov.idtet{3} = cellnames{19};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{19},CoonditioningFreezingEpoch),...
    Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
    Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).CondFreeze.map{3} = map;
SelectedPlaceCells(8).CondFreeze.stats{3} = stats;
SelectedPlaceCells(8).CondFreeze.px{3} = px;
SelectedPlaceCells(8).CondFreeze.py{3} = py;
SelectedPlaceCells(8).CondFreeze.FR{3} = FR;
SelectedPlaceCells(8).CondFreeze.PrField{3} = PrField;
SelectedPlaceCells(8).CondFreeze.idtet{3} = cellnames{19};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{19},AfterConditioningMovingEpoch),...
    Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).AfterCond.map{3} = map;
SelectedPlaceCells(8).AfterCond.stats{3} = stats;
SelectedPlaceCells(8).AfterCond.px{3} = px;
SelectedPlaceCells(8).AfterCond.py{3} = py;
SelectedPlaceCells(8).AfterCond.FR{3} = FR;
SelectedPlaceCells(8).AfterCond.PrField{3} = PrField;
SelectedPlaceCells(8).AfterCond.idtet{3} = cellnames{19};

% PC4
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{27},UMazeMovingEpoch),...
    Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).BeforeCond.map{4} = map;
SelectedPlaceCells(8).BeforeCond.stats{4} = stats;
SelectedPlaceCells(8).BeforeCond.px{4} = px;
SelectedPlaceCells(8).BeforeCond.py{4} = py;
SelectedPlaceCells(8).BeforeCond.FR{4} = FR;
SelectedPlaceCells(8).BeforeCond.PrField{4} = PrField;
SelectedPlaceCells(8).BeforeCond.idtet{4} = cellnames{27};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{27},MovingHab1Half),...
    Restrict(AlignedXtsd, MovingHab1Half),...
    Restrict(AlignedYtsd, MovingHab1Half), 'smoothing',2.5, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).Hab1Half.map{4} = map;
SelectedPlaceCells(8).Hab1Half.stats{4} = stats;
SelectedPlaceCells(8).Hab1Half.px{4} = px;
SelectedPlaceCells(8).Hab1Half.py{4} = py;
SelectedPlaceCells(8).Hab1Half.FR{4} = FR;
SelectedPlaceCells(8).Hab1Half.PrField{4} = PrField;
SelectedPlaceCells(8).Hab1Half.idtet{4} = cellnames{27};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{27},MovingHab2Half),...
    Restrict(AlignedXtsd, MovingHab2Half),...
    Restrict(AlignedYtsd, MovingHab2Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).Hab2Half.map{4} = map;
SelectedPlaceCells(8).Hab2Half.stats{4} = stats;
SelectedPlaceCells(8).Hab2Half.px{4} = px;
SelectedPlaceCells(8).Hab2Half.py{4} = py;
SelectedPlaceCells(8).Hab2Half.FR{4} = FR;
SelectedPlaceCells(8).Hab2Half.PrField{4} = PrField;
SelectedPlaceCells(8).Hab2Half.idtet{4} = cellnames{27};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{27},ConditioningMovingEpoch),...
    Restrict(AlignedXtsd, ConditioningMovingEpoch),...
    Restrict(AlignedYtsd, ConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).CondMov.map{4} = map;
SelectedPlaceCells(8).CondMov.stats{4} = stats;
SelectedPlaceCells(8).CondMov.px{4} = px;
SelectedPlaceCells(8).CondMov.py{4} = py;
SelectedPlaceCells(8).CondMov.FR{4} = FR;
SelectedPlaceCells(8).CondMov.PrField{4} = PrField;
SelectedPlaceCells(8).CondMov.idtet{4} = cellnames{27};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{27},CoonditioningFreezingEpoch),...
    Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
    Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).CondFreeze.map{4} = map;
SelectedPlaceCells(8).CondFreeze.stats{4} = stats;
SelectedPlaceCells(8).CondFreeze.px{4} = px;
SelectedPlaceCells(8).CondFreeze.py{4} = py;
SelectedPlaceCells(8).CondFreeze.FR{4} = FR;
SelectedPlaceCells(8).CondFreeze.PrField{4} = PrField;
SelectedPlaceCells(8).CondFreeze.idtet{4} = cellnames{27};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{27},AfterConditioningMovingEpoch),...
    Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(8).AfterCond.map{4} = map;
SelectedPlaceCells(8).AfterCond.stats{4} = stats;
SelectedPlaceCells(8).AfterCond.px{4} = px;
SelectedPlaceCells(8).AfterCond.py{4} = py;
SelectedPlaceCells(8).AfterCond.FR{4} = FR;
SelectedPlaceCells(8).AfterCond.PrField{4} = PrField;
SelectedPlaceCells(8).AfterCond.idtet{4} = cellnames{27};

% Ripples during CondFreezing
if ~isempty(Data(Restrict(ripts,CoonditioningFreezingEpoch)))
    [map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB...
        (Restrict(ripts,CoonditioningFreezingEpoch),...
        Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
        Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
    SelectedPlaceCells(8).CondFreezeRipples.map = map;
    SelectedPlaceCells(8).CondFreezeRipples.stats = stats;
    SelectedPlaceCells(8).CondFreezeRipples.px = px;
    SelectedPlaceCells(8).CondFreezeRipples.py = py;
    SelectedPlaceCells(8).CondFreezeRipples.FR = FR;
    SelectedPlaceCells(8).CondFreezeRipples.PrField = PrField;
else
    SelectedPlaceCells(8).CondFreezeRipples.map = [];
    SelectedPlaceCells(8).CondFreezeRipples.stats = [];
    SelectedPlaceCells(8).CondFreezeRipples.px = [];
    SelectedPlaceCells(8).CondFreezeRipples.py = [];
    SelectedPlaceCells(8).CondFreezeRipples.FR = [];
    SelectedPlaceCells(8).CondFreezeRipples.PrField = [];
end

% Clear
clearvars -except SelectedPlaceCells smoo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% go to M911
cd('/media/nas5/ProjetERC2/Mouse-911/20190508/_Concatenated/')
load('SpikeData.mat')
load('behavResources.mat')
load('Ripples.mat')
% Get ripples
ripts = ts(ripples(:,2)*1e4);

%Split Hab in halves
st = Start(SessionEpoch.Hab);
en = End(SessionEpoch.Hab);
Hab1Half = intervalSet(st,((en-st)/2)+st);
Hab2Half = intervalSet(((en-st)/2)+st,en);

% BaselineExplo Epoch
UMazeEpoch = or(SessionEpoch.Hab,SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre4);

% Conditioning
ConditioningEpoch = or(SessionEpoch.Cond1,SessionEpoch.Cond2);
ConditioningEpoch = or(ConditioningEpoch,SessionEpoch.Cond3);
ConditioningEpoch = or(ConditioningEpoch,SessionEpoch.Cond4);

% After Conditioning
AfterConditioningEpoch = or(SessionEpoch.TestPost1,SessionEpoch.TestPost2);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost3);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost4);

% Locomotion threshold
LocomotionEpoch = thresholdIntervals(tsd(Range(Vtsd),movmedian(Data(Vtsd),5)),3,'Direction','Above');

% Get resulting epochs
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);
MovingHab1Half = and(LocomotionEpoch,Hab1Half);
MovingHab2Half = and(LocomotionEpoch,Hab2Half);
ConditioningMovingEpoch = and(LocomotionEpoch, ConditioningEpoch);
CoonditioningFreezingEpoch = and(FreezeAccEpoch, ConditioningEpoch);

% Found four place cells - 5, 8, 17, and 18
SelectedPlaceCells(9).name = 'Mouse911';

% PC1
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{5},UMazeMovingEpoch),...
    Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).BeforeCond.map{1} = map;
SelectedPlaceCells(9).BeforeCond.stats{1} = stats;
SelectedPlaceCells(9).BeforeCond.px{1} = px;
SelectedPlaceCells(9).BeforeCond.py{1} = py;
SelectedPlaceCells(9).BeforeCond.FR{1} = FR;
SelectedPlaceCells(9).BeforeCond.PrField{1} = PrField;
SelectedPlaceCells(9).BeforeCond.idtet{1} = cellnames{5};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{5},MovingHab1Half),...
    Restrict(AlignedXtsd, MovingHab1Half),...
    Restrict(AlignedYtsd, MovingHab1Half), 'smoothing',2.5, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).Hab1Half.map{1} = map;
SelectedPlaceCells(9).Hab1Half.stats{1} = stats;
SelectedPlaceCells(9).Hab1Half.px{1} = px;
SelectedPlaceCells(9).Hab1Half.py{1} = py;
SelectedPlaceCells(9).Hab1Half.FR{1} = FR;
SelectedPlaceCells(9).Hab1Half.PrField{1} = PrField;
SelectedPlaceCells(9).Hab1Half.idtet{1} = cellnames{5};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,~,pfH,pf] = PlaceField_DB(Restrict(S{5},MovingHab2Half),...
    Restrict(AlignedXtsd, MovingHab2Half),...
    Restrict(AlignedYtsd, MovingHab2Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).Hab2Half.map{1} = map;
SelectedPlaceCells(9).Hab2Half.stats{1} = stats;
SelectedPlaceCells(9).Hab2Half.px{1} = px;
SelectedPlaceCells(9).Hab2Half.py{1} = py;
SelectedPlaceCells(9).Hab2Half.FR{1} = FR;
SelectedPlaceCells(9).Hab2Half.PrField{1} = PrField;
SelectedPlaceCells(9).Hab2Half.idtet{1} = cellnames{5};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{5},ConditioningMovingEpoch),...
    Restrict(AlignedXtsd, ConditioningMovingEpoch),...
    Restrict(AlignedYtsd, ConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).CondMov.map{1} = map;
SelectedPlaceCells(9).CondMov.stats{1} = stats;
SelectedPlaceCells(9).CondMov.px{1} = px;
SelectedPlaceCells(9).CondMov.py{1} = py;
SelectedPlaceCells(9).CondMov.FR{1} = FR;
SelectedPlaceCells(9).CondMov.PrField{1} = PrField;
SelectedPlaceCells(9).CondMov.idtet{1} = cellnames{5};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{5},CoonditioningFreezingEpoch),...
    Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
    Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).CondFreeze.map{1} = map;
SelectedPlaceCells(9).CondFreeze.stats{1} = stats;
SelectedPlaceCells(9).CondFreeze.px{1} = px;
SelectedPlaceCells(9).CondFreeze.py{1} = py;
SelectedPlaceCells(9).CondFreeze.FR{1} = FR;
SelectedPlaceCells(9).CondFreeze.PrField{1} = PrField;
SelectedPlaceCells(9).CondFreeze.idtet{1} = cellnames{5};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{5},AfterConditioningMovingEpoch),...
    Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).AfterCond.map{1} = map;
SelectedPlaceCells(9).AfterCond.stats{1} = stats;
SelectedPlaceCells(9).AfterCond.px{1} = px;
SelectedPlaceCells(9).AfterCond.py{1} = py;
SelectedPlaceCells(9).AfterCond.FR{1} = FR;
SelectedPlaceCells(9).AfterCond.PrField{1} = PrField;
SelectedPlaceCells(9).AfterCond.idtet{1} = cellnames{5};

% PC2
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{8},UMazeMovingEpoch),...
    Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).BeforeCond.map{2} = map;
SelectedPlaceCells(9).BeforeCond.stats{2} = stats;
SelectedPlaceCells(9).BeforeCond.px{2} = px;
SelectedPlaceCells(9).BeforeCond.py{2} = py;
SelectedPlaceCells(9).BeforeCond.FR{2} = FR;
SelectedPlaceCells(9).BeforeCond.PrField{2} = PrField;
SelectedPlaceCells(9).BeforeCond.idtet{2} = cellnames{8};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{8},MovingHab1Half),...
    Restrict(AlignedXtsd, MovingHab1Half),...
    Restrict(AlignedYtsd, MovingHab1Half), 'smoothing',2.5, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).Hab1Half.map{2} = map;
SelectedPlaceCells(9).Hab1Half.stats{2} = stats;
SelectedPlaceCells(9).Hab1Half.px{2} = px;
SelectedPlaceCells(9).Hab1Half.py{2} = py;
SelectedPlaceCells(9).Hab1Half.FR{2} = FR;
SelectedPlaceCells(9).Hab1Half.PrField{2} = PrField;
SelectedPlaceCells(9).Hab1Half.idtet{2} = cellnames{8};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{8},MovingHab2Half),...
    Restrict(AlignedXtsd, MovingHab2Half),...
    Restrict(AlignedYtsd, MovingHab2Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).Hab2Half.map{2} = map;
SelectedPlaceCells(9).Hab2Half.stats{2} = stats;
SelectedPlaceCells(9).Hab2Half.px{2} = px;
SelectedPlaceCells(9).Hab2Half.py{2} = py;
SelectedPlaceCells(9).Hab2Half.FR{2} = FR;
SelectedPlaceCells(9).Hab2Half.PrField{2} = PrField;
SelectedPlaceCells(9).Hab2Half.idtet{2} = cellnames{8};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{8},ConditioningMovingEpoch),...
    Restrict(AlignedXtsd, ConditioningMovingEpoch),...
    Restrict(AlignedYtsd, ConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).CondMov.map{2} = map;
SelectedPlaceCells(9).CondMov.stats{2} = stats;
SelectedPlaceCells(9).CondMov.px{2} = px;
SelectedPlaceCells(9).CondMov.py{2} = py;
SelectedPlaceCells(9).CondMov.FR{2} = FR;
SelectedPlaceCells(9).CondMov.PrField{2} = PrField;
SelectedPlaceCells(9).CondMov.idtet{2} = cellnames{8};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{8},CoonditioningFreezingEpoch),...
    Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
    Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).CondFreeze.map{2} = map;
SelectedPlaceCells(9).CondFreeze.stats{2} = stats;
SelectedPlaceCells(9).CondFreeze.px{2} = px;
SelectedPlaceCells(9).CondFreeze.py{2} = py;
SelectedPlaceCells(9).CondFreeze.FR{2} = FR;
SelectedPlaceCells(9).CondFreeze.PrField{2} = PrField;
SelectedPlaceCells(9).CondFreeze.idtet{2} = cellnames{8};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{8},AfterConditioningMovingEpoch),...
    Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).AfterCond.map{2} = map;
SelectedPlaceCells(9).AfterCond.stats{2} = stats;
SelectedPlaceCells(9).AfterCond.px{2} = px;
SelectedPlaceCells(9).AfterCond.py{2} = py;
SelectedPlaceCells(9).AfterCond.FR{2} = FR;
SelectedPlaceCells(9).AfterCond.PrField{2} = PrField;
SelectedPlaceCells(9).AfterCond.idtet{2} = cellnames{8};

% PC3
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{17},UMazeMovingEpoch),...
    Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).BeforeCond.map{3} = map;
SelectedPlaceCells(9).BeforeCond.stats{3} = stats;
SelectedPlaceCells(9).BeforeCond.px{3} = px;
SelectedPlaceCells(9).BeforeCond.py{3} = py;
SelectedPlaceCells(9).BeforeCond.FR{3} = FR;
SelectedPlaceCells(9).BeforeCond.PrField{3} = PrField;
SelectedPlaceCells(9).BeforeCond.idtet{3} = cellnames{17};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{17},MovingHab1Half),...
    Restrict(AlignedXtsd, MovingHab1Half),...
    Restrict(AlignedYtsd, MovingHab1Half), 'smoothing',2.5, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).Hab1Half.map{3} = map;
SelectedPlaceCells(9).Hab1Half.stats{3} = stats;
SelectedPlaceCells(9).Hab1Half.px{3} = px;
SelectedPlaceCells(9).Hab1Half.py{3} = py;
SelectedPlaceCells(9).Hab1Half.FR{3} = FR;
SelectedPlaceCells(9).Hab1Half.PrField{3} = PrField;
SelectedPlaceCells(9).Hab1Half.idtet{3} = cellnames{17};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{17},MovingHab2Half),...
    Restrict(AlignedXtsd, MovingHab2Half),...
    Restrict(AlignedYtsd, MovingHab2Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).Hab2Half.map{3} = map;
SelectedPlaceCells(9).Hab2Half.stats{3} = stats;
SelectedPlaceCells(9).Hab2Half.px{3} = px;
SelectedPlaceCells(9).Hab2Half.py{3} = py;
SelectedPlaceCells(9).Hab2Half.FR{3} = FR;
SelectedPlaceCells(9).Hab2Half.PrField{3} = PrField;
SelectedPlaceCells(9).Hab2Half.idtet{3} = cellnames{17};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{17},ConditioningMovingEpoch),...
    Restrict(AlignedXtsd, ConditioningMovingEpoch),...
    Restrict(AlignedYtsd, ConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).CondMov.map{3} = map;
SelectedPlaceCells(9).CondMov.stats{3} = stats;
SelectedPlaceCells(9).CondMov.px{3} = px;
SelectedPlaceCells(9).CondMov.py{3} = py;
SelectedPlaceCells(9).CondMov.FR{3} = FR;
SelectedPlaceCells(9).CondMov.PrField{3} = PrField;
SelectedPlaceCells(9).CondMov.idtet{3} = cellnames{17};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{17},CoonditioningFreezingEpoch),...
    Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
    Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).CondFreeze.map{3} = map;
SelectedPlaceCells(9).CondFreeze.stats{3} = stats;
SelectedPlaceCells(9).CondFreeze.px{3} = px;
SelectedPlaceCells(9).CondFreeze.py{3} = py;
SelectedPlaceCells(9).CondFreeze.FR{3} = FR;
SelectedPlaceCells(9).CondFreeze.PrField{3} = PrField;
SelectedPlaceCells(9).CondFreeze.idtet{3} = cellnames{17};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{17},AfterConditioningMovingEpoch),...
    Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).AfterCond.map{3} = map;
SelectedPlaceCells(9).AfterCond.stats{3} = stats;
SelectedPlaceCells(9).AfterCond.px{3} = px;
SelectedPlaceCells(9).AfterCond.py{3} = py;
SelectedPlaceCells(9).AfterCond.FR{3} = FR;
SelectedPlaceCells(9).AfterCond.PrField{3} = PrField;
SelectedPlaceCells(9).AfterCond.idtet{3} = cellnames{17};

% PC4
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{18},UMazeMovingEpoch),...
    Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).BeforeCond.map{4} = map;
SelectedPlaceCells(9).BeforeCond.stats{4} = stats;
SelectedPlaceCells(9).BeforeCond.px{4} = px;
SelectedPlaceCells(9).BeforeCond.py{4} = py;
SelectedPlaceCells(9).BeforeCond.FR{4} = FR;
SelectedPlaceCells(9).BeforeCond.PrField{4} = PrField;
SelectedPlaceCells(9).BeforeCond.idtet{4} = cellnames{18};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{18},MovingHab1Half),...
    Restrict(AlignedXtsd, MovingHab1Half),...
    Restrict(AlignedYtsd, MovingHab1Half), 'smoothing',2.5, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).Hab1Half.map{4} = map;
SelectedPlaceCells(9).Hab1Half.stats{4} = stats;
SelectedPlaceCells(9).Hab1Half.px{4} = px;
SelectedPlaceCells(9).Hab1Half.py{4} = py;
SelectedPlaceCells(9).Hab1Half.FR{4} = FR;
SelectedPlaceCells(9).Hab1Half.PrField{4} = PrField;
SelectedPlaceCells(9).Hab1Half.idtet{4} = cellnames{18};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{18},MovingHab2Half),...
    Restrict(AlignedXtsd, MovingHab2Half),...
    Restrict(AlignedYtsd, MovingHab2Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).Hab2Half.map{4} = map;
SelectedPlaceCells(9).Hab2Half.stats{4} = stats;
SelectedPlaceCells(9).Hab2Half.px{4} = px;
SelectedPlaceCells(9).Hab2Half.py{4} = py;
SelectedPlaceCells(9).Hab2Half.FR{4} = FR;
SelectedPlaceCells(9).Hab2Half.PrField{4} = PrField;
SelectedPlaceCells(9).Hab2Half.idtet{4} = cellnames{18};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{18},ConditioningMovingEpoch),...
    Restrict(AlignedXtsd, ConditioningMovingEpoch),...
    Restrict(AlignedYtsd, ConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).CondMov.map{4} = map;
SelectedPlaceCells(9).CondMov.stats{4} = stats;
SelectedPlaceCells(9).CondMov.px{4} = px;
SelectedPlaceCells(9).CondMov.py{4} = py;
SelectedPlaceCells(9).CondMov.FR{4} = FR;
SelectedPlaceCells(9).CondMov.PrField{4} = PrField;
SelectedPlaceCells(9).CondMov.idtet{4} = cellnames{18};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{18},CoonditioningFreezingEpoch),...
    Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
    Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).CondFreeze.map{4} = map;
SelectedPlaceCells(9).CondFreeze.stats{4} = stats;
SelectedPlaceCells(9).CondFreeze.px{4} = px;
SelectedPlaceCells(9).CondFreeze.py{4} = py;
SelectedPlaceCells(9).CondFreeze.FR{4} = FR;
SelectedPlaceCells(9).CondFreeze.PrField{4} = PrField;
SelectedPlaceCells(9).CondFreeze.idtet{4} = cellnames{18};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{18},AfterConditioningMovingEpoch),...
    Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(9).AfterCond.map{4} = map;
SelectedPlaceCells(9).AfterCond.stats{4} = stats;
SelectedPlaceCells(9).AfterCond.px{4} = px;
SelectedPlaceCells(9).AfterCond.py{4} = py;
SelectedPlaceCells(9).AfterCond.FR{4} = FR;
SelectedPlaceCells(9).AfterCond.PrField{4} = PrField;
SelectedPlaceCells(9).AfterCond.idtet{4} = cellnames{18};

% Ripples during CondFreezing
if ~isempty(Data(Restrict(ripts,CoonditioningFreezingEpoch)))
    [map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB...
        (Restrict(ripts,CoonditioningFreezingEpoch),...
        Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
        Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
    SelectedPlaceCells(9).CondFreezeRipples.map = map;
    SelectedPlaceCells(9).CondFreezeRipples.stats = stats;
    SelectedPlaceCells(9).CondFreezeRipples.px = px;
    SelectedPlaceCells(9).CondFreezeRipples.py = py;
    SelectedPlaceCells(9).CondFreezeRipples.FR = FR;
    SelectedPlaceCells(9).CondFreezeRipples.PrField = PrField;
else
    SelectedPlaceCells(9).CondFreezeRipples.map = [];
    SelectedPlaceCells(9).CondFreezeRipples.stats = [];
    SelectedPlaceCells(9).CondFreezeRipples.px = [];
    SelectedPlaceCells(9).CondFreezeRipples.py = [];
    SelectedPlaceCells(9).CondFreezeRipples.FR = [];
    SelectedPlaceCells(9).CondFreezeRipples.PrField = [];
end

% Clear
clearvars -except SelectedPlaceCells smoo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% go to M912
cd('/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/')
load('SpikeData.mat')
load('behavResources.mat')
load('Ripples.mat')
% Get ripples
ripts = ts(ripples(:,2)*1e4);

% % PosMatInit
% InitX = tsd(Range(Xtsd),PosMatInit(:,2));
% InitY = tsd(Range(Ytsd),PosMatInit(:,3));

%Split Hab in halves
st = Start(SessionEpoch.Hab);
en = End(SessionEpoch.Hab);
Hab1Half = intervalSet(st,((en-st)/2)+st);
Hab2Half = intervalSet(((en-st)/2)+st,en);

% BaselineExplo Epoch
UMazeEpoch = or(SessionEpoch.Hab,SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre4);

% Conditioning
ConditioningEpoch = or(SessionEpoch.Cond1,SessionEpoch.Cond2);
ConditioningEpoch = or(ConditioningEpoch,SessionEpoch.Cond3);
ConditioningEpoch = or(ConditioningEpoch,SessionEpoch.Cond4);

% After Conditioning
AfterConditioningEpoch = or(SessionEpoch.TestPost1,SessionEpoch.TestPost2);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost3);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost4);

% Locomotion threshold
VtsdSmoothed  = tsd(Range(Vtsd),movmedian(Data(Vtsd),5));
LocomotionEpoch = thresholdIntervals(VtsdSmoothed,3,'Direction','Above');

% Get resulting epochs
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);
MovingHab1Half = and(LocomotionEpoch,Hab1Half);
MovingHab2Half = and(LocomotionEpoch,Hab2Half);
ConditioningMovingEpoch = and(LocomotionEpoch, ConditioningEpoch);
CoonditioningFreezingEpoch = and(FreezeAccEpoch, ConditioningEpoch);

% Found four (six?) place cells - [19 20]?, 56, 58, 61, 62? and 63
SelectedPlaceCells(10).name = 'Mouse912';

PlaceField_DB(Restrict(PoolNeurons(S, [19:22]),UMazeMovingEpoch), Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
PlaceField_DB(Restrict(PoolNeurons(S, [19:22]),AfterConditioningMovingEpoch),...
    Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);

% PC1
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{56},UMazeMovingEpoch),...
    Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).BeforeCond.map{1} = map;
SelectedPlaceCells(10).BeforeCond.stats{1} = stats;
SelectedPlaceCells(10).BeforeCond.px{1} = px;
SelectedPlaceCells(10).BeforeCond.py{1} = py;
SelectedPlaceCells(10).BeforeCond.FR{1} = FR;
SelectedPlaceCells(10).BeforeCond.PrField{1} = PrField;
SelectedPlaceCells(10).BeforeCond.idtet{1} = cellnames{56};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{56},MovingHab1Half),...
    Restrict(AlignedXtsd, MovingHab1Half),...
    Restrict(AlignedYtsd, MovingHab1Half), 'smoothing',2.5, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).Hab1Half.map{1} = map;
SelectedPlaceCells(10).Hab1Half.stats{1} = stats;
SelectedPlaceCells(10).Hab1Half.px{1} = px;
SelectedPlaceCells(10).Hab1Half.py{1} = py;
SelectedPlaceCells(10).Hab1Half.FR{1} = FR;
SelectedPlaceCells(10).Hab1Half.PrField{1} = PrField;
SelectedPlaceCells(10).Hab1Half.idtet{1} = cellnames{56};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{56},MovingHab2Half),...
    Restrict(AlignedXtsd, MovingHab2Half),...
    Restrict(AlignedYtsd, MovingHab2Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).Hab2Half.map{1} = map;
SelectedPlaceCells(10).Hab2Half.stats{1} = stats;
SelectedPlaceCells(10).Hab2Half.px{1} = px;
SelectedPlaceCells(10).Hab2Half.py{1} = py;
SelectedPlaceCells(10).Hab2Half.FR{1} = FR;
SelectedPlaceCells(10).Hab2Half.PrField{1} = PrField;
SelectedPlaceCells(10).Hab2Half.idtet{1} = cellnames{56};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{56},ConditioningMovingEpoch),...
    Restrict(AlignedXtsd, ConditioningMovingEpoch),...
    Restrict(AlignedYtsd, ConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).CondMov.map{1} = map;
SelectedPlaceCells(10).CondMov.stats{1} = stats;
SelectedPlaceCells(10).CondMov.px{1} = px;
SelectedPlaceCells(10).CondMov.py{1} = py;
SelectedPlaceCells(10).CondMov.FR{1} = FR;
SelectedPlaceCells(10).CondMov.PrField{1} = PrField;
SelectedPlaceCells(10).CondMov.idtet{1} = cellnames{56};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{56},CoonditioningFreezingEpoch),...
    Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
    Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).CondFreeze.map{1} = map;
SelectedPlaceCells(10).CondFreeze.stats{1} = stats;
SelectedPlaceCells(10).CondFreeze.px{1} = px;
SelectedPlaceCells(10).CondFreeze.py{1} = py;
SelectedPlaceCells(10).CondFreeze.FR{1} = FR;
SelectedPlaceCells(10).CondFreeze.PrField{1} = PrField;
SelectedPlaceCells(10).CondFreeze.idtet{1} = cellnames{56};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{56},AfterConditioningMovingEpoch),...
    Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).AfterCond.map{1} = map;
SelectedPlaceCells(10).AfterCond.stats{1} = stats;
SelectedPlaceCells(10).AfterCond.px{1} = px;
SelectedPlaceCells(10).AfterCond.py{1} = py;
SelectedPlaceCells(10).AfterCond.FR{1} = FR;
SelectedPlaceCells(10).AfterCond.PrField{1} = PrField;
SelectedPlaceCells(10).AfterCond.idtet{1} = cellnames{56};

% PC2
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{58},UMazeMovingEpoch),...
    Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).BeforeCond.map{2} = map;
SelectedPlaceCells(10).BeforeCond.stats{2} = stats;
SelectedPlaceCells(10).BeforeCond.px{2} = px;
SelectedPlaceCells(10).BeforeCond.py{2} = py;
SelectedPlaceCells(10).BeforeCond.FR{2} = FR;
SelectedPlaceCells(10).BeforeCond.PrField{2} = PrField;
SelectedPlaceCells(10).BeforeCond.idtet{2} = cellnames{58};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{58},MovingHab1Half),...
    Restrict(AlignedXtsd, MovingHab1Half),...
    Restrict(AlignedYtsd, MovingHab1Half), 'smoothing',2.5, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).Hab1Half.map{2} = map;
SelectedPlaceCells(10).Hab1Half.stats{2} = stats;
SelectedPlaceCells(10).Hab1Half.px{2} = px;
SelectedPlaceCells(10).Hab1Half.py{2} = py;
SelectedPlaceCells(10).Hab1Half.FR{2} = FR;
SelectedPlaceCells(10).Hab1Half.PrField{2} = PrField;
SelectedPlaceCells(10).Hab1Half.idtet{2} = cellnames{58};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{58},MovingHab2Half),...
    Restrict(AlignedXtsd, MovingHab2Half),...
    Restrict(AlignedYtsd, MovingHab2Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).Hab2Half.map{2} = map;
SelectedPlaceCells(10).Hab2Half.stats{2} = stats;
SelectedPlaceCells(10).Hab2Half.px{2} = px;
SelectedPlaceCells(10).Hab2Half.py{2} = py;
SelectedPlaceCells(10).Hab2Half.FR{2} = FR;
SelectedPlaceCells(10).Hab2Half.PrField{2} = PrField;
SelectedPlaceCells(10).Hab2Half.idtet{2} = cellnames{58};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{58},ConditioningMovingEpoch),...
    Restrict(AlignedXtsd, ConditioningMovingEpoch),...
    Restrict(AlignedYtsd, ConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).CondMov.map{2} = map;
SelectedPlaceCells(10).CondMov.stats{2} = stats;
SelectedPlaceCells(10).CondMov.px{2} = px;
SelectedPlaceCells(10).CondMov.py{2} = py;
SelectedPlaceCells(10).CondMov.FR{2} = FR;
SelectedPlaceCells(10).CondMov.PrField{2} = PrField;
SelectedPlaceCells(10).CondMov.idtet{2} = cellnames{58};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{58},CoonditioningFreezingEpoch),...
    Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
    Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).CondFreeze.map{2} = map;
SelectedPlaceCells(10).CondFreeze.stats{2} = stats;
SelectedPlaceCells(10).CondFreeze.px{2} = px;
SelectedPlaceCells(10).CondFreeze.py{2} = py;
SelectedPlaceCells(10).CondFreeze.FR{2} = FR;
SelectedPlaceCells(10).CondFreeze.PrField{2} = PrField;
SelectedPlaceCells(10).CondFreeze.idtet{2} = cellnames{58};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{58},AfterConditioningMovingEpoch),...
    Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).AfterCond.map{2} = map;
SelectedPlaceCells(10).AfterCond.stats{2} = stats;
SelectedPlaceCells(10).AfterCond.px{2} = px;
SelectedPlaceCells(10).AfterCond.py{2} = py;
SelectedPlaceCells(10).AfterCond.FR{2} = FR;
SelectedPlaceCells(10).AfterCond.PrField{2} = PrField;
SelectedPlaceCells(10).AfterCond.idtet{2} = cellnames{58};

% PC3
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{61},UMazeMovingEpoch),...
    Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).BeforeCond.map{3} = map;
SelectedPlaceCells(10).BeforeCond.stats{3} = stats;
SelectedPlaceCells(10).BeforeCond.px{3} = px;
SelectedPlaceCells(10).BeforeCond.py{3} = py;
SelectedPlaceCells(10).BeforeCond.FR{3} = FR;
SelectedPlaceCells(10).BeforeCond.PrField{3} = PrField;
SelectedPlaceCells(10).BeforeCond.idtet{3} = cellnames{61};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{61},MovingHab1Half),...
    Restrict(AlignedXtsd, MovingHab1Half),...
    Restrict(AlignedYtsd, MovingHab1Half), 'smoothing',2.5, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).Hab1Half.map{3} = map;
SelectedPlaceCells(10).Hab1Half.stats{3} = stats;
SelectedPlaceCells(10).Hab1Half.px{3} = px;
SelectedPlaceCells(10).Hab1Half.py{3} = py;
SelectedPlaceCells(10).Hab1Half.FR{3} = FR;
SelectedPlaceCells(10).Hab1Half.PrField{3} = PrField;
SelectedPlaceCells(10).Hab1Half.idtet{3} = cellnames{61};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{61},MovingHab2Half),...
    Restrict(AlignedXtsd, MovingHab2Half),...
    Restrict(AlignedYtsd, MovingHab2Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).Hab2Half.map{3} = map;
SelectedPlaceCells(10).Hab2Half.stats{3} = stats;
SelectedPlaceCells(10).Hab2Half.px{3} = px;
SelectedPlaceCells(10).Hab2Half.py{3} = py;
SelectedPlaceCells(10).Hab2Half.FR{3} = FR;
SelectedPlaceCells(10).Hab2Half.PrField{3} = PrField;
SelectedPlaceCells(10).Hab2Half.idtet{3} = cellnames{61};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{61},ConditioningMovingEpoch),...
    Restrict(AlignedXtsd, ConditioningMovingEpoch),...
    Restrict(AlignedYtsd, ConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).CondMov.map{3} = map;
SelectedPlaceCells(10).CondMov.stats{3} = stats;
SelectedPlaceCells(10).CondMov.px{3} = px;
SelectedPlaceCells(10).CondMov.py{3} = py;
SelectedPlaceCells(10).CondMov.FR{3} = FR;
SelectedPlaceCells(10).CondMov.PrField{3} = PrField;
SelectedPlaceCells(10).CondMov.idtet{3} = cellnames{61};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{61},CoonditioningFreezingEpoch),...
    Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
    Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).CondFreeze.map{3} = map;
SelectedPlaceCells(10).CondFreeze.stats{3} = stats;
SelectedPlaceCells(10).CondFreeze.px{3} = px;
SelectedPlaceCells(10).CondFreeze.py{3} = py;
SelectedPlaceCells(10).CondFreeze.FR{3} = FR;
SelectedPlaceCells(10).CondFreeze.PrField{3} = PrField;
SelectedPlaceCells(10).CondFreeze.idtet{3} = cellnames{61};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{61},AfterConditioningMovingEpoch),...
    Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).AfterCond.map{3} = map;
SelectedPlaceCells(10).AfterCond.stats{3} = stats;
SelectedPlaceCells(10).AfterCond.px{3} = px;
SelectedPlaceCells(10).AfterCond.py{3} = py;
SelectedPlaceCells(10).AfterCond.FR{3} = FR;
SelectedPlaceCells(10).AfterCond.PrField{3} = PrField;
SelectedPlaceCells(10).AfterCond.idtet{3} = cellnames{61};

%%%
PlaceField_DB(Restrict(S{62},UMazeMovingEpoch), Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
PlaceField_DB(Restrict(S{62},AfterConditioningMovingEpoch), Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
%%%

% PC4
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField_DB(Restrict(S{63},UMazeMovingEpoch),...
    Restrict(AlignedXtsd, UMazeMovingEpoch),...
    Restrict(AlignedYtsd, UMazeMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).BeforeCond.map{4} = map;
SelectedPlaceCells(10).BeforeCond.stats{4} = stats;
SelectedPlaceCells(10).BeforeCond.px{4} = px;
SelectedPlaceCells(10).BeforeCond.py{4} = py;
SelectedPlaceCells(10).BeforeCond.FR{4} = FR;
SelectedPlaceCells(10).BeforeCond.PrField{4} = PrField;
SelectedPlaceCells(10).BeforeCond.idtet{4} = cellnames{63};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{63},MovingHab1Half),...
    Restrict(AlignedXtsd, MovingHab1Half),...
    Restrict(AlignedYtsd, MovingHab1Half), 'smoothing',2.5, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).Hab1Half.map{4} = map;
SelectedPlaceCells(10).Hab1Half.stats{4} = stats;
SelectedPlaceCells(10).Hab1Half.px{4} = px;
SelectedPlaceCells(10).Hab1Half.py{4} = py;
SelectedPlaceCells(10).Hab1Half.FR{4} = FR;
SelectedPlaceCells(10).Hab1Half.PrField{4} = PrField;
SelectedPlaceCells(10).Hab1Half.idtet{4} = cellnames{63};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{63},MovingHab2Half),...
    Restrict(AlignedXtsd, MovingHab2Half),...
    Restrict(AlignedYtsd, MovingHab2Half), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).Hab2Half.map{4} = map;
SelectedPlaceCells(10).Hab2Half.stats{4} = stats;
SelectedPlaceCells(10).Hab2Half.px{4} = px;
SelectedPlaceCells(10).Hab2Half.py{4} = py;
SelectedPlaceCells(10).Hab2Half.FR{4} = FR;
SelectedPlaceCells(10).Hab2Half.PrField{4} = PrField;
SelectedPlaceCells(10).Hab2Half.idtet{4} = cellnames{63};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{63},ConditioningMovingEpoch),...
    Restrict(AlignedXtsd, ConditioningMovingEpoch),...
    Restrict(AlignedYtsd, ConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).CondMov.map{4} = map;
SelectedPlaceCells(10).CondMov.stats{4} = stats;
SelectedPlaceCells(10).CondMov.px{4} = px;
SelectedPlaceCells(10).CondMov.py{4} = py;
SelectedPlaceCells(10).CondMov.FR{4} = FR;
SelectedPlaceCells(10).CondMov.PrField{4} = PrField;
SelectedPlaceCells(10).CondMov.idtet{4} = cellnames{63};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{63},CoonditioningFreezingEpoch),...
    Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
    Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).CondFreeze.map{4} = map;
SelectedPlaceCells(10).CondFreeze.stats{4} = stats;
SelectedPlaceCells(10).CondFreeze.px{4} = px;
SelectedPlaceCells(10).CondFreeze.py{4} = py;
SelectedPlaceCells(10).CondFreeze.FR{4} = FR;
SelectedPlaceCells(10).CondFreeze.PrField{4} = PrField;
SelectedPlaceCells(10).CondFreeze.idtet{4} = cellnames{63};

[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB(Restrict(S{63},AfterConditioningMovingEpoch),...
    Restrict(AlignedXtsd, AfterConditioningMovingEpoch),...
    Restrict(AlignedYtsd, AfterConditioningMovingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
SelectedPlaceCells(10).AfterCond.map{4} = map;
SelectedPlaceCells(10).AfterCond.stats{4} = stats;
SelectedPlaceCells(10).AfterCond.px{4} = px;
SelectedPlaceCells(10).AfterCond.py{4} = py;
SelectedPlaceCells(10).AfterCond.FR{4} = FR;
SelectedPlaceCells(10).AfterCond.PrField{4} = PrField;
SelectedPlaceCells(10).AfterCond.idtet{4} = cellnames{63};

% Ripples during CondFreezing
if ~isempty(Data(Restrict(ripts,CoonditioningFreezingEpoch)))
    [map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf] = PlaceField_DB...
        (Restrict(ripts,CoonditioningFreezingEpoch),...
        Restrict(AlignedXtsd, CoonditioningFreezingEpoch),...
        Restrict(AlignedYtsd, CoonditioningFreezingEpoch), 'smoothing', smoo, 'size', 75, 'plotresults',0);
    SelectedPlaceCells(10).CondFreezeRipples.map = map;
    SelectedPlaceCells(10).CondFreezeRipples.stats = stats;
    SelectedPlaceCells(10).CondFreezeRipples.px = px;
    SelectedPlaceCells(10).CondFreezeRipples.py = py;
    SelectedPlaceCells(10).CondFreezeRipples.FR = FR;
    SelectedPlaceCells(10).CondFreezeRipples.PrField = PrField;
else
    SelectedPlaceCells(10).CondFreezeRipples.map = [];
    SelectedPlaceCells(10).CondFreezeRipples.stats = [];
    SelectedPlaceCells(10).CondFreezeRipples.px = [];
    SelectedPlaceCells(10).CondFreezeRipples.py = [];
    SelectedPlaceCells(10).CondFreezeRipples.FR = [];
    SelectedPlaceCells(10).CondFreezeRipples.PrField = [];
end

% Clear
clearvars -except SelectedPlaceCells smoo

%% Save
save('/home/mobsrick/Dropbox/MOBS_workingON/Dima/SelectedPlaceCells.mat', 'SelectedPlaceCells');

%% Plot

close all
% PlotPCExamples