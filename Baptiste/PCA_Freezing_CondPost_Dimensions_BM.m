

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Eyelid_Sleep_Cond.mat')


for par=[1:8 10]%1:length(Params)
    for mouse=1:length(Mouse)
        try
            clear D, D = Data(OutPutData.Cond.(Params{par}).tsd{mouse,5});
            MeanVal_Shock.(Params{par})(mouse) = nanmean(D(round(size(D,1)*.9):end));
            clear D, D = Data(OutPutData.Cond.(Params{par}).tsd{mouse,6});
            MeanVal_Safe.(Params{par})(mouse) = nanmean(D(round(size(D,1)*.9):end));
        end
    end
end


n=1;
for par=[1:8 10]%1:length(Params)
    DATA2(n,:) = [MeanVal_Shock.(Params{par}) MeanVal_Safe.(Params{par})];
    n=n+1;
end
DATA2(DATA2==0) = NaN;

ind=and(sum(isnan(DATA2(:,1:29)))==0 , sum(isnan(DATA2(:,30:58)))==0);

Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind])')', Params([1:8 10])  , {''});

[z,mu,sigma] = zscore(DATA2(:,[ind ind])');
[Data_corr,~] = corr(z,'type','pearson');
figure, [~, ~, ~, eigen_vector] = pca(Data_corr); close

z2 = (DATA2'-mu)./sigma;

strict=0;
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

[a,b] = sort(eigen_vector(:,1),'descend');


figure
for i=1:2
    subplot(1,2,i)
    plot(eigen_vector(b,i),'Color','k','LineWidth',5)
    hold on
    plot(eigen_vector(b,i),'.','MarkerSize',50,'Color','k')
    
    xticks([1:length(Params)]), xticklabels(Params(b)), 
    xtickangle(45)
    box off
    makepretty_BM2
    h=hline(0,'--k'); set(h,'LineWidth',2);
    ylabel(['PC ' num2str(i) ' weight (a.u.)']), ylim([-3 3])
    vline([1:length(Params)],'--k')
end




figure
plot(PC_values_shock{1} , PC_values_shock{2},'.','MarkerSize',10,'Color',[1 .5 .5])
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','MarkerSize',10,'Color',[.5 .5 1])
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    
    DIST_intra{1}(mouse) = sqrt((Bar_shock(1)-PC_values_shock{1}(mouse))^2+(Bar_shock(2)-PC_values_shock{2}(mouse))^2);
    DIST_intra{2}(mouse) = sqrt((Bar_safe(1)-PC_values_safe{1}(mouse))^2+(Bar_safe(2)-PC_values_safe{2}(mouse))^2);
    
    DIST_inter{1}(mouse) = sqrt((Bar_safe(1)-PC_values_shock{1}(mouse))^2+(Bar_safe(2)-PC_values_shock{2}(mouse))^2);
    DIST_inter{2}(mouse) = sqrt((Bar_shock(1)-PC_values_safe{1}(mouse))^2+(Bar_shock(2)-PC_values_safe{2}(mouse))^2);
end
plot(Bar_shock(1),Bar_shock(2),'.','MarkerSize',100,'Color',[1 .5 .5])
plot(Bar_safe(1),Bar_safe(2),'.','MarkerSize',100,'Color',[.5 .5 1])





figure
Bar_st = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Q1_st(1) = quantile(PC_values_shock{1},.25); Q1_st(2) = quantile(PC_values_shock{1},.75);
Q2_st(1) = quantile(PC_values_shock{2},.25); Q2_st(2) = quantile(PC_values_shock{2},.75);

plot(Bar_st(1),Bar_st(2),'.','MarkerSize',70,'Color',[1 .5 .5]), hold on
line(Q1_st,[Bar_st(2) Bar_st(2)],'Color',[1 .5 .5],'LineWidth',3)
line([Bar_st(1) Bar_st(1)],Q2_st,'Color',[1 .5 .5],'LineWidth',3)

Bar_st = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
Q1_st(1) = quantile(PC_values_safe{1},.25); Q1_st(2) = quantile(PC_values_safe{1},.75);
Q2_st(1) = quantile(PC_values_safe{2},.25); Q2_st(2) = quantile(PC_values_safe{2},.75);

plot(Bar_st(1),Bar_st(2),'.','MarkerSize',70,'Color',[.5 .5 1]), hold on
line(Q1_st,[Bar_st(2) Bar_st(2)],'Color',[.5 .5 1],'LineWidth',3)
line([Bar_st(1) Bar_st(1)],Q2_st,'Color',[.5 .5 1],'LineWidth',3)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
makepretty, box on



Cols = {[1 .5 .5],[.5 .5 1]};
X = 1:2;
Legends = {'Shock','Safe'};

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({PC_values_shock{1} PC_values_safe{1}},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('PC1 values (a.u.)')
subplot(122)
MakeSpreadAndBoxPlot3_SB({PC_values_shock{2} PC_values_safe{2}},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('PC2 values (a.u.)')




figure
Data_to_use = PC_shock;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(0,1,20) , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = PC_safe;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(0,1,20) , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
makepretty


figure
Data_to_use = movmean(PC_shock',3)';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(0,1,20) , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = movmean(PC_safe',3)';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(linspace(0,1,20) , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
makepretty




%% Sleep



l=load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Eyelid_Sleep.mat');

n=1;
for par=[1:8 10]%1:length(Params)
    DATA3(n,:) = OutPutData.sleep_pre.(Params{par}).mean(:,4);
    DATA4(n,:) = OutPutData.sleep_pre.(Params{par}).mean(:,5);
    DATA5(n,:) = OutPutData.sleep_pre.(Params{par}).mean(:,2);
    n=n+1;
end
DATA3(DATA3==0) = NaN;
DATA4(DATA4==0) = NaN;
DATA5(DATA5==0) = NaN;


z3 = (DATA3'-mu)./sigma;
z4 = (DATA4'-mu)./sigma;
z5 = (DATA5'-mu)./sigma;


for pc=1:size(eigen_vector,2)
    for mouse=1:round(size(z2,1)/2)
        try
            PC_values_NREM{pc}(mouse) = eigen_vector(~isnan(z3(mouse,:)),pc)'*z3(mouse,~isnan(z3(mouse,:)))';
            PC_values_REM{pc}(mouse) = eigen_vector(~isnan(z4(mouse,:)),pc)'*z4(mouse,~isnan(z4(mouse,:)))';
            PC_values_Wake{pc}(mouse) = eigen_vector(~isnan(z5(mouse,:)),pc)'*z5(mouse,~isnan(z5(mouse,:)))';
            PC_values_NREM{pc}(PC_values_NREM{pc}==0)=NaN; 
            PC_values_REM{pc}(PC_values_REM{pc}==0)=NaN;
            PC_values_Wake{pc}(PC_values_Wake{pc}==0)=NaN;
        end
    end
end





figure
Bar_st = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Q1_st(1) = quantile(PC_values_shock{1},.25); Q1_st(2) = quantile(PC_values_shock{1},.75);
Q2_st(1) = quantile(PC_values_shock{2},.25); Q2_st(2) = quantile(PC_values_shock{2},.75);

plot(Bar_st(1),Bar_st(2),'.','MarkerSize',70,'Color',[1 .5 .5]), hold on
line(Q1_st,[Bar_st(2) Bar_st(2)],'Color',[1 .5 .5],'LineWidth',3)
line([Bar_st(1) Bar_st(1)],Q2_st,'Color',[1 .5 .5],'LineWidth',3)

Bar_st = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
Q1_st(1) = quantile(PC_values_safe{1},.25); Q1_st(2) = quantile(PC_values_safe{1},.75);
Q2_st(1) = quantile(PC_values_safe{2},.25); Q2_st(2) = quantile(PC_values_safe{2},.75);

plot(Bar_st(1),Bar_st(2),'.','MarkerSize',70,'Color',[.5 .5 1]), hold on
line(Q1_st,[Bar_st(2) Bar_st(2)],'Color',[.5 .5 1],'LineWidth',3)
line([Bar_st(1) Bar_st(1)],Q2_st,'Color',[.5 .5 1],'LineWidth',3)

Bar_st = [nanmedian(PC_values_NREM{1}) nanmedian(PC_values_NREM{2})];
Q1_st(1) = quantile(PC_values_NREM{1},.25); Q1_st(2) = quantile(PC_values_NREM{1},.75);
Q2_st(1) = quantile(PC_values_NREM{2},.25); Q2_st(2) = quantile(PC_values_NREM{2},.75);

plot(Bar_st(1),Bar_st(2),'.','MarkerSize',70,'Color',[1 0 0]), hold on
line(Q1_st,[Bar_st(2) Bar_st(2)],'Color',[1 0 0],'LineWidth',3)
line([Bar_st(1) Bar_st(1)],Q2_st,'Color',[1 0 0],'LineWidth',3)

Bar_st = [nanmedian(PC_values_REM{1}) nanmedian(PC_values_REM{2})];
Q1_st(1) = quantile(PC_values_REM{1},.25); Q1_st(2) = quantile(PC_values_REM{1},.75);
Q2_st(1) = quantile(PC_values_REM{2},.25); Q2_st(2) = quantile(PC_values_REM{2},.75);

plot(Bar_st(1),Bar_st(2),'.','MarkerSize',70,'Color',[0 1 0]), hold on
line(Q1_st,[Bar_st(2) Bar_st(2)],'Color',[0 1 0],'LineWidth',3)
line([Bar_st(1) Bar_st(1)],Q2_st,'Color',[0 1 0],'LineWidth',3)

Bar_st = [nanmedian(PC_values_Wake{1}) nanmedian(PC_values_Wake{2})];
Q1_st(1) = quantile(PC_values_Wake{1},.25); Q1_st(2) = quantile(PC_values_Wake{1},.75);
Q2_st(1) = quantile(PC_values_Wake{2},.25); Q2_st(2) = quantile(PC_values_Wake{2},.75);

plot(Bar_st(1),Bar_st(2),'.','MarkerSize',70,'Color',[0 0 1]), hold on
line(Q1_st,[Bar_st(2) Bar_st(2)],'Color',[0 0 1],'LineWidth',3)
line([Bar_st(1) Bar_st(1)],Q2_st,'Color',[0 0 1],'LineWidth',3)


axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
makepretty, box on






figure
plot(PC_values_NREM{1} , PC_values_NREM{2},'.','MarkerSize',10,'Color',[1 .5 .5])
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','MarkerSize',10,'Color',[.5 .5 1])
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_NREM{1}) nanmedian(PC_values_NREM{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
for mouse=1:length(PC_values_NREM{1})
    line([Bar_shock(1) PC_values_NREM{1}(mouse)],[Bar_shock(2) PC_values_NREM{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    
    DIST_intra{1}(mouse) = sqrt((Bar_shock(1)-PC_values_NREM{1}(mouse))^2+(Bar_shock(2)-PC_values_NREM{2}(mouse))^2);
    DIST_intra{2}(mouse) = sqrt((Bar_safe(1)-PC_values_safe{1}(mouse))^2+(Bar_safe(2)-PC_values_safe{2}(mouse))^2);
    
    DIST_inter{1}(mouse) = sqrt((Bar_safe(1)-PC_values_NREM{1}(mouse))^2+(Bar_safe(2)-PC_values_NREM{2}(mouse))^2);
    DIST_inter{2}(mouse) = sqrt((Bar_shock(1)-PC_values_safe{1}(mouse))^2+(Bar_shock(2)-PC_values_safe{2}(mouse))^2);
end
plot(Bar_shock(1),Bar_shock(2),'.','MarkerSize',100,'Color',[1 .5 .5])
plot(Bar_safe(1),Bar_safe(2),'.','MarkerSize',100,'Color',[.5 .5 1])






% edit Data_For_Decoding_Freezing_BM.m
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          ALL IN COND POST PCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% CondPost
clear all

load('	Data_Physio_Freezing_Saline_all_CondPost_2sFullBins.mat')
Session_type={'CondPost'}; sess=1; strict=0;
Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_delta','linearposition'};

figure, [~ , ~ , Freq_Max_Shock] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,5,:))); close
figure, [~ , ~ , Freq_Max_Safe] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,6,:))); close


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
plot(PC_values_shock{1} , PC_values_shock{2},'.','MarkerSize',10,'Color',[1 .5 .5])
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','MarkerSize',10,'Color',[.5 .5 1])
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    
    DIST_intra{1}(mouse) = sqrt((Bar_shock(1)-PC_values_shock{1}(mouse))^2+(Bar_shock(2)-PC_values_shock{2}(mouse))^2);
    DIST_intra{2}(mouse) = sqrt((Bar_safe(1)-PC_values_safe{1}(mouse))^2+(Bar_safe(2)-PC_values_safe{2}(mouse))^2);
    
    DIST_inter{1}(mouse) = sqrt((Bar_safe(1)-PC_values_shock{1}(mouse))^2+(Bar_safe(2)-PC_values_shock{2}(mouse))^2);
    DIST_inter{2}(mouse) = sqrt((Bar_shock(1)-PC_values_safe{1}(mouse))^2+(Bar_shock(2)-PC_values_safe{2}(mouse))^2);
end
plot(Bar_shock(1),Bar_shock(2),'.','MarkerSize',100,'Color',[1 .5 .5])
plot(Bar_safe(1),Bar_safe(2),'.','MarkerSize',100,'Color',[.5 .5 1])
title('CondPost')



%%
Cols = {[1 .5 .5],[.5 .5 1]};
X = 1:2;
Legends = {'Shock','Safe'};


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({PC_values_shock{1} PC_values_safe{1}},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('PC1 values (a.u.)')
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB({PC_values_shock{2} PC_values_safe{2}},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('PC2 values (a.u.)')
makepretty_BM2

PC_values_shock_sal=PC_values_shock;
PC_values_safe_sal=PC_values_safe;



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Active
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except mu sigma eigen_vector OB_Max_Freq DIST_intra DIST_inter PC_values_shock_sal PC_values_safe_sal

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Active_Eyelid_Sleep_2sFullBins.mat')
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Ext_2sFullBins.mat', 'Params')

for par=1:8
    DATA2(par,:) = OutPutData.CondPost.(Params{par}).mean(:,4)';
end

ind=sum(isnan(DATA2))==0;

[~,~,~, eigen_vector2] = Correlations_Matrices_Data_BM(zscore(DATA2(:,ind)')', Params , {''});

DATA3 = ((DATA2-mu')./sigma')';

for pc=1:size(eigen_vector,2)
    for mouse=1:size(DATA3,1)
        try
            PC_values_active{pc}(mouse) = eigen_vector(:,pc)'*DATA3(mouse,:)';
        end
    end
end


figure
plot(PC_values_shock_sal{1} , PC_values_shock_sal{2},'.r','MarkerSize',30)
hold on
plot(PC_values_safe_sal{1} , PC_values_safe_sal{2},'.b','MarkerSize',30)
plot(PC_values_active{1} , PC_values_active{2},'.g','MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
ind1 = and(~isnan(PC_values_shock_sal{1}) , ~isnan(PC_values_shock_sal{2}));
ind2 = and(~isnan(PC_values_safe_sal{1}) , ~isnan(PC_values_safe_sal{2}));
ind3 = and(~isnan(PC_values_active{1}) , ~isnan(PC_values_active{2}));
Bar_shock = [nanmedian(PC_values_shock_sal{1}(ind1)) nanmedian(PC_values_shock_sal{2}(ind1))];
Bar_safe = [nanmedian(PC_values_safe_sal{1}(ind2)) nanmedian(PC_values_safe_sal{2}(ind2))];
Bar_active = [nanmedian(PC_values_active{1}(ind3)) nanmedian(PC_values_active{2}(ind3))];
for mouse=1:length(PC_values_shock_sal{1})
    line([Bar_shock(1) PC_values_shock_sal{1}(mouse)],[Bar_shock(2) PC_values_shock_sal{2}(mouse)],'LineStyle','--','Color','r')
    line([Bar_safe(1) PC_values_safe_sal{1}(mouse)],[Bar_safe(2) PC_values_safe_sal{2}(mouse)],'LineStyle','--','Color','b')
    line([Bar_act(1) PC_values_active{1}(mouse)],[Bar_act(2) PC_values_active{2}(mouse)],'LineStyle','--','Color','g')
end
plot(Bar_shock(1),Bar_shock(2),'.r','MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.b','MarkerSize',60)
plot(Bar_act(1),Bar_act(2),'.g','MarkerSize',60)
f=get(gca,'Children'); legend([f([3 2 1])],'Freezing shock','Freezing safe','Active');
title('Comparison with active')



Cols2 = {[1 0 0],[0 0 1],[0 1 0]};
X2 = 1:3;
Legends2 = {'Freezing shock','Freezing safe','Active'};

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({PC_values_shock_sal{1} PC_values_safe_sal{1} PC_values_active{1}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC1 score (a.u.)')

subplot(122)
MakeSpreadAndBoxPlot3_SB({PC_values_shock_sal{2} PC_values_safe_sal{2} PC_values_active{2}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC2 score (a.u.)')


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Active shock / Active Safe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except mu sigma eigen_vector OB_Max_Freq DIST_intra DIST_inter PC_values_shock_sal PC_values_safe_sal

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Active_Eyelid_Sleep_2sFullBins.mat')
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Ext_2sFullBins.mat', 'Params')


for par=1:8
    DATA2(par,:) = [OutPutData.CondPost.(Params{par}).mean(:,7)' OutPutData.CondPost.(Params{par}).mean(:,8)'];
end

ind=and(sum(isnan(DATA2(:,1:length(Mouse))))==0 , sum(isnan(DATA2(:,length(Mouse)+1:length(Mouse)*2)))==0);

[~,~,~, eigen_vector2] = Correlations_Matrices_Data_BM(zscore(DATA2(:,ind)')', Params , {''});

DATA3 = ((DATA2-mu')./sigma')';

for pc=1:size(eigen_vector,2)
    for mouse=1:round(size(DATA3,1)/2)
        try            
            PC_values_active_shock{pc}(mouse) = eigen_vector(~isnan(DATA3(mouse,:)),pc)'*DATA3(mouse,~isnan(DATA3(mouse,:)))';
            PC_values_active_safe{pc}(mouse) = eigen_vector(~isnan(DATA3(mouse+round(size(DATA3,1)/2),:)),pc)'*DATA3(mouse+round(size(DATA3,1)/2),~isnan(DATA3(mouse+round(size(DATA3,1)/2),:)))';
            PC_values_active_shock{pc}(PC_values_active_shock{pc}==0)=NaN; PC_values_active_safe{pc}(PC_values_active_safe{pc}==0)=NaN;
        end
    end
end


figure
plot(PC_values_shock_sal{1} , PC_values_shock_sal{2},'.r','MarkerSize',15)
hold on
plot(PC_values_safe_sal{1} , PC_values_safe_sal{2},'.b','MarkerSize',15)
plot(PC_values_active_shock{1} , PC_values_active_shock{2},'.m','MarkerSize',30)
plot(PC_values_active_safe{1} , PC_values_active_safe{2},'.c','MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_fz_shock = [nanmedian(PC_values_shock_sal{1}) nanmedian(PC_values_shock_sal{2})];
Bar_fz_safe = [nanmedian(PC_values_safe_sal{1}) nanmedian(PC_values_safe_sal{2})];
Bar_act_shock = [nanmedian(PC_values_active_shock{1}) nanmedian(PC_values_active_shock{2})];
Bar_act_safe = [nanmedian(PC_values_active_safe{1}) nanmedian(PC_values_active_safe{2})];
for mouse=1:length(PC_values_shock_sal{1})
    line([Bar_fz_shock(1) PC_values_shock_sal{1}(mouse)],[Bar_fz_shock(2) PC_values_shock_sal{2}(mouse)],'LineStyle','--','Color','r')
    line([Bar_fz_safe(1) PC_values_safe_sal{1}(mouse)],[Bar_fz_safe(2) PC_values_safe_sal{2}(mouse)],'LineStyle','--','Color','b')
    line([Bar_act_shock(1) PC_values_active_shock{1}(mouse)],[Bar_act_shock(2) PC_values_active_shock{2}(mouse)],'LineStyle','--','Color','m')
    line([Bar_act_safe(1) PC_values_active_safe{1}(mouse)],[Bar_act_safe(2) PC_values_active_safe{2}(mouse)],'LineStyle','--','Color','c')
end
plot(Bar_fz_shock(1),Bar_fz_shock(2),'.r','MarkerSize',60)
plot(Bar_fz_safe(1),Bar_fz_safe(2),'.b','MarkerSize',60)
plot(Bar_act_shock(1),Bar_act_shock(2),'.m','MarkerSize',60)
plot(Bar_act_safe(1),Bar_act_safe(2),'.c','MarkerSize',60)
f=get(gca,'Children'); legend([f([4 3 2 1])],'Freezing shock','Freezing safe','Active shock','Active safe');
title('Comparison with active')



Cols2 = {[1 0 0],[0 0 1],[1 0 1],[0 1 1]};
X2 = 1:4;
Legends2 = {'Freezing shock','Freezing safe','Active shock','Active safe'};

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({PC_values_shock_sal{1} PC_values_safe_sal{1} PC_values_active_shock{1} PC_values_active_safe{1}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC1 score (a.u.)')

subplot(122)
MakeSpreadAndBoxPlot3_SB({PC_values_shock_sal{2} PC_values_safe_sal{2} PC_values_active_shock{1} PC_values_active_safe{1}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC2 score (a.u.)')





%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Sleep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except mu sigma eigen_vector OB_Max_Freq DIST_intra DIST_inter PC_values_shock_sal PC_values_safe_sal

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Sleep_2sFullBins.mat')
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Fear_2sFullBins.mat', 'Params')

for par=1:8
    DATA2(par,:) = OutPutData.sleep_pre.(Params{par}).mean(:,3)';
end

ind=sum(isnan(DATA2))==0;

[~,~,~, eigen_vector2] = Correlations_Matrices_Data_BM(zscore(DATA2(:,ind)')', Params , {''});

DATA3 = ((DATA2-mu')./sigma')';

for pc=1:size(eigen_vector,2)
    for mouse=1:size(DATA3,1)
        try
            PC_values_sleep{pc}(mouse) = eigen_vector(:,pc)'*DATA3(mouse,:)';
        end
    end
end
PC_values_sleep{1}(4)=NaN;

figure
plot(PC_values_shock{1} , PC_values_shock{2},'.r','MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.b','MarkerSize',30)
plot(PC_values_sleep{1} , PC_values_sleep{2},'.','MarkerSize',30,'Color',[0.8 0.5 0])
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
ind1 = and(~isnan(PC_values_shock{1}) , ~isnan(PC_values_shock{2}));
ind2 = and(~isnan(PC_values_safe{1}) , ~isnan(PC_values_safe{2}));
ind3 = and(~isnan(PC_values_sleep{1}) , ~isnan(PC_values_sleep{2}));
Bar_shock = [nanmedian(PC_values_shock{1}(ind1)) nanmedian(PC_values_shock{2}(ind1))];
Bar_safe = [nanmedian(PC_values_safe{1}(ind2)) nanmedian(PC_values_safe{2}(ind2))];
Bar_sleep = [nanmedian(PC_values_sleep{1}(ind3)) nanmedian(PC_values_sleep{2}(ind3))];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color','r')
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color','b')
    line([Bar_sleep(1) PC_values_sleep{1}(mouse)],[Bar_sleep(2) PC_values_sleep{2}(mouse)],'LineStyle','--','Color',[.8 .5 0])
end
plot(Bar_shock(1),Bar_shock(2),'.r','MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.b','MarkerSize',60)
plot(Bar_sleep(1),Bar_sleep(2),'.','MarkerSize',60,'Color',[0.8 0.5 0])
f=get(gca,'Children'); legend([f([3 2 1])],'Freezing shock','Freezing safe','Sleep');
title('Comparison with sleep')



Cols2 = {[1 0 0],[0 0 1],[0.8 0.5 0]};
X2 = 1:3;
Legends2 = {'Freezing shock','Freezing safe','Sleep'};

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({PC_values_shock{1} PC_values_safe{1} PC_values_sleep{1}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC1 score (a.u.)')

subplot(122)
MakeSpreadAndBoxPlot3_SB({PC_values_shock{2} PC_values_safe{2} PC_values_sleep{2}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC2 score (a.u.)')





%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Quiet wake
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except mu sigma eigen_vector OB_Max_Freq DIST_intra DIST_inter PC_values_shock_sal PC_values_safe_sal

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Cond_2sFullBins.mat', 'Params')
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/PCA_Analysis.mat','mu','sigma','eigen_vector','PC_values_shock','PC_values_safe')

Mouse=Drugs_Groups_UMaze_BM(11); Mouse=Mouse([1:12 14:20 22:35 37 40:49 51]);
Session_type={'Habituation'}; sess=1;
GetAllSalineSessions_BM
for sess=1:length(Session_type) % generate all data required for analyses
        [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
            'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition');
end

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    Speed.(Session_type{sess}) = ConcatenateDataFromFolders_SB(HabSess.(Mouse_names{mouse}),'speed');
    Smooth_speed.(Session_type{sess}) = tsd(Range(Speed.(Session_type{sess})),runmean(Data(Speed.(Session_type{sess})),10));
    Low_Speed_Epoch.(Session_type{sess}){mouse} = thresholdIntervals(Smooth_speed.(Session_type{sess}),1,'Direction','Below');
    Low_Speed_Epoch.(Session_type{sess}){mouse} = dropShortIntervals(Low_Speed_Epoch.(Session_type{sess}){mouse},3e4);
    Low_Speed_Epoch.(Session_type{sess}){mouse} = mergeCloseIntervals(Low_Speed_Epoch.(Session_type{sess}){mouse},2e4);
    
    for par=1:8
        MeanData.(Session_type{sess}).(Params{par})(mouse) = nanmean(Data(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , Low_Speed_Epoch.(Session_type{sess}){mouse})));
    end
    disp(Mouse_names{mouse})
end

for par=1:8
    DATA2(par,:) = MeanData.Habituation.(Params{par});
end


ind=sum(isnan(DATA2))==0;

[~,~,~, eigen_vector2] = Correlations_Matrices_Data_BM(zscore(DATA2(:,ind)')', Params , {''});

DATA3 = ((DATA2-mu')./sigma')';

for pc=1:size(eigen_vector,2)
    for mouse=1:size(DATA3,1)
        try
            ind=~isnan(DATA3(mouse,:));
            PC_values_quiet{pc}(mouse) = eigen_vector(ind,pc)'*DATA3(mouse,ind)';
        end
    end
    PC_values_quiet{pc}(PC_values_quiet{pc}==0)=NaN;
    PC_values_quiet{pc}([21 23 27])=NaN;
end

figure
plot(PC_values_shock{1} , PC_values_shock{2},'.r','MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.b','MarkerSize',30)
plot(PC_values_quiet{1} , PC_values_quiet{2},'.','MarkerSize',30,'Color',[.5 .8 .5])
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
ind1 = and(~isnan(PC_values_shock{1}) , ~isnan(PC_values_shock{2}));
ind2 = and(~isnan(PC_values_safe{1}) , ~isnan(PC_values_safe{2}));
ind3 = and(~isnan(PC_values_quiet{1}) , ~isnan(PC_values_quiet{2}));
Bar_shock = [nanmedian(PC_values_shock{1}(ind1)) nanmedian(PC_values_shock{2}(ind1))];
Bar_safe = [nanmedian(PC_values_safe{1}(ind2)) nanmedian(PC_values_safe{2}(ind2))];
Bar_quiet = [nanmedian(PC_values_quiet{1}(ind3)) nanmedian(PC_values_quiet{2}(ind3))];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color','r')
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color','b')
    try, line([Bar_quiet(1) PC_values_quiet{1}(mouse)],[Bar_quiet(2) PC_values_quiet{2}(mouse)],'LineStyle','--','Color',[.5 .8 .5]), end
end
plot(Bar_shock(1),Bar_shock(2),'.r','MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.b','MarkerSize',60)
plot(Bar_quiet(1),Bar_quiet(2),'.','MarkerSize',60,'Color',[.5 .8 .5])
f=get(gca,'Children'); legend([f([3 2 1])],'Freezing shock','Freezing safe','Quiet wake');
title('Comparison with quiet wake')



Cols2 = {[1 0 0],[0 0 1],[.5 .8 .5]};
X2 = 1:3;
Legends2 = {'Freezing shock','Freezing safe','Quiet wake'};

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({PC_values_shock_sal{1} PC_values_safe_sal{1} PC_values_quiet{1}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC1 score (a.u.)')

subplot(122)
MakeSpreadAndBoxPlot3_SB({PC_values_shock_sal{2} PC_values_safe_sal{2} PC_values_quiet{2}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC2 score (a.u.)')





%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          CondPre / CondPost / Ext
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except mu sigma eigen_vector OB_Max_Freq DIST_intra DIST_inter PC_values_shock_sal PC_values_safe_sal

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Freezing_Eyelid_CondPre_2sFullBins.mat')
load('Data_Physio_Freezing_Saline_all_Fear_2sFullBins.mat', 'Params')
Session_type={'CondPre'}; sess=1; strict=0;

figure, [~ , ~ , Freq_Max_Shock] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,5,:))); close
figure, [~ , ~ , Freq_Max_Safe] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,6,:))); close


DATA2(1,:) = [Freq_Max_Shock Freq_Max_Safe];
ind_mouse=1:31;

n=2;
for par=[2:8]
    DATA2(n,:) = [OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,5)' OutPutData.(Session_type{sess}).(Params{par}).mean(ind_mouse,6)'];
    n=n+1;
end


ind=and(sum(isnan(DATA2(:,1:length(Mouse(ind_mouse)))))==0 , sum(isnan(DATA2(:,length(Mouse(ind_mouse))+1:length(Mouse(ind_mouse))*2)))==0);

% [~,~,~, eigen_vector1] = Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind])')', Params  , {''});


DATA3 = ((DATA2-mu')./sigma')';

for pc=1:size(eigen_vector,2)
    for mouse=1:round(size(DATA3,1)/2)
        try            
            PC_values_condpre_shock{pc}(mouse) = eigen_vector(~isnan(DATA3(mouse,:)),pc)'*DATA3(mouse,~isnan(DATA3(mouse,:)))';
            PC_values_condpre_safe{pc}(mouse) = eigen_vector(~isnan(DATA3(mouse+round(size(DATA3,1)/2),:)),pc)'*DATA3(mouse+round(size(DATA3,1)/2),~isnan(DATA3(mouse+round(size(DATA3,1)/2),:)))';
            PC_values_condpre_shock{pc}(PC_values_condpre_shock{pc}==0)=NaN; PC_values_condpre_safe{pc}(PC_values_condpre_safe{pc}==0)=NaN;
        end
    end
end


figure
plot(PC_values_shock_sal{1} , PC_values_shock_sal{2},'.r','MarkerSize',15)
hold on
plot(PC_values_safe_sal{1} , PC_values_safe_sal{2},'.b','MarkerSize',15)
plot(PC_values_condpre_shock{1} , PC_values_condpre_shock{2},'.m','MarkerSize',30)
plot(PC_values_condpre_safe{1} , PC_values_active_safe{2},'.c','MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_fz_shock = [nanmedian(PC_values_shock_sal{1}) nanmedian(PC_values_shock_sal{2})];
Bar_fz_safe = [nanmedian(PC_values_safe_sal{1}) nanmedian(PC_values_safe_sal{2})];
Bar_act_shock = [nanmedian(PC_values_active_shock{1}) nanmedian(PC_values_active_shock{2})];
Bar_act_safe = [nanmedian(PC_values_active_safe{1}) nanmedian(PC_values_active_safe{2})];
for mouse=1:length(PC_values_shock_sal{1})
    line([Bar_fz_shock(1) PC_values_shock_sal{1}(mouse)],[Bar_fz_shock(2) PC_values_shock_sal{2}(mouse)],'LineStyle','--','Color','r')
    line([Bar_fz_safe(1) PC_values_safe_sal{1}(mouse)],[Bar_fz_safe(2) PC_values_safe_sal{2}(mouse)],'LineStyle','--','Color','b')
    line([Bar_act_shock(1) PC_values_active_shock{1}(mouse)],[Bar_act_shock(2) PC_values_active_shock{2}(mouse)],'LineStyle','--','Color','m')
    line([Bar_act_safe(1) PC_values_active_safe{1}(mouse)],[Bar_act_safe(2) PC_values_active_safe{2}(mouse)],'LineStyle','--','Color','c')
end
plot(Bar_fz_shock(1),Bar_fz_shock(2),'.r','MarkerSize',60)
plot(Bar_fz_safe(1),Bar_fz_safe(2),'.b','MarkerSize',60)
plot(Bar_act_shock(1),Bar_act_shock(2),'.m','MarkerSize',60)
plot(Bar_act_safe(1),Bar_act_safe(2),'.c','MarkerSize',60)
f=get(gca,'Children'); legend([f([4 3 2 1])],'Freezing shock','Freezing safe','Active shock','Active safe');
title('Comparison with active')



Cols2 = {[1 0 0],[0 0 1],[1 0 1],[0 1 1]};
X2 = 1:4;
Legends2 = {'Freezing shock','Freezing safe','Active shock','Active safe'};

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({PC_values_shock_sal{1} PC_values_safe_sal{1} PC_values_active_shock{1} PC_values_active_safe{1}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC1 score (a.u.)')

subplot(122)
MakeSpreadAndBoxPlot3_SB({PC_values_shock_sal{2} PC_values_safe_sal{2} PC_values_active_shock{1} PC_values_active_safe{1}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC2 score (a.u.)')





%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Wake / NREM / REM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except mu sigma eigen_vector OB_Max_Freq DIST_intra DIST_inter PC_values_shock_sal PC_values_safe_sal

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Sleep_2sFullBins.mat')
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Fear_2sFullBins.mat', 'Params')

for par=1:8
    DATA2(par,:) = [OutPutData.sleep_pre.(Params{par}).mean(:,4)' OutPutData.sleep_pre.(Params{par}).mean(:,5)' OutPutData.sleep_pre.(Params{par}).mean(:,2)'];
end

ind=and(and(sum(isnan(DATA2(:,1:length(Mouse))))==0 , sum(isnan(DATA2(:,length(Mouse)+1:length(Mouse)*2)))==0) , sum(isnan(DATA2(:,length(Mouse)*2+1:length(Mouse)*3)))==0);

[~,~,~, eigen_vector2] = Correlations_Matrices_Data_BM(zscore(DATA2(:,[ind ind ind])')', Params , {''});

DATA3 = ((DATA2-mu')./sigma')';

for pc=1:size(eigen_vector,2)
    for mouse=1:round(size(DATA3,1)/3)
%         try            
            PC_values_NREM{pc}(mouse) = eigen_vector(~isnan(DATA3(mouse,:)),pc)'*DATA3(mouse,~isnan(DATA3(mouse,:)))';
            PC_values_REM{pc}(mouse) = eigen_vector(~isnan(DATA3(mouse+round(size(DATA3,1)/3),:)),pc)'*DATA3(mouse+round(size(DATA3,1)/3),~isnan(DATA3(mouse+round(size(DATA3,1)/3),:)))';
            PC_values_Wake{pc}(mouse) = eigen_vector(~isnan(DATA3(mouse+round(size(DATA3,1)/3)*2,:)),pc)'*DATA3(mouse+round(size(DATA3,1)/3)*2,~isnan(DATA3(mouse+round(size(DATA3,1)/3)*2,:)))';
            PC_values_NREM{pc}(PC_values_NREM{pc}==0)=NaN; PC_values_REM{pc}(PC_values_REM{pc}==0)=NaN; PC_values_Wake{pc}(PC_values_Wake{pc}==0)=NaN;
%         end
    end
end
PC_values_NREM{1}(4)=NaN; PC_values_REM{1}(4)=NaN;

figure
plot(PC_values_shock{1} , PC_values_shock{2},'.','MarkerSize',30,'Color',[1 .5 .5])
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','MarkerSize',30,'Color',[.5 .5 1])
% plot(PC_values_Wake{1} , PC_values_Wake{2},'.','MarkerSize',30,'Color',[0 0 1])
plot(PC_values_NREM{1} , PC_values_NREM{2},'.','MarkerSize',30,'Color',[1 0 0])
plot(PC_values_REM{1} , PC_values_REM{2},'.','MarkerSize',30,'Color',[0 1 0])
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on

ind_shock = and(~isnan(PC_values_shock{1}) , ~isnan(PC_values_shock{2}));
ind_safe = and(~isnan(PC_values_safe{1}) , ~isnan(PC_values_safe{2}));

Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
Bar_NREM = [nanmedian(PC_values_NREM{1}) nanmedian(PC_values_NREM{2})];
Bar_REM = [nanmedian(PC_values_REM{1}) nanmedian(PC_values_REM{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    try, line([Bar_NREM(1) PC_values_NREM{1}(mouse)],[Bar_NREM(2) PC_values_NREM{2}(mouse)],'LineStyle','--','Color',[1 0 0]), end
    try, line([Bar_REM(1) PC_values_REM{1}(mouse)],[Bar_REM(2) PC_values_REM{2}(mouse)],'LineStyle','--','Color',[0 1 0]), end
end
plot(Bar_shock(1),Bar_shock(2),'.','MarkerSize',60,'Color',[1 .5 .5])
plot(Bar_safe(1),Bar_safe(2),'.','MarkerSize',60,'Color',[.5 .5 1])
plot(Bar_NREM(1),Bar_NREM(2),'.','MarkerSize',60,'Color',[1 0 0])
plot(Bar_REM(1),Bar_REM(2),'.','MarkerSize',60,'Color',[0 1 0])
f=get(gca,'Children'); legend([f([4 3 2 1])],'Freezing shock','Freezing safe','NREM','REM');
title('Comparison with sleep')



Cols2 = {[1 0 0],[0 0 1],[0.8 0.5 0]};
X2 = 1:3;
Legends2 = {'Freezing shock','Freezing safe','Sleep'};

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({PC_values_shock{1} PC_values_safe{1} PC_values_sleep{1}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC1 score (a.u.)')

subplot(122)
MakeSpreadAndBoxPlot3_SB({PC_values_shock{2} PC_values_safe{2} PC_values_sleep{2}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('PC2 score (a.u.)')







%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Head Restraint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mouse=[1189 1227 1254 1268 1304 1350 1385];
Session_type={'head_restraint'};
for sess=1:length(Session_type) 
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('head_restraint',Mouse,lower(Session_type{sess}),...
        'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','pfc_delta_power');
end


Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition'};
for par=1:8
    DATA2(par,:) = OutPutData.head_restraint.(Params{par}).mean(:,1)';
end


ind=sum(isnan(DATA2))==0;

[~,~,~, eigen_vector2] = Correlations_Matrices_Data_BM(zscore(DATA2(:,ind)')', Params , {''});

load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/PCA_Analysis.mat','PC_values_shock','PC_values_safe', 'mu', 'sigma', 'eigen_vector')
DATA3 = ((DATA2-mu')./sigma')';

for pc=1:size(eigen_vector,2)
    for mouse=1:size(DATA3,1)
        try
            PC_values_restraint{pc}(mouse) = eigen_vector(:,pc)'*DATA3(mouse,:)';
        end
    end
end


%
figure
plot(PC_values_shock{1} , PC_values_shock{2},'.r','MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.b','MarkerSize',30)
plot(PC_values_restraint{1} , PC_values_restraint{2},'.g','MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
ind1 = and(~isnan(PC_values_shock{1}) , ~isnan(PC_values_shock{2}));
ind2 = and(~isnan(PC_values_safe{1}) , ~isnan(PC_values_safe{2}));
ind3 = and(~isnan(PC_values_restraint{1}) , ~isnan(PC_values_restraint{2}));
Bar_shock = [nanmedian(PC_values_shock{1}(ind1)) nanmedian(PC_values_shock{2}(ind1))];
Bar_safe = [nanmedian(PC_values_safe{1}(ind2)) nanmedian(PC_values_safe{2}(ind2))];
Bar_restr = [nanmedian(PC_values_restraint{1}(ind3)) nanmedian(PC_values_restraint{2}(ind3))];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color','r')
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color','b')
end
for mouse=1:length(PC_values_restraint{1})
    line([Bar_restr(1) PC_values_restraint{1}(mouse)],[Bar_restr(2) PC_values_restraint{2}(mouse)],'LineStyle','--','Color','g')
end
plot(Bar_shock(1),Bar_shock(2),'.r','MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.b','MarkerSize',60)
plot(Bar_restr(1),Bar_restr(2),'.g','MarkerSize',60)
f=get(gca,'Children'); legend([f([3 2 1])],'Freezing shock','Freezing safe','Head Restraint');
title('Comparison with active')



figure
plot(PC_values_shock{3} , PC_values_shock{4},'.r','MarkerSize',30)
hold on
plot(PC_values_safe{3} , PC_values_safe{4},'.b','MarkerSize',30)
plot(PC_values_restraint{3} , PC_values_restraint{4},'.g','MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
ind1 = and(~isnan(PC_values_shock{3}) , ~isnan(PC_values_shock{4}));
ind2 = and(~isnan(PC_values_safe{3}) , ~isnan(PC_values_safe{4}));
ind3 = and(~isnan(PC_values_restraint{3}) , ~isnan(PC_values_restraint{4}));
Bar_shock = [nanmedian(PC_values_shock{3}(ind1)) nanmedian(PC_values_shock{4}(ind1))];
Bar_safe = [nanmedian(PC_values_safe{3}(ind2)) nanmedian(PC_values_safe{4}(ind2))];
Bar_restr = [nanmedian(PC_values_restraint{3}(ind3)) nanmedian(PC_values_restraint{4}(ind3))];
for mouse=1:length(PC_values_shock{3})
    line([Bar_shock(1) PC_values_shock{3}(mouse)],[Bar_shock(2) PC_values_shock{4}(mouse)],'LineStyle','--','Color','r')
    line([Bar_safe(1) PC_values_safe{3}(mouse)],[Bar_safe(2) PC_values_safe{4}(mouse)],'LineStyle','--','Color','b')
end
for mouse=1:length(PC_values_restraint{3})
    line([Bar_restr(1) PC_values_restraint{3}(mouse)],[Bar_restr(2) PC_values_restraint{4}(mouse)],'LineStyle','--','Color','g')
end
plot(Bar_shock(1),Bar_shock(2),'.r','MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.b','MarkerSize',60)
plot(Bar_restr(1),Bar_restr(2),'.g','MarkerSize',60)
f=get(gca,'Children'); legend([f([3 2 1])],'Freezing shock','Freezing safe','Head Restraint');
title('Comparison with active')



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Temporal evolution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Cond_2sFullBins.mat')
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/PCA_Analysis.mat','PC_values_shock','PC_values_safe', 'mu', 'sigma', 'eigen_vector')
Session_type={'Cond'};

for mouse=1:length(Mouse)
    clear DATA3
    DATA3 = ((DATA.(Session_type{sess}).(Mouse_names{mouse})(1:8,:)-mu')./sigma')';
    for pc=1:size(eigen_vector,2)
        for i=1:size(DATA3,1)
            
            ind = ~isnan(DATA3(i,:));
            PC_values{pc}{mouse}(i) = eigen_vector(ind,pc)'*DATA3(i,ind)';
            
        end
        ind_shock = DATA.(Session_type{sess}).(Mouse_names{mouse})(9,:)<.35;
        ind_safe = DATA.(Session_type{sess}).(Mouse_names{mouse})(9,:)>.6;
        PC_values_SHOCK{pc}{mouse} = PC_values{pc}{mouse}(ind_shock);
        PC_values_SAFE{pc}{mouse} = PC_values{pc}{mouse}(ind_safe);
    end
end

a=jet;
for mouse=1:length(Mouse)
    figure
    subplot(121)
    plot(nanmedian(PC_values_SHOCK{1}{mouse}) , nanmedian(PC_values_SHOCK{2}{mouse}) ,'.r','MarkerSize',60), hold on
    plot(nanmedian(PC_values_SAFE{1}{mouse}) , nanmedian(PC_values_SAFE{2}{mouse}) ,'.b','MarkerSize',60), hold on
    n=linspace(1,64,length(PC_values_SHOCK{2}{mouse}));
    for i=1:length(PC_values_SHOCK{1}{mouse})
        plot(PC_values_SHOCK{1}{mouse}(i) , PC_values_SHOCK{2}{mouse}(i), '.', 'Color' , a(65-round(n(i)),:) , 'MarkerSize' , 10)
        try, PC1_shock_dist{mouse}(i) = PC_values_SHOCK{1}{mouse}(i+1)-PC_values_SHOCK{1}{mouse}(i); end
        try, PC2_shock_dist{mouse}(i) = PC_values_SHOCK{2}{mouse}(i+1)-PC_values_SHOCK{2}{mouse}(i); end
    end
    axis square
    u1=[xlim ylim];
    
    subplot(122)
    plot(nanmedian(PC_values_SHOCK{1}{mouse}()) , nanmedian(PC_values_SHOCK{2}{mouse}) ,'.r','MarkerSize',60), hold on
    plot(nanmedian(PC_values_SAFE{1}{mouse}) , nanmedian(PC_values_SAFE{2}{mouse}) ,'.b','MarkerSize',60), hold on
    n=linspace(1,64,length(PC_values_SAFE{2}{mouse}));
    for i=1:length(PC_values_SAFE{1}{mouse})
        plot(PC_values_SAFE{1}{mouse}(i) , PC_values_SAFE{2}{mouse}(i), '.', 'Color' , a(65-round(n(i)),:) , 'MarkerSize' , 10)
        try, PC1_safe_dist{mouse}(i) = PC_values_SAFE{1}{mouse}(i+1)-PC_values_SAFE{1}{mouse}(i); end
        try, PC2_safe_dist{mouse}(i) = PC_values_SAFE{2}{mouse}(i+1)-PC_values_SAFE{2}{mouse}(i); end
    end
    u2=[xlim ylim];
    axis square
    
    subplot(121)
    xlim([min(u1(1),u2(1)) max(u1(2),u2(2))]), ylim([min(u1(3),u2(3)) max(u1(4),u2(4))]),
    subplot(122)
    xlim([min(u1(1),u2(1)) max(u1(2),u2(2))]), ylim([min(u1(3),u2(3)) max(u1(4),u2(4))]),
    close
end



% example mouse
xlabel('PC1 value'), ylabel('PC2 value')
title('Freezing shock')
title('Freezing safe')
f=get(gca,'Children'); legend([f([end end-1])],'Freezing shock median','Freezing safe median');
u=colorbar; u.Ticks=[0 1]; u.Label.String = 'time (a.u.)'; u.Label.FontSize=12;
colormap jet


figure, n=1;
for mouse=[8 11:14 16 18 19 22 24 27:29 31 35]
    subplot(3,5,n)
    line([0 sum(PC1_shock_dist{mouse})],[0 sum(PC2_shock_dist{mouse})] , 'Color' , [1 .5 .5] , 'LineWidth' , 5);
    hold on
    line([0 sum(PC1_safe_dist{mouse})],[0 sum(PC2_safe_dist{mouse})] , 'Color' , [.5 .5 1] , 'LineWidth' , 5);
    n=n+1;
    xlim([-10 10]), ylim([-4 4])
end

% example mouse
mouse=13;
figure
line([0 sum(PC1_shock_dist{mouse})],[0 sum(PC2_shock_dist{mouse})] , 'Color' , [1 .5 .5] , 'LineWidth' , 5);
hold on
line([0 sum(PC1_safe_dist{mouse})],[0 sum(PC2_safe_dist{mouse})] , 'Color' , [.5 .5 1] , 'LineWidth' , 5);
axis square
xlabel('global evolution on PC1')
ylabel('global evolution on PC2')


figure, n=1;
for mouse=[8 11:14 16 18 19 22 24 27:29 31 35]
    subplot(3,5,n)
    line([0 nanmedian(PC1_shock_dist{mouse})],[0 nanmedian(PC2_shock_dist{mouse})] , 'Color' , [1 .5 .5] , 'LineWidth' , 5);
    hold on
    line([0 nanmedian(PC1_safe_dist{mouse})],[0 nanmedian(PC2_safe_dist{mouse})] , 'Color' , [.5 .5 1] , 'LineWidth' , 5);
    n=n+1;
end


for mouse=1:length(Mouse)
    Sum_Dist_shock_PC1(mouse) = sum(PC1_shock_dist{mouse}); 
    Sum_Dist_shock_PC2(mouse) = sum(PC2_shock_dist{mouse});
    Sum_Dist_safe_PC1(mouse) = sum(PC1_safe_dist{mouse});
    Sum_Dist_safe_PC2(mouse) = sum(PC2_safe_dist{mouse});
end
Sum_Dist_shock_PC1(Sum_Dist_shock_PC1==0)=NaN;
Sum_Dist_shock_PC2(Sum_Dist_shock_PC2==0)=NaN;
Sum_Dist_safe_PC1(Sum_Dist_safe_PC1==0)=NaN;
Sum_Dist_safe_PC2(Sum_Dist_safe_PC2==0)=NaN;



Cols = {[1 .5 .5],[1 .5 .5],[.5 .5 1],[.5 .5 1]};
X = 1:4;
Legends = {'Shock PC1','Shock PC2','Safe PC1','Safe PC2'};


figure
subplot(121)
makepretty_BM
MakeSpreadAndBoxPlot3_SB({Sum_Dist_shock_PC1 Sum_Dist_shock_PC2 Sum_Dist_safe_PC1 Sum_Dist_safe_PC2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('temporal evolution on PCs')
hline(0,'--r')

[h,p1]=ttest(Sum_Dist_shock_PC1,zeros(1,length(Sum_Dist_shock_PC1))); 
[h,p2]=ttest(Sum_Dist_shock_PC2,zeros(1,length(Sum_Dist_shock_PC2))); 
[h,p3]=ttest(Sum_Dist_safe_PC1,zeros(1,length(Sum_Dist_safe_PC1))); 
[h,p4]=ttest(Sum_Dist_safe_PC2,zeros(1,length(Sum_Dist_safe_PC2))); 

text([3 4],[4 4],'***','HorizontalAlignment','Center','BackGroundColor','none','Tag','sigstar_stars');

subplot(122)
makepretty_BM
xlim([-2 1]), ylim([-2 1])
quiver(0,0,nanmedian(Sum_Dist_shock_PC1),nanmedian(Sum_Dist_shock_PC2) , 'Color' , [1 .5 .5] , 'LineWidth' , 5 , 'MaxHeadSize', 1); 
hold on
quiver(0,0,nanmedian(Sum_Dist_safe_PC1),nanmedian(Sum_Dist_safe_PC2) , 'Color' , [.5 .5 1] , 'LineWidth' , 5);
axis square
xlabel('global evolution on PC1')
ylabel('global evolution on PC2')
grid on



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Sound conditionning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mouse=[439 490 507 508 509 510 512 514];
Session_type={'sound_cond'};
for sess=1:length(Session_type) 
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('sound_cond',Mouse,lower(Session_type{sess}),...
        'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power');
end


Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition'};
for par=1:8
    DATA2(par,:) = OutPutData.sound_cond.(Params{par}).mean(:,1)';
end


ind=sum(isnan(DATA2))==0;

[~,~,~, eigen_vector2] = Correlations_Matrices_Data_BM(zscore(DATA2(:,ind)')', Params , {''});

load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/PCA_Analysis.mat','PC_values_shock','PC_values_safe', 'mu', 'sigma', 'eigen_vector')
DATA3 = ((DATA2-mu')./sigma')';

for pc=1:size(eigen_vector,2)
    for mouse=1:size(DATA3,1)
        try
            ind = ~isnan(DATA3(mouse,:));
            PC_values_sound_cond{pc}(mouse) = eigen_vector(ind,pc)'*DATA3(mouse,ind)';
        end
    end
end


%
figure
plot(PC_values_shock{1} , PC_values_shock{2},'.r','MarkerSize',30)
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.b','MarkerSize',30)
plot(PC_values_sound_cond{1} , PC_values_sound_cond{2},'.g','MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
ind1 = and(~isnan(PC_values_shock{1}) , ~isnan(PC_values_shock{2}));
ind2 = and(~isnan(PC_values_safe{1}) , ~isnan(PC_values_safe{2}));
ind3 = and(~isnan(PC_values_sound_cond{1}) , ~isnan(PC_values_sound_cond{2}));
Bar_shock = [nanmedian(PC_values_shock{1}(ind1)) nanmedian(PC_values_shock{2}(ind1))];
Bar_safe = [nanmedian(PC_values_safe{1}(ind2)) nanmedian(PC_values_safe{2}(ind2))];
Bar_restr = [nanmedian(PC_values_sound_cond{1}(ind3)) nanmedian(PC_values_sound_cond{2}(ind3))];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color','r')
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color','b')
end
for mouse=1:length(PC_values_sound_cond{1})
    line([Bar_restr(1) PC_values_sound_cond{1}(mouse)],[Bar_restr(2) PC_values_sound_cond{2}(mouse)],'LineStyle','--','Color','g')
end
plot(Bar_shock(1),Bar_shock(2),'.r','MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.b','MarkerSize',60)
plot(Bar_restr(1),Bar_restr(2),'.g','MarkerSize',60)
f=get(gca,'Children'); legend([f([3 2 1])],'Freezing shock','Freezing safe','Sound cond');
title('Comparison with sound conditioning')



figure
plot(PC_values_shock{3} , PC_values_shock{4},'.r','MarkerSize',30)
hold on
plot(PC_values_safe{3} , PC_values_safe{4},'.b','MarkerSize',30)
plot(PC_values_sound_cond{3} , PC_values_sound_cond{4},'.g','MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
ind1 = and(~isnan(PC_values_shock{3}) , ~isnan(PC_values_shock{4}));
ind2 = and(~isnan(PC_values_safe{3}) , ~isnan(PC_values_safe{4}));
ind3 = and(~isnan(PC_values_sound_cond{3}) , ~isnan(PC_values_sound_cond{4}));
Bar_shock = [nanmedian(PC_values_shock{3}(ind1)) nanmedian(PC_values_shock{4}(ind1))];
Bar_safe = [nanmedian(PC_values_safe{3}(ind2)) nanmedian(PC_values_safe{4}(ind2))];
Bar_restr = [nanmedian(PC_values_sound_cond{3}(ind3)) nanmedian(PC_values_sound_cond{4}(ind3))];
for mouse=1:length(PC_values_shock{3})
    line([Bar_shock(1) PC_values_shock{3}(mouse)],[Bar_shock(2) PC_values_shock{4}(mouse)],'LineStyle','--','Color','r')
    line([Bar_safe(1) PC_values_safe{3}(mouse)],[Bar_safe(2) PC_values_safe{4}(mouse)],'LineStyle','--','Color','b')
end
for mouse=1:length(PC_values_sound_cond{3})
    line([Bar_restr(1) PC_values_sound_cond{3}(mouse)],[Bar_restr(2) PC_values_sound_cond{4}(mouse)],'LineStyle','--','Color','g')
end
plot(Bar_shock(1),Bar_shock(2),'.r','MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.b','MarkerSize',60)
plot(Bar_restr(1),Bar_restr(2),'.g','MarkerSize',60)
f=get(gca,'Children'); legend([f([3 2 1])],'Freezing shock','Freezing safe','Head Restraint');
title('Comparison with active')



load('/media/nas7/ProjetEmbReact/DataEmbReact/PCA_Ext_Saline.mat','PC_values_shock','PC_values_safe', 'mu', 'sigma', 'eigen_vector')
DATA3 = ((DATA2-mu')./sigma')';

for pc=1:size(eigen_vector,2)
    for mouse=1:size(DATA3,1)
        try
            ind = ~isnan(DATA3(mouse,:));
            PC_values_sound_cond{pc}(mouse) = eigen_vector(ind,pc)'*DATA3(mouse,ind)';
        end
    end
end



Cols = {[1 .5 .5],[.5 .5 1],[0 1 0]};
X = 1:3;
Legends = {'Shock','Safe','SoundCond'};

Mouse2=Mouse;
GetAllSalineSessions_BM

for mouse=1:length(Mouse2)
    ind(mouse) = find(Mouse2(mouse)==Mouse);
end

figure
MakeSpreadAndBoxPlot3_SB({PC_values_shock{1}(ind) PC_values_safe{1}(ind) PC_values_sound_cond{1}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('PC1 value')
hline(0,'--r')




figure
plot(PC_values_shock{1}(ind) , PC_values_shock{2}(ind),'.r','MarkerSize',30)
hold on
plot(PC_values_safe{1}(ind) , PC_values_safe{2}(ind),'.b','MarkerSize',30)
plot(PC_values_sound_cond{1} , PC_values_sound_cond{2},'.g','MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
ind1 = and(~isnan(PC_values_shock{1}(ind)) , ~isnan(PC_values_shock{2}(ind)));
ind2 = and(~isnan(PC_values_safe{1}(ind)) , ~isnan(PC_values_safe{2}(ind)));
ind3 = and(~isnan(PC_values_sound_cond{1}) , ~isnan(PC_values_sound_cond{2}));
Bar_shock = [nanmedian(PC_values_shock{1}(ind1)) nanmedian(PC_values_shock{2}(ind1))];
Bar_safe = [nanmedian(PC_values_safe{1}(ind2)) nanmedian(PC_values_safe{2}(ind2))];
Bar_restr = [nanmedian(PC_values_sound_cond{1}(ind3)) nanmedian(PC_values_sound_cond{2}(ind3))];
for mouse=ind
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color','r')
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color','b')
end
for mouse=1:length(PC_values_sound_cond{1})
    line([Bar_restr(1) PC_values_sound_cond{1}(mouse)],[Bar_restr(2) PC_values_sound_cond{2}(mouse)],'LineStyle','--','Color','g')
end
plot(Bar_shock(1),Bar_shock(2),'.r','MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.b','MarkerSize',60)
plot(Bar_restr(1),Bar_restr(2),'.g','MarkerSize',60)
f=get(gca,'Children'); legend([f([3 2 1])],'Freezing shock','Freezing safe','Sound cond');
title('Comparison with sound conditioning')









