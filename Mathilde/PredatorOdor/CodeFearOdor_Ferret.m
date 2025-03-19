% in Dropbox/Mobs_members/MathildeChouvaeff you will find a document with brief explanations of these
% different tests

%% First test with ferret odor with ONE mouse

ToUse =  [0,2,3,4,6];
Titres = {'Base1','Tis.Imb','Litière','Base2','Poils'}
for k = 1 :length(ToUse)
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/FearOdorPoject/FearOdor_Ferret/FirstTest/SLEEP-Mouse-758-02072018-Sleep_0',num2str(ToUse(k))])
    load('behavResources.mat')
    
    % subplot(1,5,k)
    % hist(Data(Vtsd),50)
    % plot(Data(Xtsd),Data(Ytsd))
    % title(Titres{k})
    
    TimeEmpty(k) = sum(Data(Ytsd)>30)./length(Data(Ytsd));
    TimeOdor(k) = sum(Data(Ytsd)<30)./length(Data(Ytsd));
    
    MeanDist(k) = mean(sqrt((Data(Ytsd)-17).^2+(Data(Xtsd)-20).^2));
    
    % MeanSp(k) = mean(Data(Vtsd));
    % [Y,X]=hist(Data(Vtsd),50);
    % plot(X,cumsum(Y)/sum(Y)), hold on
    
    CloseTubeEpoch = thresholdIntervals(Ytsd,20,'Direction','Below');
    CloseTubeEpochDur(k) = mean(Stop(CloseTubeEpoch,'s')-Start(CloseTubeEpoch,'s'));
    NumEp (k) = length(Stop(CloseTubeEpoch,'s')-Start(CloseTubeEpoch,'s'));
    TotExplo (k) = sum(Stop(CloseTubeEpoch,'s')-Start(CloseTubeEpoch,'s'));
    
end

figure
% time spent in empty side
subplot(611)
PlotErrorBarN_KJ({TimeEmpty(1), TimeEmpty(2), TimeEmpty(3), TimeEmpty(4), TimeEmpty(5) }, 'newfig',0, 'paired',0)
xticks (1:5)
xticklabels({'Base1','Tis.Imb','Litière','Base2','Poils'})
ylabel('Time (%)')
title('Time spent in empty side')

% time spent in odor side
subplot(612)
PlotErrorBarN_KJ({TimeOdor(1), TimeOdor(2), TimeOdor(3), TimeOdor(4), TimeOdor(5) }, 'newfig',0, 'paired',0)
xticks (1:5)
xticklabels({'Base1','Tis.Imb','Litière','Base2','Poils'})
ylabel('Time (%)')
title('Time spent in tube side')

% mean duration of tube explo episode
subplot(613)
PlotErrorBarN_KJ({CloseTubeEpochDur(1), CloseTubeEpochDur(2), CloseTubeEpochDur(3), CloseTubeEpochDur(4), CloseTubeEpochDur(5) }, 'newfig',0, 'paired',0)
xticks (1:5)
xticklabels({'Base1','Tis.Imb','Litière','Base2','Poils'})
ylabel('Time (s)')
title('Ep duration tube explo')

% number of episodes
subplot(614)
PlotErrorBarN_KJ({NumEp(1),NumEp(2),NumEp(3),NumEp(4),NumEp(5) },'newfig',0, 'paired', 0)
xticks (1:5)
xticklabels({'Base1','Tis.Imb','Litière','Base2','Poils'})
ylabel('Number of episodes')
title('number of tube exploration episodes')

% tot explo
subplot(615)
PlotErrorBarN_KJ({TotExplo(1),TotExplo(2),TotExplo(3),TotExplo(4),TotExplo(5) },'newfig',0, 'paired', 0)
xticks (1:5)
xticklabels({'Base1','Tis.Imb','Litière','Base2','Poils'})
ylabel('Time (s)')
title('Tot tube exploration')

% mean dist to tube
subplot(616)
PlotErrorBarN_KJ({MeanDist(1), MeanDist(2), MeanDist(3), MeanDist(4), MeanDist(5) }, 'newfig',0, 'paired',0)
xticks (1:5)
xticklabels({'Base1','Tis.Imb','Litière','Base2','Poils'})
xlabel('Conditions')
ylabel('Distance (cm)')
title('Mean Dist to Tube')




%% preference test
clear all

% to get tube position on ref picture
 cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/FearOdorPoject/FearOdor_Ferret/PreferenceTest/SLEEP-Mouse-763-04072018-Sleep_00'])
 load('behavResources.mat')
 test=ref;
 test(mask==1)=0;
 figure, imagesc(test)
 title('click on empty tube (right) and enter then odor tube (left) then enter')
 PosTube = ginput
 PosTube_odor = ginput


MiceNum = [718 756 758 763];
for j = 1:length(MiceNum)
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/FearOdorPoject/FearOdor_Ferret/PreferenceTest/SLEEP-Mouse-',num2str(MiceNum(j)),'-04072018-Sleep_01'])
    load('behavResources.mat')
    
