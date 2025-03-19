


Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All.(Drug_Group{Group(1)})ine','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};
Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_delta','linearposition'};
% Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_ratio','ripples_density','hpc_theta_freq','hpc_theta_delta','linearposition'};
Group=[13 15];
Session_type={'Cond'};

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
            'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_delta','linearposition');
    end
end
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        [OutPutData2.(Drug_Group{group}).(Session_type{sess}) , ~ , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
            'ob_low');
    end
end


load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/DATA.(Drug_Group{Group(2)})_Physio.mat')

%%
clear DATA
group=Group(1); Mouse=Drugs_Groups_UMaze_BM(group);
figure, [~ , ~ , Freq_Max_Shock.(Drug_Group{Group(1)})] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,:))); close
figure, [~ , ~ , Freq_Max_Safe.(Drug_Group{Group(1)})] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,:))); close

ind_mouse=1:length(Mouse);

DATA.(Drug_Group{Group(1)})(1,:) = [Freq_Max_Shock.(Drug_Group{Group(1)})(ind_mouse) Freq_Max_Safe.(Drug_Group{Group(1)})(ind_mouse)];

n=2;
for par=[2:8]
    DATA.(Drug_Group{Group(1)})(n,:) = [OutPutData.(Drug_Group{group}).(Session_type{sess}).(Params{par}).mean(ind_mouse,5)' OutPutData.(Drug_Group{group}).(Session_type{sess}).(Params{par}).mean(ind_mouse,6)'];
    n=n+1;
end


ind=and(sum(isnan(DATA.(Drug_Group{Group(1)})(:,1:length(Mouse(ind_mouse)))))==0 , sum(isnan(DATA.(Drug_Group{Group(1)})(:,length(Mouse(ind_mouse))+1:length(Mouse(ind_mouse))*2)))==0);

[Mf , v1, v2 , eig1 , eig2] = Correlations_Matrices_Data_BM(zscore(DATA.(Drug_Group{Group(1)})(:,[ind ind])')', Params([1:8])  , {''});


[z,mu,sigma] = zscore(DATA.(Drug_Group{Group(1)})(:,[ind ind])');
[Data_corr,~] = corr(z,'type','pearson');
figure, [~, ~, eigen_vector, ~, ~, ~] = pca(Data_corr, 'normalized' , 99); close

z2 = (DATA.(Drug_Group{Group(1)})'-mu)./sigma;
% [z2,mu2,sigma2] = zscore_nan_BM(DATA2');


for pc=1:size(eigen_vector,2)
    for mouse=1:round(size(z2,1)/2)
        try
            PC_values_shock.(Drug_Group{Group(1)}){pc}(mouse) = eigen_vector(~isnan(z2(mouse,:)),pc)'*z2(mouse,~isnan(z2(mouse,:)))';
            PC_values_safe.(Drug_Group{Group(1)}){pc}(mouse) = eigen_vector(~isnan(z2(mouse+round(size(z2,1)/2),:)),pc)'*z2(mouse+round(size(z2,1)/2),~isnan(z2(mouse+round(size(z2,1)/2),:)))';
            PC_values_shock.(Drug_Group{Group(1)}){pc}(PC_values_shock.(Drug_Group{Group(1)}){pc}==0)=NaN; PC_values_safe.(Drug_Group{Group(1)}){pc}(PC_values_safe.(Drug_Group{Group(1)}){pc}==0)=NaN;
        end
    end
end


figure
Make_PCA_Plot_BM(PC_values_shock.(Drug_Group{Group(1)}){1} , PC_values_shock.(Drug_Group{Group(1)}){2} , 'color' , [1 .5 .5]), hold on
Make_PCA_Plot_BM(PC_values_safe.(Drug_Group{Group(1)}){1} , PC_values_safe.(Drug_Group{Group(1)}){2} , 'color' , [.5 .5 1])



%% DZP
clear DATA
group=Group(2); Mouse=Drugs_Groups_UMaze_BM(group);
figure, [~ , ~ , Freq_Max_Shock.(Drug_Group{Group(2)})] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,:))); close
figure, [~ , ~ , Freq_Max_Safe.(Drug_Group{Group(2)})] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,:))); close


ind_mouse=1:length(Mouse);

DATA.(Drug_Group{Group(2)})(1,:) = [Freq_Max_Shock.(Drug_Group{Group(2)})(ind_mouse) Freq_Max_Safe.(Drug_Group{Group(2)})(ind_mouse)];

n=2;
for par=[2:8]
    DATA.(Drug_Group{Group(2)})(n,:) = [OutPutData.(Drug_Group{group}).(Session_type{sess}).(Params{par}).mean(ind_mouse,5)' OutPutData.(Drug_Group{group}).(Session_type{sess}).(Params{par}).mean(ind_mouse,6)'];
    n=n+1;
end

ind=and(sum(isnan(DATA.(Drug_Group{Group(2)})(:,1:length(Mouse(ind_mouse)))))==0 , sum(isnan(DATA.(Drug_Group{Group(2)})(:,length(Mouse(ind_mouse))+1:length(Mouse(ind_mouse))*2)))==0);
[Mf , v1, v2 , eig1 , eig2] = Correlations_Matrices_Data_BM(zscore(DATA.(Drug_Group{Group(2)})(:,[ind ind])')', Params([1:8])  , {''});

z_drug = (DATA.(Drug_Group{Group(2)})'-mu)./sigma;


for pc=1:size(eigen_vector,2)
    for mouse=1:round(size(z_drug,1)/2)
        try
            PC_values_shock.(Drug_Group{Group(2)}){pc}(mouse) = eigen_vector(~isnan(z_drug(mouse,:)),pc)'*z_drug(mouse,~isnan(z_drug(mouse,:)))';
            PC_values_safe.(Drug_Group{Group(2)}){pc}(mouse) = eigen_vector(~isnan(z_drug(mouse+round(size(z_drug,1)/2),:)),pc)'*z_drug(mouse+round(size(z_drug,1)/2),~isnan(z_drug(mouse+round(size(z_drug,1)/2),:)))';
            PC_values_shock.(Drug_Group{Group(2)}){pc}(PC_values_shock.(Drug_Group{Group(2)}){pc}==0)=NaN; PC_values_safe.(Drug_Group{Group(2)}){pc}(PC_values_safe.(Drug_Group{Group(2)}){pc}==0)=NaN;
        end
    end
end



Make_PCA_Plot_BM(PC_values_shock.(Drug_Group{Group(2)}){1} , PC_values_shock.(Drug_Group{Group(2)}){2} , 'color' , [.7 .3 .3]), hold on
Make_PCA_Plot_BM(PC_values_safe.(Drug_Group{Group(2)}){1} , PC_values_safe.(Drug_Group{Group(2)}){2} , 'color' , [.3 .3 .7])
xlabel('PC1 values'), ylabel('PC2 values')














