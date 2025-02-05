
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Generate data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sound conditioning

Mouse=[244,243,253,254,258,259,299,394,395,402,403,450,451,248];
Session_type={'sound_test'};
for sess=1:length(Session_type) 
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('sound_test',Mouse,lower(Session_type{sess}),...
        'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','ob_low');
end
save('Data_SoundTest.mat','Epoch1','Mouse','NameEpoch','OutPutData',...
    'Session_type','sess') % Mast saved by SB 4/02/2024 with correction for ob_gamma


%% Paired data for sound cond & Maze

Mouse=[439 490 507 508 509 510 512 514];    
Session_type={'sound_test_umze'};
for sess=1:length(Session_type) 
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('sound_test_umze',Mouse,lower(Session_type{sess}),...
        'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','ob_low');
end
cd /media/nas7/ProjetEmbReact/DataEmbReact
save('Data_SoundTest_MazeMice.mat','Epoch1','Mouse','NameEpoch','OutPutData',...
    'Session_type','sess') % Mast saved by SB 4/02/2024 with correction for ob_gamma


%% Contextual fear conditionning
Mouse=[923 926 927 928 929];
Session_type={'fear_ctxt'};
for sess=1:length(Session_type) 
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Session_type{sess},Mouse,lower(Session_type{sess}),...
        'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','ob_low');
end
save('Data_FearCtxt.mat','Epoch1','Mouse','NameEpoch','OutPutData',...
    'Session_type','sess') % Mast saved by SB 4/02/2024 with correction for ob_gamma


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mean spectrum
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/OB_Spec.mat', 'OB_MeanSpecFz_Shock', 'OB_MeanSpecFz_Safe')

figure
[h , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock.Ext, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 1);
[h , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe.Ext , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 1);
close
% Freq_Max1(7)=NaN; Freq_Max2(7)=1.373;
% Freq_Max1(8)=2.747; Freq_Max2(8)=NaN;


figure
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock.Ext, 'color' , [1 .5 .5] , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe.Ext , 'color' , [.5 .5 1] , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));

f=get(gca,'Children'); l=legend([f(5),f(1)],'Shock','Safe'); l.Box='off';
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 10]); ylim([0 1])
makepretty
v1=vline(nanmean(4.122)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(2.214)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])
axis square


load('FearCondSound.mat', 'OutPutData')
OutPutData_Sound = OutPutData;
load('FearCtxt.mat', 'OutPutData')
OutPutData_Ctxt = OutPutData;

figure
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData_Sound.sound_test.ob_low.mean(:,2,:)), 'color' , [.8 .1 .2] , 'smoothing' , 3 , 'dashed_line',0);
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData_Ctxt.fear_ctxt.ob_low.mean(:,2,:)), 'color' , [1 .4 .1] , 'smoothing' , 3 , 'threshold' , 26, 'dashed_line',0);
xlim([0 10]); ylim([0 1])
makepretty
xticks([0:2:14])
axis square
v1=vline(nanmean(4.122)); set(v1,'LineStyle','--','Color',[1 .5 .5] , 'LineWidth',3); v2=vline(nanmean(2.214)); set(v2,'LineStyle','--','Color',[.5 .5 1], 'LineWidth',3)
f=get(gca,'Children'); l=legend([f(5),f(1)],'Sound recall','Context recall'); l.Box='off';


%% Box plots
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/FearCondSound.mat', 'Freq_Max_Shock_FearSound','Freq_Max1','Freq_Max2')
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/FearCtxt.mat', 'Freq_Max_Shock_FearCtxt')

Freq_Max1(46)=4.959;
Freq_Max2(30)=NaN;

Cols = {[1 .5 .5],[.5 .5 1],[.8 .1 .2],[1 .4 .1]};
X = 1:4;
Legends = {'Shock','Safe','Sound','Context'};

figure
MakeSpreadAndBoxPlot3_SB({Freq_Max1(26:end) Freq_Max2(26:end) Freq_Max_Shock_FearSound Freq_Max_Shock_FearCtxt},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 8]), ylabel('Breathing (Hz)'), yticks([0:8])
makepretty_BM2


load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/MeanBodyValues_Fz.mat', 'Ripples_Shock', 'Ripples_Safe')

