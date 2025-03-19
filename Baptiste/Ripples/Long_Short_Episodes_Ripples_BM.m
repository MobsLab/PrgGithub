

load('/media/nas6/ProjetEmbReact/DataEmbReact/Create_Behav_Drugs_BM.mat', 'Epoch1')
Session_type={'Cond'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired'};
Side={'All','Shock','Safe'}; Side_ind=[3 5 6];
GetEmbReactMiceFolderList_BM

for group=[1]
    clear Mouse
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type) % generate all data required for analyses
        [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ripples','respi_freq_bm');
    end
end

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    FreezeEpoch.All.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch_nosleep');
    ZoneEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
    FreezeEpoch.Shock.(Mouse_names{mouse}) = and(FreezeEpoch.All.(Mouse_names{mouse}) , ZoneEpoch.(Mouse_names{mouse}){1});
    FreezeEpoch.Safe.(Mouse_names{mouse}) = and(FreezeEpoch.All.(Mouse_names{mouse}) , or(ZoneEpoch.(Mouse_names{mouse}){2} , ZoneEpoch.(Mouse_names{mouse}){5}));
end

for mouse=1:length(Mouse)
    for side=1:length(Side)
        
        Dur.(Side{side}).(Mouse_names{mouse}) = DurationEpoch(FreezeEpoch.(Side{side}).(Mouse_names{mouse}))/1e4;
        clear I; I = 1:length(Dur.(Side{side}).(Mouse_names{mouse}));
        Short_Fz_ind.(Side{side}).(Mouse_names{mouse}) = I(Dur.(Side{side}).(Mouse_names{mouse})<5);
        Long_Fz_ind.(Side{side}).(Mouse_names{mouse}) = I(Dur.(Side{side}).(Mouse_names{mouse})>10);
        
    end
end

% all values in epoch corresponding to episodes
% for mouse=1:length(Mouse)
%     for side=1:length(Side)
%
%         Respi.Short.(Side{side}).(Mouse_names{mouse}) = Restrict(OutPutData.SalineSB.Cond.respi_freq_bm.tsd{mouse, 3}   , subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Short_Fz_ind.(Side{side}).(Mouse_names{mouse})));
%         Respi.Long.(Side{side}).(Mouse_names{mouse}) = Restrict(OutPutData.SalineSB.Cond.respi_freq_bm.tsd{mouse, 3}   , subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Long_Fz_ind.(Side{side}).(Mouse_names{mouse})));
%
%         try
%             Ripples.Short.(Side{side}).(Mouse_names{mouse}) = Restrict(OutPutData.SalineSB.Cond.ripples.ts{mouse, 3}   , subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Short_Fz_ind.(Side{side}).(Mouse_names{mouse})));
%             Ripples.Long.(Side{side}).(Mouse_names{mouse}) = Restrict(OutPutData.SalineSB.Cond.ripples.ts{mouse, 3}   , subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Long_Fz_ind.(Side{side}).(Mouse_names{mouse})));
%         end
%     end
% end

% Mean value by episode type
for mouse=1:length(Mouse)
    for side=1:length(Side)
        
        % short episodes
        for ep=1:length(Short_Fz_ind.(Side{side}).(Mouse_names{mouse}))
            Respi.Short.(Side{side}).(Mouse_names{mouse})(ep) = nanmean(Data(Restrict(OutPutData.SalineSB.Cond.respi_freq_bm.tsd{mouse, 3}   , subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Short_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep)))));
            try
                Ripples.Short.(Side{side}).(Mouse_names{mouse})(ep) = length(Range(Restrict(OutPutData.SalineSB.Cond.ripples.ts{mouse, 3}   , subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Short_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep)))))/(DurationEpoch(subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Short_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep)))/1e4);
            catch
                Ripples.Short.(Side{side}).(Mouse_names{mouse})(ep) = NaN;
            end
        end
        
        % long episodes
        if isempty(Long_Fz_ind.(Side{side}).(Mouse_names{mouse}))
            Respi.Long.(Side{side}).(Mouse_names{mouse}) = NaN;
            Ripples.Long.(Side{side}).(Mouse_names{mouse}) = NaN;
        else
            for ep=1:length(Long_Fz_ind.(Side{side}).(Mouse_names{mouse}))
                Respi.Long.(Side{side}).(Mouse_names{mouse})(ep) = nanmean(Data(Restrict(OutPutData.SalineSB.Cond.respi_freq_bm.tsd{mouse, 3}   , subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Long_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep)))));
                try
                    Ripples.Long.(Side{side}).(Mouse_names{mouse})(ep) = length(Range(Restrict(OutPutData.SalineSB.Cond.ripples.ts{mouse, 3}   , subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Long_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep)))))/(DurationEpoch(subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Long_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep)))/1e4);
                catch
                    Ripples.Long.(Side{side}).(Mouse_names{mouse})(ep) = NaN;
                end
            end
        end
    end
