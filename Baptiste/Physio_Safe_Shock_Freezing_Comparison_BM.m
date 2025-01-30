



clear DATA_SAL
group=13; Mouse=Drugs_Groups_UMaze_BM(group);
figure, [~ , ~ , Freq_Max_Shock_SAL] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,:))); close
figure, [~ , ~ , Freq_Max_Safe_SAL] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,:))); close

ind_mouse=1:length(Mouse);

DATA_SAL(1,:) = [Freq_Max_Shock_SAL(ind_mouse) Freq_Max_Safe_SAL(ind_mouse)];

n=2;
for par=[2:6 8]
    DATA_SAL(n,:) = [OutPutData.(Drug_Group{group}).(Session_type{sess}).(Params{par}).mean(ind_mouse,5)' OutPutData.(Drug_Group{group}).(Session_type{sess}).(Params{par}).mean(ind_mouse,6)'];
    n=n+1;
end


ind=and(sum(isnan(DATA_SAL(:,1:length(Mouse(ind_mouse)))))==0 , sum(isnan(DATA_SAL(:,length(Mouse(ind_mouse))+1:length(Mouse(ind_mouse))*2)))==0);

[Mf , v1, v2 , eig1 , eig2] = Correlations_Matrices_Data_BM(zscore(DATA_SAL(:,[ind ind])')', Params([1:6 8])  , {''});


M_shock = zscore(DATA_SAL(:,[ind ind])')';
Params = Params([1:6 8]);

figure
subplot(141)
imagesc(corr(M_shock(v2,:)')), axis xy, axis square, colormap redblue,% caxis([-1 1])
xticks([1:8]), yticks([1:8]), xticklabels(Params(v2)), yticklabels(Params(v2)), xtickangle(45)
subplot(142)
imagesc(corr(M_shock(v2,1:length(M_shock)/2)')), axis xy, axis square, colormap redblue,% caxis([-1 1])
xticks([1:8]), yticks([1:8]), xticklabels(Params(v2)), yticklabels(Params(v2)), xtickangle(45)
subplot(143)
imagesc(corr(M_shock(v2,length(M_shock)/2:end)')), axis xy, axis square, colormap redblue,% caxis([-1 1])
xticks([1:8]), yticks([1:8]), xticklabels(Params(v2)), yticklabels(Params(v2)), xtickangle(45)

A1 = corr(M_shock(v2,1:length(M_shock)/2)');
A2 = corr(M_shock(v2,length(M_shock)/2:end)');

subplot(144)
imagesc(A2-A1), axis xy, axis square, colormap redblue,% caxis([-1 1])
xticks([1:8]), yticks([1:8]), xticklabels(Params(v2)), yticklabels(Params(v2)), xtickangle(45)