figure
MakeSpreadAndBoxPlot3_SB({Ripples_Shock.Ext(26:end) Ripples_Safe.Ext(26:end) OutPutData_Sound.sound_test.ripples_density.mean(:,2) OutPutData_Ctxt.fear_ctxt.ripples_density.mean(:,2)},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .8]), ylabel('Ripples occurence (#/s)')
makepretty_BM2




load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/FearCondSound.mat', 'SVM_scores_Sound')
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/FearCtxt.mat', 'SVM_scores_Ctxt')
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SVM_Sal_MouseByMouse_CondPost.mat','SVMScores_Sk_Ctrl','SVMScores_Sf_Ctrl')
svm_type=1;

SVMChoice_Sf_Ctrl{svm_type}(SVMScores_Sf_Ctrl{svm_type}==0) = NaN;
SVMScores_Sf_Ctrl{svm_type}(SVMScores_Sf_Ctrl{svm_type}==0) = NaN;
SVMChoice_Sk_Ctrl{svm_type}(SVMScores_Sk_Ctrl{svm_type}==0) = NaN;
SVMScores_Sk_Ctrl{svm_type}(SVMScores_Sk_Ctrl{svm_type}==0) = NaN;


figure
MakeSpreadAndBoxPlot3_SB({SVMScores_Sk_Ctrl{svm_type}(1,:) SVMScores_Sf_Ctrl{svm_type}(1,:) SVM_scores_Sound...
    SVM_scores_Ctxt},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('SVM score (a.u.)')



%% PCA
Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition'};

DATA2(1,:) = Freq_Max_Shock_FearSound;
for par=2:8
    DATA2(par,:) = OutPutData_Sound.sound_test.(Params{par}).mean(:,2)';
end
DATA2([4 5],:)=[];

ind=sum(isnan(DATA2))==0;

load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/PCA_Analysis_Ext.mat','PC_values_shock','PC_values_safe', 'mu', 'sigma', 'eigen_vector')
DATA3 = ((DATA2-mu')./sigma')';

for pc=1:size(eigen_vector,2)
    for mouse=1:size(DATA3,1)
        try
            ind = ~isnan(DATA3(mouse,:));
            PC_values_sound_test{pc}(mouse) = eigen_vector(ind,pc)'*DATA3(mouse,ind)';
        end
    end
end

figure
subplot(221)
plot(PC_values_sound_test{1} , PC_values_sound_test{2},'.','MarkerSize',30,'Color',[.8 .1 .2]), hold on
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
ind1 = and(~isnan(PC_values_shock{1}) , ~isnan(PC_values_shock{2}));
ind2 = and(~isnan(PC_values_safe{1}) , ~isnan(PC_values_safe{2}));
ind3 = and(~isnan(PC_values_sound_test{1}) , ~isnan(PC_values_sound_test{2}));
Bar_shock = [nanmedian(PC_values_shock{1}(ind1)) nanmedian(PC_values_shock{2}(ind1))];
Bar_safe = [nanmedian(PC_values_safe{1}(ind2)) nanmedian(PC_values_safe{2}(ind2))];
Bar_restr = [nanmedian(PC_values_sound_test{1}(ind3)) nanmedian(PC_values_sound_test{2}(ind3))];
for mouse=1:length(PC_values_sound_test{1})
    line([Bar_restr(1) PC_values_sound_test{1}(mouse)],[Bar_restr(2) PC_values_sound_test{2}(mouse)],'LineStyle','--','Color',[.8 .1 .2])
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
plot(Bar_restr(1),Bar_restr(2),'.','MarkerSize',60,'Color',[.8 .1 .2])
f=get(gca,'Children'); legend([f([3 2 1])],'Shock','Safe','Sound');


subplot(222)
plot(PC_values_sound_test{3} , PC_values_sound_test{4},'.','MarkerSize',30,'Color',[.8 .1 .2]), hold on
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
ind1 = and(~isnan(PC_values_shock{3}) , ~isnan(PC_values_shock{4}));
ind2 = and(~isnan(PC_values_safe{3}) , ~isnan(PC_values_safe{4}));
ind3 = and(~isnan(PC_values_sound_test{3}) , ~isnan(PC_values_sound_test{4}));
Bar_shock = [nanmedian(PC_values_shock{3}(ind1)) nanmedian(PC_values_shock{4}(ind1))];
Bar_safe = [nanmedian(PC_values_safe{3}(ind2)) nanmedian(PC_values_safe{4}(ind2))];
Bar_restr = [nanmedian(PC_values_sound_test{3}(ind3)) nanmedian(PC_values_sound_test{4}(ind3))];
for mouse=1:length(PC_values_sound_test{3})
    line([Bar_restr(1) PC_values_sound_test{3}(mouse)],[Bar_restr(2) PC_values_sound_test{4}(mouse)],'LineStyle','--','Color',[.8 .1 .2])
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
plot(Bar_restr(1),Bar_restr(2),'.','MarkerSize',60,'Color',[.8 .1 .2])




clear DATA2 DATA3
DATA2(1,:) = Freq_Max_Shock_FearCtxt;
for par=2:8
    DATA2(par,:) = OutPutData.fear_ctxt.(Params{par}).mean(:,2)';
end
DATA2([4 5],:)=[];

ind=sum(isnan(DATA2))==0;

DATA3 = ((DATA2-mu')./sigma')';

for pc=1:size(eigen_vector,2)
    for mouse=1:size(DATA3,1)
        try
            ind = ~isnan(DATA3(mouse,:));
            PC_values_fear_ctxt{pc}(mouse) = eigen_vector(ind,pc)'*DATA3(mouse,ind)';
        end
    end
end


subplot(223)
plot(PC_values_fear_ctxt{1} , PC_values_fear_ctxt{2},'.','MarkerSize',30,'Color',[1 .4 .1]), hold on
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
ind1 = and(~isnan(PC_values_shock{1}) , ~isnan(PC_values_shock{2}));
ind2 = and(~isnan(PC_values_safe{1}) , ~isnan(PC_values_safe{2}));
ind3 = and(~isnan(PC_values_fear_ctxt{1}) , ~isnan(PC_values_fear_ctxt{2}));
Bar_shock = [nanmedian(PC_values_shock{1}(ind1)) nanmedian(PC_values_shock{2}(ind1))];
Bar_safe = [nanmedian(PC_values_safe{1}(ind2)) nanmedian(PC_values_safe{2}(ind2))];
Bar_restr = [nanmedian(PC_values_fear_ctxt{1}(ind3)) nanmedian(PC_values_fear_ctxt{2}(ind3))];
for mouse=1:length(PC_values_fear_ctxt{1})
    line([Bar_restr(1) PC_values_fear_ctxt{1}(mouse)],[Bar_restr(2) PC_values_fear_ctxt{2}(mouse)],'LineStyle','--','Color',[.8 .1 .2])
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
plot(Bar_restr(1),Bar_restr(2),'.','MarkerSize',60,'Color',[1 .4 .1])
f=get(gca,'Children'); legend([f([3 2 1])],'Shock','Safe','Sound');


subplot(224)
plot(PC_values_fear_ctxt{3} , PC_values_fear_ctxt{4},'.','MarkerSize',30,'Color',[1 .4 .1]), hold on
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
ind1 = and(~isnan(PC_values_shock{3}) , ~isnan(PC_values_shock{4}));
ind2 = and(~isnan(PC_values_safe{3}) , ~isnan(PC_values_safe{4}));
ind3 = and(~isnan(PC_values_fear_ctxt{3}) , ~isnan(PC_values_fear_ctxt{4}));
Bar_shock = [nanmedian(PC_values_shock{3}(ind1)) nanmedian(PC_values_shock{4}(ind1))];
Bar_safe = [nanmedian(PC_values_safe{3}(ind2)) nanmedian(PC_values_safe{4}(ind2))];
Bar_restr = [nanmedian(PC_values_fear_ctxt{3}(ind3)) nanmedian(PC_values_fear_ctxt{4}(ind3))];
for mouse=1:length(PC_values_fear_ctxt{3})
    line([Bar_restr(1) PC_values_fear_ctxt{3}(mouse)],[Bar_restr(2) PC_values_fear_ctxt{4}(mouse)],'LineStyle','--','Color',[1 .4 .1])
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
plot(Bar_restr(1),Bar_restr(2),'.','MarkerSize',60,'Color',[1 .4 .1])




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% others
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Sound test & OB power
Mouse=[244,243,253,254,258,259,299,394,395,402,403,450,451,248];
Session_type={'sound_test'};
for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('sound_test',Mouse,lower(Session_type{sess}),...
        'speed');
end

SoundCondSess = SoundCondSess2;
for mouse=1:length(Mouse)
   Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
   OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(SoundCondSess.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
end

ind=13:91; %ind=39:78; 13-91 --> 1-7Hz
for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            
            % fz
            if isempty(Start(Epoch1.(Session_type{sess}){mouse,2}))
                OB_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse}=NaN;
            else
                for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse,2}))
                    try
                        FzEp = subset(Epoch1.(Session_type{sess}){mouse,2},ep);
                        OB_Fz_Shock.(Session_type{sess}){mouse}{ep} = Restrict(OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) , FzEp);
                        
                        clear D
                        D = Data(OB_Fz_Shock.(Session_type{sess}){mouse}{ep});
                        OB_Mean_Fz_Shock.(Session_type{sess}){mouse}(ep,1:size(D,1)) = nansum(D(:,ind)'); % frequency band sum
                        % interpolanting spectrogram
                        for i=1:261
                            OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse}(ep,i,:) = interp1(linspace(0,1,size(D,1)) , D(:,i) , linspace(0,1,100));
                        end
                        
                        FzLength_Shock.(Session_type{sess}){mouse}(ep) = sum(DurationEpoch(FzEp))/1e4;
                        OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}(ep) = nanmean(nansum(D(:,ind)'));
                        OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}(OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}==0)=NaN;
                        
                        OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse}(ep,:,:) = OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse}(ep,:,:)./OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse}(ep);
                        OB_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse}(ep,:) = nanmean(squeeze(OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse}(ep,ind,:)));
                        OB_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse}(OB_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse}==0)=NaN;
                    end
                end
            end
        end
        disp(Mouse_names{mouse})
    end
