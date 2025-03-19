
%% create
clear all
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat','Mouse')
Var={'Respi','HeartRate','HeartVar','ob_gamma_freq','ob_gamma_power','ripples_denstiy','hpc_theta_freq','HPC_theta_delta',...
    'TailTemperature','emg_pect','accelero','speed','imdiff','all'};
Session_type = {'Cond'};
bin_size = 20;
% 5 = freezing shock, 6 = freezign safe

for sess=1:length(Session_type) 
    [OutPutData2.(Session_type{sess}) , Epoch.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',...
        Mouse,lower(Session_type{sess}),'speed','emg_pect','tailtemperature','accelero','imdiff','trackingnans');
end

clear Good
for mm = 1:size(OutPutData2.Cond.speed.tsd,1)
    OutPutData2.Cond.trackingnans.tsd{mm,1} = Restrict(OutPutData2.Cond.trackingnans.tsd{mm,1},ts(Range(OutPutData2.Cond.imdiff.tsd{mm,1})));
    OutPutData2.Cond.trackingnans.tsd{mm,1} = Restrict(OutPutData2.Cond.trackingnans.tsd{mm,1},ts(Range(OutPutData2.Cond.speed.tsd{mm,1})));

    OutPutData2.Cond.imdiff.tsd{mm,1} = Restrict(OutPutData2.Cond.imdiff.tsd{mm,1},ts(Range(OutPutData2.Cond.trackingnans.tsd{mm,1})));
    OutPutData2.Cond.imdiff.tsd{mm,1} = Restrict(OutPutData2.Cond.imdiff.tsd{mm,1},ts(Range(OutPutData2.Cond.speed.tsd{mm,1})));
    
    OutPutData2.Cond.speed.tsd{mm,1} = Restrict(OutPutData2.Cond.imdiff.tsd{mm,1},ts(Range(OutPutData2.Cond.trackingnans.tsd{mm,1})));
    OutPutData2.Cond.speed.tsd{mm,1} = Restrict(OutPutData2.Cond.imdiff.tsd{mm,1},ts(Range(OutPutData2.Cond.imdiff.tsd{mm,1})));


end

mergestructs = @(x,y) cell2struct([struct2cell(x);struct2cell(y)],[fieldnames(x);fieldnames(y)]);
OutPutData.Cond = mergestructs(OutPutData.Cond, OutPutData2.Cond);
cd /media/nas7/ProjetEmbReact/DataEmbReact/
save('/media/nas7/ProjetEmbReact/DataEmbReact/ROC_values_Cond_Eyelid_NaNOK.mat','OutPutData')

%% load
load('/media/nas7/ProjetEmbReact/DataEmbReact/ROC_values_Cond_Eyelid_NaNOK.mat')


%%
clear Y_axis_all
Var = fieldnames(OutPutData.Cond);
for var=1:length(Var)-1
    
    DATA = OutPutData.Cond.(Var{var}).tsd;
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        
        
        % Subsample to same number of bins
        D_shock = Data(DATA{mouse,5});
        if strcmp(Var{var},'imdiff') | strcmp(Var{var},'speed')
            NaNIn5 = Data(OutPutData.Cond.trackingnans.tsd{mouse,5});
            D_shock (find(NaNIn5)) = [];
        end
        D_safe = Data(DATA{mouse,6});
        if strcmp(Var{var},'imdiff') | strcmp(Var{var},'speed')
            NaNIn6= Data(OutPutData.Cond.trackingnans.tsd{mouse,6});
            D_safe (find(NaNIn6)) = [];
        end
        D_shock(randperm(length(D_shock))); D_safe(randperm(length(D_safe)));
        numclass = min([length(D_shock) length(D_safe)]);
        D_shock = D_shock(1:numclass); D_safe = D_safe(1:numclass);
        
        
        clear A B Side mdl scores
        try
            if strcmp(Var{var},'ob_gamma_power') % subsample Gamma power
                A = [D_shock ; D_safe];
                B = logical([ones(1,length(D_shock))' ; zeros(1,length(D_safe))']);
                A=A(1:100:end); B=B(1:100:end);
            elseif strcmp(Var{var},'emg_pect') % subsample EMG
                A = [D_shock ; D_safe];
                B = logical([ones(1,length(D_shock))' ; zeros(1,length(D_safe))']);
                A=A(1:10:end); B=B(1:10:end);
            else
                A = [D_shock ; D_safe];
                B = logical([ones(1,length(D_shock))' ; zeros(1,length(D_safe))']);
            end
            
            
            for i=1:sum(B==1)
                Side{i} = 'Shock';
            end
            for i=1:sum(B==0)
                Side{sum(B==1)+i} = 'Safe';
            end
            mdl = nhist(A,B,'Distribution','binomial','Link','reciprocal');
            Coeff.(Var{var})(mouse) = mdl.Coefficients.Estimate(2);
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
            a=title(['ROC curves, ' Var{var}]); a.FontSize=20;

    subplot(133)
    MakeSpreadAndBoxPlot4_SB({AUC.(Var{var})},{[.3 .3 .3]},[1],{''},'showpoints',1,'paired',0)
    hline(.5,'--k')
    if var==4; ylim([.4 1]); end
    ylabel('AUC (a.u.)')
    title(['ROC median = ' num2str(nanmedian(AUC.(Var{var})))])
    
end
for var=1:length(Var)-1
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
MakeSpreadAndBoxPlot3_SB(AUC_all,Cols,1:14,Var(1:end-1),'showpoints',1,'paired',0,'showsigstar','none');
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

%%
%%
Var = fieldnames(OutPutData.Cond);
for var=1:length(Var)-1
    figure
    DATA = OutPutData.Cond.(Var{var}).tsd;
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        
        
        % Subsample to same number of bins
        D_shock = Data(DATA{mouse,5});
        if strcmp(Var{var},'imdiff') | strcmp(Var{var},'speed')
            NaNIn5 = Data(OutPutData.Cond.trackingnans.tsd{mouse,5});
            D_shock (find(NaNIn5)) = [];
        end
        D_safe = Data(DATA{mouse,6});
        if strcmp(Var{var},'imdiff') | strcmp(Var{var},'speed')
            NaNIn6= Data(OutPutData.Cond.trackingnans.tsd{mouse,6});
            D_safe (find(NaNIn6)) = [];
        end
        D_shock(randperm(length(D_shock))); D_safe(randperm(length(D_safe)));
        numclass = min([length(D_shock) length(D_safe)]);
        D_shock = D_shock(1:numclass); D_safe = D_safe(1:numclass);
        
        subplot(6,5,mouse)
        nhist({D_shock,D_safe})
        title(Var{var})
    end
end