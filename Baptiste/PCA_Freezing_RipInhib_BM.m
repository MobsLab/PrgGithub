
%
% edit Data_For_Decoding_Freezing_BM.m
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          RIP CONTROL / RIP INHIB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
load('/media/nas7/ProjetEmbReact/DataEmbReact//Data_Physio_Freezing_RipInhib_Ctrl_Cond_2sFullBins.mat')
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/PCA_Analysis.mat')
Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition'};

OB_MaxFreq_Maze_BM
strict=1; 

DATA2(1,:) = [OB_Max_Freq.RipControl.Cond.Shock OB_Max_Freq.RipControl.Cond.Safe];

n=2;
for par=[2:5 7:8]
    DATA2(n,:) = [OutPutData.Cond.(Params{par}).mean(:,5)' OutPutData.Cond.(Params{par}).mean(:,6)'];
    n=n+1;
end

ind=and(sum(isnan(DATA2(:,1:10)))==0 , sum(isnan(DATA2(:,11:20)))==0);

[~,~,~, eigen_vector] = Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind])')', Params([1:5 7:8])  , Mouse_names([1:5 7 9]));

[z,mu,sigma] = zscore(DATA2(:,[ind ind])');
[Data_corr,~] = corr(z,'type','pearson');
figure, [~, ~, eigen_vector, ~, ~, ~] = pca(Data_corr); close

for pc=1:size(eigen_vector,2)
    if strict
        for mouse=1:round(size(z,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(:,pc)'*z(mouse,:)';
                PC_values_safe{pc}(mouse) = eigen_vector(:,pc)'*z(mouse+round(size(z,1)/2),:)';
            end
        end
    else
        for mouse=1:round(size(z2,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(~isnan(z2(mouse,:)),pc)'*z2(mouse,~isnan(z2(mouse,:)))';
                PC_values_safe{pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/2),:)),pc)'*z2(mouse+round(size(z2,1)/2),~isnan(z2(mouse+round(size(z2,1)/2),:)))';
                PC_values_shock{pc}(PC_values_shock{pc}==0)=NaN; PC_values_safe{pc}(PC_values_safe{pc}==0)=NaN;
            end
        end
    end
end

figure
subplot(121)
plot(PC_values_shock{1} , PC_values_shock{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','Color',[.5 .5 1],'MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    
    DIST_intra{1}(mouse) = sqrt((Bar_shock(1)-PC_values_shock{1}(mouse))^2+(Bar_shock(2)-PC_values_shock{2}(mouse))^2);
    DIST_intra{3}(mouse) = sqrt((Bar_safe(1)-PC_values_safe{1}(mouse))^2+(Bar_safe(2)-PC_values_safe{2}(mouse))^2);
    
    DIST_inter{1}(mouse) = sqrt((Bar_safe(1)-PC_values_shock{1}(mouse))^2+(Bar_safe(2)-PC_values_shock{2}(mouse))^2);
    DIST_inter{3}(mouse) = sqrt((Bar_shock(1)-PC_values_safe{1}(mouse))^2+(Bar_shock(2)-PC_values_safe{2}(mouse))^2);
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
xlim([-4 4]), ylim([-3 2.5])
vline(0), hline(0)
title('Rip control')


PC_values_shock_sal= PC_values_shock;
PC_values_safe_sal = PC_values_safe;



%%
clearvars -except mu sigma eigen_vector OB_Max_Freq Distance DIST_intra DIST_inter PC_values_shock_sal PC_values_safe_sal

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_RipInhib_Cond_2sFullBins.mat')

DATA2(1,:) = [OB_Max_Freq.RipInhib.Cond.Shock OB_Max_Freq.RipInhib.Cond.Safe];

n=2;
for par=[2:5 7:8]
    DATA2(n,:) = [OutPutData.Cond.(Params{par}).mean(:,5)' OutPutData.Cond.(Params{par}).mean(:,6)'];
    n=n+1;
end

ind=and(sum(isnan(DATA2(:,1:10)))==0 , sum(isnan(DATA2(:,11:20)))==0);

[~,~,~, eigen_vector2] = Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind])')', Params([1:5 7:8])  , Mouse_names([1:5 7 9]));

DATA3 = ((DATA2(:,[ind ind])-mu')./sigma')';

for pc=1:size(eigen_vector,2)
    for mouse=1:round(size(DATA3,1)/2)
        try
            PC_values_shock{pc}(mouse) = eigen_vector(:,pc)'*DATA3(mouse,:)';
            PC_values_safe{pc}(mouse) = eigen_vector(:,pc)'*DATA3(mouse+round(size(DATA3,1)/2),:)';
        end
    end
end


subplot(122)
plot(PC_values_shock{1} , PC_values_shock{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','Color',[.5 .5 1],'MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    
    DIST_intra{2}(mouse) = sqrt((Bar_shock(1)-PC_values_shock{1}(mouse))^2+(Bar_shock(2)-PC_values_shock{2}(mouse))^2);
    DIST_intra{4}(mouse) = sqrt((Bar_safe(1)-PC_values_safe{1}(mouse))^2+(Bar_safe(2)-PC_values_safe{2}(mouse))^2);
    
    DIST_inter{2}(mouse) = sqrt((Bar_safe(1)-PC_values_shock{1}(mouse))^2+(Bar_safe(2)-PC_values_shock{2}(mouse))^2);
    DIST_inter{4}(mouse) = sqrt((Bar_shock(1)-PC_values_safe{1}(mouse))^2+(Bar_shock(2)-PC_values_safe{2}(mouse))^2);
end
xlim([-4 4]), ylim([-3 4])
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
vline(0), hline(0)
title('Rip inhib')



PC_values_shock_drug=PC_values_shock;
PC_values_safe_drug=PC_values_safe;



%%
Cols2 = {[1 0 0],[.6 0 0],[0 0 1],[0 0 .6]};
X2 = 1:4;
Legends2 = {'Shock rip control','Shock rip inhib','Safe rip control','Safe rip inhib'};


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(DIST_intra,Cols2,X2,Legends2,'showpoints',1,'paired',0);
hline(0), ylabel('distance to line (a.u.)')
title('Intra')
ylim([0 4])

subplot(122)
MakeSpreadAndBoxPlot3_SB(DIST_inter,Cols2,X2,Legends2,'showpoints',1,'paired',0);
hline(0), ylabel('distance to line (a.u.)')
title('Inter')
ylim([0 4])



figure
subplot(121)
imagesc([eigen_vector(:,1) -eigen_vector2(:,1)])
xticks([1 2]), xticklabels({'Rip control','Rip inhib'}), yticklabels(Params([1:5 7:8])), xtickangle(45)
title('PC1')

subplot(122)
imagesc([eigen_vector(:,2) eigen_vector2(:,2)])
xticks([1 2]), xticklabels({'Rip control','Rip inhib'}), yticklabels(Params([1:5 7:8])), xtickangle(45)
title('PC2')

colormap redblue



figure
MakeSpreadAndBoxPlot3_SB({PC_values_shock_sal{1} PC_values_shock_drug{1} PC_values_safe_sal{1} PC_values_safe_drug{1}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC1 score (a.u.)')




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          SALINE / CHRONIC FLX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Saline
clear all

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_FlxChr_Ctrl_Ext_2sFullBins.mat')
Session_type={'Ext'}; sess=1; strict=0;

figure, [~ , ~ , Freq_Max_Shock] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,5,:))); close
figure, [~ , ~ , Freq_Max_Safe] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,6,:))); close
% Fear
% Freq_Max_Shock([7 36 40 51])=[NaN 2.67 2.289 4.73];
% Freq_Max_Safe([33 36])=[2.899 3.357];

