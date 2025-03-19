
%% CODE FOR CAT ODOR
close all
clear all

% to get tube position on ref picture
cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/FearOdorPoject/FearOdor_Cat/SLEEP-Mouse-763-13072018-Sleep_00'])
load('behavResources.mat')
test=ref;
test(mask==1)=0;
figure, imagesc(test)
suptitle('click on tube and enter')
PosTube = ginput


%timeEpoch=[0, 180*1E4];
%timeEpoch=[180*1E4 360*1E4];
%timeEpoch=[360*1E4 600*1E4];
timeEpoch=[0, 200*1E4];


% Controle condition
MiceNum = [692 693 718 756 758 763];

for i = 1:length(MiceNum)
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/FearOdorPoject/FearOdor_Cat/SLEEP-Mouse-',num2str(MiceNum(i)),'-13072018-Sleep_00'])
    load('behavResources.mat')
    
    Thresh = min(Data(Ytsd)+(max(Data(Ytsd))-min(Data(Ytsd)))/2); % limit of the 2 parts of the box (with and without odor)
    
    Xtsd=Restrict(Xtsd,intervalSet(timeEpoch(1),timeEpoch(2)));
    Ytsd=Restrict(Ytsd,intervalSet(timeEpoch(1),timeEpoch(2)));
    
    TimeEmptySide_sham(i) = sum(Data(Ytsd)>Thresh)./length(Data(Ytsd)); % time spent in each empty side
    TimeOdorSide_sham(i) = sum(Data(Ytsd)<Thresh)./length(Data(Ytsd)); % time spent in odor side

    MeanDist_sham(i) = mean(sqrt((Data(Ytsd)-PosTube(1)/Ratio_IMAonREAL).^2+(Data(Xtsd)-PosTube(2)/Ratio_IMAonREAL).^2));
    
    % episode close to tube 
    Dist_tube_inst_s = tsd(Range(Ytsd),sqrt((Data(Ytsd)-PosTube(1)/Ratio_IMAonREAL).^2+(Data(Xtsd)-PosTube(2)/Ratio_IMAonREAL).^2));
    CloseTubeEpoch_s = thresholdIntervals(Dist_tube_inst_s,8,'Direction','Below');
    CloseTubeEpochDur_s(i) = mean(Stop(CloseTubeEpoch_s,'s')-Start(CloseTubeEpoch_s,'s'));
    TotExplo_s (i) = sum(Stop(CloseTubeEpoch_s,'s')-Start(CloseTubeEpoch_s,'s'));% tot duration of tube explo
    NumEp_s(i) = length(Stop(CloseTubeEpoch_s,'s')-Start(CloseTubeEpoch_s,'s')); % nuber of exploration episodes
    
end

% litter condition
for j = 1:length(MiceNum)
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/FearOdorPoject/FearOdor_Cat/SLEEP-Mouse-',num2str(MiceNum(j)),'-13072018-Sleep_01'])
    load('behavResources.mat')
    
    Thresh = min(Data(Ytsd)+(max(Data(Ytsd))-min(Data(Ytsd)))/2);
    
    Xtsd=Restrict(Xtsd,intervalSet(timeEpoch(1),timeEpoch(2)));
    Ytsd=Restrict(Ytsd,intervalSet(timeEpoch(1),timeEpoch(2)));
    
%     subplot(1,6,j)
%     hist(Data(Vtsd),50)
%     plot(Data(Xtsd),Data(Ytsd))
    
    TimeEmptySide_litter(j) = sum(Data(Ytsd)>Thresh)./length(Data(Ytsd));
    TimeOdorSide_litter(j) = sum(Data(Ytsd)<Thresh)./length(Data(Ytsd));
    
    MeanDist_litter(j) = mean(sqrt((Data(Ytsd)-PosTube(1)/Ratio_IMAonREAL).^2+(Data(Xtsd)-PosTube(2)/Ratio_IMAonREAL).^2));
    
    % episode close to tube 
    Dist_tube_inst_l = tsd(Range(Ytsd),sqrt((Data(Ytsd)-PosTube(1)/Ratio_IMAonREAL).^2+(Data(Xtsd)-PosTube(2)/Ratio_IMAonREAL).^2));
    CloseTubeEpoch_l = thresholdIntervals(Dist_tube_inst_l,8,'Direction','Below');
    CloseTubeEpochDur_l(j) = mean(Stop(CloseTubeEpoch_l,'s')-Start(CloseTubeEpoch_l,'s'));
    TotExplo_l (j) = sum(Stop(CloseTubeEpoch_l,'s')-Start(CloseTubeEpoch_l,'s'));
    NumEp_l(j) = length(Stop(CloseTubeEpoch_l,'s')-Start(CloseTubeEpoch_l,'s'));
    