end


figure
for side=1:3
    for mouse=1:length(Mouse)
        subplot(3,7,(side-1)*7+mouse)
        h=histogram(Respi.Short.(Side{side}).(Mouse_names{mouse}),'BinLimits',[1 8],'NumBins',91);
        hold on
        try
            h=histogram(Respi.Long.(Side{side}).(Mouse_names{mouse}),'BinLimits',[1 8],'NumBins',91);
        end
    end
end

figure
for side=1:3
    for mouse=1:length(Mouse)
        subplot(3,7,(side-1)*7+mouse)
        nhist({Respi.Short.(Side{side}).(Mouse_names{mouse}) Respi.Long.(Side{side}).(Mouse_names{mouse})})
    end
end

figure
for side=1:3
    for mouse=1:length(Mouse)
        subplot(3,7,(side-1)*7+mouse)
        nhist({Ripples.Short.(Side{side}).(Mouse_names{mouse}) Ripples.Long.(Side{side}).(Mouse_names{mouse})})
    end
end

h=histogram(Data(TSD_DATA.(Session_type{sess}).respi_freq_bm.tsd{mouse,Side_ind(side)}),'BinLimits',[1 8],'NumBins',91); % 91=nansum(and(1<Spectro{3},Spectro{3}<8))
HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;




%%
Session_type={'Cond'};
Side={'All','Shock','Safe'}; Side_ind=[3 5 6];
GetEmbReactMiceFolderList_BM
Mouse=[688,739,777,849];


for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ripples','respi_freq_bm');
end


for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    FreezeEpoch.All.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch_nosleep');
    ZoneEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
    FreezeEpoch.Shock.(Mouse_names{mouse}) = and(FreezeEpoch.All.(Mouse_names{mouse}) , ZoneEpoch.(Mouse_names{mouse}){1});
    FreezeEpoch.Safe.(Mouse_names{mouse}) = and(FreezeEpoch.All.(Mouse_names{mouse}) , or(ZoneEpoch.(Mouse_names{mouse}){2} , ZoneEpoch.(Mouse_names{mouse}){5}));
end


for mouse=1:length(Mouse)
    for side=1:length(Side)
              
        Dur.(Side{side}).(Mouse_names{mouse}) = DurationEpoch(FreezeEpoch.(Side{side}).(Mouse_names{mouse}))/1e4;
        clear I; I = 1:length(Dur.(Side{side}).(Mouse_names{mouse}));
        Short_Fz_ind.(Side{side}).(Mouse_names{mouse}) = I(Dur.(Side{side}).(Mouse_names{mouse})<5);
        Long_Fz_ind.(Side{side}).(Mouse_names{mouse}) = I(Dur.(Side{side}).(Mouse_names{mouse})>5);
    
    end
end

