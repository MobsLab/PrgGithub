%%data CD-1 mouse - sensory expo CD1 cage
% cd /media/mobschapeau/DataMOBS150/M1217/20210804/SensoryExpoCD1cage/SLEEP-Mouse-1217&1214&1218&1215-04082021_00/Mouse1214-BaselineSleep
% cd /media/mobschapeau/DataMOBS150/M1219/20210818/SensoryExpoCD1cage/SLEEP-Mouse-1219&1220&1215&1216-18082021_00/Mouse1215-BaselineSleep
% cd /media/mobschapeau/DataMOBS150/M1220/20210818/SensoryExpoCD1cage/SLEEP-Mouse-1219&1220&1215&1216-18082021_00/Mouse1216-BaselineSleep
cd /media/nas6/ProjetPFCVLPO/M1149/20210520/SocialDefeat/SensoryExpoCD1cage/DREADD_1149_SD_sensory_CD1cage_210520_093520/

data_CD1_sensoryExpo_CD1cage = load('behavResources_CD1.mat');
xtsd_CD1_sensoryExpo_CD1cage = data_CD1_sensoryExpo_CD1cage.Xtsd;
ytsd_CD1_sensoryExpo_CD1cage = data_CD1_sensoryExpo_CD1cage.Ytsd;
ratio_IMAonREAL_CD1_sensoryExpo_CD1cage = data_CD1_sensoryExpo_CD1cage.Ratio_IMAonREAL;


%%data CD-1 mouse - sensory expo C57 cage
% cd /media/mobschapeau/DataMOBS150/M1217/20210804/SensoryExpoC57cage/SLEEP-Mouse-1217&1214&1218&1215-04082021_01/Mouse1214-BaselineSleep
cd /media/mobschapeau/DataMOBS150/M1218/20210804/SensoryExpoC57cage/SLEEP-Mouse-1217&1214&1218&1215-04082021_01/Mouse1215-BaselineSleep
% cd /media/mobschapeau/DataMOBS150/M1219/20210818/SensoryExpoC57cage/SLEEP-Mouse-1219&1220&1215&1216-18082021_01/Mouse1215-BaselineSleep
% cd /media/mobschapeau/DataMOBS150/M1220/20210818/SensoryExpoC57cage/SLEEP-Mouse-1219&1220&1215&1216-18082021_01/Mouse1216-BaselineSleep

data_CD1_sensoryExpo_C57cage = load('behavResources_Offline_CD1.mat');
xtsd_CD1_sensoryExpo_C57cage = data_CD1_sensoryExpo_C57cage.Xtsd;
ytsd_CD1_sensoryExpo_C57cage = data_CD1_sensoryExpo_C57cage.Ytsd;
ratio_IMAonREAL_CD1_sensoryExpo_C57cage = data_CD1_sensoryExpo_C57cage.Ratio_IMAonREAL;

%%
%%data experimental mice
% cd /media/mobschapeau/DataMOBS150/M1217/20210804
cd /media/nas6/ProjetPFCVLPO/M1149/20210520/SocialDefeat/SensoryExpoCD1cage/DREADD_1149_SD_sensory_CD1cage_210520_093520
% cd /media/mobschapeau/DataMOBS150/M1219/20210818
% cd /media/mobschapeau/DataMOBS150/M1220/20210818

CPT_C57 = load('behavResources.mat');
sleep_C57 = load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch');

%%sensory expo CD1 cage
xtsd_C57_sensoryExpo_CD1cage = CPT_C57.Xtsd;
ytsd_C57_sensoryExpo_CD1cage = CPT_C57.Ytsd;
ratio_IMAonREAL_C57_sensoryExpo_CD1cage = CPT_C57.Ratio_IMAonREAL;

%%sensory expo C57 cage
xtsd_C57_sensoryExpo_C57cage = CPT_C57.behavResources(2).Xtsd;
ytsd_C57_sensoryExpo_C57cage = CPT_C57.behavResources(2).Ytsd;
ratio_IMAonREAL_C57_sensoryExpo_C57cage = CPT_C57.behavResources(2).Ratio_IMAonREAL;