end

% hairs condition
MiceNum = [692 693 718 756 758 763];

for k = 1:length(MiceNum)
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/FearOdorPoject/FearOdor_Cat/SLEEP-Mouse-',num2str(MiceNum(k)),'-13072018-Sleep_02'])
    load('behavResources.mat')
    
    Thresh = min(Data(Ytsd)+(max(Data(Ytsd))-min(Data(Ytsd)))/2);
    
    Xtsd=Restrict(Xtsd,intervalSet(timeEpoch(1),timeEpoch(2)));
    Ytsd=Restrict(Ytsd,intervalSet(timeEpoch(1),timeEpoch(2)));
    
    %     subplot(1,6,k)
    %     scatter(Data(Xtsd),Data(Ytsd),10,Range(Xtsd),'filled')
    %     ylim([0 50])
    %     line(xlim,[Thresh Thresh])
    
    TimeEmptySide_hairs(k) = sum(Data(Ytsd)>Thresh)./length(Data(Ytsd));
    TimeOdorSide_hairs(k) = sum(Data(Ytsd)<Thresh)./length(Data(Ytsd));

    MeanDist_hairs(k) = mean(sqrt((Data(Ytsd)-PosTube(1)/Ratio_IMAonREAL).^2+(Data(Xtsd)-PosTube(2)/Ratio_IMAonREAL).^2));
    
    % episode close to tube 
    Dist_tube_inst_h = tsd(Range(Ytsd),sqrt((Data(Ytsd)-PosTube(1)/Ratio_IMAonREAL).^2+(Data(Xtsd)-PosTube(2)/Ratio_IMAonREAL).^2));
    CloseTubeEpoch_h = thresholdIntervals(Dist_tube_inst_h,8,'Direction','Below');
    CloseTubeEpochDur_h(k) = mean(Stop(CloseTubeEpoch_h,'s')-Start(CloseTubeEpoch_h,'s'));
    TotExplo_h (k) = sum(Stop(CloseTubeEpoch_h,'s')-Start(CloseTubeEpoch_h,'s'));
    NumEp_h(k) = length(Stop(CloseTubeEpoch_h,'s')-Start(CloseTubeEpoch_h,'s'));
    
end


% GENERATE PLOT
% time spent in each side
figure
PlotBarCrossProtocol_Cat(TimeEmptySide_sham, TimeOdorSide_sham, TimeEmptySide_litter,TimeOdorSide_litter, TimeEmptySide_hairs, TimeOdorSide_hairs)
ylabel('Time (%)')
xticks(1:3)
xticklabels({'controle condition','litter','hairs'})
ylim([0 1])


figure

subplot(411)
PlotErrorBarN_KJ({MeanDist_sham, MeanDist_litter, MeanDist_hairs},'newfig',0,'paired',0)
xticks(1:3)
xticklabels({'controle','litter','hairs'})
ylabel('distance (cm)')
title('mean dist to tube')

% mean duration of an exploration episode 
subplot(412)
PlotErrorBarN_KJ({CloseTubeEpochDur_s, CloseTubeEpochDur_l, CloseTubeEpochDur_h},'newfig',0, 'paired',0)
xticks(1:3)
xticklabels({'controle condition','litter','hairs'})
ylabel('Time (s)')
title('mean duration of tube episode exploration')
ylim([0 30])


% number of episodes
subplot(413)
PlotErrorBarN_KJ({NumEp_s, NumEp_l, NumEp_h},'newfig',0, 'paired', 0)
xticks(1:3)
xticklabels({'controle','litter','hairs'})
ylabel('number of episodes')
title('number of tube exploration episodes')
ylim([0 60])

% tot explo
subplot(414)
PlotErrorBarN_KJ({TotExplo_s, TotExplo_l, TotExplo_h},'newfig',0, 'paired', 0)
xticks(1:3)
xticklabels({'controle','litter','hairs'})
ylabel('Time (s)')
title('Tot tube exploration')
ylim([0 450])