bin=5;
for mouse=1:length(Mouse)
    for side=1:length(Side)
        
        % short episodes
        for ep=1:length(Short_Fz_ind.(Side{side}).(Mouse_names{mouse}))
            clear FzType ; FzType = subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Short_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep));
            
            for i=1:ceil(DurationEpoch(subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Short_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep)))/(1e4/bin))-1
                subset_epoch = intervalSet(Start(FzType)+(i-1)*(1e4/bin) , Start(FzType)+i*(1e4/bin));
                RIP.Short.(Side{side}).(Mouse_names{mouse})(ep,i) = length(Range(Restrict(OutPutData.Cond.ripples.ts{1, 3} , subset_epoch)));
                DUR.Short.(Side{side}).(Mouse_names{mouse})(ep,i) = DurationEpoch(subset_epoch)/(1e4/bin);
            end
            
            i=ceil(DurationEpoch(subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Short_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep)))/(1e4/bin));
            subset_epoch = intervalSet(Start(FzType)+(i-1)*(1e4/bin) , Stop(FzType));
            RIP.Short.(Side{side}).(Mouse_names{mouse})(ep,i) = length(Range(Restrict(OutPutData.Cond.ripples.ts{1, 3} , subset_epoch)));
            DUR.Short.(Side{side}).(Mouse_names{mouse})(ep,i) = DurationEpoch(subset_epoch)/1e4;
            
            if ceil(DurationEpoch(subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Short_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep)))/(1e4/bin))<5*bin
                for i=ceil(DurationEpoch(subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Short_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep)))/(1e4/bin))+1:5*bin
                    RIP.Short.(Side{side}).(Mouse_names{mouse})(ep,i) = NaN;
                    DUR.Short.(Side{side}).(Mouse_names{mouse})(ep,i) = NaN;
                end
            end
        end
        RIP_DENSITY.Short.(Side{side}).(Mouse_names{mouse}) = RIP.Short.(Side{side}).(Mouse_names{mouse})./DUR.Short.(Side{side}).(Mouse_names{mouse});
        
        % long episodes
        if length(Long_Fz_ind.(Side{side}).(Mouse_names{mouse}))>0 % long episodes exist ?
        for ep=1:length(Long_Fz_ind.(Side{side}).(Mouse_names{mouse}))
            clear FzType ; FzType = subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Long_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep));
            
            if ceil(DurationEpoch(subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Long_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep)))/1e4)<30 % consider only episodes shorter then 30s
                for i=1:ceil(DurationEpoch(subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Long_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep)))/1e4)-1
                    subset_epoch = intervalSet(Start(FzType)+(i-1)*1e4 , Start(FzType)+i*1e4);
                    RIP.Long.(Side{side}).(Mouse_names{mouse})(ep,i) = length(Range(Restrict(OutPutData.Cond.ripples.ts{1, 3} , subset_epoch)));
                    DUR.Long.(Side{side}).(Mouse_names{mouse})(ep,i) = DurationEpoch(subset_epoch)/1e4;
                end
                
                i=ceil(DurationEpoch(subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Long_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep)))/1e4);
                subset_epoch = intervalSet(Start(FzType)+(i-1)*1e4 , Stop(FzType));
                RIP.Long.(Side{side}).(Mouse_names{mouse})(ep,i) = length(Range(Restrict(OutPutData.Cond.ripples.ts{1, 3} , subset_epoch)));
                DUR.Long.(Side{side}).(Mouse_names{mouse})(ep,i) = DurationEpoch(subset_epoch)/1e4;
                
                for i=ceil(DurationEpoch(subset(FreezeEpoch.(Side{side}).(Mouse_names{mouse}) , Long_Fz_ind.(Side{side}).(Mouse_names{mouse})(ep)))/1e4)+1:30
                    RIP.Long.(Side{side}).(Mouse_names{mouse})(ep,i) = NaN;
                    DUR.Long.(Side{side}).(Mouse_names{mouse})(ep,i) = NaN;
                end
            end
        end
        else
            RIP.Long.(Side{side}).(Mouse_names{mouse}) = NaN;
            DUR.Long.(Side{side}).(Mouse_names{mouse}) = NaN;
        end
        RIP_DENSITY.Long.(Side{side}).(Mouse_names{mouse}) = RIP.Long.(Side{side}).(Mouse_names{mouse})./DUR.Long.(Side{side}).(Mouse_names{mouse});
    end
end


for side=1:length(Side)
    for mouse=1:length(Mouse)
        
        RIP_DENSITY_ALL.Short.(Side{side})(mouse,:) = nanmean(RIP_DENSITY.Short.(Side{side}).(Mouse_names{mouse}));
        RIP_DENSITY_ALL.Long.(Side{side})(mouse,:) = nanmean(RIP_DENSITY.Long.(Side{side}).(Mouse_names{mouse}));
        
    end
end


