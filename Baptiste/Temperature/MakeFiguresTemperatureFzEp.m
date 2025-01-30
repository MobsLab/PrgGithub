
cd('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Baptiste')

cd('/home/mobsmorty/Dropbox/Kteam/PrgMatlab/Baptiste')
load('Sess.mat')
%% Folder List

Mouse=[666 667 668 669 688 739 777 779 849 893];
for mouse = 1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    %Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
end
CondSess.M666=[{CondSess.M666{1}} {CondSess.M666{4}} {CondSess.M666{7}} {CondSess.M666{8}}];

%% Generate Data
Zones={'Fz','Shock','Safe'};
margins_bef=30;
for zones=1:length(Zones)
    for mouse=1:length(Mouse)
        Episodes= Temperature_FreezingEpisodes3(Mouse(mouse),CondSess,Zones{zones},margins_bef,'Yes','Yes','Yes','Yes','Yes','Yes','Yes');
        FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse})=Episodes;
    end
end

% Gathering all data
clear all_mice;
for zones=1:length(Zones)
    all_mice.(Zones{zones}).TTemp=[]; 
    all_mice.(Zones{zones}).MTemp=[]; 
    all_mice.(Zones{zones}).Speed=[];
    all_mice.(Zones{zones}).Acc=[];
    all_mice.(Zones{zones}).Respi=[];
    all_mice.(Zones{zones}).HR=[];
    all_mice.(Zones{zones}).HRVar=[];
    all_mice.(Zones{zones}).ZscoredTail=[];
    all_mice.(Zones{zones}).ZscoredMask=[];
    all_mice.(Zones{zones}).LocalStd=[];
    for mouse=1:length(Mouse_names)
        if ~isempty(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}))
            if size(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).TTempTogether,1)==1
            else
                all_mice.(Zones{zones}).TTemp=[all_mice.(Zones{zones}).TTemp ; nanmean(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).TTempTogether)];
                all_mice.(Zones{zones}).MTemp=[all_mice.(Zones{zones}).MTemp ; nanmean(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).MTempTogether)];
                all_mice.(Zones{zones}).Speed=[all_mice.(Zones{zones}).Speed ; nanmean(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).SpeedTogether)];
                all_mice.(Zones{zones}).Acc=[all_mice.(Zones{zones}).Acc ; nanmean(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).AccTogether)];
                all_mice.(Zones{zones}).Respi=[all_mice.(Zones{zones}).Respi; nanmean(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).RespiTogether)];
                try
                    all_mice.(Zones{zones}).HR=[all_mice.(Zones{zones}).HR ; nanmean(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).HRTogether)];
                    all_mice.(Zones{zones}).HRVar=[all_mice.(Zones{zones}).HRVar ; nanmean(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).HRVarTogether)];
                end
                %all_mice.(Zones{zones}).LocalStd=[all_mice.(Zones{zones}).LocalStd ; FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).Mean_local_stdFzEpandMargins];
            end
        end
    end
 end

for mouse=1:length(Mouse_names)
    MeanTTempPerMice.(Mouse_names{mouse})=nanmean(Data(ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'tailtemperature')));
    MeanMTempPerMice.(Mouse_names{mouse})=nanmean(Data(ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'masktemperature')));
end

% Substract mean temperature
for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        all_mice.(Zones{zones}).TTemp(mouse,:)=all_mice.(Zones{zones}).TTemp(mouse,:)-MeanTTempPerMice.(Mouse_names{mouse});
        all_mice.(Zones{zones}).MTemp(mouse,:)=all_mice.(Zones{zones}).MTemp(mouse,:)-MeanMTempPerMice.(Mouse_names{mouse});
    end
end

%% Transitions
figure
% Accelero
a=subplot(161)
zones=2;
int2=runmean(all_mice.(Zones{zones}).Acc,margins_bef/5,2);
Conf_Inter=nanstd(int2)/sqrt(size(all_mice.(Zones{zones}).Acc,1));
shadedErrorBar([1:margins_bef*30],nanmean(int2),Conf_Inter,'-r',1); hold on;
zones=3;
int3=runmean(all_mice.(Zones{zones}).Acc,margins_bef/5,2);
Conf_Inter=nanstd(int3)/sqrt(size(all_mice.(Zones{zones}).Acc,1));
shadedErrorBar([1:margins_bef*30],nanmean(int3),Conf_Inter,'-b',1); hold on;
ylabel('Movement quantity')
title('Movement')
xlim([0 margins_bef*30]); ylim([0 8e7]) ;
xticks([0 margins_bef*10 margins_bef*20 margins_bef*30])
xticklabels({'-30s','0s','0s','30s'})
a=vline(margins_bef*10,'--r');  a.LineWidth=2; a=vline(margins_bef*20,'--r'); a.LineWidth=2;  
f=get(gca,'Children');
legend([f(8),f(4)],'Shock side freezing','Safe side freezing')
makepretty
text(20,6e7,'30s before','FontSize',18,'Color','r')
text(margins_bef*10 +20,6e7,'Freezing','FontSize',18,'Color','r')
text(margins_bef*20 + 20,6e7,'30s after','FontSize',18,'Color','r')
set(gca,'FontSize',20)

