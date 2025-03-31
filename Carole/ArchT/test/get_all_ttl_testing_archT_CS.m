clear all
Mice=[915,916,917,918,919,920];
i=6;
mouse_num=Mice(i);
path=strcat('/media/gruffalo/09E7077B1FE07CCB/ARCHT/ArchT/', num2str(mouse_num), '/test');
cd(path)
load('ExpeInfo.mat');
load('behavResources.mat');



%% ON epoch
ONChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'ONOFF')));
load(['LFPData/DigInfo',num2str(ONChannel),'.mat']); 
%plot(Range(DigTSD, 's'), Data(DigTSD)*100)
Epoch.ONEpoch=thresholdIntervals(DigTSD,0.9,'Direction','Above');

%% cs+
ToneChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'CS+Tone')));
load(['LFPData/DigInfo',num2str(ToneChannel),'.mat']);
%plot(Range(DigTSD, 's'), Data(DigTSD)*100)
ToneEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
AllToneTTL = Start(ToneEpoch);
%% Cs-

WNChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'CS-WN')));
load(['LFPData/DigInfo',num2str(WNChannel),'.mat']);
%plot(Range(DigTSD, 's'), Data(DigTSD)*100)
WNEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
AllWNTTL = Start(WNEpoch);
%%

TTLInfo.AllToneTTL=AllToneTTL;
TTLInfo.AllWNTTL=AllWNTTL;

% 1er son de chaque série de 27 bip

CSMoinsTTL=[AllWNTTL(1)];
for k=2:length(AllWNTTL)-1
    if AllWNTTL(k)-AllWNTTL(k-1)>2*1e4
       CSMoinsTTL=[CSMoinsTTL; AllWNTTL(k)];
    end
end

CSPlusTTL=[AllToneTTL(1)];
for k=2:length(AllToneTTL)-1
    if AllToneTTL(k)-AllToneTTL(k-1)>2*1e4
        CSPlusTTL=[CSPlusTTL; AllToneTTL(k)];
    end
end

TTLInfo.CSMoinsTTL=CSMoinsTTL;
TTLInfo.CSPlusTTL=CSPlusTTL;

save('behavResources.mat','TTLInfo','-append');

%% cs+ et - epochs 

Epoch.CSPlus_14=intervalSet(TTLInfo.CSPlusTTL(1:4), TTLInfo.CSPlusTTL(1:4)+45*1e4);
Epoch.CSPlus_12=intervalSet(TTLInfo.CSPlusTTL(1:2), TTLInfo.CSPlusTTL(1:2)+45*1e4);
Epoch.CSPlus_34=intervalSet(TTLInfo.CSPlusTTL(3:4), TTLInfo.CSPlusTTL(3:4)+45*1e4);
Epoch.CSPlus_all=intervalSet(TTLInfo.CSPlusTTL, TTLInfo.CSPlusTTL+45*1e4);
Epoch.CSMoins=intervalSet(TTLInfo.CSMoinsTTL, TTLInfo.CSMoinsTTL+45*1e4);

%% laser epoch
LaserChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'Laser')));
load(['LFPData/DigInfo',num2str(LaserChannel),'.mat']);
%plot(Range(DigTSD, 's'), Data(DigTSD)*100)
LaserOn = thresholdIntervals(DigTSD,0.9,'Direction','Above');
%%
AlllaserTTL = Start(LaserOn);
LaserTTL=[AlllaserTTL(1)];
for k=2:length(AlllaserTTL)
    if AlllaserTTL(k)-LaserTTL(length(LaserTTL))>46*1e4
        LaserTTL=[LaserTTL; AlllaserTTL(k)];
    end
end
Epoch.LaserON=intervalSet(LaserTTL, LaserTTL+45*1e4);
Epoch.LaserOFF = Epoch.ONEpoch-Epoch.LaserON;

%% detect freezing with accelerometer

%smoofact=10;
smoofact_Acc = 30;
th_immob_Acc = 20000000;
thtps_immob=2;
save('behavResources.mat','th_immob_Acc','-append');
     
NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
%% freeze et non freeze epoch
Epoch.FreezeAcc=FreezeAccEpoch;
Epoch.Non_FreezeAcc=Epoch.ONEpoch-Epoch.FreezeAcc;

save('Epoch', 'Epoch');

