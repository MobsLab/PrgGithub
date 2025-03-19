Mice=[873, 874, 891];
i=3
mouse_num=Mice(i);
path=strcat('/media/vador/09E7077B1FE07CCB/DREADD/', num2str(mouse_num), '/cond/day2_sleep_ext_sleep');
cd(path)
load('ExpeInfo.mat');
load('behavResources.mat');

%% differents evennements de la journée tous les TTL sont mis en sec
    
if mouse_num==873
    start=tpsCatEvt{1};
    instant_inj=8700;
    instant_extinction=tpsCatEvt{2};
    instant_post_extinction=tpsCatEvt{4};
    End=tpsCatEvt{length(tpsCatEvt)};
else
    start=tpsCatEvt{1};
    instant_inj=tpsCatEvt{2};
    instant_extinction=tpsCatEvt{4};
    instant_post_extinction=tpsCatEvt{6};
    End=tpsCatEvt{length(tpsCatEvt)};
end

TTLInfo.StartTTL=start;
TTLInfo.InjectTTL=instant_inj;
TTLInfo.ExtTTL=instant_extinction;
TTLInfo.PostExtTTL=instant_post_extinction;
TTLInfo.EndTTL=End;


%% sons pendant l'extinction en sec

% trouver tous les sons
%cs+
ToneChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'CS+Tone')));
load(['LFPData/DigInfo',num2str(ToneChannel),'.mat']);
ToneEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
AllToneTTL = Start(ToneEpoch);
AllToneTTL_bon=AllToneTTL*1e-4;
AllToneTTL=AllToneTTL_bon;

%Cs-

WNChannel = find(~cellfun(@isempty,strfind(ExpeInfo.DigID,'CS-WN')));
load(['LFPData/DigInfo',num2str(WNChannel),'.mat']);
WNEpoch = thresholdIntervals(DigTSD,0.9,'Direction','Above');
AllWNTTL = Start(WNEpoch);
AllWNTTL_bon=AllWNTTL*1e-4;
AllWNTTL=AllWNTTL_bon;

if mouse_num==874 | mouse_num==891
    AllWNTTL_bon=[];
    for k=1:length(AllWNTTL)
        if AllWNTTL(k)>TTLInfo.ExtTTL & AllWNTTL(k)<TTLInfo.PostExtTTL
           AllWNTTL_bon=[AllWNTTL_bon AllWNTTL(k)];
        end
    end
    AllWNTTL=AllWNTTL_bon';
end

TTLInfo.AllToneTTL=AllToneTTL;
TTLInfo.AllWNTTL=AllWNTTL;

% 1er son de chaque série de 27 bip

CSMoinsTTL=[AllWNTTL(1)];
for k=2:length(AllWNTTL)-1
    if AllWNTTL(k)-AllWNTTL(k-1)>2
       CSMoinsTTL=[CSMoinsTTL; AllWNTTL(k)];
    end
end

CSPlusTTL=[AllToneTTL(1)];
for k=2:length(AllToneTTL)-1
    if AllToneTTL(k)-AllToneTTL(k-1)>2
        CSPlusTTL=[CSPlusTTL; AllToneTTL(k)];
    end
end

TTLInfo.CSMoinsTTL=CSMoinsTTL;
TTLInfo.CSPlusTTL=CSPlusTTL;

save('behavResources.mat','TTLInfo','-append');


%%%%%%%% Epochs departs et fins en msec !!!

%% cs+ et - epochs 

Epoch.CSPlus_1=intervalSet(TTLInfo.CSPlusTTL(1:4)*1e4, TTLInfo.CSPlusTTL(1:4)*1e4+60*1e4);
Epoch.CSPlus_2=intervalSet(TTLInfo.CSPlusTTL(5:8)*1e4, TTLInfo.CSPlusTTL(5:8)*1e4+60*1e4);
Epoch.CSPlus_3=intervalSet(TTLInfo.CSPlusTTL(9:12)*1e4, TTLInfo.CSPlusTTL(9:12)*1e4+60*1e4);
Epoch.CSMoins=intervalSet(TTLInfo.CSMoinsTTL*1e4, TTLInfo.CSMoinsTTL*1e4+60*1e4);

%% extinction et non extinction

Epoch.Pre_Inj=intervalSet(TTLInfo.StartTTL*1e4, TTLInfo.InjectTTL*1e4);
Epoch.Inj=intervalSet(TTLInfo.InjectTTL*1e4, TTLInfo.ExtTTL*1e4);
Epoch.Ext=intervalSet(TTLInfo.ExtTTL*1e4, TTLInfo.PostExtTTL*1e4);
Epoch.Post_Ext=intervalSet(TTLInfo.PostExtTTL*1e4, TTLInfo.EndTTL*1e4);
Epoch.Non_Ext=intervalSet([TTLInfo.StartTTL*1e4,TTLInfo.ExtTTL*1e4],[TTLInfo.PostExtTTL*1e4, TTLInfo.EndTTL*1e4]);
Epoch.All_Day=intervalSet(TTLInfo.StartTTL*1e4,TTLInfo.EndTTL*1e4);

%% freezing (et sleep deduit du freezing)

%smoofact=10;
smoofact_Acc = 30;
th_immob_Acc = 20000000;
thtps_immob=2;
save('behavResources.mat','th_immob_Acc','-append');
     
NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
%%
Epoch.All_FreezeAcc=FreezeAccEpoch;
Epoch.FreezeAcc_Ext=and(Epoch.Ext, Epoch.All_FreezeAcc);
Epoch.FreezeAcc_Pre_Inj=and(Epoch.Pre_Inj,Epoch.All_FreezeAcc);
Epoch.FreezeAcc_Post_Ext=and(Epoch.Post_Ext,Epoch.All_FreezeAcc);

%% non freeze epoch :

Epoch.All_Non_FreezeAcc=intervalSet([Start(Epoch.All_Day);Stop(Epoch.All_FreezeAcc)],[Start(Epoch.All_FreezeAcc);Stop(Epoch.All_Day)]);
Epoch.Non_FreezeAcc_Pre_Inj=and(Epoch.Pre_Inj,Epoch.All_Non_FreezeAcc);
Epoch.Non_FreezeAcc_Post_Ext=and(Epoch.Post_Ext,Epoch.All_Non_FreezeAcc);
Epoch.Non_FreezeAcc_Ext=and(Epoch.Ext,Epoch.All_Non_FreezeAcc);

save('Epoch', 'Epoch');