% Heart Rate
a=subplot(162)
zones=2;
int2=runmean(all_mice.(Zones{zones}).HR,margins_bef/5,2);
Conf_Inter=nanstd(int2)/sqrt(size(all_mice.(Zones{zones}).HR,1));
shadedErrorBar([1:margins_bef*30],nanmean(int2),Conf_Inter,'-r',1); hold on;
zones=3;
int3=runmean(all_mice.(Zones{zones}).HR,margins_bef/5,2);
Conf_Inter=nanstd(int3)/sqrt(size(all_mice.(Zones{zones}).HR,1));
shadedErrorBar([1:margins_bef*30],nanmean(int3),Conf_Inter,'-b',1); hold on;
a=vline(margins_bef*10,'--r');  a.LineWidth=2; a=vline(margins_bef*20,'--r'); a.LineWidth=2;  
title('Heart rate')
ylabel('Frequency (Hz)')
makepretty
xlim([0 margins_bef*30])
xticks([0 margins_bef*10 margins_bef*20 margins_bef*30])
xticklabels({'-30s','0s','0s','30s'})
set(gca,'FontSize',20)

% Heart Rate Variability
a=subplot(163)
zones=2;
int2=runmean(all_mice.(Zones{zones}).HRVar,margins_bef/5,2);
Conf_Inter=nanstd(int2)/sqrt(size(all_mice.(Zones{zones}).HRVar,1));
shadedErrorBar([1:margins_bef*30],nanmean(int2),Conf_Inter,'-r',1); hold on;
zones=3;
int3=runmean(all_mice.(Zones{zones}).HRVar,margins_bef/5,2);
Conf_Inter=nanstd(int3)/sqrt(size(all_mice.(Zones{zones}).HRVar,1));
shadedErrorBar([1:margins_bef*30],nanmean(int3),Conf_Inter,'-b',1); hold on;
a=vline(margins_bef*10,'--r');  a.LineWidth=2; a=vline(margins_bef*20,'--r'); a.LineWidth=2;  
title('Heart rate Variability')
ylabel('Variability')
makepretty
xlim([0 margins_bef*30])
xticks([0 margins_bef*10 margins_bef*20 margins_bef*30])
xticklabels({'-30s','0s','0s','30s'})
set(gca,'FontSize',20)

% Respiratory Rate
a=subplot(164);
zones=2;
int2=runmean(all_mice.(Zones{zones}).Respi,margins_bef/5,2);
Conf_Inter=nanstd(int2)/sqrt(size(all_mice.(Zones{zones}).Respi,1));
shadedErrorBar([1:margins_bef*30],nanmean(int2),Conf_Inter,'-r',1); hold on;
zones=3;
int3=runmean(all_mice.(Zones{zones}).Respi,margins_bef/5,2);
Conf_Inter=nanstd(int3)/sqrt(size(all_mice.(Zones{zones}).Respi,1));
shadedErrorBar([1:margins_bef*30],nanmean(int3),Conf_Inter,'-b',1); hold on;
a=vline(margins_bef*10,'--r');  a.LineWidth=2; a=vline(margins_bef*20,'--r'); a.LineWidth=2;  
title('Respiratory rate')
ylabel('Frequency (Hz)')
makepretty
xlim([0 margins_bef*30])
xticks([0 margins_bef*10 margins_bef*20 margins_bef*30])
xticklabels({'-30s','0s','0s','30s'})
set(gca,'FontSize',20)

