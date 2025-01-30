
%% create
clear all
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat')
Var={'Respi','HeartRate','HeartVar','ob_gamma_freq','ob_gamma_power','ripples_denstiy','hpc_theta_freq','HPC_theta_delta','TailTemperature','emg_pect','accelero','speed','all'};
Session_type = {'Cond'};
bin_size = 20;
% 5 = freezing shock, 6 = freezign safe

for sess=1:length(Session_type) 
    [OutPutData2.(Session_type{sess}) , Epoch.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'speed','emg_pect','tailtemperature','accelero','imdiff','trackingnans');
end

%% load
load('/media/nas7/ProjetEmbReact/DataEmbReact/ROC_values_Cond_Eyelid.mat')


%%
for var=1:length(Var)
    
    if var==1
        DATA = OutPutData.Cond.respi_freq_bm.tsd;
    elseif var==2
        DATA = OutPutData.Cond.heartrate.tsd;
    elseif var==3
        DATA = OutPutData.Cond.heartratevar.tsd;
    elseif var==4
        DATA = OutPutData.Cond.ob_gamma_freq.tsd;
    elseif var==5
        DATA = OutPutData.Cond.ob_gamma_power.tsd;
    elseif var==6
        DATA = OutPutData.Cond.ripples_density.tsd;
    elseif var==7
        DATA = OutPutData.Cond.hpc_theta_freq.tsd;
    elseif var==8
        DATA = OutPutData.Cond.hpc_theta_delta.tsd;
    elseif var==9
        DATA = OutPutData2.Cond.tailtemperature.tsd;
    elseif var==10
        DATA = OutPutData2.Cond.emg_pect.tsd;
    elseif var==11
        DATA = OutPutData2.Cond.accelero.tsd;
    elseif var==12
        DATA = OutPutData2.Cond.speed.tsd;
    end
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        D_shock = Data(DATA{mouse,5}); D_safe = Data(DATA{mouse,6});
        D_shock(randperm(length(D_shock))); D_safe(randperm(length(D_safe)));
        numclass = min([length(D_shock) length(D_safe)]);
        D_shock = D_shock(1:numclass); D_safe = D_safe(1:numclass);
        
        
        clear A B Side mdl scores
        try
            if or(var==5 , var==10) % subsampled EMG and Gamma power
                A = [D_shock ; D_safe];
                B = logical([ones(1,length(D_shock))' ; zeros(1,length(Data(DATA{mouse,6})))']);
                A=A(1:10:end); B=B(1:10:end);
            else
                A = [D_shock ; D_safe];
                B = logical([ones(1,length(D_shock))' ; zeros(1,length(D_safe))']);
            end
            
            if var<13
                A_all.(Mouse_names{mouse})(:,var) = interp1(linspace(0,1,length(A)) , A , linspace(0,1,1000));
                B_all.(Mouse_names{mouse}) = logical(interp1(linspace(0,1,length(B)) , double(B) , linspace(0,1,1000)));
                
                for i=1:sum(B==1)
                    Side{i} = 'Shock';
                end
                for i=1:sum(B==0)
                    Side{sum(B==1)+i} = 'Safe';
                end
                
                mdl = fitglm(A,B,'Distribution','binomial','Link','reciprocal');
                scores = mdl.Fitted.Probability;
                try
                    [X2.(Var{var}).(Mouse_names{mouse}),Y.(Var{var}).(Mouse_names{mouse}),T.(Var{var}).(Mouse_names{mouse}),...
                        AUC.(Var{var})(mouse)] = perfcurve(Side,scores,'Shock');
                catch
                    X2.(Var{var}).(Mouse_names{mouse})=NaN;
                    Y.(Var{var}).(Mouse_names{mouse})=NaN;
                    T.(Var{var}).(Mouse_names{mouse})=NaN;
                    AUC.(Var{var})(mouse)=NaN;
                end
            else
                for i=1:sum(B_all.(Mouse_names{mouse}))
                    Side{i} = 'Shock';
                end
                for i=sum(B_all.(Mouse_names{mouse})):length(B_all.(Mouse_names{mouse}))
                    Side{i} = 'Safe';
                end
                
                mdl = fitglm(A_all.(Mouse_names{mouse})(:,1:5),B_all.(Mouse_names{mouse}),'Distribution','binomial','Link','reciprocal');
                scores = mdl.Fitted.Probability;
                [X2.(Var{var}).(Mouse_names{mouse}),Y.(Var{var}).(Mouse_names{mouse}),T.(Var{var}).(Mouse_names{mouse}),AUC.(Var{var})(mouse)] = perfcurve(Side,scores,'Shock');
                
            end
        end
        
        try
            for bin=1:bin_size
                Y_axis_all.(Var{var})(mouse,bin) = nanmean(Y.(Var{var}).(Mouse_names{mouse})(and(X2.(Var{var}).(Mouse_names{mouse})>((bin-1)/bin_size) , X2.(Var{var}).(Mouse_names{mouse})<(bin/bin_size))));
            end
        catch
            Y_axis_all.(Var{var})(mouse,:) = NaN(1,bin_size);
        end
        disp(Mouse_names{mouse})
    end
    AUC.(Var{var})(AUC.(Var{var})==0)=NaN;
    
    %     if var==4; AUC.(Var{var})(37:end)=NaN; end
    Y_axis_all.(Var{var}) = [zeros(length(Mouse),1) Y_axis_all.(Var{var})];
    
    figure
    subplot(1,3,1:2)
    Data_to_use = Y_axis_all.(Var{var});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    h=shadedErrorBar(linspace(0,1,length(Mean_All_Sp)) , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
    line([0 1],[0 1],'LineStyle','--','Color','k')
    axis square
    xlabel('False positive'), ylabel('True positive')
    box off
    
    subplot(133)
    MakeSpreadAndBoxPlot4_SB({AUC.(Var{var})},{[.3 .3 .3]},[1],{''},'showpoints',1,'paired',0)
    hline(.5,'--k')
    if var==4; ylim([.4 1]); end
    ylabel('AUC (a.u.)')
    title(['ROC median = ' num2str(nanmedian(AUC.(Var{var})))])
    
    a=suptitle(['ROC curves, ' Var{var}]); a.FontSize=20;
end
AUC_all{9}(AUC_all{9}==.5)=NaN;

for var=1:length(Var)
    AUC_all{var} = AUC.(Var{var});
    if var<9
        Cols{var} = [.5 0 0] + rand(1,3)*.5;
    elseif and(var>8 , var<13)
        Cols{var} = [0 0 .5] + rand(1,3)*.5;
    else
        Cols{var} = [.3 .3 .3];
    end
end

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(AUC_all(1:8),Cols(1:8),1:8,Var(1:8),'showpoints',1,'paired',0);
hline(.5,'--k')
ylabel('AUC'), ylim([0 1.15]), makepretty_BM2

subplot(1,6,4:5)
MakeSpreadAndBoxPlot3_SB(AUC_all(9:12),Cols(9:12),1:4,Var(9:12),'showpoints',1,'paired',0);
hline(.5,'--k')
ylim([0 1.15]), makepretty_BM2

subplot(166)
MakeSpreadAndBoxPlot4_SB(AUC_all(13),Cols(13),1,Var(13),'showpoints',1,'paired',0);
hline(.5,'--k')
ylim([0 1.15]), makepretty_BM2








%% old
%% load data
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/ROC_curves.mat')
bin_size = 20;

%% generate data
clear all
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/MeanBodyValues_Fz.mat','OutPutData')
Mouse=Drugs_Groups_UMaze_BM(11);

Var={'Respi','HeartRate','HeartVar','TailTemperature','emg_pect','accelero','all'};
Session_type = {'Fear'};
bin_size = 20;

for var=1:length(Var)
    
    if var==1
        DATA = OutPutData.Fear.respi_freq_bm.tsd;
    elseif var==2
        DATA = OutPutData.Fear.heartrate.tsd;
    elseif var==3
        DATA = OutPutData.Fear.heartratevar.tsd;
    elseif var==4
        DATA = OutPutData.Fear.tailtemperature.tsd;
    elseif var==5
        DATA = OutPutData.Fear.emg_pect.tsd;
    elseif var==6
        DATA = OutPutData.Fear.accelero.tsd;
    end
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        clear A B Side mdl scores
        try
            if var==5 % subsampled EMG
                A = [D_shock ; D_safe];
                B = logical([ones(1,length(D_shock))' ; zeros(1,length(D_safe))']);
                A=A(1:10:end); B=B(1:10:end);
            else
                A = [D_shock ; D_safe];
                B = logical([ones(1,length(D_shock))' ; zeros(1,length(D_safe))']);
            end
            
            if var<7
                A_all.(Mouse_names{mouse})(:,var) = interp1(linspace(0,1,length(A)) , A , linspace(0,1,1000));
                B_all.(Mouse_names{mouse}) = logical(interp1(linspace(0,1,length(B)) , double(B) , linspace(0,1,1000)));
                
                for i=1:sum(B==1)
                    %                for i=1:length(DATA{mouse,5})

                    Side{i} = 'Shock';
                end
                for i=1:sum(B==0)
%                 for i=1:length(DATA{mouse,6})
                    Side{sum(B==1)+i} = 'Safe';
                end
                
                mdl = fitglm(A,B,'Distribution','binomial','Link','reciprocal');
                scores = mdl.Fitted.Probability;
                [X2.(Var{var}).(Mouse_names{mouse}),Y.(Var{var}).(Mouse_names{mouse}),T.(Var{var}).(Mouse_names{mouse}),AUC.(Var{var})(mouse)] = perfcurve(Side,scores,'Shock');
                
            else
                for i=1:sum(B_all.(Mouse_names{mouse}))
                    Side{i} = 'Shock';
                end
                for i=sum(B_all.(Mouse_names{mouse})):length(B_all.(Mouse_names{mouse}))
                    Side{i} = 'Safe';
                end
                
                mdl = fitglm(A_all.(Mouse_names{mouse})(:,1:5),B_all.(Mouse_names{mouse}),'Distribution','binomial','Link','reciprocal');
                scores = mdl.Fitted.Probability;
                [X2.(Var{var}).(Mouse_names{mouse}),Y.(Var{var}).(Mouse_names{mouse}),T.(Var{var}).(Mouse_names{mouse}),AUC.(Var{var})(mouse)] = perfcurve(Side,scores,'Shock');
                
            end
        end
        
        try
            for bin=1:bin_size
                Y_axis_all.(Var{var})(mouse,bin) = nanmean(Y.(Var{var}).(Mouse_names{mouse})(and(X2.(Var{var}).(Mouse_names{mouse})>((bin-1)/bin_size) , X2.(Var{var}).(Mouse_names{mouse})<(bin/bin_size))));
            end
        catch
            Y_axis_all.(Var{var})(mouse,:) = NaN(1,bin_size);
        end
        disp(Mouse_names{mouse})
    end
AUC.(Var{var})(AUC.(Var{var})==0)=NaN;
   
    if var==4; AUC.(Var{var})(37:end)=NaN; end
    Y_axis_all.(Var{var}) = [zeros(length(Mouse),1) Y_axis_all.(Var{var})];
    
    figure
    subplot(1,3,1:2)
    Data_to_use = Y_axis_all.(Var{var});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    h=shadedErrorBar(linspace(0,1,bin_size+1) , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
    line([0 1],[0 1],'LineStyle','--','Color','k')
    axis square
    xlabel('False positive'), ylabel('True positive')
    box off
    
    subplot(133)
    MakeSpreadAndBoxPlot4_SB({AUC.(Var{var})},{[.3 .3 .3]},[1],{''},'showpoints',1,'paired',0)
    hline(.5,'--k')
    if var==4; ylim([.4 1]); end
    ylabel('AUC (a.u.)')
    title(['ROC median = ' num2str(nanmedian(AUC.(Var{var})))])
    
    a=suptitle(['ROC curves, ' Var{var}]); a.FontSize=20;
end


%% figures
Cols = {[.36 .59 .31],[.83 .35 .35],[.59 .31 .31],[.31 .31 .59],[.49 .36 .67],[.51 .7 .69],[.91 .55 .01]};

figure
subplot(1,3,1:2)
for var=1:6
    Data_to_use = Y_axis_all.(Var{var});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    h=shadedErrorBar(linspace(0,1,bin_size+1) , Mean_All_Sp , Conf_Inter , '-k' ,1); hold on;
    h.mainLine.Color=Cols{var}; h.patch.FaceColor=Cols{var}; h.edge(1).Color=Cols{var}; h.edge(2).Color=Cols{var};
end
line([0 1],[0 1],'LineStyle','--','Color','k')
axis square
xlabel('False positive'), ylabel('True positive')
makepretty_BM
f=get(gca,'Children'); l=legend([f(18),f(14),f(10),f(6),f(2)],'Breathing','Heart rate','Heart rate variability','Tail temperature','EMG','Motion'); l.Box='off';
title('ROC curves')

subplot(133)
MakeSpreadAndBoxPlot3_SB({AUC.Respi AUC.HeartRate AUC.HeartVar AUC.TailTemperature AUC.EMG AUC.accelero}...
    ,Cols([1:6]),1:6,{'Breathing','Heart rate','Heart rate variability','Tail temperature','EMG','Motion'},'showpoints',1,'paired',0);
hline(.5,'--k')
ylabel('ROC value')
title('AUC')

a=suptitle('ROC analyses, somatic parameters'); a.FontSize=20;




%% Correlations with time spent in shock zone TestPost
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try
        ZoneEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(TestPostSess.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
        Time_TestPost(mouse) = sum(DurationEpoch(ZoneEpoch.(Mouse_names{mouse}){1}))/720e4;
    end
    disp(Mouse_names{mouse})
end


figure
for var=1:7
    subplot(1,7,var)
    PlotCorrelations_BM(AUC.(Var{var}) , Time_TestPost , 'method' , 'spearman')
end


figure
PlotCorrelations_BM(AUC.Respi , Time_TestPost , 'method' , 'spearman')
xlabel('AUC respi, Fear'), ylabel('Time in shock zone, Test Post')
axis square


%% All params
var=7;

figure
subplot(1,3,1:2)
Data_to_use = Y_axis_all.(Var{var});
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(0,1,bin_size+1) , Mean_All_Sp , Conf_Inter , '-k' ,1); hold on;
h.mainLine.Color=Cols{var}; h.patch.FaceColor=Cols{var}; h.edge(1).Color=Cols{var}; h.edge(2).Color=Cols{var};

line([0 1],[0 1],'LineStyle','--','Color','k')
axis square
xlabel('False positive'), ylabel('True positive')
makepretty_BM
title('ROC curves')

subplot(133)
MakeSpreadAndBoxPlot4_SB({AUC.all}...
    ,Cols(7),1,{'All somatic parameters'},'showpoints',1,'paired',0);
hline(.5,'--k')
ylabel('ROC value'), ylim([.3 1.25])
title('AUC')

a=suptitle('ROC analyses, somatic parameters'); a.FontSize=20;




figure
PlotCorrelations_BM(AUC.all , Time_TestPost , 'method' , 'spearman')
xlabel('AUC all physio params, Fear'), ylabel('Time in shock zone, Test Post')
axis square