end


for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        if ~isempty(OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse})
            if size(OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse},1)==1
                All_OB_SpecNorm_Fz_Shock.(Session_type{sess})(mouse,:,:) = squeeze(OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse});
            else
                All_OB_SpecNorm_Fz_Shock.(Session_type{sess})(mouse,:,:) = squeeze(nanmean(OB_SpecNorm_Fz_Shock.(Session_type{sess}){mouse}));
            end
        end
        
        FzLength_Shock.(Session_type{sess}){mouse}(FzLength_Shock.(Session_type{sess}){mouse}==0)=NaN;        
    end
end


figure
for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        try
            [R_shock.(Session_type{sess})(mouse),P_shock.(Session_type{sess})(mouse)] = PlotCorrelations_BM(FzLength_Shock.(Session_type{sess}){mouse} , OB_Mean_Fz_ByEp_Shock.(Session_type{sess}){mouse} , 'method' , 'spearman');
        end
        R_shock.(Session_type{sess})(R_shock.(Session_type{sess})==0)=NaN;
    end
end
close

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        if isnan(nanmean(OB_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse}))
            OB_PowerEvol_in_Ep_Shock_all.(Session_type{sess})(mouse,:) = NaN(1,100);
        else
            OB_PowerEvol_in_Ep_Shock_all.(Session_type{sess})(mouse,:) = nanmean(OB_PowerEvol_in_Ep_Shock.(Session_type{sess}){mouse});
        end
    end
    OB_PowerEvol_in_Ep_Shock_all2.(Session_type{sess}) = zscore_nan_BM(OB_PowerEvol_in_Ep_Shock_all.(Session_type{sess})');
end


figure, sess=1;
MakeSpreadAndBoxPlot4_SB({R_shock.(Session_type{sess})(P_shock.(Session_type{sess})<.05)},{[.3 .3 .3]},1,{'Saline'},'showpoints',1,'paired',0);
h=hline(0); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R_shock.(Session_type{sess}),zeros(1,length(R_shock.(Session_type{sess}))))
title(['p = ' num2str(p)])


figure, sess=1;
MakeSpreadAndBoxPlot4_SB({R_shock.(Session_type{sess})},{[.3 .3 .3]},1,{'Saline'},'showpoints',1,'paired',0);
h=hline(0); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R_shock.(Session_type{sess}),zeros(1,length(R_shock.(Session_type{sess}))))
title(['p = ' num2str(p)])


figure
subplot(121)
clear Sp; Sp=squeeze(nanmean(All_OB_SpecNorm_Fz_Shock.(Session_type{sess})));
imagesc(linspace(0,1,100) , Spectro{3} , Sp), axis xy
ylabel('Frequency (Hz)'), ylim([0 10])

subplot(122)
Data_to_use = OB_PowerEvol_in_Ep_Shock_all.(Session_type{sess});
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,1,100) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-r',1); hold on;
xlabel('norm time'), ylabel('OB power (a.u.)'), box off, l=ylim; yticks(l), yticklabels({'0','1'})