% Mask Temperature
subplot(165);
zones=2;
int2=runmean(all_mice.(Zones{zones}).MTemp,margins_bef/5,2);
Conf_Inter=nanstd(int2)/sqrt(size(all_mice.(Zones{zones}).MTemp,1));
shadedErrorBar([1:margins_bef*30],nanmean(int2),Conf_Inter,'-r',1); hold on;
zones=3;
int3=runmean(all_mice.(Zones{zones}).MTemp,margins_bef/5,2);
Conf_Inter=nanstd(int3)/sqrt(size(all_mice.(Zones{zones}).MTemp,1));
shadedErrorBar([1:margins_bef*30],nanmean(int3),Conf_Inter,'-b',1); hold on;
ylabel('NormalizedTemperature (°C)')
a=vline(margins_bef*10,'--r');  a.LineWidth=2; a=vline(margins_bef*20,'--r'); a.LineWidth=2;  
title('Total Body Temperature')
makepretty
xlim([0 margins_bef*30]); 
xticks([0 margins_bef*10 margins_bef*20 margins_bef*30])
xticklabels({'-30s','0s','0s','30s'})
set(gca,'FontSize',20)

% Tail Temperature
subplot(166); 
zones=2;
int2=runmean(all_mice.(Zones{zones}).TTemp,margins_bef/5,2);
Conf_Inter=nanstd(int2)/sqrt(size(all_mice.(Zones{zones}).TTemp,1));
shadedErrorBar([1:margins_bef*30],nanmean(int2),Conf_Inter,'-r',1); hold on;
zones=3;
int3=runmean(all_mice.(Zones{zones}).TTemp,margins_bef/5,2);
Conf_Inter=nanstd(int3)/sqrt(size(all_mice.(Zones{zones}).TTemp,1));
shadedErrorBar([1:margins_bef*30],nanmean(int3),Conf_Inter,'-b',1); hold on;
ylabel('NormalizedTemperature (°C)')
title('Tail Temperature')
makepretty
xlim([0 margins_bef*30]);
a=vline(margins_bef*10,'--r');  a.LineWidth=2; a=vline(margins_bef*20,'--r'); a.LineWidth=2;  
xticks([0 margins_bef*10 margins_bef*20 margins_bef*30])
xticklabels({'-30s','0s','0s','30s'})
set(gca,'FontSize',20)

a=suptitle('Physiological parameters and behaviour evolution around freezing episodes, eyelidshocks (n=10) '); a.FontSize=30;

% call MakeFigureTemperatureFreezingEpDetailled for significant figure

%% SHOCKS ANALYSIS

clear distancesBef ; clear distancesAft; clear DistBef; clear DistAft;
for zones=1:3
    for mouse=1:10
        try
            distancesBef = FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).StimTimeToStart(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).StimTimeToStart~=0);
            distancesAft = FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).StimTimeToStop(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).StimTimeToStop~=0);
            DistBef.(Zones{zones})(mouse,1:length(distancesBef))= distancesBef;
            DistAft.(Zones{zones})(mouse,1:length(distancesAft))= distancesAft;
        end
    end
end

for zones=1:3
    DistBef.(Zones{zones})=DistBef.(Zones{zones})(DistBef.(Zones{zones})~=0);
    DistAft.(Zones{zones})=DistAft.(Zones{zones})(DistAft.(Zones{zones})~=0);
end

StimBefore=abs((DistBef.Fz(find(DistBef.Fz>0))./1e4)-30).*10;
StimAfter=(abs(DistAft.Fz(find(DistAft.Fz<0))./1e4)*10)+margins_bef*20;

a=subplot(2,3,4)
histogram([StimBefore ; StimAfter], 30)
title('Shock density')
ylabel('hit numbers')
vline(margins_bef*10,'--r'); vline(margins_bef*20,'--r');
makepretty
xlim([0 margins_bef*30])
xticks([0 margins_bef*10 margins_bef*20 margins_bef*30])
xticklabels({'-30s','0s','0s','30s'})

%% Local std analysis
a=subplot(2,3,5);
bar(nanmean(all_mice.Safe.LocalStd),'b')
vline(margins_bef*10,'--r'); vline(margins_bef*20,'--r');
makepretty
a.FontSize=8;
a.LineWidth=0.2;
a=subplot(2,3,6);
bar(nanmean(all_mice.Shock.LocalStd),'r')
vline(margins_bef*10,'--r'); vline(margins_bef*20,'--r');
makepretty
a.FontSize=8;
a.LineWidth=0.2;
xlim([0 margins_bef*30])
title('Local standard deviation tail temperature')



%% Spectro analysis
% Deleting weird episodes 
for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        for ep=1:size(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).SpectroTogether,2)
            FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).SpectroTogether{ep}(margins_bef*30,1)=0;
            FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).SpectroTogether{ep}(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).SpectroTogether{ep}==0)=NaN;
        end
    end
end

