%% Limits study (shock, onset, offset,...) 

Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
Mouse=[666 667 668 669 688 739 777 779 849 893];
for mouse = 1:length(Mouse_names)
    Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
end
CondSess.M666=[{CondSess.M666{1}} {CondSess.M666{4}} {CondSess.M666{7}} {CondSess.M666{8}}];


Zones={'Stim','FreezingOnset','FreezingOffset'};
for zones=1:length(Zones)
    for mouse=1:length(Mouse)
        Episodes= Temperature_ShockEpisodes(Mouse(mouse),CondSess,Zones{zones},10,'Yes','Yes','Yes','Yes','Yes');
        On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse})=Episodes;
    end
end

clear all_mice_onset; 
for zones=1:length(Zones)
%Gathering all episodes in an array
    all_mice_onset.(Zones{zones}).TTemp=[];
    all_mice_onset.(Zones{zones}).MTemp=[];
    all_mice_onset.(Zones{zones}).Respi=[];
    all_mice_onset.(Zones{zones}).HR=[];
    all_mice_onset.(Zones{zones}).HRVar=[];
    all_mice_onset.(Zones{zones}).Speed=[];
    all_mice_onset.(Zones{zones}).Acc=[];
    all_mice_onset.(Zones{zones}).RespiBis=[];    
        for mouse=1:length(Mouse_names)
            all_mice_onset.(Zones{zones}).TTemp=[all_mice_onset.(Zones{zones}).TTemp ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).TTemp_Interp')];
            all_mice_onset.(Zones{zones}).MTemp=[all_mice_onset.(Zones{zones}).MTemp ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).MTemp_Interp')];
            all_mice_onset.(Zones{zones}).Respi=[all_mice_onset.(Zones{zones}).Respi; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).Respi_Interp')];
            all_mice_onset.(Zones{zones}).HR=[all_mice_onset.(Zones{zones}).HR ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).HR_Interp')];
            all_mice_onset.(Zones{zones}).HRVar=[all_mice_onset.(Zones{zones}).HRVar ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).HRVar_Interp')];
            all_mice_onset.(Zones{zones}).Speed=[all_mice_onset.(Zones{zones}).Speed ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).Speed_Interp')];
            all_mice_onset.(Zones{zones}).Acc=[all_mice_onset.(Zones{zones}).Acc ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).Acc_Interp')];
            all_mice_onset.(Zones{zones}).RespiBis=[all_mice_onset.(Zones{zones}).RespiBis ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).RespiFrom_OB_Interp')];
        end
    all_mice_onset.(Zones{zones}).HR([5 8 10],:)=NaN;
    all_mice_onset.(Zones{zones}).HRVar([5 8 10],:)=NaN;
end
       
for mouse=1:length(Mouse_names)
    MeanTTempPerMice.(Mouse_names{mouse})=nanmean(Data(ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'tailtemperature')));
    MeanMTempPerMice.(Mouse_names{mouse})=nanmean(Data(ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'masktemperature')));
end


% Substract mean temperature
for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        all_mice_onset.(Zones{zones}).TTemp(mouse,:)=all_mice_onset.(Zones{zones}).TTemp(mouse,:)-MeanTTempPerMice.(Mouse_names{mouse});
        all_mice_onset.(Zones{zones}).MTemp(mouse,:)=all_mice_onset.(Zones{zones}).MTemp(mouse,:)-MeanMTempPerMice.(Mouse_names{mouse});
    end
end


% Gathering episodes in MeanSpectro
for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        Meanspectro.(Zones{zones}).(Mouse_names{mouse})=On_Offset_Freezing.(Zones{zones}).M666.Spectro_Interp{1}-On_Offset_Freezing.(Zones{zones}).M666.Spectro_Interp{1};
        for ep=1:length(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).Spectro_Interp)
            if On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).Spectro_Interp{ep}~=0
                Meanspectro.(Zones{zones}).(Mouse_names{mouse}) =cat(3,Meanspectro.(Zones{zones}).(Mouse_names{mouse}) , On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).Spectro_Interp{ep});
                Meanspectro.(Zones{zones}).(Mouse_names{mouse}) =nansum( Meanspectro.(Zones{zones}).(Mouse_names{mouse}),3);
            end
        end
        Meanspectro.(Zones{zones}).(Mouse_names{mouse})=Meanspectro.(Zones{zones}).(Mouse_names{mouse})./(length(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse})));
    end
end





for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        
Respi.(Zones{zones}).(Mouse_names{mouse})=RespiratoryRythmFromSpectrum_BM(Meanspectro.(Zones{zones}).(Mouse_names{mouse}));

    end
end


figure
for mouse=1:length(Mouse_names)
    subplot(2,5,mouse)
    plot(Respi.(Zones{zones}).(Mouse_names{mouse}))
    yticks([1:12:121])
yticklabels({'0','1','2','3','4','5','6','7','8','9','10'})
ylim([0 120])
end

figure
for mouse=1:length(Mouse_names)
    subplot(2,5,mouse)
    imagesc(Meanspectro.(Zones{zones}).(Mouse_names{mouse})')
    axis xy
end

micenames = fieldnames(Meanspectro.Stim);
for zones=1:length(Zones)
    for ep = 1:length(micenames)
        AllMiceSpectrum.(Zones{zones})(ep,:,:) = (zscore(Meanspectro.(Zones{zones}).(micenames{ep})')')';
    end
end
    
figure
imagesc(squeeze(nanmean(AllMiceSpectrum.(Zones{zones}),1)))
axis xy
RespiAll.(Zones{zones})=RespiratoryRythmFromSpectrum2_BM(squeeze(nanmean(AllMiceSpectrum.(Zones{zones}),1))');

  


zones=1;    zones=2;    zones=3;
figure
Conf_Inter=nanstd(all_mice_onset.(Zones{zones}).RespiBis)/sqrt(size(all_mice_onset.(Zones{zones}).RespiBis,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.(Zones{zones}).RespiBis),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
makepretty
xticklabels({'-10s','0s','10s'})
set(gca,'FontSize',20)
yticks([1:6:121])
yticklabels({'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5','5','5.5','6','6.5','7','7.5','8','9','10'})
a=vline(50,'--r'); a.LineWidth=5;