% Cond
% Freq_Max_Shock([49])=[4.349];
% Freq_Max_Safe([33 36])=[2.899 3.357];

% Saline Long SB
Freq_Max_Safe([4 6]) = [2.823 2.594];

% Chronic fluo
% Freq_Max_Safe([3]) = [1.068];

ind_mouse=1:length(Mouse);

DATA2(1,:) = [Freq_Max_Shock(ind_mouse) Freq_Max_Safe(ind_mouse)];

n=2;
for par=[2:8]
    DATA2(n,:) = [OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,5)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,6)'];
    n=n+1;
end


ind=and(sum(isnan(DATA2(:,1:length(Mouse(ind_mouse)))))==0 , sum(isnan(DATA2(:,length(Mouse(ind_mouse))+1:length(Mouse(ind_mouse))*2)))==0);

[~,~,~, eigen_vector] = Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind])')', Params  , {''});

[z,mu,sigma] = zscore(DATA2(:,[ind ind])');
[Data_corr,~] = corr(z,'type','pearson');
figure, [~, ~, eigen_vector, ~, ~, ~] = pca(Data_corr); close

[z2,mu2,sigma2] = zscore_nan_BM(DATA2');

for pc=1:size(eigen_vector,2)
    if strict
        for mouse=1:round(size(z,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(:,pc)'*z(mouse,:)';
                PC_values_safe{pc}(mouse) = eigen_vector(:,pc)'*z(mouse+round(size(z,1)/2),:)';
            end
        end
    else
        for mouse=1:round(size(z2,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(~isnan(z2(mouse,:)),pc)'*z2(mouse,~isnan(z2(mouse,:)))';
                PC_values_safe{pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/2),:)),pc)'*z2(mouse+round(size(z2,1)/2),~isnan(z2(mouse+round(size(z2,1)/2),:)))';
                PC_values_shock{pc}(PC_values_shock{pc}==0)=NaN; PC_values_safe{pc}(PC_values_safe{pc}==0)=NaN;
            end
        end
    end
end

figure
subplot(121)
plot(PC_values_shock{1} , PC_values_shock{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','Color',[.5 .5 1],'MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    
    DIST_intra{1}(mouse) = sqrt((Bar_shock(1)-PC_values_shock{1}(mouse))^2+(Bar_shock(2)-PC_values_shock{2}(mouse))^2);
    DIST_intra{3}(mouse) = sqrt((Bar_safe(1)-PC_values_safe{1}(mouse))^2+(Bar_safe(2)-PC_values_safe{2}(mouse))^2);
    
    DIST_inter{1}(mouse) = sqrt((Bar_safe(1)-PC_values_shock{1}(mouse))^2+(Bar_safe(2)-PC_values_shock{2}(mouse))^2);
    DIST_inter{3}(mouse) = sqrt((Bar_shock(1)-PC_values_safe{1}(mouse))^2+(Bar_shock(2)-PC_values_safe{2}(mouse))^2);
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
xlim([-4 4]), ylim([-3 3])
vline(0), hline(0)
title('Saline')



PC_values_shock_sal=PC_values_shock;
PC_values_safe_sal=PC_values_safe;

%% Chronic flx
clearvars -except mu sigma eigen_vector OB_Max_Freq Distance DIST_intra DIST_inter Freq_Max_Shock Freq_Max_Safe OutPutData sess Session_type Params Mouse strict PC_values_shock_sal PC_values_safe_sal

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_FlxChr_Ext_2sFullBins.mat')
Session_type={'Ext'};

figure, [~ , ~ , Freq_Max_Shock] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,5,:))); close
figure, [~ , ~ , Freq_Max_Safe] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,6,:))); close
Freq_Max_Safe([3]) = [1.068];

ind_mouse=1:length(Mouse);

DATA2(1,:) = [Freq_Max_Shock(ind_mouse) Freq_Max_Safe(ind_mouse)];

n=2;
for par=[2:8]
    DATA2(n,:) = [OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,5)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,6)'];
    n=n+1;
end

ind=and(sum(isnan(DATA2(:,1:length(Mouse(ind_mouse)))))==0 , sum(isnan(DATA2(:,length(Mouse(ind_mouse))+1:length(Mouse(ind_mouse))*2)))==0);


[~,~,~, eigen_vector2] = Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind])')', Params  , Mouse_names);


