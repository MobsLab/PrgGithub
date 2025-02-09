
clear all
group=1;
Drug_Group={'Saline'};
Session_type={'Cond'};
Side={'All','Shock','Safe'};

GetEmbReactMiceFolderList_BM
Mouse=Drugs_Groups_UMaze_BM(22);

%%
% load('/media/nas6/ProjetEmbReact/DataEmbReact/SWR_BreathingPhase.mat')
% or
for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',...
        Mouse,lower(Session_type{sess}),'hpc_vhigh_on_respi_phase_pref','ripples','ripples_density','instphase','instfreq');
end

for sess=1:length(Session_type)
    n=1;
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        if length(OutPutData.(Session_type{sess}).ripples.ts{mouse,3})>20
            Mouse2(n) = Mouse(mouse);
            ind(n)=mouse;
            n=n+1;
        end
    end
end
% Mouse=Mouse2;
% Mouse=Mouse([3 7 10:13 16 18 23 24]);

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        MaxValue = max([max(OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.PhasePref{mouse,5}(:,50:end)) max(OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.PhasePref{mouse,6}(:,50:end))]);
        if isnan(OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.PhasePref{mouse,5})
            PhasePref.Shock.(Session_type{sess}).(Mouse_names{mouse}) = NaN(94,30);
        else
            PhasePref.Shock.(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.PhasePref{mouse,5}'./MaxValue;
        end
        if isnan(OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.PhasePref{mouse,6})
            PhasePref.Safe.(Session_type{sess}).(Mouse_names{mouse}) = NaN(94,30);
        else
            PhasePref.Safe.(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.PhasePref{mouse,6}'./MaxValue;
        end
        disp(Mouse_names{mouse})
    end
end

for sess=1:length(Session_type) % generate all data required for analyses
    for mouse=ind
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            PhasePref.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = PhasePref.Shock.(Session_type{sess}).(Mouse_names{mouse});
            PhasePref.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = PhasePref.Safe.(Session_type{sess}).(Mouse_names{mouse});
        end
    end
    PhasePref.Shock.(Drug_Group{group}).(Session_type{sess})(PhasePref.Shock.(Drug_Group{group}).(Session_type{sess})==0)=NaN;
    PhasePref.Safe.(Drug_Group{group}).(Session_type{sess})(PhasePref.Safe.(Drug_Group{group}).(Session_type{sess})==0)=NaN;
    
    PhasePref_Averaged.Shock.(Drug_Group{group}).(Session_type{sess}) = squeeze(nanmean(PhasePref.Shock.(Drug_Group{group}).(Session_type{sess})));
    PhasePref_Averaged.Safe.(Drug_Group{group}).(Session_type{sess}) = squeeze(nanmean(PhasePref.Safe.(Drug_Group{group}).(Session_type{sess})));
end


for mouse=1:length(Mouse)
    Mean_LFP_respi_shock(mouse,1:30) = OutPutData.Cond.hpc_vhigh_on_respi_phase_pref.MeanLFP{mouse,5};
    Mean_LFP_respi_safe(mouse,1:30) = OutPutData.Cond.hpc_vhigh_on_respi_phase_pref.MeanLFP{mouse,6};
end


for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for side=1:3
            if side==1
                s=3;
            elseif side==2
                s=5;
            elseif side==3
                s=6;
            end
            try
                [P,mu,Kappa,pval]=SpikeLFPModulationTransform_BM(OutPutData.(Session_type{sess}).ripples.ts{mouse,s},...
                    tsd(Range(OutPutData.(Session_type{sess}).instphase.tsd{mouse,s}),mod(Data(OutPutData.(Session_type{sess}).instphase.tsd{mouse,s})+pi/2,2*pi)),...
                    Epoch.(Session_type{sess}){mouse,s},30,0,0);
                PhaseRip.(Side{side}).(Session_type{sess}){mouse} = P.Nontransf;
                Mu_all.(Side{side}).(Session_type{sess})(mouse) = mu.Nontransf;
                Kappa_all.(Side{side}).(Session_type{sess})(mouse) = Kappa.Nontransf;
                pval_all.(Side{side}).(Session_type{sess})(mouse) = pval.Nontransf;
                
                h=histogram(PhaseRip.(Side{side}).(Session_type{sess}){mouse},'BinLimits',[0 2*pi],'NumBins',30);
                HistData.(Side{side}).(Session_type{sess})(mouse,:) = (h.Values*30)./((sum(DurationEpoch(Epoch.(Session_type{sess}){mouse,s}))/1e4)*OutPutData.Cond.instfreq.mean(mouse,s));
            end
            HistData.(Side{side}).(Session_type{sess})(HistData.(Side{side}).(Session_type{sess})==0)=NaN;
            Mu_all.(Side{side}).(Session_type{sess})(Mu_all.(Side{side}).(Session_type{sess})==0)=NaN;
            Kappa_all.(Side{side}).(Session_type{sess})(Kappa_all.(Side{side}).(Session_type{sess})==0)=NaN;
            pval_all.(Side{side}).(Session_type{sess})(pval_all.(Side{side}).(Session_type{sess})==0)=NaN;
        end
    end
end

HistData.Shock.Cond(HistData.Shock.Cond>1)=NaN;
HistData.Safe.Cond(HistData.Safe.Cond>1)=NaN;
Kappa_all.Shock.Cond(Kappa_all.Shock.Cond>2)=NaN;
Kappa_all.Safe.Cond(Kappa_all.Safe.Cond>2)=NaN;
pval_all.Safe.Cond(log10(pval_all.Shock.Cond)<-50)=NaN;


%% figures
figure
% Shock
Bins = OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase;
Freq = OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.Frequency;
for i=1:size(PhasePref_Averaged.Safe.(Drug_Group{group}).(Session_type{sess}),1)
    Phase_Pref(i,:) = interp1(linspace(0,1,size(PhasePref_Averaged.Shock.(Drug_Group{group}).(Session_type{sess}),2)) , PhasePref_Averaged.Shock.(Drug_Group{group}).(Session_type{sess})(i,:) , linspace(0,1,200));
end
subplot(221)
imagesc(linspace(0,720,60) , Freq , (Freq'.*SmoothDec([Phase_Pref(:,101:200) Phase_Pref Phase_Pref(:,1:100)],5)));
axis xy, ylim([140 250]), xticks([0 180 360 540 720]), xticklabels({'0','π','2π','3π','4π'})
caxis([50 1.2e2])
makepretty_BM2
hold on
ylabel('Frequency (Hz)')

Data_to_use = Mean_LFP_respi_shock(ind,:);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
Conf_Inter=(Conf_Inter/(max(Mean_All_Sp)-min(Mean_All_Sp)))*20
Mean_All_Sp = ((Mean_All_Sp-min(Mean_All_Sp))/(max(Mean_All_Sp)-min(Mean_All_Sp)))*20+220;
shadedErrorBar(linspace(0,720,60) , [Mean_All_Sp Mean_All_Sp] , [Conf_Inter Conf_Inter],'-w',1); hold on;

title('Shock')


subplot(223)
Data_to_use = HistData.Shock.Cond;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,720,60) , runmean([Mean_All_Sp Mean_All_Sp],5) , runmean([Conf_Inter Conf_Inter],5) ,'-k',1); hold on;
xlim([0 720]), xticks([0 180 360 540 720]), xticklabels({'0','π','2π','3π','4π'})
box off, xlabel('Phase (rad)')
makepretty_BM, makepretty_BM2
ylim([0 .25])


% Safe
sess=1;
Bins = OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase;
Freq = OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.Frequency;
for i=1:size(PhasePref_Averaged.Safe.(Drug_Group{group}).(Session_type{sess}),1)
    Phase_Pref(i,:) = interp1(linspace(0,1,size(PhasePref_Averaged.Safe.(Drug_Group{group}).(Session_type{sess}),2)) , PhasePref_Averaged.Safe.(Drug_Group{group}).(Session_type{sess})(i,:) , linspace(0,1,200));
end

subplot(222)
imagesc(linspace(0,720,60) , Freq , (Freq'.*SmoothDec([Phase_Pref(:,101:200) Phase_Pref Phase_Pref(:,1:100)],5)));
axis xy, ylim([140 250]), xticks([0 180 360 540 720]), xticklabels({'0','π','2π','3π','4π'})
caxis([50 1.2e2])
makepretty_BM2
hold on
ylabel('Frequency (Hz)')

colormap jet

Data_to_use = Mean_LFP_respi_safe(ind,:);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
Conf_Inter=(Conf_Inter/(max(Mean_All_Sp)-min(Mean_All_Sp)))*20;
Mean_All_Sp = ((Mean_All_Sp-min(Mean_All_Sp))/(max(Mean_All_Sp)-min(Mean_All_Sp)))*20+220;
shadedErrorBar(linspace(0,720,60) , [Mean_All_Sp Mean_All_Sp] , [Conf_Inter Conf_Inter],'-w',1); hold on;

title('Safe')


subplot(224)
Data_to_use = HistData.Safe.Cond;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,720,60) , runmean([Mean_All_Sp Mean_All_Sp],5) , runmean([Conf_Inter Conf_Inter],5) ,'-k',1); hold on;
xlim([0 720]), xticks([0 180 360 540 720]), xticklabels({'0','π','2π','3π','4π'})
box off
xlabel('Phase (rad)'), ylabel('number of events (#/cycle)')
makepretty_BM, makepretty_BM2
ylim([0 .25])




Cols = {[1 .5 .5],[.5 .5 1]};
X = [1:2];
Legends = {'Shock','Safe'};



figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({Mu_all.Shock.Cond Mu_all.Safe.Cond },Cols,X,Legends,'showpoints',0,'paired',1);
yticks([0 1.57 3.14 4.71 6.28]), yticklabels({'0','π/2','π','3π/2','2π'}), ylabel('mu')
makepretty_BM2

subplot(132)
MakeSpreadAndBoxPlot3_SB({Kappa_all.Shock.Cond Kappa_all.Safe.Cond },Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Kappa')
makepretty_BM2

subplot(133)
MakeSpreadAndBoxPlot3_SB({pval_all.Shock.Cond pval_all.Safe.Cond },Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('p-val')
makepretty_BM2
 


figure
MakeSpreadAndBoxPlot3_SB({Kappa_all.Shock.Cond(pval_all.Shock.Cond<.05) Kappa_all.Safe.Cond(pval_all.Safe.Cond<.05)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Kappa'), makepretty_BM2





%% toolbox
figure, n=1;
for mouse=1:length(Mouse)
    if sum(sum(isnan(squeeze(PhasePref.Safe.(Session_type{sess}).(Mouse_names{mouse})))))~=2820
        subplot(4,7,n)
        imagesc([OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase+354] , OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.Frequency ,...
            [squeeze(PhasePref.Safe.(Session_type{sess}).(Mouse_names{mouse})) squeeze(PhasePref.Safe.(Session_type{sess}).(Mouse_names{mouse}))]);
        axis xy; ylim([120 250]); caxis([0 1]);
        makepretty_BM
        
        n=n+1;
    end
end



%% old version
for sess=1:length(Session_type) % generate all data required for analyses
    figure
    Mouse=Drugs_Groups_UMaze_BM(11);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        subplot(2,length(Mouse),mouse)
        imagesc([OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase+354] , OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.Frequency , [squeeze(PhasePref.Shock.(Session_type{sess}).(Mouse_names{mouse})) squeeze(PhasePref.Shock.(Session_type{sess}).(Mouse_names{mouse}))]);
        axis xy; ylim([120 250]); caxis([0 1]);
        makepretty;
        title(['Mouse n°' num2str(Mouse(mouse))]);
        if mouse==1; ylabel('Frequency (Hz)'); u=text(-200,160,'Shock'); set(u,'FontSize',30,'FontWeight','bold'); set(u,'Rotation',90); end
        
        subplot(2,length(Mouse),mouse+length(Mouse))
        imagesc([OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase+354] , OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.Frequency , [squeeze(PhasePref.Safe.(Session_type{sess}).(Mouse_names{mouse})) squeeze(PhasePref.Safe.(Session_type{sess}).(Mouse_names{mouse}))]);
        axis xy; ylim([120 250]); caxis([0 1]);
        makepretty;
        xlabel('Phase (°)')
        if mouse==1; ylabel('Frequency (Hz)'); u=text(-200,160,'Safe'); set(u,'FontSize',30,'FontWeight','bold'); set(u,'Rotation',90); end
    end
    colormap jet
    a=suptitle(['HPC VHigh Spectrum on breathing phase, ' Session_type{sess} ' sessions, ' Drug_Group{group} ', n = ' num2str(length(Mouse))]); a.FontSize=20;
end

for sess=1:length(Session_type) % generate all data required for analyses
    figure, n=1;
    for group=11%:4
        
        subplot(2,4,n)
        imagesc([OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase+354] , OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.Frequency , [PhasePref_Averaged.Shock.(Drug_Group{group}).(Session_type{sess}) PhasePref_Averaged.Shock.(Drug_Group{group}).(Session_type{sess})]);
        axis xy; ylim([120 250]); caxis([0 1]);
        makepretty;
        title([Drug_Group{group}])
        if n==1; ylabel('Frequency (Hz)'); u=text(-150,160,'Shock'); set(u,'FontSize',30,'FontWeight','bold'); set(u,'Rotation',90); end
        
        subplot(2,4,n+4)
        imagesc([OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase+354], OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.Frequency , [PhasePref_Averaged.Safe.(Drug_Group{group}).(Session_type{sess}) PhasePref_Averaged.Safe.(Drug_Group{group}).(Session_type{sess})]);
        axis xy; ylim([120 250]); caxis([0 1]);
        makepretty;
        xlabel('Phase (°)')
        if n==1; ylabel('Frequency (Hz)'); u=text(-150,160,'Safe'); set(u,'FontSize',30,'FontWeight','bold'); set(u,'Rotation',90); end
        
    end
    a=suptitle(['HPC VHigh Spectrum on breathing phase, ' Session_type{sess} ' sessions']); a.FontSize=20;
    colormap jet
end

for sess=1:length(Session_type) % generate all data required for analyses
    figure
    for group=5:8
        
        subplot(2,4,group-4)
        imagesc([OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase+354] , OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.Frequency , [PhasePref_Averaged.Shock.(Drug_Group{group}).(Session_type{sess}) PhasePref_Averaged.Shock.(Drug_Group{group}).(Session_type{sess})]);
        axis xy; ylim([120 250]); caxis([0 1]);
        makepretty;
        title([Drug_Group{group}])
        if group==5; ylabel('Frequency (Hz)'); u=text(-150,160,'Shock'); set(u,'FontSize',30,'FontWeight','bold'); set(u,'Rotation',90); end
        
        subplot(2,4,group)
        imagesc([OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase+354], OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.Frequency , [PhasePref_Averaged.Safe.(Drug_Group{group}).(Session_type{sess}) PhasePref_Averaged.Safe.(Drug_Group{group}).(Session_type{sess})]);
        axis xy; ylim([120 250]); caxis([0 1]);
        makepretty;
        xlabel('Phase (°)')
        if group==5; ylabel('Frequency (Hz)'); u=text(-150,160,'Safe'); set(u,'FontSize',30,'FontWeight','bold'); set(u,'Rotation',90); end
        
    end
    a=suptitle(['HPC VHigh Spectrum on breathing phase, ' Session_type{sess} ' sessions']); a.FontSize=20;
    colormap jet
end

for sess=1:length(Session_type) % generate all data required for analyses
    figure
    for group=9:14
        
        subplot(2,6,group-8)
        imagesc([OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase+354] , OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.Frequency , [PhasePref_Averaged.Shock.(Drug_Group{group}).(Session_type{sess}) PhasePref_Averaged.Shock.(Drug_Group{group}).(Session_type{sess})]);
        axis xy; ylim([120 250]); caxis([0 1]);
        makepretty;
        title([Drug_Group{group}])
        if group==9; ylabel('Frequency (Hz)'); u=text(-150,160,'Shock'); set(u,'FontSize',30,'FontWeight','bold'); set(u,'Rotation',90); end
        
        subplot(2,6,group-2)
        imagesc([OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase+354], OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.Frequency , [PhasePref_Averaged.Safe.(Drug_Group{group}).(Session_type{sess}) PhasePref_Averaged.Safe.(Drug_Group{group}).(Session_type{sess})]);
        axis xy; ylim([120 250]); caxis([0 1]);
        makepretty;
        xlabel('Phase (°)')
        if group==9; ylabel('Frequency (Hz)'); u=text(-150,160,'Safe'); set(u,'FontSize',30,'FontWeight','bold'); set(u,'Rotation',90); end
        
    end
    a=suptitle(['HPC VHigh Spectrum on breathing phase, ' Session_type{sess} ' sessions']); a.FontSize=20;
    colormap jet
end


for f=1:8
    saveFigure(f,['Ripples_Phase_Breathing' num2str(f)],'/home/mobsmorty/Desktop/FinalFigures/')
end



%% 2nd method: use InstFreq phase and made events distribution
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS'};
Session_type={'Cond','Ext'};
GetEmbReactMiceFolderList_BM
Side={'All','Shock','Safe'}; Side_ind=[3 5 6];

for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'instphase','ripples');
end

for sess=1:length(Session_type) % generate all data required for analyses
    for mouse = 1:length(Mouse)
        
        for side=1:length(Side)
            try
                h=histogram(Data(Restrict(OutPutData.(Session_type{sess}).instphase.tsd{mouse,Side_ind(side)} , OutPutData.(Session_type{sess}).ripples.ts{mouse,Side_ind(side)}))/(2*pi),'BinLimits',[0 1],'NumBins',20);
                HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
            end
        end
    end
end


for group=1:length(Drug_Group)
    
    Drugs_Groups_Ripples_UMaze_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            for side=1:length(Side)
                try
                    if isnan(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})))
                        HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,20);
                    else
                        HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}));
                    end
                catch
                    HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,91);
                end
            end
        end
    end