% Gathering episodes in MeanSpectro
for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        Meanspectro.(Zones{zones}).(Mouse_names{mouse})=FreezingEpisodes.(Zones{zones}).M666.SpectroTogether{1}-FreezingEpisodes.(Zones{zones}).M666.SpectroTogether{1};
        for ep=1:length(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).SpectroTogether)
            if FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).SpectroTogether{ep}~=0
                Meanspectro.(Zones{zones}).(Mouse_names{mouse}) =cat(3,Meanspectro.(Zones{zones}).(Mouse_names{mouse}) , FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).SpectroTogether{ep});
                Meanspectro.(Zones{zones}).(Mouse_names{mouse}) =nansum( Meanspectro.(Zones{zones}).(Mouse_names{mouse}),3);
            end
        end
        Meanspectro.(Zones{zones}).(Mouse_names{mouse})=Meanspectro.(Zones{zones}).(Mouse_names{mouse})./(length(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse})));
    end
end

% mean spectro for each mice
micenames = fieldnames(Meanspectro.Safe);
for mouse = 1:length(micenames)
    for zones=1:length(Zones)
        AllMiceOBSpectrum.(Zones{zones})(mouse,:,:) = (zscore(Meanspectro.(Zones{zones}).(micenames{mouse})')')';
    end
end

for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        Mean_OBSpectrum.(Zones{zones}).(Mouse_names{mouse})=squeeze(AllMiceOBSpectrum.(Zones{zones})(mouse,:,:));
    end
end
    
% Extract respi from OB spectrum
for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        AllMiceRespiratoryFrequency.(Zones{zones})(mouse,:)=RespiratoryRythmFromSpectrum_BM(Mean_OBSpectrum.(Zones{zones}).(Mouse_names{mouse})')
    end
end

AllMiceRespiratoryFrequency.Safe(9,:)=NaN; % Mouse with bad spectro
AllMiceRespiratoryFrequency.Fz(9,:)=NaN; 


% Plot mean Spectro
a=subplot(121)
imagesc(squeeze(nanmean(AllMiceOBSpectrum.Shock,1)))
axis xy
a=hline(26,'--k'); a.LineWidth=4; a=hline(52,'--k'); a.LineWidth=4; a=hline(78,'--k'); a.LineWidth=4;
yticks([0:65:260])
yticklabels({'0','5','10','15','20'})
ylabel('Frequency (Hz)')
a=title('Mean Spectrogram Shock zone Freezing'); a.Color=[1 0 0];
makepretty
a=vline(margins_bef*10,'--r');  a.LineWidth=4; a=vline(margins_bef*20,'--r'); a.LineWidth=4;  
xticks([0 margins_bef*10 margins_bef*20 margins_bef*30])
xticklabels({'-30s','0s','0s','30s'})
xlim([0 margins_bef*30])
set(gca,'FontSize',20)

a=subplot(122)
imagesc(squeeze(nanmean(AllMiceOBSpectrum.Safe,1)))
axis xy
a=hline(26,'--k'); a.LineWidth=4; a=hline(52,'--k'); a.LineWidth=4; a=hline(78,'--k'); a.LineWidth=4;
yticks([0:65:260])
yticklabels({'0','5','10','15','20'})
a=title('Mean Spectrogram Safe zone Freezing'); a.Color=[0 0 1];
makepretty
a=vline(margins_bef*10,'--r');  a.LineWidth=4; a=vline(margins_bef*20,'--r'); a.LineWidth=4;  
xticks([0 margins_bef*10 margins_bef*20 margins_bef*30])
xticklabels({'-30s','0s','0s','30s'})
xlim([0 margins_bef*30])
set(gca,'FontSize',20)

a=colorbar;
ylabel(a, 'Power (n.u)')
a.FontSize=20;

a=suptitle('Physiological parameters and behaviour evolution around freezing episodes, eyelidshocks (n=10) '); a.FontSize=30;

saveFigure(1,'Physiological_Analysis_ShockSafeFz_Norm','/home/mobsmorty/Desktop/Baptiste/FiguresForSophie/')



%% Respi from OB spectrum
subplot(264)
Conf_Inter=nanstd(AllMiceRespiratoryFrequency.Safe)/sqrt(size(AllMiceRespiratoryFrequency.Safe,1));
shadedErrorBar([1:margins_bef*30],nanmean(AllMiceRespiratoryFrequency.Safe),Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(AllMiceRespiratoryFrequency.Shock)/sqrt(size(AllMiceRespiratoryFrequency.Shock,1));
shadedErrorBar([1:margins_bef*30],nanmean(AllMiceRespiratoryFrequency.Shock),Conf_Inter,'-r',1); hold on;

yticks(Spectro{3})
yticklabels({'0','1','2','3','4','5','6','7','8','9','10'})
ylim([2 8])
title('Respiratory rate')
ylabel('Frequency (Hz)')
makepretty
xlim([0 margins_bef*30])
xticks([0 margins_bef*10 margins_bef*20 margins_bef*30])
xticklabels({'-30s','0s','0s','30s'})
set(gca,'FontSize',20)
a=vline(margins_bef*10,'--r');  a.LineWidth=2; a=vline(margins_bef*20,'--r'); a.LineWidth=2;  



%% Triche
figure
subplot(2,3,4)
zones=2;
A1=[all_mice.(Zones{zones}).Respi(:,1:300) (AllMiceRespiratoryFrequency.(Zones{zones})(:,301:600)) all_mice.(Zones{zones}).Respi(:,601:900)];
int2=runmean(A1,margins_bef/5,2);
Conf_Inter=nanstd(int2)/sqrt(size(all_mice.(Zones{zones}).Respi,1));
shadedErrorBar([1:margins_bef*30],nanmean(int2),Conf_Inter,'-r',1); hold on;
zones=3;
A2=[all_mice.(Zones{zones}).Respi(:,1:300) (AllMiceRespiratoryFrequency.(Zones{zones})(:,301:600)) all_mice.(Zones{zones}).Respi(:,601:900)];
int3=runmean(A2,margins_bef/5,2);
Conf_Inter=nanstd(int3)/sqrt(size(all_mice.(Zones{zones}).Respi,1));
shadedErrorBar([1:margins_bef*30],nanmean(int3),Conf_Inter,'-b',1); hold on;
a=vline(margins_bef*10,'--r');  a.LineWidth=2; a=vline(margins_bef*20,'--r'); a.LineWidth=2;  
title('Respiratory rate')
ylabel('Frequency (Hz)')
makepretty
xlim([0 margins_bef*30])
xticks([0 margins_bef*10 margins_bef*20 margins_bef*30])
xticklabels({'-30s','0s','0s','30s'})
set(gca,'FontSize',20)

subplot(2,6,10)
K=[nanmean(A1(:,1:300)')'  nanmean(A1(:,301:600)')'  nanmean(A2(:,301:600)')'  nanmean(A2(:,1:300)')' ];
MakeSpreadAndBoxPlot2_SB(K ,Cols,X,Legends,'showpoints',0,'paired',1);
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigureTemp,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('Frequency (Hz)')
a=title( 'Respiratory Rate'); a.FontSize=25;
xticklabels({'Active shock','Freezing shock','Freezing safe','Active safe'}) 
makepretty
xtickangle(45)
set(gca,'FontSize',20)


%% Control movement
% Find episodes where movement quantity was the same after freezing either
% on the shock/safe side
for mouse =1:length(Mouse_names)
    for zones = 1:length(Zones)
        clear a b
        [a,b]= find(mean(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).Acc_Pre_Interp')<2e7 | mean(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).Acc_Pre_Interp')>3e7);
        
FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).TTempTogether(b,:)=NaN;
FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).MTempTogether(b,:)=NaN;
FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).SpeedTogether(b,:)=NaN;
FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).AccTogether(b,:)=NaN;
FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).RespiTogether(b,:)=NaN;
                try
FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).HRTogether(b,:)=NaN;
FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).HRVarTogether(b,:)=NaN;
                end
                
                for k=1:length(b)
        FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).SpectroTogether{b(k)}=[];
                end
    end
end

% Gathering episodes in MeanSpectro
for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        Meanspectro.(Zones{zones}).(Mouse_names{mouse})=FreezingEpisodes.(Zones{zones}).M666.SpectroTogether{1}-FreezingEpisodes.(Zones{zones}).M666.SpectroTogether{1};
        for ep=1:length(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).SpectroTogether)
            if FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).SpectroTogether{ep}~=0 & size(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).SpectroTogether{ep},1)==90 & size(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).SpectroTogether{ep},2)==261
                Meanspectro.(Zones{zones}).(Mouse_names{mouse}) =cat(3,Meanspectro.(Zones{zones}).(Mouse_names{mouse}) , FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse}).SpectroTogether{ep});
                Meanspectro.(Zones{zones}).(Mouse_names{mouse}) =nansum( Meanspectro.(Zones{zones}).(Mouse_names{mouse}),3);
            end
        end
        Meanspectro.(Zones{zones}).(Mouse_names{mouse})=Meanspectro.(Zones{zones}).(Mouse_names{mouse})./(length(FreezingEpisodes.(Zones{zones}).(Mouse_names{mouse})));
    end
end


% FreezingEpDetailledMovementThreshold programm for significative analysis


