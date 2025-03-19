
Dir{1}=PathForExperiments_DREADD_MC('1Inj2mg_Nacl');
Dir{2}=PathForExperiments_DREADD_MC('1Inj2mg_CNO');
%%
Dir{1} = PathForExperiments_DREADD_MC('OneInject_Nacl');
Dir{2} = PathForExperiments_DREADD_MC('OneInject_CNO');

percN1_sal_half1=[];
percN2_sal_half1=[];
percN3_sal_half1=[];
percREM_sal_half1=[];
percWake_sal_half1=[];
percN1_sal_half2=[];
percN2_sal_half2=[];
percN3_sal_half2=[];
percREM_sal_half2=[];
percWake_sal_half2=[];
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    [ResN1_half1,ResN2_half1,ResN3_half1,ResREM_half1,ResWake_half1,ResN1_half2,ResN2_half2,ResN3_half2,ResREM_half2,ResWake_half2] = CRHGetSubStagesPerc_MC;
    percN1_sal_half1=[percN1_sal_half1,ResN1_half1];
    percN2_sal_half1=[percN2_sal_half1,ResN2_half1];
    percN3_sal_half1=[percN3_sal_half1,ResN3_half1];
    percREM_sal_half1=[percREM_sal_half1,ResREM_half1];
    percWake_sal_half1=[percWake_sal_half1,ResWake_half1];
    
    percN1_sal_half2=[percN1_sal_half2,ResN1_half2];
    percN2_sal_half2=[percN2_sal_half2,ResN2_half2];
    percN3_sal_half2=[percN3_sal_half2,ResN3_half2];
    percREM_sal_half2=[percREM_sal_half2,ResREM_half2];
    percWake_sal_half2=[percWake_sal_half2,ResWake_half2];
end

percN1_CNO_hafl1=[];
percN2_CNO_half1=[];
percN3_CNO_half1=[];
percREM_CNO_half1=[];
percWake_CNO_half1=[];
percN1_CNO_hafl2=[];
percN2_CNO_half2=[];
percN3_CNO_half2=[];
percREM_CNO_half2=[];
percWake_CNO_half2=[];
for j=1:length(Dir{2}.path)
    cd(Dir{2}.path{j}{1});
    [ResN1_half1,ResN2_half1,ResN3_half1,ResREM_half1,ResWake_half1,ResN1_half2,ResN2_half2,ResN3_half2,ResREM_half2,ResWake_half2] = CRHGetSubStagesPerc_MC;
    percN1_CNO_hafl1=[percN1_CNO_hafl1,ResN1_half1];
    percN2_CNO_half1=[percN2_CNO_half1,ResN2_half1];
    percN3_CNO_half1=[percN3_CNO_half1,ResN3_half1];
    percREM_CNO_half1=[percREM_CNO_half1,ResREM_half1];
    percWake_CNO_half1=[percWake_CNO_half1,ResWake_half1];
    
    percN1_CNO_hafl2=[percN1_CNO_hafl2,ResN1_half2];
    percN2_CNO_half2=[percN2_CNO_half2,ResN2_half2];
    percN3_CNO_half2=[percN3_CNO_half2,ResN3_half2];
    percREM_CNO_half2=[percREM_CNO_half2,ResREM_half2];
    percWake_CNO_half2=[percWake_CNO_half2,ResWake_half2];
end

%%    
figure,subplot(121),PlotBarCRH_MC(percN1_sal_half1,percN1_CNO_hafl1,percN2_sal_half1,percN2_CNO_half1,percN3_sal_half1,percN3_CNO_half1,percREM_sal_half1,percREM_CNO_half1,percWake_sal_half1,percWake_CNO_half1,1)
xticks([1 2 3 4 5])
xticklabels({'N1','N2','N3','REM','Wake'})
ylim([0 100])
ylabel('Percentage (%)')
subplot(122),PlotBarCRH_MC(percN1_sal_half2,percN1_CNO_hafl2,percN2_sal_half2,percN2_CNO_half2,percN3_sal_half2,percN3_CNO_half2,percREM_sal_half2,percREM_CNO_half2,percWake_sal_half2,percWake_CNO_half2,1)
xticks([1 2 3 4 5])
xticklabels({'N1','N2','N3','REM','Wake'})
ylim([0 100])
ylabel('Percentage (%)')