DATA3 = ((DATA2(:,[ind ind])-mu')./sigma')';
DATA4 = ((DATA2-mu')./sigma')';

for pc=1:size(eigen_vector,2)
    if strict
        for mouse=1:round(size(DATA3,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(:,pc)'*DATA3(mouse,:)';
                PC_values_safe{pc}(mouse) = eigen_vector(:,pc)'*DATA3(mouse+round(size(DATA3,1)/2),:)';
            end
        end
    else
        for mouse=1:round(size(DATA4,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(~isnan(DATA4(mouse,:)),pc)'*DATA4(mouse,~isnan(DATA4(mouse,:)))';
                PC_values_safe{pc}(mouse) = eigen_vector(~isnan(DATA4(mouse+round(size(DATA4,1)/2),:)),pc)'*DATA4(mouse+round(size(DATA4,1)/2),~isnan(DATA4(mouse+round(size(DATA4,1)/2),:)))';
                PC_values_shock{pc}(PC_values_shock{pc}==0)=NaN; PC_values_safe{pc}(PC_values_safe{pc}==0)=NaN;
            end
        end
    end
end


subplot(122)
plot(PC_values_shock{1} , PC_values_shock{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','Color',[.5 .5 1],'MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    
    DIST_intra{2}(mouse) = sqrt((Bar_shock(1)-PC_values_shock{1}(mouse))^2+(Bar_shock(2)-PC_values_shock{2}(mouse))^2);
    DIST_intra{4}(mouse) = sqrt((Bar_safe(1)-PC_values_safe{1}(mouse))^2+(Bar_safe(2)-PC_values_safe{2}(mouse))^2);
    
    DIST_inter{2}(mouse) = sqrt((Bar_safe(1)-PC_values_shock{1}(mouse))^2+(Bar_safe(2)-PC_values_shock{2}(mouse))^2);
    DIST_inter{4}(mouse) = sqrt((Bar_shock(1)-PC_values_safe{1}(mouse))^2+(Bar_shock(2)-PC_values_safe{2}(mouse))^2);
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
xlim([-4 4]), ylim([-3 3])
vline(0), hline(0)
title('Chronic fluoxetine')


PC_values_shock_flx=PC_values_shock;
PC_values_safe_flx=PC_values_safe;


%%
Cols2 = {[1 0 0],[.6 0 0],[0 0 1],[0 0 .6]};
X2 = 1:4;
Legends2 = {'Shock Saline','Shock Chronic flx','Safe Saline','Safe flx'};


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(DIST_intra,Cols2,X2,Legends2,'showpoints',1,'paired',0);
hline(0), ylabel('distance to line (a.u.)')
title('Intra')
ylim([0 4])

subplot(122)
MakeSpreadAndBoxPlot3_SB(DIST_inter,Cols2,X2,Legends2,'showpoints',1,'paired',0);
hline(0), ylabel('distance to line (a.u.)')
title('Inter')
ylim([0 4])



figure
subplot(121)
imagesc([eigen_vector(:,1) -eigen_vector2(:,1)])
xticks([1 2]), xticklabels({'Saline','Chronic flx'}), yticklabels(Params), xtickangle(45)
title('PC1')

subplot(122)
imagesc([eigen_vector(:,2) eigen_vector2(:,2)])
xticks([1 2]), xticklabels({'Saline','Chronic flx'}), yticklabels(Params), xtickangle(45)
title('PC2')

colormap redblue



figure
MakeSpreadAndBoxPlot3_SB({PC_values_shock_sal{1} PC_values_shock_flx{1} PC_values_safe_sal{1} PC_values_safe_flx{1}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC1 score (a.u.)')



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          COND / EXT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Cond
clear all

load('Data_Physio_Freezing_Saline_all_Cond_2sFullBins.mat')
Session_type={'Cond'}; sess=1; strict=0;

figure, [~ , ~ , Freq_Max_Shock] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,5,:))); close
figure, [~ , ~ , Freq_Max_Safe] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,6,:))); close

% Cond
Freq_Max_Shock([49])=[4.349];
Freq_Max_Safe([33 36])=[2.899 3.357];

ind_mouse=21:length(Mouse);

DATA2(1,:) = [Freq_Max_Shock(ind_mouse) Freq_Max_Safe(ind_mouse)];

n=2;
for par=[2:8]
    DATA2(n,:) = [OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,5)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,6)'];
    n=n+1;
end


ind=and(sum(isnan(DATA2(:,1:length(Mouse(ind_mouse)))))==0 , sum(isnan(DATA2(:,length(Mouse(ind_mouse))+1:length(Mouse(ind_mouse))*2)))==0);

% [~,~,~, eigen_vector] = Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind])')', Params  , {''});

[z,mu,sigma] = zscore(DATA2(:,[ind ind])');
[Data_corr,~] = corr(z,'type','pearson');
figure, [~, ~, eigen_vector, ~, ~, ~] = pca(Data_corr); close

[z2,mu2,sigma2] = zscore_nan_BM(DATA2');

for pc=1:size(eigen_vector,2)
    if strict
        for mouse=1:round(size(z,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(:,pc)'*z(mouse,:)';
                PC_values_safe{pc}(mouse) = eigen_vector(:,pc)'*z(mouse+round(size(z,1)/2),:)';
            end
        end
    else
        for mouse=1:round(size(z2,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(~isnan(z2(mouse,:)),pc)'*z2(mouse,~isnan(z2(mouse,:)))';
                PC_values_safe{pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/2),:)),pc)'*z2(mouse+round(size(z2,1)/2),~isnan(z2(mouse+round(size(z2,1)/2),:)))';
                PC_values_shock{pc}(PC_values_shock{pc}==0)=NaN; PC_values_safe{pc}(PC_values_safe{pc}==0)=NaN;
            end
        end
    end
end

figure
subplot(121)
plot(PC_values_shock{1} , PC_values_shock{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','Color',[.5 .5 1],'MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    
    DIST_intra{1}(mouse) = sqrt((Bar_shock(1)-PC_values_shock{1}(mouse))^2+(Bar_shock(2)-PC_values_shock{2}(mouse))^2);
    DIST_intra{3}(mouse) = sqrt((Bar_safe(1)-PC_values_safe{1}(mouse))^2+(Bar_safe(2)-PC_values_safe{2}(mouse))^2);
    
    DIST_inter{1}(mouse) = sqrt((Bar_safe(1)-PC_values_shock{1}(mouse))^2+(Bar_safe(2)-PC_values_shock{2}(mouse))^2);
    DIST_inter{3}(mouse) = sqrt((Bar_shock(1)-PC_values_safe{1}(mouse))^2+(Bar_shock(2)-PC_values_safe{2}(mouse))^2);
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
title('Cond')




%% Ext
clearvars -except mu sigma eigen_vector OB_Max_Freq Distance DIST_intra DIST_inter Freq_Max_Shock Freq_Max_Safe OutPutData sess Session_type Params Mouse strict

load('Data_Physio_Freezing_Saline_all_Ext_2sFullBins.mat')
Session_type={'Ext'}; sess=1; strict=0;

figure, [~ , ~ , Freq_Max_Shock] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,5,:))); close
figure, [~ , ~ , Freq_Max_Safe] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,6,:))); close

% Ext
Freq_Max_Shock([24 26 36 40 47 48 51])=[4.425 6.18 2.67 2.213 4.959 4.349 4.349];
Freq_Max_Safe([26 28 33 36 48 51])=[5.569 2.213 2.823 2.747 4.272 3.204];

ind_mouse=21:length(Mouse);

DATA2(1,:) = [Freq_Max_Shock(ind_mouse) Freq_Max_Safe(ind_mouse)];


ind_mouse=21:length(Mouse);

DATA2(1,:) = [Freq_Max_Shock(ind_mouse) Freq_Max_Safe(ind_mouse)];

n=2;
for par=[2:8]
    DATA2(n,:) = [OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,5)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,6)'];
    n=n+1;
end

ind=and(sum(isnan(DATA2(:,1:length(Mouse(ind_mouse)))))==0 , sum(isnan(DATA2(:,length(Mouse(ind_mouse))+1:length(Mouse(ind_mouse))*2)))==0);


% [~,~,~, eigen_vector2] = Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind])')', Params  , {''});