%%sleep post SD
xtsd_C57_sleepPostSD = CPT_C57.behavResources(3).Xtsd;
ytsd_C57_sleepPostSD = CPT_C57.behavResources(3).Ytsd;
ratio_IMAonREAL_C57_sleepPostSD = CPT_C57.behavResources(3).Ratio_IMAonREAL;

%%sleep stages
durtotal = max([max(End(sleep_C57.Wake)),max(End(sleep_C57.SWSEpoch))]);
%3h after SD
epoch_3hPostSD = intervalSet(0*3600*1E4,2*3600*1E4);
%2h after first long sleep episode
[tpsFirstREM, tpsFirstSWS]= FindLatencySleep_MC(sleep_C57.Wake,sleep_C57.SWSEpoch,sleep_C57.REMEpoch,5,70); tpsFirstSleep_SD=tpsFirstSWS;
epoch_3hPostFisrtSleep_SD=intervalSet(tpsFirstSleep_SD*1e4,tpsFirstSleep_SD*1e4+3*3600*1E4);
    
%%
x_max_limit = max(Data(xtsd_CD1_sensoryExpo_CD1cage))+2;
x_min_limit = min(Data(xtsd_C57_sensoryExpo_CD1cage))-2;

y_max_limit = max(Data(ytsd_CD1_sensoryExpo_CD1cage))+2;
y_min_limit = min(Data(ytsd_C57_sensoryExpo_CD1cage))-2;


figure, subplot(131)
p(1)=plot(Data(xtsd_CD1_sensoryExpo_CD1cage),Data(ytsd_CD1_sensoryExpo_CD1cage),'b'),hold on
p(2)=plot(Data(xtsd_C57_sensoryExpo_CD1cage),Data(ytsd_C57_sensoryExpo_CD1cage),'k')
xlim([x_min_limit x_max_limit])
ylim([y_min_limit y_max_limit])
hold on,line([22.5 22.5],ylim,'color','r')
title('Sensory exposure in CD1 cage')

subplot(132),
p(3)=plot(Data(xtsd_CD1_sensoryExpo_C57cage),Data(ytsd_CD1_sensoryExpo_C57cage),'b'), hold on
p(4)=plot(Data(xtsd_C57_sensoryExpo_C57cage),Data(ytsd_C57_sensoryExpo_C57cage),'k')
xlim([x_min_limit x_max_limit])
ylim([y_min_limit y_max_limit])
hold on,line([22.5 22.5],ylim,'color','r')
title('Sensory exposure in C57 cage')

subplot(133),
% p(5)=plot(Data(xtsd_C57_sleepPostSD),Data(ytsd_C57_sleepPostSD),'k'), hold on
p(5)=plot(Data(Restrict(xtsd_C57_sleepPostSD,epoch_3hPostFisrtSleep_SD)),Data(Restrict(ytsd_C57_sleepPostSD,epoch_3hPostFisrtSleep_SD)),'k'), hold on
xlim([x_min_limit x_max_limit])
ylim([y_min_limit y_max_limit])
hold on,line([22.5 22.5],ylim,'color','r')
title('SleepPostSD')
title('SleepPostSD (3h post SD starting after first sleep episod)')

set(p,'xlim',[10 35],'ylim',[y_min_limit y_max_limit])






% figure,imagesc('XData',x1_C57_sensoryExpo_CD1cage,'YData',x2_C57_sensoryExpo_CD1cage,'CData',occH_C57_sensoryExpo_CD1cage), hold on
%%
smo=2;
TrObjLocal.frame_rate=15;
sizeMap = 50;

%%sensory exposure CD1 cage
[occH_C57_sensoryExpo_CD1cage, x1_C57_sensoryExpo_CD1cage, x2_C57_sensoryExpo_CD1cage] = hist2(Data(xtsd_C57_sensoryExpo_CD1cage),Data(ytsd_C57_sensoryExpo_CD1cage),240,320);
occH_C57_sensoryExpo_CD1cage(1:320,1:240) = SmoothDec(occH_C57_sensoryExpo_CD1cage/TrObjLocal.frame_rate,[smo smo]); 
    
  