figure
for side=1:length(Side)
    
    subplot(1,3,side)
    plot(runmean(RIP_DENSITY_ALL.Short.(Side{side})',3))
    
end
figure
for side=1:length(Side)
    
    subplot(1,3,side)
    plot(RIP_DENSITY_ALL.Short.(Side{side})')
    
end
figure
for side=1:length(Side)
    
    subplot(1,3,side)
    plot(RIP_DENSITY_ALL.Long.(Side{side})')
    
end


figure
plot(RIP_DENSITY_ALL.Long.(Side{1})(1,:))




%% From Ripples_Occurence_BM

Mouse=[688,739,777,849,1170,1189,11207,11251,11252,11253,11254];
Session_type={'Cond','Ext','Fear','sleep_pre','sleep_post'};
Features={'Duration','Frequency','Amplitude'};

for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ripples_all');
end

bin=20; figure
for sess=1:3%length(Session_type)
    if or(sess==4 , sess==5)
        NameEpoch{1}='Total'; NameEpoch{2}='Wake'; NameEpoch{3}='Sleep'; NameEpoch{4}='NREM'; NameEpoch{5}='REM'; NameEpoch{6}='N1'; NameEpoch{7}='N2'; NameEpoch{8}='N3'; Side=NameEpoch;
    else
        NameEpoch{1}='Total'; NameEpoch{2}='After_stim'; NameEpoch{3}='Freezing'; NameEpoch{4}='Active'; NameEpoch{5}='Freezing_shock'; NameEpoch{6}='Freezing_safe'; NameEpoch{7}='Active_shock'; NameEpoch{8}='Active_safe'; Side=NameEpoch;
    end
    
    for mouse = 1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for side=1:length(Side)
            for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse,side}))
                
                try
                    Fz_Epoch = subset(Epoch1.(Session_type{sess}){mouse,side} , ep);
                    if (DurationEpoch(Fz_Epoch)/1e4)<5
                    Ripples_during_Fz_Epoch = Restrict(TSD_DATA.(Session_type{sess}).ripples_all.tsd{mouse,side} , Fz_Epoch);
                    % start of all ripples time in this epoch, 2nd column of ripples array
                    Ripples_Norm.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(ep,1:length(Ripples_during_Fz_Epoch)) = (Range(Ripples_during_Fz_Epoch) - Start(Fz_Epoch))/sum(Stop(Fz_Epoch)-Start(Fz_Epoch));
                    
                    clear Fz_Epoch Ripples_during_Fz_Epoch
                    end
                end
                
            end
            try
                Ripples_Norm.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})(Ripples_Norm.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})==0)=NaN;
                
                h=histogram(Ripples_Norm.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),'NumBins',bin);
                HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
            end
        end
    end
end


 Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};
for group=[1 5 6]
    for sess=1:3%length(Session_type) % generate all data required for analyses
    if or(sess==4 , sess==5)
        NameEpoch{1}='Total'; NameEpoch{2}='Wake'; NameEpoch{3}='Sleep'; NameEpoch{4}='NREM'; NameEpoch{5}='REM'; NameEpoch{6}='N1'; NameEpoch{7}='N2'; NameEpoch{8}='N3'; Side=NameEpoch;
    else
        NameEpoch{1}='Total'; NameEpoch{2}='After_stim'; NameEpoch{3}='Freezing'; NameEpoch{4}='Active'; NameEpoch{5}='Freezing_shock'; NameEpoch{6}='Freezing_safe'; NameEpoch{7}='Active_shock'; NameEpoch{8}='Active_safe'; Side=NameEpoch;
    end
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            for side=1:length(Side)
                for feat=1:length(Features)
                    try
                        if isnan(runmean(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3))
                            HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,bin);
                        else
                            % ripples number normalized along considered episode
                            HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = runmean(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3);
                            % ripples number / episode number
                            HistData_ByEp.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = runmean(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),3)./(size(Ripples_Norm.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),1));
                            % ripples number / episode number / episode duration            
                            HistData_ByEp_ByDur.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = bin*runmean(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),3)./(size(Ripples_Norm.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}),1)*nanmean(Stop(Epoch1.(Session_type{sess}){mouse,side})-Start(Epoch1.(Session_type{sess}){mouse,side}))/1e4);
                        end
                    catch
                        HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,bin);
                    end
                end
            end
        end
    end
end