[z,mu,sigma] = zscore(DATA2(:,[ind ind])');
[Data_corr,~] = corr(z,'type','pearson');
figure, [~, ~, eigen_vector, ~, ~, ~] = pca(Data_corr); close

[z2,mu2,sigma2] = zscore_nan_BM(DATA2');

for pc=1:size(eigen_vector,2)
    if strict
        for mouse=1:round(size(z,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(:,pc)'*z(mouse,:)';
                PC_values_safe{pc}(mouse) = eigen_vector(:,pc)'*z(mouse+round(size(z,1)/2),:)';
            end
        end
    else
        for mouse=1:round(size(z2,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(~isnan(z2(mouse,:)),pc)'*z2(mouse,~isnan(z2(mouse,:)))';
                PC_values_safe{pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/2),:)),pc)'*z2(mouse+round(size(z2,1)/2),~isnan(z2(mouse+round(size(z2,1)/2),:)))';
                PC_values_shock{pc}(PC_values_shock{pc}==0)=NaN; PC_values_safe{pc}(PC_values_safe{pc}==0)=NaN;
            end
        end
    end
end


subplot(122)
plot(PC_values_shock{1} , PC_values_shock{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','Color',[.5 .5 1],'MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    
    DIST_intra{2}(mouse) = sqrt((Bar_shock(1)-PC_values_shock{1}(mouse))^2+(Bar_shock(2)-PC_values_shock{2}(mouse))^2);
    DIST_intra{4}(mouse) = sqrt((Bar_safe(1)-PC_values_safe{1}(mouse))^2+(Bar_safe(2)-PC_values_safe{2}(mouse))^2);
    
    DIST_inter{2}(mouse) = sqrt((Bar_safe(1)-PC_values_shock{1}(mouse))^2+(Bar_safe(2)-PC_values_shock{2}(mouse))^2);
    DIST_inter{4}(mouse) = sqrt((Bar_shock(1)-PC_values_safe{1}(mouse))^2+(Bar_shock(2)-PC_values_safe{2}(mouse))^2);
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
v=vline(-.2); set(v,'LineWidth',2);
title('Ext')




%%
Cols2 = {[1 0 0],[.6 0 0],[0 0 1],[0 0 .6]};
X2 = 1:4;
Legends2 = {'Shock PAG','Shock Eyelid','Safe PAG','Safe Eyelid'};


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(DIST_intra,Cols2,X2,Legends2,'showpoints',1,'paired',0);
hline(0), ylabel('distance to line (a.u.)')
title('Intra')
ylim([0 4])

subplot(122)
MakeSpreadAndBoxPlot3_SB(DIST_inter,Cols2,X2,Legends2,'showpoints',1,'paired',0);
hline(0), ylabel('distance to line (a.u.)')
title('Inter')
ylim([0 4])




figure
subplot(121)
imagesc([eigen_vector(:,1) -eigen_vector2(:,1)])
xticks([1 2]), xticklabels({'Cond','Ext'}), yticklabels(Params), xtickangle(45)
title('PC1')

subplot(122)
imagesc([eigen_vector(:,2) eigen_vector2(:,2)])
xticks([1 2]), xticklabels({'Cond','Ext'}), yticklabels(Params), xtickangle(45)
title('PC2')

colormap redblue





%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          PAG / EYELID
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PAG
clear all

load('Data_Physio_Freezing_Saline_all_Fear_2sFullBins.mat')
Session_type={'Fear'}; sess=1; strict=0;

figure, [~ , ~ , Freq_Max_Shock] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,5,:))); close
figure, [~ , ~ , Freq_Max_Safe] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,6,:))); close
% Fear
Freq_Max_Shock([7 36 40 51])=[NaN 2.67 2.289 4.73];
Freq_Max_Safe([33 36])=[2.899 3.357];

ind_mouse=1:20;

DATA2(1,:) = [Freq_Max_Shock(ind_mouse) Freq_Max_Safe(ind_mouse)];

n=2;
for par=[2:8]
    DATA2(n,:) = [OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,5)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,6)'];
    n=n+1;
end


ind=and(sum(isnan(DATA2(:,1:length(Mouse(ind_mouse)))))==0 , sum(isnan(DATA2(:,length(Mouse(ind_mouse))+1:length(Mouse(ind_mouse))*2)))==0);

% [~,~,~, eigen_vector] = Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind])')', Params  , {''});