end

bin = linspace(0,1,20); bin2 = linspace(0,1,40);
figure
for group=1:4
    for sess=1:length(Session_type)
        subplot(2,4,(sess-1)*4+group)
        try
            Conf_Inter=nanstd(HistData.Shock.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.Shock.(Drug_Group{group}).(Session_type{sess}),1));
            shadedErrorBar(bin,runmean(nanmean(HistData.Shock.(Drug_Group{group}).(Session_type{sess})),3) , runmean(Conf_Inter,3),'r',1); hold on;
        end
        try
            Conf_Inter=nanstd(HistData.Safe.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.Safe.(Drug_Group{group}).(Session_type{sess}),1));
            shadedErrorBar(bin,runmean(nanmean(HistData.Safe.(Drug_Group{group}).(Session_type{sess})),3),runmean(Conf_Inter,3),'b',1); hold on;
        end
        if sess==1; title(Drug_Group{group}); end
        if group==1; ylabel(Session_type{sess}); end
        if and(sess==1 , group==1); f=get(gca,'Children'); legend([f(5),f(1)],'Shock','Safe'); end
        makepretty; grid on
        xticks([0 .5 1]); xticklabels({'0','π','2π'})
    end
end
a=suptitle(['Ripples events on breathing phase']); a.FontSize=20;


figure
for group=5:8
    for sess=1:length(Session_type)
        subplot(2,4,(sess-1)*4+group-4)
        try
            Conf_Inter=nanstd(HistData.Shock.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.Shock.(Drug_Group{group}).(Session_type{sess}),1));
            shadedErrorBar(bin,runmean(nanmean(HistData.Shock.(Drug_Group{group}).(Session_type{sess})),3) , runmean(Conf_Inter,3),'r',1); hold on;
        end
        try
            Conf_Inter=nanstd(HistData.Safe.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.Safe.(Drug_Group{group}).(Session_type{sess}),1));
            shadedErrorBar(bin,runmean(nanmean(HistData.Safe.(Drug_Group{group}).(Session_type{sess})),3),runmean(Conf_Inter,3),'b',1); hold on;
        end
        if sess==1; title(Drug_Group{group}); end
        if group==5; ylabel(Session_type{sess}); end
        if and(sess==1 , group==5); f=get(gca,'Children'); legend([f(5),f(1)],'Shock','Safe'); end
        makepretty; grid on
        xticks([0 .5 1]); xticklabels({'0','π','2π'})
    end
end
a=suptitle(['Ripples events on breathing phase']); a.FontSize=20;











