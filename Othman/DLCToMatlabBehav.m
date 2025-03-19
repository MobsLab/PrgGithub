% 'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
% 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...


Dir = PathForExperimentsEmbReact('UMazeCondExplo_PreDrug')
% cd(Dir.path{2}{2})
% cd(Dir.path{2}{1})
cd(Dir.path{3}{2})
cd(Dir.path{4}{1})
cd(Dir.path{4}{2})
cd(Dir.path{5}{1})
cd(Dir.path{5}{2})

load('behavResources.mat', 'GotFrame')

load('behavResources_SB.mat')
[filename,pathname]=uigetfile('*.csv','Select the DeepLabCut tracking file')
DLC=csvread(fullfile(pathname,filename),3); %loads the csv from line 3 to the end (to skip the Header)
% Extract the body parts coordinates
NosePos_X = DLC(:,2);
NosePos_Y = DLC(:,3);
NeckPos_X = DLC(:,5);
NeckPos_Y = DLC(:,6);
CntrPos_X = DLC(:,8);
CntrPos_Y = DLC(:,9);
TailBase_X = DLC(:,11);
TailBase_Y = DLC(:,12);
TailCntr_X = DLC(:,14);
TailCntr_Y = DLC(:,15);
TailTip_X = DLC(:,17);
TailTip_Y = DLC(:,18);


% Convert to cm
plot(NosePos_X/Params.Ratio_IMAonREAL,NosePos_Y/Params.Ratio_IMAonREAL)
Behav.Xtsd_Nose = tsd(Range(Behav.Xtsd),NosePos_X/Params.Ratio_IMAonREAL);
Behav.Ytsd_Nose = tsd(Range(Behav.Xtsd),NosePos_Y/Params.Ratio_IMAonREAL);

% Get aaligned coordinates
x = Params.XYOutput(1,:);
y = Params.XYOutput(2,:);

% Transformation of coordinates
Coord1 = [x(2)-x(1),y(2)-y(1)];
Coord2 = [x(3)-x(1),y(3)-y(1)];
TranssMat = [Coord1',Coord2'];
XInit = (NosePos_X)-x(1);
YInit = (NosePos_Y)-y(1);

% Creating the frames time stamps

MissedFrame=find(GotFrame==0);
VideoTimes=Range(Behav.Xtsd); 
VideoTimes(MissedFrame,:)=[];


% The Xtsd and Ytsd in new coordinates
A = ((pinv(TranssMat)*[XInit,YInit]')');
Behav.AlignedXtsd_Nose = tsd(VideoTimes,NosePos_X);
Behav.AlignedYtsd_Nose = tsd(VideoTimes,NosePos_Y);
Behav.AlignedXtsd_Neck = tsd(VideoTimes,NeckPos_X);
Behav.AlignedYtsd_Neck = tsd(VideoTimes,NeckPos_Y);
Behav.AlignedXtsd_Cntr = tsd(VideoTimes,CntrPos_X);
Behav.AlignedYtsd_Cntr = tsd(VideoTimes,CntrPos_Y);
Behav.AlignedXtsd_TailBase = tsd(VideoTimes,TailBase_X);
Behav.AlignedYtsd_TailBase = tsd(VideoTimes,TailBase_Y);
Behav.AlignedXtsd_TailCntr = tsd(VideoTimes,TailCntr_X);
Behav.AlignedYtsd_TailCntr = tsd(VideoTimes,TailCntr_Y);
Behav.AlignedXtsd_TailTip = tsd(VideoTimes,TailTip_X);
Behav.AlignedYtsd_TailTip = tsd(VideoTimes,TailTip_Y);

%Suppose that TailTemperature is the temperature extracted from video + DLC
%tracking
TailTemperature=TailTemperature(TailBase_X,TailBase_Y,TailCntr_X,TailCntr_Y);
[Temp_tail_InDegrees]=IR2DEG(cd,TailTemperature);
Behav.TailTemperatureTSD=tsd(VideoTimes,Temp_tail_InDegrees');

TempSafeFreeze=mean(Data(Restrict(Behav.TailTemperatureTSD,and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{2}))));
TempFreeze=mean(Data(Restrict(Behav.TailTemperatureTSD,Behav.FreezeAccEpoch)));
TempShockZone=mean(Data(Restrict(Behav.TailTemperatureTSD,Behav.ZoneEpoch{1})));
TempSafeZone=mean(Data(Restrict(Behav.TailTemperatureTSD,Behav.ZoneEpoch{2})));
AvgTemp=mean(Data(Behav.TailTemperatureTSD));

EpochOfInterest = intervalSet([0,60]*1e4,[60,120]*1e4,[120,180]*1e4,[180,240]*1e4);


Start(and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{1}))
Start(and(FreezeAccEpoch,ZoneEpoch{1}))


%Pour avoir les Risk Assessment Epochs validés par le scoreur (score 2) :
GoodEpoch  = subset(Behav.RAEpoch.ToShock,find(Behav.RAUser.ToShock==2));