% OccupMap_temp=occH_C57_sensoryExpo_CD1cage;
% 
%     OccupMap_temp = hist2d(Data(xtsd_C57_sensoryExpo_CD1cage), Data(ytsd_C57_sensoryExpo_CD1cage),sizeMap,sizeMap);
%     OccupMap_temp = OccupMap_temp/sum(OccupMap_temp(:));
%     largerMatrix = zeros(sizeMap+floor(sizeMap/4),sizeMap+floor(sizeMap/4));
%     largerMatrix(1+floor(sizeMap/8):sizeMap+floor(sizeMap/8),1+floor(sizeMap/8):sizeMap+floor(sizeMap/8)) = (OccupMap_temp)';
%     OccupMap_temp=SmoothDec(largerMatrix,[smo,smo]);






[occH_CD1_sensoryExpo_CD1cage, x1_CD1_sensoryExpo_CD1cage, x2_CD1_sensoryExpo_CD1cage] = hist2(Data(xtsd_CD1_sensoryExpo_CD1cage),Data(ytsd_CD1_sensoryExpo_CD1cage),240,320);
occH_CD1_sensoryExpo_CD1cage(1:320,1:240) = SmoothDec(occH_CD1_sensoryExpo_CD1cage/TrObjLocal.frame_rate,[smo smo]);

%%sensory exposure C57 cage
[occH_C57_sensoryExpo_C57cage, x1_C57_sensoryExpo_C57cage, x2_C57_sensoryExpo_C57cage] = hist2(Data(xtsd_C57_sensoryExpo_C57cage),Data(ytsd_C57_sensoryExpo_C57cage),240,320);
occH_C57_sensoryExpo_C57cage(1:320,1:240) = SmoothDec(occH_C57_sensoryExpo_C57cage/TrObjLocal.frame_rate,[smo smo]);
   
[occH_CD1_sensoryExpo_C57cage, x1_CD1_sensoryExpo_C57cage, x2_CD1_sensoryExpo_C57cage] = hist2(Data(xtsd_CD1_sensoryExpo_C57cage),Data(ytsd_CD1_sensoryExpo_C57cage),240,320);
occH_CD1_sensoryExpo_C57cage(1:320,1:240) = SmoothDec(occH_CD1_sensoryExpo_C57cage/TrObjLocal.frame_rate,[smo smo]);

% %%sleep post SD
[occH_C57_sleepPostSD, x1_C57_sleepPostSD, x2_C57_sleepPostSD] = hist2(Data(xtsd_C57_sleepPostSD),Data(ytsd_C57_sleepPostSD),240,320);
occH_C57_sleepPostSD(1:320,1:240) = SmoothDec(occH_C57_sleepPostSD/TrObjLocal.frame_rate,[smo smo]);
%%sleep post SD (restricted to 3h post SD)
[occH_C57_sleepPostSD, x1_C57_sleepPostSD, x2_C57_sleepPostSD] = hist2(Data(Restrict(xtsd_C57_sleepPostSD,epoch_3hPostFisrtSleep_SD)),Data(Restrict(ytsd_C57_sleepPostSD,epoch_3hPostFisrtSleep_SD)),240,320);
occH_C57_sleepPostSD(1:320,1:240) = SmoothDec(occH_C57_sleepPostSD/TrObjLocal.frame_rate,[smo smo]);

%%
% map=[14.11 80; 30.61 80; 30.61 43.07; 14.11 43.07; 14.11 80];

figure,
%%sensory exposure CD1 cage
subplot(131),

imagesc('XData',x1_C57_sensoryExpo_CD1cage,'YData',x2_C57_sensoryExpo_CD1cage,'CData',occH_C57_sensoryExpo_CD1cage), hold on
caxis([0 0.15])
% p1=plot(Data(xtsd_C57_sensoryExpo_CD1cage),Data(ytsd_C57_sensoryExpo_CD1cage),'colo','k','linewidth',0.5)
p1.Color(4)= .1;
% ylabel('Sensory exposure in CD1 cage')
set(gca,'color','none')
% subplot(182),
imagesc('XData',x1_CD1_sensoryExpo_CD1cage,'YData',x2_CD1_sensoryExpo_CD1cage,'CData',occH_CD1_sensoryExpo_CD1cage), hold on
caxis([0 0.15])
% p1=plot(Data(xtsd_CD1_sensoryExpo_CD1cage),Data(ytsd_CD1_sensoryExpo_CD1cage),'colo','k','linewidth',0.5)
p1.Color(4)= .1;
set(gca,'color','none')

