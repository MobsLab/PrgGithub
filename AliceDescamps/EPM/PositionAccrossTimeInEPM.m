Dir_EPM_1 = PathForExperiments_EPM_MC('EPM_ctrl');
% Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_10h_behav_dreadd_exci_CRH_VLPO_saline');
% Dir_EPM_3 = PathForExperiments_EPM_MC('EPM_behav_dreadd_exci_CRH_VLPO_cno');

% Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_10h_behav_dreadd_exci_CRH_VLPO_saline');
% Dir_EPM_3 = PathForExperiments_EPM_MC('EPM_10h_behav_dreadd_exci_CRH_VLPO_cno');

Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_10h_behav_dreadd_exci_CRH_VLPO_saline');
Dir_EPM_3 = PathForExperiments_EPM_MC('EPM_10h_behav_dreadd_exci_CRH_VLPO_cno');

%%
figure, title('Control');
for i = 1:length(Dir_EPM_1.path)
    cd(Dir_EPM_1.path{i}{1})
    load ('behavResources.mat')
    subplot (4,3,i),ylim([-2 2]);
    AbsXtsd = abs(AlignedXtsd);
    AbsYtsd = abs(AlignedYtsd);
    hold on, plot (Range(Restrict(AbsYtsd,ZoneEpoch{1})),-Data(Restrict(AbsYtsd,ZoneEpoch{1})),'r.');
    hold on, plot (Range(Restrict(AbsXtsd,ZoneEpoch{2})),Data(Restrict(AbsXtsd,ZoneEpoch{2})),'b.');
end

figure, suptitle('Saline exci CRH');
for j = 1:length(Dir_EPM_2.path)
    cd(Dir_EPM_2.path{j}{1})
    load ('behavResources.mat')
    subplot (2,2,j),ylim([-2 2]);
    AbsXtsd = abs(AlignedXtsd);
    AbsYtsd = abs(AlignedYtsd);
    hold on, plot (Range(Restrict(AbsYtsd,ZoneEpoch{1})),-Data(Restrict(AbsYtsd,ZoneEpoch{1})),'r.');
    hold on, plot (Range(Restrict(AbsXtsd,ZoneEpoch{2})),Data(Restrict(AbsXtsd,ZoneEpoch{2})),'b.');
end

figure, suptitle('CNO exci CRH');
for k = 1:length(Dir_EPM_3.path)
    cd(Dir_EPM_3.path{k}{1})
    load ('behavResources.mat')
    subplot (2,2,k),ylim([-2 2]);
    AbsXtsd = abs(AlignedXtsd);
    AbsYtsd = abs(AlignedYtsd);
    hold on, plot (Range(Restrict(AbsYtsd,ZoneEpoch{1})),-Data(Restrict(AbsYtsd,ZoneEpoch{1})),'r.');
    hold on, plot (Range(Restrict(AbsXtsd,ZoneEpoch{2})),Data(Restrict(AbsXtsd,ZoneEpoch{2})),'b.');
end