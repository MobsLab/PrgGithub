
%% create
clear all
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat','Mouse')
Var={'Respi','HeartRate','HeartVar','ob_gamma_freq','ob_gamma_power','ripples_denstiy','hpc_theta_freq','HPC_theta_delta',...
    'TailTemperature','emg_pect','accelero','speed','imdiff','all'};
Session_type = {'Cond'};
bin_size = 20;
% 5 = freezing shock, 6 = freezign safe

% for sess=1:length(Session_type)
%     [OutPutData2.(Session_type{sess}) , Epoch.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',...
%         Mouse,lower(Session_type{sess}),'speed','emg_pect','tailtemperature','accelero','imdiff','trackingnans');
% end
%
% clear Good
% for mm = 1:size(OutPutData2.Cond.speed.tsd,1)
%     OutPutData2.Cond.trackingnans.tsd{mm,1} = Restrict(OutPutData2.Cond.trackingnans.tsd{mm,1},ts(Range(OutPutData2.Cond.imdiff.tsd{mm,1})));
%     OutPutData2.Cond.trackingnans.tsd{mm,1} = Restrict(OutPutData2.Cond.trackingnans.tsd{mm,1},ts(Range(OutPutData2.Cond.speed.tsd{mm,1})));
%
%     OutPutData2.Cond.imdiff.tsd{mm,1} = Restrict(OutPutData2.Cond.imdiff.tsd{mm,1},ts(Range(OutPutData2.Cond.trackingnans.tsd{mm,1})));
%     OutPutData2.Cond.imdiff.tsd{mm,1} = Restrict(OutPutData2.Cond.imdiff.tsd{mm,1},ts(Range(OutPutData2.Cond.speed.tsd{mm,1})));
%
%     OutPutData2.Cond.speed.tsd{mm,1} = Restrict(OutPutData2.Cond.imdiff.tsd{mm,1},ts(Range(OutPutData2.Cond.trackingnans.tsd{mm,1})));
%     OutPutData2.Cond.speed.tsd{mm,1} = Restrict(OutPutData2.Cond.imdiff.tsd{mm,1},ts(Range(OutPutData2.Cond.imdiff.tsd{mm,1})));
%
% end
%
% mergestructs = @(x,y) cell2struct([struct2cell(x);struct2cell(y)],[fieldnames(x);fieldnames(y)]);
% OutPutData.Cond = mergestructs(OutPutData.Cond, OutPutData2.Cond);
% cd /media/nas7/ProjetEmbReact/DataEmbReact/
% save('/media/nas7/ProjetEmbReact/DataEmbReact/ROC_values_Cond_Eyelid_NaNOK.mat','OutPutData')

%% load
load('/media/nas7/ProjetEmbReact/DataEmbReact/ROC_values_Cond_Eyelid_NaNOK.mat')

% Add neck muscle EMG
Mouse_emg = Drugs_Groups_UMaze_BM(23);
[OutPutData_temp, ~, ~] = ...
    MeanValuesPhysiologicalParameters_BM('all_saline',Mouse_emg,lower('Cond'),'emg_neck');

OutPutData.Cond.emg_neck = OutPutData_temp.emg_neck;
OutPutData.Cond.emg_neck.tsd = OutPutData.Cond.emg_neck.tsd(38:end,:);
Var = fieldnames(OutPutData.Cond);
Var = Var([1:14,16,15])
% OutPutData.Cond = rmfield(OutPutData.Cond,'linearposition');
%% resample to same size bins
binsize = 2; % 1s
for var=1:length(Var)
    for mouse=1:length(Mouse)
        
        if not(isempty(Range(OutPutData.Cond.(Var{var}).tsd{mouse,1})))
            binsize_orig = median(diff(Range(OutPutData.Cond.(Var{var}).tsd{mouse,1},'s')));
            
            for zone = 5:6
                dat = Data(OutPutData.Cond.(Var{var}).tsd{mouse,zone});
                rg = Range(OutPutData.Cond.(Var{var}).tsd{mouse,zone});
                
                if strcmp(Var{var},'imdiff') | strcmp(Var{var},'speed')
                    NaNIn = Data(OutPutData.Cond.trackingnans.tsd{mouse,zone});
                    dat (find(NaNIn)) = [];
                    rg (find(NaNIn)) = [];
                end
                dat = movmean(dat,ceil(binsize/binsize_orig));
                dat = dat(1:ceil(binsize/binsize_orig):end);
                rg = rg(1:ceil(binsize/binsize_orig):end);
                OutPutDataNew.Cond.(Var{var}).tsd{mouse,zone} = tsd(rg,dat);
            end
        else
            OutPutDataNew.Cond.(Var{var}).tsd{mouse,zone} = OutPutData.Cond.(Var{var}).tsd{mouse,zone};
        end
    end