[z,mu,sigma] = zscore(DATA2(:,[ind ind])');
[Data_corr,~] = corr(z,'type','pearson');
figure, [~, ~, eigen_vector, ~, ~, ~] = pca(Data_corr); close

[z2,mu2,sigma2] = zscore_nan_BM(DATA2');

for pc=1:size(eigen_vector,2)
    if strict
        for mouse=1:round(size(z,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(:,pc)'*z(mouse,:)';
                PC_values_safe{pc}(mouse) = eigen_vector(:,pc)'*z(mouse+round(size(z,1)/2),:)';
            end
        end
    else
        for mouse=1:round(size(z2,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(~isnan(z2(mouse,:)),pc)'*z2(mouse,~isnan(z2(mouse,:)))';
                PC_values_safe{pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/2),:)),pc)'*z2(mouse+round(size(z2,1)/2),~isnan(z2(mouse+round(size(z2,1)/2),:)))';
                PC_values_shock{pc}(PC_values_shock{pc}==0)=NaN; PC_values_safe{pc}(PC_values_safe{pc}==0)=NaN;
            end
        end
    end
end

figure
subplot(121)
plot(PC_values_shock{1} , PC_values_shock{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','Color',[.5 .5 1],'MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    
    DIST_intra{1}(mouse) = sqrt((Bar_shock(1)-PC_values_shock{1}(mouse))^2+(Bar_shock(2)-PC_values_shock{2}(mouse))^2);
    DIST_intra{3}(mouse) = sqrt((Bar_safe(1)-PC_values_safe{1}(mouse))^2+(Bar_safe(2)-PC_values_safe{2}(mouse))^2);
    
    DIST_inter{1}(mouse) = sqrt((Bar_safe(1)-PC_values_shock{1}(mouse))^2+(Bar_safe(2)-PC_values_shock{2}(mouse))^2);
    DIST_inter{3}(mouse) = sqrt((Bar_shock(1)-PC_values_safe{1}(mouse))^2+(Bar_shock(2)-PC_values_safe{2}(mouse))^2);
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
title('PAG')




%% Eyelid
clearvars -except mu sigma eigen_vector OB_Max_Freq Distance DIST_intra DIST_inter Freq_Max_Shock Freq_Max_Safe OutPutData sess Session_type Params Mouse strict

ind_mouse=21:length(Mouse);

DATA2(1,:) = [Freq_Max_Shock(ind_mouse) Freq_Max_Safe(ind_mouse)];

n=2;
for par=[2:8]
    DATA2(n,:) = [OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,5)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,6)'];
    n=n+1;
end

ind=and(sum(isnan(DATA2(:,1:length(Mouse(ind_mouse)))))==0 , sum(isnan(DATA2(:,length(Mouse(ind_mouse))+1:length(Mouse(ind_mouse))*2)))==0);


% [~,~,~, eigen_vector2] = Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind])')', Params  , {''});


[z,mu,sigma] = zscore(DATA2(:,[ind ind])');
[Data_corr,~] = corr(z,'type','pearson');
figure, [~, ~, eigen_vector, ~, ~, ~] = pca(Data_corr); close

[z2,mu2,sigma2] = zscore_nan_BM(DATA2');

for pc=1:size(eigen_vector,2)
    if strict
        for mouse=1:round(size(z,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(:,pc)'*z(mouse,:)';
                PC_values_safe{pc}(mouse) = eigen_vector(:,pc)'*z(mouse+round(size(z,1)/2),:)';
            end
        end
    else
        for mouse=1:round(size(z2,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(~isnan(z2(mouse,:)),pc)'*z2(mouse,~isnan(z2(mouse,:)))';
                PC_values_safe{pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/2),:)),pc)'*z2(mouse+round(size(z2,1)/2),~isnan(z2(mouse+round(size(z2,1)/2),:)))';
                PC_values_shock{pc}(PC_values_shock{pc}==0)=NaN; PC_values_safe{pc}(PC_values_safe{pc}==0)=NaN;
            end
        end
    end
end


subplot(122)
plot(PC_values_shock{1} , PC_values_shock{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','Color',[.5 .5 1],'MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    
    DIST_intra{2}(mouse) = sqrt((Bar_shock(1)-PC_values_shock{1}(mouse))^2+(Bar_shock(2)-PC_values_shock{2}(mouse))^2);
    DIST_intra{4}(mouse) = sqrt((Bar_safe(1)-PC_values_safe{1}(mouse))^2+(Bar_safe(2)-PC_values_safe{2}(mouse))^2);
    
    DIST_inter{2}(mouse) = sqrt((Bar_safe(1)-PC_values_shock{1}(mouse))^2+(Bar_safe(2)-PC_values_shock{2}(mouse))^2);
    DIST_inter{4}(mouse) = sqrt((Bar_shock(1)-PC_values_safe{1}(mouse))^2+(Bar_shock(2)-PC_values_safe{2}(mouse))^2);
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
v=vline(-.2); set(v,'LineWidth',2);
title('Eyelid')




%%
Cols2 = {[1 0 0],[.6 0 0],[0 0 1],[0 0 .6]};
X2 = 1:4;
Legends2 = {'Shock PAG','Shock Eyelid','Safe PAG','Safe Eyelid'};


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(DIST_intra,Cols2,X2,Legends2,'showpoints',1,'paired',0);
hline(0), ylabel('distance to line (a.u.)')
title('Intra')
ylim([0 4])

subplot(122)
MakeSpreadAndBoxPlot3_SB(DIST_inter,Cols2,X2,Legends2,'showpoints',1,'paired',0);
hline(0), ylabel('distance to line (a.u.)')
title('Inter')
ylim([0 4])




figure
subplot(121)
imagesc([eigen_vector(:,1) -eigen_vector2(:,1)])
xticks([1 2]), xticklabels({'PAG','Eyelid'}), yticklabels(Params), xtickangle(45)
title('PC1')

subplot(122)
imagesc([eigen_vector(:,2) eigen_vector2(:,2)])
xticks([1 2]), xticklabels({'PAG','Eyelid'}), yticklabels(Params), xtickangle(45)
title('PC2')

colormap redblue


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          ACTIVE / FREEZING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Active/freezing
clear all

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Fear_2sFullBins.mat')
Session_type={'Fear'}; sess=1; strict=0;

ind_mouse=21:51;

for par=1:8
    DATA2(par,:) = [OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,3)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,4)' ];
end

ind=and(sum(isnan(DATA2(:,1:length(Mouse(ind_mouse)))))==0 , sum(isnan(DATA2(:,length(Mouse(ind_mouse))+1:length(Mouse(ind_mouse))*2)))==0);

% [~,~,~, eigen_vector] = Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind])')', Params  , {''});

[z,mu,sigma] = zscore(DATA2(:,[ind ind])');
[Data_corr,~] = corr(z,'type','pearson');
figure, [~, ~, eigen_vector, ~, ~, ~] = pca(Data_corr); close

[z2,mu2,sigma2] = zscore_nan_BM(DATA2');

for pc=1:size(eigen_vector,2)
    if strict
        for mouse=1:round(size(z,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(:,pc)'*z(mouse,:)';
                PC_values_safe{pc}(mouse) = eigen_vector(:,pc)'*z(mouse+round(size(z,1)/2),:)';
            end
        end
    else
        for mouse=1:round(size(z2,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(~isnan(z2(mouse,:)),pc)'*z2(mouse,~isnan(z2(mouse,:)))';
                PC_values_safe{pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/2),:)),pc)'*z2(mouse+round(size(z2,1)/2),~isnan(z2(mouse+round(size(z2,1)/2),:)))';
                PC_values_shock{pc}(PC_values_shock{pc}==0)=NaN; PC_values_safe{pc}(PC_values_safe{pc}==0)=NaN;
            end
        end
    end
end



figure
plot(PC_values_shock{1} , PC_values_shock{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','Color',[.5 .5 1],'MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    
    DIST_intra{1}(mouse) = sqrt((Bar_shock(1)-PC_values_shock{1}(mouse))^2+(Bar_shock(2)-PC_values_shock{2}(mouse))^2);
    DIST_intra{3}(mouse) = sqrt((Bar_safe(1)-PC_values_safe{1}(mouse))^2+(Bar_safe(2)-PC_values_safe{2}(mouse))^2);
    
    DIST_inter{1}(mouse) = sqrt((Bar_safe(1)-PC_values_shock{1}(mouse))^2+(Bar_safe(2)-PC_values_shock{2}(mouse))^2);
    DIST_inter{3}(mouse) = sqrt((Bar_shock(1)-PC_values_safe{1}(mouse))^2+(Bar_shock(2)-PC_values_safe{2}(mouse))^2);
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
title('Active/freezing')



%% Active shock/Active safe
clear all

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Fear_2sFullBins.mat')
Session_type={'Fear'}; sess=1; strict=0;

ind_mouse=21:51;

for par=1:8
    DATA2(par,:) = [OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,7)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,8)' ];
end

ind=and(sum(isnan(DATA2(:,1:length(Mouse(ind_mouse)))))==0 , sum(isnan(DATA2(:,length(Mouse(ind_mouse))+1:length(Mouse(ind_mouse))*2)))==0);

% [~,~,~, eigen_vector] = Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind])')', Params  , {''});

[z,mu,sigma] = zscore(DATA2(:,[ind ind])');
[Data_corr,~] = corr(z,'type','pearson');
figure, [~, ~, eigen_vector, ~, ~, ~] = pca(Data_corr); close

[z2,mu2,sigma2] = zscore_nan_BM(DATA2');

for pc=1:size(eigen_vector,2)
    if strict
        for mouse=1:round(size(z,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(:,pc)'*z(mouse,:)';
                PC_values_safe{pc}(mouse) = eigen_vector(:,pc)'*z(mouse+round(size(z,1)/2),:)';
            end
        end
    else
        for mouse=1:round(size(z2,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(~isnan(z2(mouse,:)),pc)'*z2(mouse,~isnan(z2(mouse,:)))';
                PC_values_safe{pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/2),:)),pc)'*z2(mouse+round(size(z2,1)/2),~isnan(z2(mouse+round(size(z2,1)/2),:)))';
                PC_values_shock{pc}(PC_values_shock{pc}==0)=NaN; PC_values_safe{pc}(PC_values_safe{pc}==0)=NaN;
            end
        end
    end
end



figure
plot(PC_values_shock{1} , PC_values_shock{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','Color',[.5 .5 1],'MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    
    DIST_intra{1}(mouse) = sqrt((Bar_shock(1)-PC_values_shock{1}(mouse))^2+(Bar_shock(2)-PC_values_shock{2}(mouse))^2);
    DIST_intra{3}(mouse) = sqrt((Bar_safe(1)-PC_values_safe{1}(mouse))^2+(Bar_safe(2)-PC_values_safe{2}(mouse))^2);
    
    DIST_inter{1}(mouse) = sqrt((Bar_safe(1)-PC_values_shock{1}(mouse))^2+(Bar_safe(2)-PC_values_shock{2}(mouse))^2);
    DIST_inter{3}(mouse) = sqrt((Bar_shock(1)-PC_values_safe{1}(mouse))^2+(Bar_shock(2)-PC_values_safe{2}(mouse))^2);
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
title('Active shock/Active safe')


Cols = {[1 0 0],[0 0 1]};
X = 1:2;
Legends = {'Shock','Safe'};


figure
MakeSpreadAndBoxPlot3_SB({PC_values_shock{1} PC_values_safe{1}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('PC1 score (a.u.)')


%% Fz shock / Fz safe / Active shock / Active safe

clear all

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Fear_2sFullBins.mat')
Session_type={'Fear'}; sess=1; strict=0;

ind_mouse=21:51;

for par=1:8
    DATA2(par,:) = [OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,5)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,6)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,7)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,8)'];
end

ind=and(and(sum(isnan(DATA2(:,1:length(Mouse(ind_mouse)))))==0 , sum(isnan(DATA2(:,length(Mouse(ind_mouse))+1:length(Mouse(ind_mouse))*2)))==0) , and(sum(isnan(DATA2(:,length(Mouse(ind_mouse))*2+1:length(Mouse(ind_mouse))*3)))==0 , sum(isnan(DATA2(:,length(Mouse(ind_mouse))*3+1:length(Mouse(ind_mouse))*4)))==0));

% [~,~,~, eigen_vector] = Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind ind ind])')', Params  , {''});

[z,mu,sigma] = zscore(DATA2(:,[ind ind ind ind])');
[Data_corr,~] = corr(z,'type','pearson');
figure, [~, ~, eigen_vector, ~, ~, ~] = pca(Data_corr); close

[z2,mu2,sigma2] = zscore_nan_BM(DATA2');

for pc=1:size(eigen_vector,2)
    if strict
        for mouse=1:round(size(z,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(:,pc)'*z(mouse,:)';
                PC_values_safe{pc}(mouse) = eigen_vector(:,pc)'*z(mouse+round(size(z,1)/2),:)';
            end
        end
    else
        for mouse=1:round(size(z2,1)/4)
            try
                PC_values_fz_shock{pc}(mouse) = eigen_vector(~isnan(z2(mouse,:)),pc)'*z2(mouse,~isnan(z2(mouse,:)))';
                PC_values_fz_safe{pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/4),:)),pc)'*z2(mouse+round(size(z2,1)/4),~isnan(z2(mouse+round(size(z2,1)/4),:)))';
                PC_values_act_shock{pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/4)*2,:)),pc)'*z2(mouse+round(size(z2,1)/4)*2,~isnan(z2(mouse+round(size(z2,1)/4)*2,:)))';
                PC_values_act_safe{pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/4)*3,:)),pc)'*z2(mouse+round(size(z2,1)/4)*3,~isnan(z2(mouse+round(size(z2,1)/4)*3,:)))';
                PC_values_shock{pc}(PC_values_shock{pc}==0)=NaN; PC_values_safe{pc}(PC_values_safe{pc}==0)=NaN;
                PC_values_act_shock{pc}(PC_values_act_shock{pc}==0)=NaN; PC_values_act_safe{pc}(PC_values_act_safe{pc}==0)=NaN;
            end
        end
    end