figure
Conf_Inter=nanstd(HistData.Freezing.Saline.Ext)/sqrt(size(HistData.Freezing.Saline.Ext,1));
shadedErrorBar([1:bin],nanmean(HistData.Freezing.Saline.Ext),Conf_Inter,'c',1); hold on;
Conf_Inter=nanstd(HistData.Freezing.Saline.Cond)/sqrt(size(HistData.Freezing.Saline.Cond,1));
shadedErrorBar([1:bin],nanmean(HistData.Freezing.Saline.Cond),Conf_Inter,'m',1); hold on;
makepretty; xlabel('normalized time (a.u.)'); ylabel('#'); 
f=get(gca,'Children'); legend([f(4),f(8)],'Cond','Ext')
hline(1/bin,'--r')


figure
Conf_Inter=nanstd(HistData.Freezing_shock.Saline.Fear)/sqrt(size(HistData.Freezing_shock.Saline.Fear,1));
shadedErrorBar([1:bin],nanmean(HistData.Freezing_shock.Saline.Fear),Conf_Inter,'r',1); hold on;
Conf_Inter=nanstd(HistData.Freezing_safe.Saline.Fear)/sqrt(size(HistData.Freezing_safe.Saline.Fear,1));
shadedErrorBar([1:bin],nanmean(HistData.Freezing_safe.Saline.Fear),Conf_Inter,'b',1); hold on;
makepretty; xlabel('normalized time (a.u.)'); 
f=get(gca,'Children'); legend([f(8),f(4)],'Shock Fz','Safe Fz')
hline(1/bin,'--r')



%%
Session_type={'Cond'};
Side={'All','Shock','Safe'}; Side_ind=[3 5 6];
GetEmbReactMiceFolderList_BM
Mouse=[688,739,777,849];


for sess=1 % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ripples','respi_freq_bm');
end


for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    FreezeEpoch.All.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch_nosleep');
    ZoneEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
    FreezeEpoch.Shock.(Mouse_names{mouse}) = and(FreezeEpoch.All.(Mouse_names{mouse}) , ZoneEpoch.(Mouse_names{mouse}){1});
    FreezeEpoch.Safe.(Mouse_names{mouse}) = and(FreezeEpoch.All.(Mouse_names{mouse}) , or(ZoneEpoch.(Mouse_names{mouse}){2} , ZoneEpoch.(Mouse_names{mouse}){5}));
end


for mouse=1:length(Mouse)
    Dur.(Side{side}).(Mouse_names{mouse}) = DurationEpoch(FreezeEpoch.(Side{side}).(Mouse_names{mouse}))/1e4;
end

bin=5;
for mouse=1:length(Mouse)
    for ep=1:length(Start(FreezeEpoch.All.(Mouse_names{mouse})))
        clear FzType ; FzType = subset(FreezeEpoch.All.(Mouse_names{mouse}) , ep);
        
        for i=1:ceil(DurationEpoch(FzType)/(1e4/bin))-1
            subset_epoch = intervalSet(Start(FzType)+(i-1)*(1e4/bin) , Start(FzType)+i*(1e4/bin));
            RIP.(Side{side}).(Mouse_names{mouse})(ep,i) = length(Range(Restrict(OutPutData.Cond.ripples.ts{1, 3} , subset_epoch)));
            DUR.(Side{side}).(Mouse_names{mouse})(ep,i) = DurationEpoch(subset_epoch)/1e4;
        end
        
        i=ceil(DurationEpoch(FzType)/(1e4/bin));
        subset_epoch = intervalSet(Start(FzType)+(i-1)*(1e4/bin) , Stop(FzType));
        RIP.(Side{side}).(Mouse_names{mouse})(ep,i) = length(Range(Restrict(OutPutData.Cond.ripples.ts{1, 3} , subset_epoch)));
        DUR.(Side{side}).(Mouse_names{mouse})(ep,i) = DurationEpoch(subset_epoch)/1e4;
        
    end
    disp(Mouse_names{mouse})
end

for mouse=1:length(Mouse)
   
    Dur_Tot.(Mouse_names{mouse}) = nansum(DUR.(Side{side}).(Mouse_names{mouse}),2);
    Rip_Tot.(Mouse_names{mouse}) = nansum(RIP.(Side{side}).(Mouse_names{mouse}),2);
    Rip_Density.(Mouse_names{mouse}) = Rip_Tot.(Mouse_names{mouse})./Dur_Tot.(Mouse_names{mouse});
    
end

figure
for mouse=1:4
    subplot(2,2,mouse)
    plot(Dur_Tot.(Mouse_names{mouse}) , Rip_Density.(Mouse_names{mouse}) , '.r')
    makepretty
end