end

%%
clear Y X2
for var=1:length(Var)-1
    
    DATA = OutPutDataNew.Cond.(Var{var}).tsd;
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        if not(isempty((DATA{mouse,5}))) & not(isempty((DATA{mouse,6})))
            
            if not(isempty(Data(DATA{mouse,5}))) & not(isempty(Data(DATA{mouse,6})))
                % Subsample to same number of bins
                D_shock = Data(DATA{mouse,5});
                
                D_safe = Data(DATA{mouse,6});
                D_safe = D_safe(end/2:end);
                
                D_shock(randperm(length(D_shock))); D_safe(randperm(length(D_safe)));
                numclass = min([length(D_shock) length(D_safe)]);
                D_shock = D_shock(1:numclass); D_safe = D_safe(1:numclass);
                
                
                clear A B
                
                
                A = [D_shock ; D_safe];
                B = logical([ones(1,length(D_shock))' ; zeros(1,length(D_safe))']);
                
                
                
                %         [Roc_NoTransform,X1,Y1] = SimpleROCanalysis(A,B);
                [AUC.(Var{var})(mouse),X2.(Var{var})(mouse,:),Y.(Var{var})(mouse,:)] = SimpleROCanalysis(A,B);
                
                
            else
                AUC.(Var{var})(mouse) = NaN;
                X2.(Var{var})(mouse,:)= nan(1,20);
                Y.(Var{var})(mouse,:) = nan(1,20);
            end
            
        else
            AUC.(Var{var})(mouse) = NaN;
            X2.(Var{var})(mouse,:)= nan(1,20);
            Y.(Var{var})(mouse,:) = nan(1,20);
        end
        
    end
    AUC.(Var{var})(AUC.(Var{var})==0)=NaN;
    AUC.(Var{var})(AUC.(Var{var})==0.5)=NaN;
    
    
    %     if var==4; AUC.(Var{var})(37:end)=NaN; end
    
    figure
    subplot(1,3,1:2)
    Data_to_use = Y.(Var{var});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    h=shadedErrorBar(nanmean(X2.(Var{var})), nanmean(Y.(Var{var})), Conf_Inter ,'-k',1); hold on;
    line([0 1],[0 1],'LineStyle','--','Color','k')
    axis square
    xlabel('False positive'), ylabel('True positive')
    box off
    a=title(['ROC curves, ' Var{var}]); a.FontSize=20;
    
    subplot(133)
    MakeSpreadAndBoxPlot4_SB({AUC.(Var{var})},{[.3 .3 .3]},[1],{''},'showpoints',1,'paired',0)
    hline(.5,'--k')
    if var==4; ylim([0 1]); end
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

%% Flip the AUC depending on mean diff
for var  = 1:length(Var)-1
    if nanmean(AUC_all{var})<0.5
        AUC_all{var} = 1-AUC_all{var};
    end
end
Cols{1} = [.5 0 0] ;
Cols{2} = [.5 0 0] ;
Cols{3} = [.5 0 0] ;
Cols{4} = [.5 0 0] ;
Cols{5} = [0 0 0.5] ;
Cols{6} = [0 0 0.5] ;
Cols{7} = [0 0 0.5] ;
Cols{8} = [0 0.5 0] ;
Cols{9} = [0 0.5 0] ;
Cols{10} = [0 0.5 0] ;
Cols{11} = [0 0.5 0] ;
%     figure
clf
Order = [1,2,3,11,6,8,4,10,13,14,15];
X = [1 2 3 4 6 7 8 10 11 12 13];
MakeSpreadAndBoxPlot3_SB(AUC_all(Order),Cols,X,Var(Order),'showpoints',1,'paired',0,'showsigstar','none');
hline(.5,'--k')
ylabel('AUC'), ylim([0 1.15]), makepretty_BM2
for v = 1:length(Order)
    [p,h,stats] = signrank(AUC_all{Order(v)},0.5);
    p
    stats
    sigstar({[X(v),X(v)+0.01]},p)
end

