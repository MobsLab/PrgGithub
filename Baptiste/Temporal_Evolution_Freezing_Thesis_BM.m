
clear all

% load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Cond_2sFullBins.mat')
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat')
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/PCA_Analysis.mat','PC_values_shock','PC_values_safe', 'mu', 'sigma', 'eigen_vector')
Session_type={'Cond'};
Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power'};

for param=1:8
    for mouse = 1:length(Mouse)
        try
            clear D, D = Data(OutPutData.Cond.(Params{param}).tsd{mouse,5});
            DATA_shock.(Params{param})(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
        end
        try
            clear D, D = Data(OutPutData.Cond.(Params{param}).tsd{mouse,6});
            DATA_safe.(Params{param})(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
        end
    end
    DATA_shock.(Params{param})(DATA_shock.(Params{param})==0) = NaN;
    DATA_safe.(Params{param})(DATA_safe.(Params{param})==0) = NaN;
end


% example mouse
figure
for param=1:8
    subplot(2,4,param)
    plot(DATA_shock.(Params{param})(43,:) , 'Color' , [1 .5 .5])
    hold on
    plot(DATA_safe.(Params{param})(43,:) , 'Color' , [.5 .5 1])
    xlabel('time (a.u)')
    makepretty
    
    if param==1
        ylabel('Breathing (Hz)')
    elseif param==2
        ylabel('Heart rate (Hz)')
    elseif param==3
        ylabel('Heart rate variability (a.u.)')
    elseif param==4
        ylabel('OB Gamma frequency (Hz)')
    elseif param==5
        ylabel('OB Gamma power (a.u.)')
    elseif param==6
        ylabel('SWR occurence (#/s)')
    elseif param==7
        ylabel('Theta frequency (Hz)')
    elseif param==8
        ylabel('Theta power (a.u.)')
    end
end

figure, param=1;
subplot(121)
plot(movmean(DATA_shock.(Params{param})(43,:),2,'omitnan') , 'Color' , [1 .5 .5])
hold on
plot(movmean(DATA_safe.(Params{param})(43,:),2,'omitnan') , 'Color' , [.5 .5 1])
xlabel('time (a.u)'), ylabel('Breathing (Hz)')
makepretty
legend('Shock Fz','Safe Fz')
ylim([1 7])

param=2;
subplot(122)
plot(movmean(DATA_shock.(Params{param})(43,:),2,'omitnan') , 'Color' , [1 .5 .5])
hold on
plot(movmean(DATA_safe.(Params{param})(43,:),2,'omitnan') , 'Color' , [.5 .5 1])
xlabel('time (a.u)'), ylabel('Heart rate (Hz)')
makepretty



% all mice
x = linspace(0,1,100);

figure
for param=1:8
    subplot(2,4,param)
    
    Data_to_use = DATA_shock.(Params{param});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(x , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
    col = [1 .5 .5]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    if or(or(param==1 , param==2) ,  or(param==8 , param==4))
        a1 = runmean(nanmean(Data_to_use),10)-runmean(Conf_Inter,10);
    elseif or(param==6 , param==3)
        a1 = runmean(nanmean(Data_to_use),10)+runmean(Conf_Inter,10);
    end
    
    Data_to_use = DATA_safe.(Params{param});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(x , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
    col = [.5 .5 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    if or(or(param==1 , param==2) ,  or(param==8 , param==4))
        a2 = runmean(nanmean(Data_to_use),10)+runmean(Conf_Inter,10);
    elseif or(param==6 , param==3)
        a2 = runmean(nanmean(Data_to_use),10)-runmean(Conf_Inter,10);
    end
    
    if or(or(or(param==1 , param==2) ,  or(param==8 , param==4)) , or(param==6 , param==3))
        patch([x fliplr(x)], [a1 fliplr(a2)], 'k' , 'FaceAlpha' , .5)
    end
    makepretty
    xlabel('time (a.u.)')
    
    if param==1
        ylabel('Breathing (Hz)')
        f=get(gca,'Children'); legend([f(6),f(2)],'Shock Fz','Safe Fz');
    elseif param==2
        ylabel('Heart rate (Hz)')
    elseif param==3
        ylabel('Heart rate variability (a.u.)')
    elseif param==4
        ylabel('OB Gamma frequency (Hz)')
    elseif param==5
        ylabel('OB Gamma power (a.u.)')
    elseif param==6
        ylabel('SWR occurence (#/s)')
    elseif param==7
        ylabel('Theta frequency (Hz)')
    elseif param==8
        ylabel('Theta power (a.u.)')
    end
end

param=1; clear p
for i=1:100
    [~,p(i)] = ttest(DATA_shock.(Params{param})(:,i)' , DATA_safe.(Params{param})(:,i)');
end


figure
plot(p,'.-k','MarkerSize',20), hold on
hline(.05,'--k')
plot(find(p>.05) , p(p>.05),'.r','MarkerSize',20)
set(gca , 'Yscale','log')
makepretty
ylabel('pvalues')

A = nanmean(DATA_shock.(Params{param})(:,95:100)')-nanmean(DATA_shock.(Params{param})(:,1:5)');
B = nanmean(DATA_safe.(Params{param})(:,95:100)')-nanmean(DATA_safe.(Params{param})(:,1:5)');

[h,p]=ttest(A,zeros(1,51))
[h,p]=ttest(B,zeros(1,51))



for mouse=1:length(Mouse)
    for param=1:8
        for i=1:10
            
            DATA2_shock.(Params{param})(mouse,i) = nanmean(DATA_shock.(Params{param})(mouse,(i-1)*10+1:10*i));
            DATA2_safe.(Params{param})(mouse,i) = nanmean(DATA_safe.(Params{param})(mouse,(i-1)*10+1:10*i));
            
        end
    end
end

figure
for param=1:8
    subplot(2,4,param)
    
    Data_to_use = DATA2_shock.(Params{param})-DATA2_safe.(Params{param});
    Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp=nanmean(Data_to_use);
    b=bar(Mean_All_Sp); b.FaceColor=[.5 .5 .5]; hold on
   if or(or(or(param==1 , param==2) ,  or(param==8 , param==4)) , param==7)
    errorbar([1:10],Mean_All_Sp,zeros(size(Conf_Inter)),Conf_Inter,'.','vertical','Color','k')
   else 
       errorbar([1:10],Mean_All_Sp,Conf_Inter,zeros(size(Conf_Inter)),'.','vertical','Color','k')
   end
   xticklabels({''})
   
    makepretty
    xlabel('time (a.u.)')
    
    if param==1
        ylabel('Breathing (Hz)')
    elseif param==2
        ylabel('Heart rate (Hz)')
    elseif param==3
        ylabel('Heart rate variability (a.u.)')
    elseif param==4
        ylabel('OB Gamma frequency (Hz)')
    elseif param==5
        ylabel('OB Gamma power (a.u.)')
    elseif param==6
        ylabel('SWR occurence (#/s)')
    elseif param==7
        ylabel('Theta frequency (Hz)')
    elseif param==8
        ylabel('Theta power (a.u.)')
    end
end



a=[linspace(.3,.5,10) ; linspace(.3,.5,10) ; linspace(.3,1,10)]';
b=[linspace(.3,1,10) ; linspace(.3,.5,10) ; linspace(.3,.5,10)]';


U = [1:ceil(length(PC_values_SHOCK{2}{mouse})/10)-1:length(PC_values_SHOCK{2}{mouse})];
for i=1:10
    X(i) = nanmedian(PC_values_SHOCK{1}{mouse}(U(i):U(i+1)));
    Y(i) = nanmedian(PC_values_SHOCK{2}{mouse}(U(i):U(i+1)));
end
for i=1:10
    if or(i==1 , i==10)
        plot(X(i) , Y(i), '.', 'Color' , b(i,:) , 'MarkerSize' , 35), hold on
    else
        plot(X(i) , Y(i), '.', 'Color' , b(i,:) , 'MarkerSize' , 15), hold on
    end
    if i~=1; line([X(i) X(i-1)] , [Y(i) Y(i-1)] , 'Color' , [.5 .5 .5]); end
end

U = [1:ceil(length(PC_values_SAFE{2}{mouse})/10)-1:length(PC_values_SAFE{2}{mouse})];
for i=1:10
    X(i) = nanmedian(PC_values_SAFE{1}{mouse}(U(i):U(i+1)));
    Y(i) = nanmedian(PC_values_SAFE{2}{mouse}(U(i):U(i+1)));
end
for i=1:10
    if or(i==1 , i==10)
        plot(X(i) , Y(i), '.', 'Color' , a(i,:) , 'MarkerSize' , 35), hold on
    else 
        plot(X(i) , Y(i), '.', 'Color' , a(i,:) , 'MarkerSize' , 15), hold on
    end
    if i~=1; line([X(i) X(i-1)] , [Y(i) Y(i-1)] , 'Color' , [.5 .5 .5]); end
end
xlabel('PC1 value'), ylabel('PC2 value')
grid on
axis square



for mouse=1:length(Mouse)
    try
        clear U
        U = [1:ceil(length(PC_values_SHOCK{2}{mouse})/10)-1:length(PC_values_SHOCK{2}{mouse})];
        for i=1:10
            X_shock{mouse}(i) = nanmedian(PC_values_SHOCK{1}{mouse}(U(i):U(i+1)));
            Y_shock{mouse}(i) = nanmedian(PC_values_SHOCK{2}{mouse}(U(i):U(i+1)));
        end
        Mean_Dist_X_shock(mouse) = X_shock{mouse}(10)-X_shock{mouse}(1);
        Mean_Dist_Y_shock(mouse) = Y_shock{mouse}(10)-Y_shock{mouse}(1);
    end
    
    try
        clear U
        U = [1:ceil(length(PC_values_SAFE{2}{mouse})/10)-1:length(PC_values_SAFE{2}{mouse})];
        for i=1:10
            X_safe{mouse}(i) = nanmedian(PC_values_SAFE{1}{mouse}(U(i):U(i+1)));
            Y_safe{mouse}(i) = nanmedian(PC_values_SAFE{2}{mouse}(U(i):U(i+1)));
        end
        Mean_Dist_X_safe(mouse) = X_safe{mouse}(10)-X_safe{mouse}(1);
        Mean_Dist_Y_safe(mouse) = Y_safe{mouse}(10)-Y_safe{mouse}(1);
    end
end
Mean_Dist_X_shock(Mean_Dist_X_shock==0) = NaN;
Mean_Dist_X_safe(Mean_Dist_X_safe==0) = NaN;
Mean_Dist_Y_shock(Mean_Dist_Y_shock==0) = NaN;
Mean_Dist_Y_safe(Mean_Dist_Y_safe==0) = NaN;


figure
subplot(121)
quiver(zeros(1,length(Mean_Dist_X_shock)),zeros(1,length(Mean_Dist_X_shock)),Mean_Dist_X_shock,Mean_Dist_Y_shock ,...
        'Color' , [1 .5 .5] , 'LineWidth' , 1 , 'MaxHeadSize', 1)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
xlim([-5 5]), ylim([-4 4]), xticks([-5:5]), yticks([-5:5])

subplot(122)
quiver(zeros(1,length(Mean_Dist_Y_safe)),zeros(1,length(Mean_Dist_Y_safe)),Mean_Dist_X_safe,Mean_Dist_Y_safe ,...
        'Color' , [.5 .5 1] , 'LineWidth' , 1 , 'MaxHeadSize', 1)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
xlim([-5 5]), ylim([-4 4]), xticks([-5:5]), yticks([-5:5])



figure
quiver(0,0,nanmean(Mean_Dist_X_safe),nanmean(Mean_Dist_Y_safe) ,...
    'Color' , [.5 .5 1] , 'LineWidth' , 5 , 'MaxHeadSize', 1), hold on
quiver(0,0,nanmean(Mean_Dist_X_shock),nanmean(Mean_Dist_Y_shock) ,...
    'Color' , [1 .5 .5] , 'LineWidth' , 5 , 'MaxHeadSize', 1)
plot(0,0,'.','Color',[.3 .3 .3],'MarkerSize',40)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
xlim([-1 1]), ylim([-1 1])


Cols={[1 .5 .5],[.5 .5 1]};
X = [1:2];
Legends = {'Shock','Safe'};


figure
MakeSpreadAndBoxPlot3_SB({abs(Mean_Dist_X_shock) abs(Mean_Dist_X_safe)},Cols,X,Legends,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB({abs(Mean_Dist_X_shock) abs(Mean_Dist_X_safe)},Cols,X,Legends,'showpoints',0,'paired',1);




%% SVM
SVMScores_Sk_Ctrl_interp(SVMScores_Sk_Ctrl_interp==0) = NaN;
SVMScores_Sf_Ctrl_interp(SVMScores_Sf_Ctrl_interp==0) = NaN;
SVMChoice_Sk_Ctrl_interp(nanmean(SVMChoice_Sf_Ctrl_interp')==0,:) = NaN;
SVMChoice_Sf_Ctrl_interp(nanmean(SVMChoice_Sf_Ctrl_interp')==0,:) = NaN;

x = linspace(0,1,100);
SVMScores_Sk_Ctrl_interp([12 31 40 49],:) = NaN;
SVMChoice_Sk_Ctrl_interp([12 31 40 49],:) = NaN;
SVMScores_Sf_Ctrl_interp([40],:) = NaN;
SVMChoice_Sf_Ctrl_interp([40],:) = NaN;


% M1189
figure
subplot(121)
plot(linspace(0,100,size(SVMScores_Sk_Ctrl_interp,2)) , SVMScores_Sk_Ctrl_interp(43,:) , 'Color' , [1 .5 .5])
hold on
plot(linspace(0,100,size(SVMScores_Sf_Ctrl_interp,2)) , SVMScores_Sf_Ctrl_interp(43,:) , 'Color' , [.5 .5 1])
xlabel('time (a.u.)'), ylabel('SVM score (a.u.)')
makepretty
hline(0,'--k')
ylim([-1.4 1.4])

subplot(122)
plot(linspace(0,100,size(SVMChoice_Sk_Ctrl_interp,2)) , 1-SVMChoice_Sk_Ctrl_interp(43,:) , 'Color' , [1 .5 .5])
hold on
plot(linspace(0,100,size(SVMChoice_Sf_Ctrl_interp,2)) , SVMChoice_Sf_Ctrl_interp(43,:) , 'Color' , [.5 .5 1])
xlabel('time (a.u.)'), ylabel('accuracy (a.u.)')
makepretty
ylim([-.05 1.05])


% all mice
figure
subplot(121)
Data_to_use = SVMScores_Sk_Ctrl_interp;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(x , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [1 .5 .5]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
a1 = runmean(nanmean(Data_to_use),10)-runmean(Conf_Inter,10);
Data_to_use = SVMScores_Sf_Ctrl_interp;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(x , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [.5 .5 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
a2 = runmean(nanmean(Data_to_use),10)+runmean(Conf_Inter,10);
patch([x fliplr(x)], [a1 fliplr(a2)], 'k' , 'FaceAlpha' , .5)

hline(0,'--k'), ylim([-.6 .6])
makepretty
xlabel('time (a.u.)'), ylabel('SVM score (a.u.)')
        

subplot(122)
Data_to_use = 1-SVMChoice_Sk_Ctrl_interp;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(x , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [1 .5 .5]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
Data_to_use = SVMChoice_Sf_Ctrl_interp;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(x , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [.5 .5 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
hline(.5,'--k')
makepretty
xlabel('time (a.u.)'), ylabel('accuracy (a.u.)'), ylim([0 1])

for mouse=1:length(Mouse)
    for i=1:10
        
        SVMChoice_Sk_Ctrl_interp2(mouse,i)  = nanmean(SVMChoice_Sk_Ctrl_interp(mouse,(i-1)*10+1:10*i));
        SVMScores_Sf_Ctrl_interp2(mouse,i)  = nanmean(SVMScores_Sf_Ctrl_interp(mouse,(i-1)*10+1:10*i));
        
    end
end


param=1; clear p
for i=1:100
    [~,p(i)] = ttest(SVMScores_Sk_Ctrl_interp(:,i)' , SVMScores_Sf_Ctrl_interp(:,i)');
end


figure
plot(p,'.-k','MarkerSize',20), hold on
hline(.05,'--k')
plot(find(p>.05) , p(p>.05),'.r','MarkerSize',20)
set(gca , 'Yscale','log')
makepretty
ylabel('pvalues')


figure
Data_to_use = SVMChoice_Sk_Ctrl_interp2-SVMScores_Sf_Ctrl_interp2;
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
b=bar(Mean_All_Sp); b.FaceColor=[.5 .5 .5]; hold on
errorbar([1:10],Mean_All_Sp,zeros(size(Conf_Inter)),Conf_Inter,'.','vertical','Color','k')
makepretty
xlabel('time (a.u.)'), ylabel('SVM score (a.u.)')
       
Cols = {[1 .5 .5],[.5 .5 1]};
X = 1:2;
Legends = {'Shock','Safe'};


figure
A = nanmean(SVMScores_Sk_Ctrl_interp(:,95:100)')-nanmean(SVMScores_Sk_Ctrl_interp(:,1:5)');
B = nanmean(SVMScores_Sf_Ctrl_interp(:,95:100)')-nanmean(SVMScores_Sf_Ctrl_interp(:,1:5)');
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0);
hline(0,'--k')


[h,p]=ttest(A,zeros(1,51))
[h,p]=ttest(B,zeros(1,51))




%% zoom on very first data
figure, param=1; bin=20;
Data_to_use = DATA_shock.(Params{param})(:,1:bin);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(x(1:bin) , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
col = [1 .5 .5]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
a1 = nanmean(Data_to_use)-Conf_Inter;
Data_to_use = DATA_safe.(Params{param})(:,1:bin);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(x(1:bin) , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
col = [.5 .5 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
a2 = nanmean(Data_to_use)+Conf_Inter;
patch([x(1:bin) fliplr(x(1:bin))], [a1 fliplr(a2)], 'k' , 'FaceAlpha' , .5)



Data_to_use = DATA_shock.(Params{param});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(x , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
    col = [1 .5 .5]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    if or(or(param==1 , param==2) ,  or(param==8 , param==4))
        a1 = runmean(nanmean(Data_to_use),10)-runmean(Conf_Inter,10);
    elseif or(param==6 , param==3)
        a1 = runmean(nanmean(Data_to_use),10)+runmean(Conf_Inter,10);
    end
    
    Data_to_use = DATA_safe.(Params{param});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(x , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
    col = [.5 .5 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    if or(or(param==1 , param==2) ,  or(param==8 , param==4))
        a2 = runmean(nanmean(Data_to_use),10)+runmean(Conf_Inter,10);
    elseif or(param==6 , param==3)
        a2 = runmean(nanmean(Data_to_use),10)-runmean(Conf_Inter,10);
    end
    
    if or(or(or(param==1 , param==2) ,  or(param==8 , param==4)) , or(param==6 , param==3))
        patch([x fliplr(x)], [a1 fliplr(a2)], 'k' , 'FaceAlpha' , .5)
    end
    makepretty
    xlabel('time (a.u.)')
   


figure
Data_to_use = SVMScores_Sk_Ctrl_interp(:,1:bin);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(x(1:bin) , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
col = [1 .5 .5]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
a1 = nanmean(Data_to_use)-Conf_Inter;
Data_to_use = SVMScores_Sf_Ctrl_interp(:,1:bin);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(x(1:bin) , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
col = [.5 .5 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
a2 = nanmean(Data_to_use)+Conf_Inter;
patch([x(1:bin) fliplr(x(1:bin))], [a1 fliplr(a2)], 'k' , 'FaceAlpha' , .5)

makepretty
xlabel('time (a.u.)'), ylabel('SVM score (a.u.)')




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              %   Time since Last shock
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edit OBFreq_TimeSinceLastStim_BM.m





%% Spectro evolution
clear all
GetAllSalineSessions_BM
Mouse=Drugs_Groups_UMaze_BM(22);
Session_type = {'Cond'};
load('B_Low_Spectrum.mat')

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
        Freeze.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
        Zone.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
        ShockZone.(Session_type{sess}).(Mouse_names{mouse}) = Zone.(Session_type{sess}).(Mouse_names{mouse}){1};
        SafeZone.(Session_type{sess}).(Mouse_names{mouse}) = or(Zone.(Session_type{sess}).(Mouse_names{mouse}){2} , Zone.(Session_type{sess}).(Mouse_names{mouse}){5});
        
        Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}) = and(Freeze.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
        Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}) = and(Freeze.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
        
    end
end



sess=2;
Fz_Shock = and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}));
Fz_Safe = and(Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
for ep=1:length(Start(Fz_Shock))
    clear D
    D = Data(Restrict(OBSpec.(Session_type{sess}).(Mouse_names{mouse}) , subset(Fz_Shock,ep)));
    for i=1:261
        OB_shock(ep,:,i) = interp1(linspace(0,1,size(D(:,i),1)) , D(:,i) , linspace(0,1,100));
    end
end
for ep=round(length(Start(Fz_Safe))*.8):length(Start(Fz_Safe))
    try
        clear D
        D = Data(Restrict(OBSpec.(Session_type{sess}).(Mouse_names{mouse}) , subset(Fz_Safe,ep)));
        for i=1:261
            OB_safe(ep,:,i) = interp1(linspace(0,1,size(D(:,i),1)) , D(:,i) , linspace(0,1,100));
        end
    end
end
OB_shock(OB_shock==0) = NaN;
OB_safe(OB_safe==0) = NaN;