%         subplot(1,4,j)
%         hist(Data(Vtsd),50)
%         plot(Data(Xtsd),Data(Ytsd))
%     
    Thresh = min(Data(Ytsd)+(max(Data(Ytsd))-min(Data(Ytsd)))/2);
    
    TimeCloseEmpty(j) = sum(Data(Ytsd)>Thresh)./length(Data(Ytsd));
    TimeCloseOdor(j) = sum(Data(Ytsd)<Thresh)./length(Data(Ytsd));
   
    YPos = min(Data(Ytsd));
    XPos = min(Data(Xtsd)+(max(Data(Xtsd))-min(Data(Xtsd)))/2);
    MeanDistOdor(j) = nanmean(sqrt((Data(Ytsd)-YPos).^2+(Data(Xtsd)-XPos).^2));
    
    YPos_empty = max(Data(Ytsd));
    XPos_empty = min(Data(Xtsd)+(max(Data(Xtsd))-min(Data(Xtsd)))/2);
    MeanDistEmpty(j) = nanmean(sqrt((Data(Ytsd)-YPos_empty).^2+(Data(Xtsd)-XPos_empty).^2));
    

    % episode close to tube 
    Dist_tube_inst_empty = tsd(Range(Ytsd),sqrt((Data(Ytsd)-PosTube(1)/Ratio_IMAonREAL).^2+(Data(Xtsd)-PosTube(2)/Ratio_IMAonREAL).^2));

    CloseEmptyTubeEpoch_c = thresholdIntervals(Dist_tube_inst_empty,5,'Direction','Below');
    CloseEmptyTubeEpochDur_c(j) = nanmean(Stop(CloseEmptyTubeEpoch_c,'s')-Start(CloseEmptyTubeEpoch_c,'s'));
    TotExplo_Empty_c (j) = sum(Stop(CloseEmptyTubeEpoch_c,'s')-Start(CloseEmptyTubeEpoch_c,'s'));
    NumEp_Empty_c(j) = length(Stop(CloseEmptyTubeEpoch_c,'s')-Start(CloseEmptyTubeEpoch_c,'s'));
    
    
    Dist_tube_inst_odor = tsd(Range(Ytsd),sqrt((Data(Ytsd)-PosTube_odor(1)/Ratio_IMAonREAL).^2+(Data(Xtsd)-PosTube_odor(2)/Ratio_IMAonREAL).^2));
    
    CloseOdorTubeEpoch_c = thresholdIntervals(Dist_tube_inst_odor,5,'Direction','Below');
    CloseOdorTubeEpochDur_c(j) = nanmean(Stop(CloseOdorTubeEpoch_c,'s')-Start(CloseOdorTubeEpoch_c,'s'));
    TotExplo_Odor_c (j) = sum(Stop(CloseOdorTubeEpoch_c,'s')-Start(CloseOdorTubeEpoch_c,'s'));
    NumEp_Odor_c(j) = length(Stop(CloseOdorTubeEpoch_c,'s')-Start(CloseOdorTubeEpoch_c,'s'));
    
    
end


% time spent close to tubes
figure
PlotErrorBarN_KJ({TimeCloseEmpty, TimeCloseOdor}, 'newfig',0,'paired',0)
xticks(1:2)
xticklabels({'Empty','Odor'})
ylabel ('Time (%)')
title('Time spent in each side')

% mean dist to tubes
figure
suptitle(' preference test')
subplot(411)
PlotErrorBarN_KJ({MeanDistEmpty, MeanDistOdor}, 'newfig', 0, 'paired', 0)
ylabel('Distance (cm)')
xticks(1:2)
xticklabels({'Empty','Odor'})
title('Distance to tube')

% Ep duration tubes explo
subplot(412)
PlotErrorBarN_KJ({CloseEmptyTubeEpochDur_c, CloseOdorTubeEpochDur_c}, 'newfig', 0, 'paired',0)
ylabel('Time (s)')
xticks(1:2)
xticklabels({'Empty','Odor'})
title('Episode duration tube exploration ')

% number of episodes
subplot(413)
PlotErrorBarN_KJ({NumEp_Empty_c, NumEp_Odor_c},'newfig',0, 'paired', 0)
xticks(1:2)
xticklabels({'Empty','Odor'})
ylabel('Number of episodes')
title('number of tube exploration episodes')

% tot explo
subplot(414)
PlotErrorBarN_KJ({TotExplo_Empty_c, TotExplo_Odor_c},'newfig',0, 'paired', 0)
xticks(1:2)
xticklabels({'Empty','Odor'})
ylabel('Time (s)')
title('Tot tube exploration')



%% half odor test
clear all

MiceNum = [718 756 758 763];
for i = 1:length(MiceNum)
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/FearOdorPoject/FearOdor_Ferret/HalfOdorTest/SLEEP-Mouse-',num2str(MiceNum(i)),'-05072018-Sleep_00'])
    load('behavResources.mat')
    
    %   subplot(1,4,i)
    %   hist(Data(Vtsd),50)
    %   plot(Data(Xtsd),Data(Ytsd))
        
    Thresh = min(Data(Ytsd)+(max(Data(Ytsd))-min(Data(Ytsd)))/2);
    
    TimeEmptySide(i) = sum(Data(Ytsd)>Thresh)./length(Data(Ytsd));
    TimeOdorSide(i) = sum(Data(Ytsd)<Thresh)./length(Data(Ytsd));
    
end

figure
PlotErrorBarN_KJ({TimeEmptySide, TimeOdorSide}, 'newfig',0, 'paired',0)
ylabel('Time (%)')
xticks(1:4)
xticklabels({'Empty','Odor'})
ylim([0 1])
title('Time spent in each side (HalfOdor)')




