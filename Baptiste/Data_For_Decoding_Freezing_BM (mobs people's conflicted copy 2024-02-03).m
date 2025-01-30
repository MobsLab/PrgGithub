

%% Generate all physio-brain params that indicate shock/safe
clear all
GetAllSalineSessions_BM
GetEmbReactMiceFolderList_BM
Group=2; %saline 11m chr fluo =2

Mouse=Drugs_Groups_UMaze_BM(Group);
Session_type={'Cond'};
for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
        'respi_freq_bm','heartrate','heartratevar','tailtemperature','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition');
end

clearvars -except OutPutData Epoch1 NameEpoch CondSess FearSess Session_type Group 

Mouse=Drugs_Groups_UMaze_BM(Group);
Params={'respi_freq_bm','heartrate','heartratevar','tailtemperature','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition'};

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
%         try
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            i=1;
            clear ep ind_to_use
            
            for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse, 3}))
                
                % for full 1s bin
                for bin=1:ceil(((DurationEpoch(subset(Epoch1.(Session_type{sess}){mouse, 3},ep)))/1e4))-1 % bin of 2s or less
                    
                    % define bin
                    SmallEpoch = intervalSet(Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))+(bin-1)*1e4 , Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))+(bin)*1e4);
                    
                    % param in this bin
                    for par=1:length(Params)
                        DATA.(Session_type{sess}).(Mouse_names{mouse})(par,i) = nanmedian(Data(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , SmallEpoch)));
                    end
                    
                    i=i+1;
                end
                
                
                % for what's left in the episode, <1s of freezing epoch
                ind_to_use = ceil(((DurationEpoch(subset(Epoch1.(Session_type{sess}){mouse, 3},ep)))/1e4))-1; % se(Session_type{sess}) to last freezing episode indice
                SmallEpoch = intervalSet(Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))+(ind_to_use)*1e4 , Stop(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))); % last small epoch is a bin with time < 2s
                for par=1:length(Params)
                    DATA.(Session_type{sess}).(Mouse_names{mouse})(par,i) = nanmedian(Data(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , SmallEpoch)));
                end
                
                i=i+1;
            end
            
            disp(Mouse_names{mouse})
%         end
    end
end


for mouse=1:length(Mouse)
    ind = ~(sum(isnan(DATA.Cond.(Mouse_names{mouse})'))==size(DATA.Cond.(Mouse_names{mouse}),2));
    M_pre=DATA.Cond.(Mouse_names{mouse})(ind,:); % remove if not the parameter
    M_pre2=M_pre(:,sum(~isnan(M_pre))==sum(ind)); % remove if missing data for this second
    M=corr(zscore(M_pre2')');
    subplot(6,8,mouse)
    imagesc(M)
    axis square
    colorbar
end
colormap redblue

figure
for mouse=1:48
    ind = ~(sum(or(isnan(DATA.Cond.(Mouse_names{mouse})') , DATA.Cond.(Mouse_names{mouse})'==0))==size(DATA.Cond.(Mouse_names{mouse}),2));
    M_pre=DATA.Cond.(Mouse_names{mouse})(ind,:); % remove if not the parameter
    M_pre2=M_pre(:,sum(~isnan(M_pre))==sum(ind)); % remove if missing data for this second
    M=corr(M_pre2');
    subplot(6,8,mouse)
    imagesc(M)
    axis square
    caxis([-1 1])
    yticks([1:sum(ind)]), yticklabels(Params(ind))
end
colormap redblue, colorbar


% sort by position
figure
for mouse=1:48
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    [i,j] = sort(DATA.Cond.(Mouse_names{mouse})(10,:));
    M_pre_pre = DATA.Cond.(Mouse_names{mouse})(:,j);
    ind = ~(sum(isnan(M_pre_pre'))==size(M_pre_pre,2));
    M_pre = M_pre_pre(ind,:); % remove if not the parameter
    M_pre2 = M_pre(:,sum(~isnan(M_pre))==sum(ind)); % remove if missing data for this second
    
    M=corr(zscore(M_pre2')');
    subplot(6,8,mouse)
    imagesc(M)
    axis square
    colorbar
end
colormap redblue, colorbar


% put a log on ob gamma
for mouse=1:length(Mouse)
    DATA2.Cond.(Mouse_names{mouse}) = [DATA.Cond.(Mouse_names{mouse})(1:4,:) ; log10(DATA.Cond.(Mouse_names{mouse})(5:6,:)) ; DATA.Cond.(Mouse_names{mouse})(7:10,:)];
end

DATA_all.Cond=[];
for mouse=1:length(Mouse)
    DATA_all.Cond = [DATA_all.Cond DATA2.Cond.(Mouse_names{mouse})];
end
[i,j] = sort(DATA_all.Cond(10,:));
DATA_all.Cond=DATA_all.Cond(:,j);


figure
imagesc(corr(DATA_all.Cond'))
  ind = ~(sum(isnan(DATA_all.Cond))==size(DATA_all.Cond,1));
    M_pre = M_pre_pre(ind,:); % remove if not the parameter
    



pca(DATA_all.Cond)


for mouse=1:length(Mouse)
    ind = ~(sum(isnan(DATA.Cond.(Mouse_names{mouse})'))==size(DATA.Cond.(Mouse_names{mouse}),2));
    M_pre=DATA.Cond.(Mouse_names{mouse})(ind,:); % remove if not the parameter
    M_pre2=M_pre(:,sum(~isnan(M_pre))==sum(ind)); % remove if missing data for this second
    [rlvm, frvals, frvecs, trnsfrmd, mn, dv] = pca(M_pre2','Rows','pairwise');
end