end
Bar_fz_shock = [nanmedian(PC_values_fz_shock{1}) nanmedian(PC_values_fz_shock{2})];
Bar_fz_safe = [nanmedian(PC_values_fz_safe{1}) nanmedian(PC_values_fz_safe{2})];
Bar_act_shock = [nanmedian(PC_values_act_shock{1}) nanmedian(PC_values_act_shock{2})];
Bar_act_safe = [nanmedian(PC_values_act_safe{1}) nanmedian(PC_values_act_safe{2})];
Bar_fz = [nanmedian([PC_values_fz_shock{1} PC_values_fz_safe{1}]) nanmedian([PC_values_fz_shock{2} PC_values_fz_safe{2}])];
Bar_act = [nanmedian([PC_values_act_shock{1} PC_values_act_safe{1}]) nanmedian([PC_values_act_shock{2} PC_values_act_safe{2}])];
Bar_shock = [nanmedian([PC_values_fz_shock{1} PC_values_act_shock{1}]) nanmedian([PC_values_fz_shock{2} PC_values_act_shock{2}])];
Bar_safe = [nanmedian([PC_values_fz_safe{1} PC_values_act_safe{1}]) nanmedian([PC_values_fz_safe{2} PC_values_act_safe{2}])];


figure
subplot(131)
plot(PC_values_fz_shock{1} , PC_values_fz_shock{2},'.k','MarkerSize',30)
hold on
plot(PC_values_fz_safe{1} , PC_values_fz_safe{2},'.k','MarkerSize',30)
plot(PC_values_act_shock{1} , PC_values_act_shock{2},'.g','MarkerSize',30)
plot(PC_values_act_safe{1} , PC_values_act_safe{2},'.g','MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
for mouse=1:length(PC_values_fz_shock{1})
    line([Bar_fz(1) PC_values_fz_shock{1}(mouse)],[Bar_fz(2) PC_values_fz_shock{2}(mouse)],'LineStyle','--','Color','k')
    line([Bar_fz(1) PC_values_fz_safe{1}(mouse)],[Bar_fz(2) PC_values_fz_safe{2}(mouse)],'LineStyle','--','Color','k')
    line([Bar_act(1) PC_values_act_shock{1}(mouse)],[Bar_act(2) PC_values_act_shock{2}(mouse)],'LineStyle','--','Color','g')
    line([Bar_act(1) PC_values_act_safe{1}(mouse)],[Bar_act(2) PC_values_act_safe{2}(mouse)],'LineStyle','--','Color','g')
end
plot(Bar_fz(1),Bar_fz(2),'.k','MarkerSize',60)
plot(Bar_act(1),Bar_act(2),'.g','MarkerSize',60)
f=get(gca,'Children'); legend([f([2 1])],'Freezing','Active');
title('Active / Freezing')


subplot(132)
plot(PC_values_fz_shock{1} , PC_values_fz_shock{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_fz_safe{1} , PC_values_fz_safe{2},'.','Color',[.5 .5 1],'MarkerSize',30)
plot(PC_values_act_shock{1} , PC_values_act_shock{2},'.','Color',[1 .5 .5],'MarkerSize',30)
plot(PC_values_act_safe{1} , PC_values_act_safe{2},'.','Color',[.5 .5 1],'MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
for mouse=1:length(PC_values_fz_shock{1})
    line([Bar_shock(1) PC_values_fz_shock{1}(mouse)],[Bar_shock(2) PC_values_fz_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_fz_safe{1}(mouse)],[Bar_safe(2) PC_values_fz_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    line([Bar_shock(1) PC_values_act_shock{1}(mouse)],[Bar_shock(2) PC_values_act_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_act_safe{1}(mouse)],[Bar_safe(2) PC_values_act_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
f=get(gca,'Children'); legend([f([2 1])],'Shock','Safe');
title('Shock / Safe')


subplot(133)
plot(PC_values_fz_shock{1} , PC_values_fz_shock{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_fz_safe{1} , PC_values_fz_safe{2},'.','Color',[.5 .5 1],'MarkerSize',30)
plot(PC_values_act_shock{1} , PC_values_act_shock{2},'.m','MarkerSize',30)
plot(PC_values_act_safe{1} , PC_values_act_safe{2},'.c','MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
for mouse=1:length(PC_values_fz_shock{1})
    line([Bar_fz_shock(1) PC_values_fz_shock{1}(mouse)],[Bar_fz_shock(2) PC_values_fz_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_fz_safe(1) PC_values_fz_safe{1}(mouse)],[Bar_fz_safe(2) PC_values_fz_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    line([Bar_act_shock(1) PC_values_act_shock{1}(mouse)],[Bar_act_shock(2) PC_values_act_shock{2}(mouse)],'LineStyle','--','Color','m')
    line([Bar_act_safe(1) PC_values_act_safe{1}(mouse)],[Bar_act_safe(2) PC_values_act_safe{2}(mouse)],'LineStyle','--','Color','c')
end
plot(Bar_fz_shock(1),Bar_fz_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_fz_safe(1),Bar_fz_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
plot(Bar_act_shock(1),Bar_act_shock(2),'.m','MarkerSize',60)
plot(Bar_act_safe(1),Bar_act_safe(2),'.c','MarkerSize',60)
f=get(gca,'Children'); legend([f([4 3 2 1])],'Freezing shock','Freezing safe','Active shock','Active safe');
title('All states')


Cols2 = {[1 0 0],[0 0 1],[.6 0 0],[0 0 .6]};
X2 = 1:4;
Legends2 = {'Freezing shock','Freezing safe','Active shock','Active safe'};

figure
subplot(231)
MakeSpreadAndBoxPlot3_SB({[PC_values_fz_shock{1} PC_values_fz_safe{1}] [PC_values_act_shock{1} PC_values_act_safe{1}]},{[0 0 0],[0 1 0]},[1 2],{'Freezing','Active'},'showpoints',1,'paired',0);
ylabel('PC1 score (a.u.)')
subplot(234)
MakeSpreadAndBoxPlot3_SB({[PC_values_fz_shock{2} PC_values_fz_safe{2}] [PC_values_act_shock{2} PC_values_act_safe{2}]},{[0 0 0],[0 1 0]},[1 2],{'Freezing','Active'},'showpoints',1,'paired',0);
ylabel('PC2 score (a.u.)')

subplot(232)
MakeSpreadAndBoxPlot3_SB({[PC_values_fz_shock{1} PC_values_act_shock{1}] [PC_values_fz_safe{1} PC_values_act_safe{1}]},{[1 0 0],[0 0 1]},[1 2],{'Shock','Safe'},'showpoints',1,'paired',0);
subplot(235)
MakeSpreadAndBoxPlot3_SB({[PC_values_fz_shock{2} PC_values_act_shock{2}] [PC_values_fz_safe{2} PC_values_act_safe{2}]},{[1 0 0],[0 0 1]},[1 2],{'Shock','Safe'},'showpoints',1,'paired',0);

subplot(233)
MakeSpreadAndBoxPlot3_SB({PC_values_fz_shock{1} PC_values_fz_safe{1} PC_values_act_shock{1} PC_values_act_safe{1}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
subplot(236)
MakeSpreadAndBoxPlot3_SB({PC_values_fz_shock{2} PC_values_fz_safe{2} PC_values_act_shock{2} PC_values_act_safe{2}},Cols2,X2,Legends2,'showpoints',1,'paired',0);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          QUIET WAKE / SLEEP /FREEZING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Sleep / Freezing
clear all

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Cond_2sFullBins.mat')
Session_type={'Cond'}; sess=1; strict=0;

ind_mouse=21:51;

for par=1:8
    DATA1(par,:) = [OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,5)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,6)'];
end


load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Sleep.mat')
Session_type={'sleep_pre'}; sess=1; 
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Fear_2sFullBins.mat','Params')

ind_mouse=1:length(Mouse);

for par=1:8
    DATA3(par,:) = [OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,3)'];
end

DATA2=[DATA1 DATA3];
DATA2([4 5],66)=NaN;

ind=and(and(sum(isnan(DATA2(:,1:length(Mouse(ind_mouse)))))==0 , sum(isnan(DATA2(:,length(Mouse(ind_mouse))+1:length(Mouse(ind_mouse))*2)))==0) , sum(isnan(DATA2(:,length(Mouse(ind_mouse))*2+1:length(Mouse(ind_mouse))*3)))==0);

[~,~,~, eigen_vector] = Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind ind])')', Params  , {''});

[z,mu,sigma] = zscore(DATA2(:,[ind ind ind])');
[Data_corr,~] = corr(z,'type','pearson');
figure, [~, ~, eigen_vector, ~, ~, ~] = pca(Data_corr); close

[z2,mu2,sigma2] = zscore_nan_BM(DATA2');

for pc=1:size(eigen_vector,2)
    if strict
        for mouse=1:round(size(z,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(:,pc)'*z(mouse,:)';
                PC_values_safe{pc}(mouse) = eigen_vector(:,pc)'*z(mouse+round(size(z,1)/2),:)';
            end
        end
    else
        for mouse=1:length(Mouse)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(~isnan(z2(mouse,:)),pc)'*z2(mouse,~isnan(z2(mouse,:)))';
                PC_values_safe{pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/3),:)),pc)'*z2(mouse+round(size(z2,1)/3),~isnan(z2(mouse+round(size(z2,1)/3),:)))';
                PC_values_sleep{pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/3)*2,:)),pc)'*z2(mouse+round(size(z2,1)/3)*2,~isnan(z2(mouse+round(size(z2,1)/3)*2,:)))';
                PC_values_shock{pc}(PC_values_shock{pc}==0)=NaN; PC_values_safe{pc}(PC_values_safe{pc}==0)=NaN; PC_values_sleep{pc}(PC_values_sleep{pc}==0)=NaN; 
            end
        end
    end
end



figure
plot(PC_values_shock{1} , PC_values_shock{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','Color',[.5 .5 1],'MarkerSize',30)
plot(PC_values_sleep{1} , PC_values_sleep{2},'.','MarkerSize',30,'Color',[0.8 0.5 0])
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
Bar_sleep = [nanmedian(PC_values_sleep{1}) nanmedian(PC_values_sleep{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    line([Bar_sleep(1) PC_values_sleep{1}(mouse)],[Bar_sleep(2) PC_values_sleep{2}(mouse)],'LineStyle','--','Color',[0.8 0.5 0])
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
plot(Bar_sleep(1),Bar_sleep(2),'.','MarkerSize',60,'Color',[0.8 0.5 0])
f=get(gca,'Children'); legend([f([3 2 1])],'Freezing shock','Freezing safe','Sleep');
title('Freezing / Sleep')


Cols2 = {[1 0 0],[0 0 1],[0.8 0.5 0]};
X2 = 1:3;
Legends2 = {'Freezing shock','Freezing safe','Sleep'};

figure
MakeSpreadAndBoxPlot3_SB({PC_values_shock{1} PC_values_safe{1} PC_values_sleep{1}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC1 score (a.u.)')


%% Quiet wake / Freezing
clear all
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Cond_2sFullBins.mat')
Session_type={'Cond'}; sess=1; strict=0;

ind_mouse=21:51;

for par=1:8
    DATA1(par,:) = [OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,5)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,6)'];
end


load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_TestPre_2sFullBins.mat')
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Fear_2sFullBins.mat','Params')
Session_type={'TestPre'}; sess=1; 
Mouse2=Mouse;

GetAllSalineSessions_BM
Mouse=Mouse2;
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for par=1:8
        Speed{mouse} = ConcatenateDataFromFolders_SB(TestPreSess.(Mouse_names{mouse}),'speed');
        Low_Speed_Epoch{mouse} = thresholdIntervals(Speed{mouse},1,'Direction','Below');
        MeanData.TestPre.(Params{par})(mouse) = nanmean(Data(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , Low_Speed_Epoch{mouse})));
    end
    disp(Mouse_names{mouse})
end

for par=1:8
    DATA3(par,:) = MeanData.TestPre.(Params{par});
end

DATA2=[DATA1 DATA3];
% DATA2([4 5],66)=NaN;

ind=and(and(sum(isnan(DATA2(:,1:length(Mouse))))==0 , sum(isnan(DATA2(:,length(Mouse)+1:length(Mouse)*2)))==0) , sum(isnan(DATA2(:,length(Mouse)*2+1:length(Mouse)*3)))==0);

% [~,~,~, eigen_vector] = Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind ind])')', Params  , {''});

[z,mu,sigma] = zscore(DATA2(:,[ind ind ind])');
[Data_corr,~] = corr(z,'type','pearson');
figure, [~, ~, eigen_vector, ~, ~, ~] = pca(Data_corr); close

[z2,mu2,sigma2] = zscore_nan_BM(DATA2');

for pc=1:size(eigen_vector,2)
    if strict
        for mouse=1:round(size(z,1)/2)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(:,pc)'*z(mouse,:)';
                PC_values_safe{pc}(mouse) = eigen_vector(:,pc)'*z(mouse+round(size(z,1)/2),:)';
            end
        end
    else
        for mouse=1:length(Mouse)
            try
                PC_values_shock{pc}(mouse) = eigen_vector(~isnan(z2(mouse,:)),pc)'*z2(mouse,~isnan(z2(mouse,:)))';
                PC_values_safe{pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/3),:)),pc)'*z2(mouse+round(size(z2,1)/3),~isnan(z2(mouse+round(size(z2,1)/3),:)))';
                PC_values_quiet{pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/3)*2,:)),pc)'*z2(mouse+round(size(z2,1)/3)*2,~isnan(z2(mouse+round(size(z2,1)/3)*2,:)))';
                PC_values_shock{pc}(PC_values_shock{pc}==0)=NaN; PC_values_safe{pc}(PC_values_safe{pc}==0)=NaN; PC_values_quiet{pc}(PC_values_quiet{pc}==0)=NaN; 
            end
        end
    end
end



figure
plot(PC_values_shock{1} , PC_values_shock{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','Color',[.5 .5 1],'MarkerSize',30)
plot(PC_values_quiet{1} , PC_values_quiet{2},'.','MarkerSize',30,'Color',[.5 .8 .5])
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
Bar_quiet = [nanmedian(PC_values_quiet{1}) nanmedian(PC_values_quiet{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    line([Bar_quiet(1) PC_values_quiet{1}(mouse)],[Bar_quiet(2) PC_values_quiet{2}(mouse)],'LineStyle','--','Color',[.5 .8 .5])
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
plot(Bar_quiet(1),Bar_quiet(2),'.','MarkerSize',60,'Color',[.5 .8 .5])
f=get(gca,'Children'); legend([f([3 2 1])],'Freezing shock','Freezing safe','Quiet wake');
title('Freezing / Quiet Wake')


Cols2 = {[1 0 0],[0 0 1],[.5 .8 .5]};
X2 = 1:3;
Legends2 = {'Freezing shock','Freezing safe','Quiet Wake'};

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({PC_values_shock{1} PC_values_safe{1} PC_values_quiet{1}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC1 score (a.u.)')

subplot(122)
MakeSpreadAndBoxPlot3_SB({PC_values_shock{2} PC_values_safe{2} PC_values_quiet{2}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC1 score (a.u.)')





