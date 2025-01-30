




Mouse=[666 668 688 739 777 779 849 893];
[OutPutData , Epoch , NameEpoch , OutPutTSD] = MeanValuesPhysiologicalParameters_BM(Mouse,'fear','phase_pref');


for mouse=1:length(Mouse)
    PhasePref_Shock(mouse,:,:) = OutPutData.phase_pref.PhasePref{mouse, 5}'./max(max(OutPutData.phase_pref.PhasePref{mouse, 5}(:,5:32)));
    PhasePref_Safe(mouse,:,:) = OutPutData.phase_pref.PhasePref{mouse, 6}'./max(max(OutPutData.phase_pref.PhasePref{mouse, 6}(:,5:32)));
end

PhasePref_Shock_Averaged = squeeze(nanmean(PhasePref_Shock));
PhasePref_Safe_Averaged = squeeze(nanmean(PhasePref_Safe));

for mouse=1:length(Mouse)
    Norm_Values_OB_Gamma(mouse,1) = max(max(OutPutData.phase_pref.PhasePref{mouse, 5}(:,5:32)));
    Norm_Values_OB_Gamma(mouse,2) = max(max(OutPutData.phase_pref.PhasePref{mouse, 6}(:,5:32)));
end

%% Figures

figure
MakeSpreadAndBoxPlot2_SB(Norm_Values_OB_Gamma , {[1, 0.5, 0.5],[0.5 0.5 1]},[1,2], {'Shock side freezing','Safe side freezing'},'showpoints',0,'paired',1); 

figure
for mouse=1:length(Mouse)
    subplot(2,8,mouse)
    plot(squeeze(PhasePref_Shock(mouse,:,:)))
    ylim([0 1.3])
    subplot(2,8,mouse+8)
    plot(squeeze(PhasePref_Safe(mouse,:,:)))
    ylim([0 1.3])
end

figure
subplot(121)
plot(PhasePref_Shock_Averaged); ylim([0 1.3])
subplot(122)
plot(PhasePref_Safe_Averaged); ylim([0 1.3])

figure
for mouse=1:length(Mouse)
    subplot(2,8,mouse)
    imagesc(OutPutData.phase_pref.BinnedPhase , OutPutData.phase_pref.Frequency , squeeze(PhasePref_Shock(mouse,:,:))); axis xy; caxis([0 0.7])
    subplot(2,8,mouse+8)
    imagesc(OutPutData.phase_pref.BinnedPhase , OutPutData.phase_pref.Frequency , squeeze(PhasePref_Safe(mouse,:,:))); axis xy; caxis([0 0.9])
end

figure
subplot(121)
imagesc(OutPutData.phase_pref.BinnedPhase , OutPutData.phase_pref.Frequency , PhasePref_Shock_Averaged); axis xy; caxis([0 0.7])
subplot(122)
imagesc(OutPutData.phase_pref.BinnedPhase , OutPutData.phase_pref.Frequency , PhasePref_Safe_Averaged); axis xy; caxis([0 0.9])


figure
subplot(121)
contourf(OutPutData.phase_pref.BinnedPhase , OutPutData.phase_pref.Frequency , PhasePref_Shock_Averaged,'linestyle','none'); axis xy; 
subplot(122)
contourf(OutPutData.phase_pref.BinnedPhase , OutPutData.phase_pref.Frequency , PhasePref_Safe_Averaged,'linestyle','none'); axis xy; 



subplot(133), contourf(VBinnedPhase,f,P','linestyle','none'), axis xy