%%sensory exposure C57 cage
subplot(132),
imagesc('XData',x1_C57_sensoryExpo_C57cage,'YData',x2_C57_sensoryExpo_C57cage,'CData',occH_C57_sensoryExpo_C57cage), hold on
caxis([0 0.15])
% p1=plot(Data(xtsd_C57_sensoryExpo_C57cage),Data(ytsd_C57_sensoryExpo_C57cage),'colo','k','linewidth',0.5)
p1.Color(4)= .1;
set(gca,'color','none')

ylabel('Sensory exposure in C57 cage')

% subplot(185),
imagesc('XData',x1_CD1_sensoryExpo_C57cage,'YData',x2_CD1_sensoryExpo_C57cage,'CData',occH_CD1_sensoryExpo_C57cage), hold on
caxis([0 0.15])
% p1=plot(Data(xtsd_CD1_sensoryExpo_C57cage),Data(ytsd_CD1_sensoryExpo_C57cage),'colo','k','linewidth',0.5)
p1.Color(4)= .1;
set(gca,'color','none')


% subplot(1,8,[7,8]),
subplot(133),

%%sleep post SD
imagesc('XData',x1_C57_sleepPostSD,'YData',x2_C57_sleepPostSD,'CData',occH_C57_sleepPostSD), hold on
caxis([0 0.15])
% p1=plot(Data(xtsd_C57_sleepPostSD),Data(ytsd_C57_sleepPostSD),'color','w','linewidth',0.5)
% p1=plot(Data(Restrict(xtsd_C57_sleepPostSD,epoch_3hPostFisrtSleep_SD)),Data(Restrict(ytsd_C57_sleepPostSD,epoch_3hPostFisrtSleep_SD)),'colo','k','linewidth',0.5)

p1.Color(4)= .1;
set(gca,'color','none')

ylabel('Sleep post SD')

% set(gca,'FontSize',13)
% set(gca,'visible','off')



%%cd /media/nas6/ProjetPFCVLPO/M1217/20210804/SocialDefeat/SensoryExpoCD1cage/DREADD_1217_SensoryExpoCD1cage_210804_091140/

data_CD1_sensoryExpo_CD1cage = load('behavResources_CD1.mat');
xtsd_CD1_sensoryExpo_CD1cage = data_CD1_sensoryExpo_CD1cage.Xtsd;
ytsd_CD1_sensoryExpo_CD1cage = data_CD1_sensoryExpo_CD1cage.Ytsd;
ratio_IMAonREAL_CD1_sensoryExpo_CD1cage = data_CD1_sensoryExpo_CD1cage.Ratio_IMAonREAL;



CPT_C57 = load('behavResources.mat');


%%sensory expo CD1 cage
xtsd_C57_sensoryExpo_CD1cage = CPT_C57.Xtsd;
ytsd_C57_sensoryExpo_CD1cage = CPT_C57.Ytsd;
ratio_IMAonREAL_C57_sensoryExpo_CD1cage = CPT_C57.Ratio_IMAonREAL;


figure, 
%subplot(131)
p(1)=plot(Data(xtsd_CD1_sensoryExpo_CD1cage),Data(ytsd_CD1_sensoryExpo_CD1cage),'b'),hold on
p(2)=plot(Data(xtsd_C57_sensoryExpo_CD1cage),Data(ytsd_C57_sensoryExpo_CD1cage),'k')
xlim([x_min_limit x_max_limit])
ylim([y_min_limit y_max_limit])
hold on,line([22.5 22.5],ylim,'color','r')
title('Sensory exposure in CD1 cage')




