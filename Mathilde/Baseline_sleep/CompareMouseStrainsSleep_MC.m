%% compare sleep C57 and CRH-cre
%%dir C57 mice
DirC57mice=PathForExperiments_BaselineSleep_MC('BaselineSleep');
%%dir CRH-cre mice
DirBasal_dreadd1 = PathForExperiments_DREADD_MC('BaselineSleep');
DirBasal_dreadd2 = PathForExperiments_DREADD_MC('OneInject_Nacl');
DirCRHmice = MergePathForExperiment(DirBasal_dreadd1,DirBasal_dreadd2);

%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%% get data BASELINE sleep
for i=1:length(DirC57mice.path)
    cd(DirC57mice.path{i}{1});
    if exist('ExpeInfo.mat')
        MiceInfo{i}=load('ExpeInfo.mat');
        MiceNum{i}=MiceInfo{i}.ExpeInfo.nmouse;
        MiceNum{i}=MiceInfo{i}.ExpeInfo.MouseStrain;
    else
        MiceInfo{i}=[];
        MiceNum{i}=[];
    end
    
    if exist('SleepScoring_Accelero.mat')
        b{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        if isempty(b{i})==1
        else
            GoodNum{i}=DirC57mice.name{i};

            %%periods of time
            durtotal_basal{i} = max([max(End(b{i}.Wake)),max(End(b{i}.SWSEpoch))]);
            %pre injection
            epoch_PreInj_basal{i} = intervalSet(0, en_epoch_preInj);
            %     epoch_PreInj_basal{i} = intervalSet(0, durtotal_basal{i}/2);
            %post injection
            epoch_PostInj_basal{i} = intervalSet(st_epoch_postInj,durtotal_basal{i});
            %     epoch_PostInj_basal{i} = intervalSet(durtotal_basal{i}/2,durtotal_basal{i});
            %3h post injection
            epoch_3hPostInj_basal{i}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
            
            %%percentage
            Restemp_basal{i}=ComputeSleepStagesPercentagesMC(b{i}.Wake,b{i}.SWSEpoch,b{i}.REMEpoch);
            %percentage all session
            percWAKE_basal_tot(i)=Restemp_basal{i}(1,1); percWAKE_basal_tot(percWAKE_basal_tot==0)=NaN;
            percSWS_basal_tot(i)=Restemp_basal{i}(2,1); percSWS_basal_tot(percSWS_basal_tot==0)=NaN;
            percREM_basal_tot(i)=Restemp_basal{i}(3,1); percREM_basal_tot(percREM_basal_tot==0)=NaN;
            
            %percentage pre injection
            percWAKE_basal_pre(i)=Restemp_basal{i}(1,2); percWAKE_basal_pre(percWAKE_basal_pre==0)=NaN;
            percSWS_basal_pre(i)=Restemp_basal{i}(2,2); percSWS_basal_pre(percSWS_basal_pre==0)=NaN;
            percREM_basal_pre(i)=Restemp_basal{i}(3,2); percREM_basal_pre(percREM_basal_pre==0)=NaN;
            %percentage post injection
            percWAKE_basal_post(i)=Restemp_basal{i}(1,3); percWAKE_basal_post(percWAKE_basal_post==0)=NaN;
            percSWS_basal_post(i)=Restemp_basal{i}(2,3); percSWS_basal_post(percSWS_basal_post==0)=NaN;
            percREM_basal_post(i)=Restemp_basal{i}(3,3); percREM_basal_post(percREM_basal_post==0)=NaN;
            %percentage 3h post injection
            percWAKE_basal_3hPostInj(i)=Restemp_basal{i}(1,4); percWAKE_basal_3hPostInj(percWAKE_basal_3hPostInj==0)=NaN;
            percSWS_basal_3hPostInj(i)=Restemp_basal{i}(2,4); percSWS_basal_3hPostInj(percSWS_basal_3hPostInj==0)=NaN;
            percREM_basal_3hPostInj(i)=Restemp_basal{i}(3,4); percREM_basal_3hPostInj(percREM_basal_3hPostInj==0)=NaN;
            
            %number of bouts all session
            NumSWS_basal_tot(i)=length(length(b{i}.SWSEpoch)); NumSWS_basal_tot(NumSWS_basal_tot==0)=NaN;
            NumWAKE_basal_tot(i)=length(length(b{i}.Wake)); NumWAKE_basal_tot(NumWAKE_basal_tot==0)=NaN;
            NumREM_basal_tot(i)=length(length(b{i}.REMEpoch)); NumREM_basal_tot(NumREM_basal_tot==0)=NaN;
            
            %number of bouts pre injection
            NumSWS_basal_pre(i)=length(length(and(b{i}.SWSEpoch,epoch_PreInj_basal{i})));
            NumWAKE_basal_pre(i)=length(length(and(b{i}.Wake,epoch_PreInj_basal{i})));
            NumREM_basal_pre(i)=length(length(and(b{i}.REMEpoch,epoch_PreInj_basal{i})));
            %number of bouts post injection
            NumSWS_basal_post(i)=length(length(and(b{i}.SWSEpoch,epoch_PostInj_basal{i})));
            NumWAKE_basal_post(i)=length(length(and(b{i}.Wake,epoch_PostInj_basal{i})));
            NumREM_basal_post(i)=length(length(and(b{i}.REMEpoch,epoch_PostInj_basal{i})));
            %number of bouts 3h post injection
            NumSWS_basal_3hPostInj(i)=length(length(and(b{i}.SWSEpoch,epoch_3hPostInj_basal{i})));
            NumWAKE_basal_3hPostInj(i)=length(length(and(b{i}.Wake,epoch_3hPostInj_basal{i})));
            NumREM_basal_3hPostInj(i)=length(length(and(b{i}.REMEpoch,epoch_3hPostInj_basal{i})));
            
            %duration of bouts all session
            durWAKE_basal_tot(i)=mean(End(b{i}.Wake)-Start(b{i}.Wake))/1E4; durWAKE_basal_tot(durWAKE_basal_tot==0)=NaN;
            durSWS_basal_tot(i)=mean(End(b{i}.SWSEpoch)-Start(b{i}.SWSEpoch))/1E4; durSWS_basal_tot(durSWS_basal_tot==0)=NaN;
            durREM_basal_tot(i)=mean(End(b{i}.REMEpoch)-Start(b{i}.REMEpoch))/1E4; durREM_basal_tot(durREM_basal_tot==0)=NaN;
            
            %duration of bouts pre injection
            durWAKE_basal_pre(i)=mean(End(and(b{i}.Wake,epoch_PreInj_basal{i}))-Start(and(b{i}.Wake,epoch_PreInj_basal{i})))/1E4;
            durSWS_basal_pre(i)=mean(End(and(b{i}.SWSEpoch,epoch_PreInj_basal{i}))-Start(and(b{i}.SWSEpoch,epoch_PreInj_basal{i})))/1E4;
            durREM_basal_pre(i)=mean(End(and(b{i}.REMEpoch,epoch_PreInj_basal{i}))-Start(and(b{i}.REMEpoch,epoch_PreInj_basal{i})))/1E4;
            %duration of bouts post injection
            durWAKE_basal_post(i)=mean(End(and(b{i}.Wake,epoch_PostInj_basal{i}))-Start(and(b{i}.Wake,epoch_PostInj_basal{i})))/1E4;
            durSWS_basal_post(i)=mean(End(and(b{i}.SWSEpoch,epoch_PostInj_basal{i}))-Start(and(b{i}.SWSEpoch,epoch_PostInj_basal{i})))/1E4;
            durREM_basal_post(i)=mean(End(and(b{i}.REMEpoch,epoch_PostInj_basal{i}))-Start(and(b{i}.REMEpoch,epoch_PostInj_basal{i})))/1E4;
            %duration of bouts 3h post injection
            durWAKE_basal_3hPostInj(i)=mean(End(and(b{i}.Wake,epoch_3hPostInj_basal{i}))-Start(and(b{i}.Wake,epoch_3hPostInj_basal{i})))/1E4;
            durSWS_basal_3hPostInj(i)=mean(End(and(b{i}.SWSEpoch,epoch_3hPostInj_basal{i}))-Start(and(b{i}.SWSEpoch,epoch_3hPostInj_basal{i})))/1E4;
            durREM_basal_3hPostInj(i)=mean(End(and(b{i}.REMEpoch,epoch_3hPostInj_basal{i}))-Start(and(b{i}.REMEpoch,epoch_3hPostInj_basal{i})))/1E4;
        end
    else
    end
end

%%
goodNumber=[];
good=[];
for aa=1:1:length(b)
    if percREM_basal_post(aa)==0
    else
        good=[good;percREM_basal_post(aa)];
        goodNumber=[goodNumber;MiceNum{aa}];

    end
end




%% 
for k=1:length(DirCRHmice.path)
    cd(DirCRHmice.path{k}{1});
    c{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    
    %%separate day in different periods
    durtotal_cno{k} = max([max(End(c{k}.Wake)),max(End(c{k}.SWSEpoch))]);
    %pre injection
    epoch_PreInj_cno{k} = intervalSet(0, en_epoch_preInj);
    %     epoch_PreInj_cno{j} = intervalSet(0, durtotal_cno{j}/2);
    %post injection
    epoch_PostInj_cno{k} = intervalSet(st_epoch_postInj,durtotal_cno{k});
    %     epoch_PostInj_cno{j} = intervalSet(durtotal_cno{j}/2,durtotal_cno{j});
    %3h post injection
    epoch_3hPostInj_cno{k}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
    
    Restemp_cno{k}=ComputeSleepStagesPercentagesMC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch);
    %percentage all session
    percWAKE_CNO_tot(k) = Restemp_cno{k}(1,1);
    percSWS_CNO_tot(k) = Restemp_cno{k}(2,1);
    percREM_CNO_tot(k) = Restemp_cno{k}(3,1);
    
    %percentage pre injection
    percWAKE_CNO_pre(k) = Restemp_cno{k}(1,2);
    percSWS_CNO_pre(k) = Restemp_cno{k}(2,2);
    percREM_CNO_pre(k) = Restemp_cno{k}(3,2);
    %percentage post injection
    percWAKE_CNO_post(k) = Restemp_cno{k}(1,3);
    percSWS_CNO_post(k) = Restemp_cno{k}(2,3);
    percREM_CNO_post(k) = Restemp_cno{k}(3,3);
    %percentage 3h post injection
    percWAKE_CNO_3hPostInj(k) = Restemp_cno{k}(1,4);
    percSWS_CNO_3hPostInj(k) = Restemp_cno{k}(2,4);
    percREM_CNO_3hPostInj(k) = Restemp_cno{k}(3,4);
    
    %number of bouts all session
    NumSWS_CNO_tot(k) = length(length(c{k}.SWSEpoch));
    NumWAKE_CNO_tot(k) = length(length(c{k}.Wake));
    NumREM_CNO_tot(k) = length(length(c{k}.REMEpoch));
    
    %number of bouts pre injection
    NumSWS_CNO_pre(k) = length(length(and(c{k}.SWSEpoch,epoch_PreInj_cno{k})));
    NumWAKE_CNO_pre(k) = length(length(and(c{k}.Wake,epoch_PreInj_cno{k})));
    NumREM_CNO_pre(k) = length(length(and(c{k}.REMEpoch,epoch_PreInj_cno{k})));
    %number of bouts post injection
    NumSWS_CNO_post(k) = length(length(and(c{k}.SWSEpoch,epoch_PostInj_cno{k})));
    NumWAKE_CNO_post(k) = length(length(and(c{k}.Wake,epoch_PostInj_cno{k})));
    NumREM_CNO_post(k) = length(length(and(c{k}.REMEpoch,epoch_PostInj_cno{k})));
    %number of bouts 3h post injection
    NumSWS_CNO_3hPostInj(k) = length(length(and(c{k}.SWSEpoch,epoch_3hPostInj_cno{k})));
    NumWAKE_CNO_3hPostInj(k) = length(length(and(c{k}.Wake,epoch_3hPostInj_cno{k})));
    NumREM_CNO_3hPostInj(k) = length(length(and(c{k}.REMEpoch,epoch_3hPostInj_cno{k})));
    
    %duration of bouts all session
    durWAKE_CNO_tot(k) = mean(End(c{k}.Wake)-Start(c{k}.Wake))/1E4;
    durSWS_CNO_tot(k) = mean(End(c{k}.SWSEpoch)-Start(c{k}.SWSEpoch))/1E4;
    durREM_CNO_tot(k) = mean(End(c{k}.REMEpoch)-Start(c{k}.REMEpoch))/1E4;
    
    %duration of bouts pre injection
    durWAKE_CNO_pre(k) = mean(End(and(c{k}.Wake,epoch_PreInj_cno{k}))-Start(and(c{k}.Wake,epoch_PreInj_cno{k})))/1E4;
    durSWS_CNO_pre(k) = mean(End(and(c{k}.SWSEpoch,epoch_PreInj_cno{k}))-Start(and(c{k}.SWSEpoch,epoch_PreInj_cno{k})))/1E4;
    durREM_CNO_pre(k) = mean(End(and(c{k}.REMEpoch,epoch_PreInj_cno{k}))-Start(and(c{k}.REMEpoch,epoch_PreInj_cno{k})))/1E4;
    %duration of bouts post injection
    durWAKE_CNO_post(k) = mean(End(and(c{k}.Wake,epoch_PostInj_cno{k}))-Start(and(c{k}.Wake,epoch_PostInj_cno{k})))/1E4;
    durSWS_CNO_post(k) = mean(End(and(c{k}.SWSEpoch,epoch_PostInj_cno{k}))-Start(and(c{k}.SWSEpoch,epoch_PostInj_cno{k})))/1E4;
    durREM_CNO_post(k) = mean(End(and(c{k}.REMEpoch,epoch_PostInj_cno{k}))-Start(and(c{k}.REMEpoch,epoch_PostInj_cno{k})))/1E4;
    %duration of bouts 3h post injection
    durWAKE_CNO_3hPostInj(k) = mean(End(and(c{k}.Wake,epoch_3hPostInj_cno{k}))-Start(and(c{k}.Wake,epoch_3hPostInj_cno{k})))/1E4;
    durSWS_CNO_3hPostInj(k) = mean(End(and(c{k}.SWSEpoch,epoch_3hPostInj_cno{k}))-Start(and(c{k}.SWSEpoch,epoch_3hPostInj_cno{k})))/1E4;
    durREM_CNO_3hPostInj(k) = mean(End(and(c{k}.REMEpoch,epoch_3hPostInj_cno{k}))-Start(and(c{k}.REMEpoch,epoch_3hPostInj_cno{k})))/1E4;

        if isnan(durREM_CNO_post(k))==1
        durREM_CNO_post(k)=0;
    else
        end
    
        
    if isnan(durREM_CNO_3hPostInj(k))==1
        durREM_CNO_3hPostInj(k)=0;
    else
    end

end



%% figures with BaselineSleep
%% pourcentage
figure
ax1(1)=subplot(331),PlotErrorBarN_KJ({percWAKE_basal_tot,percWAKE_CNO_tot},'newfig',0,'paired',0,'ShowSigstar','none');
xticks([1:2]); xticklabels({'C57Bl6/J','CRH-Cre'}); xtickangle(45)
ylabel('Percentage of wakefulness (%)')
makepretty
ax1(2)=subplot(332),PlotErrorBarN_KJ({percSWS_basal_tot,percSWS_CNO_tot},'newfig',0,'paired',0,'ShowSigstar','none');
xticks([1:2]); xticklabels({'C57Bl6/J','CRH-Cre'}); xtickangle(45)
ylabel('Percentage of NREM (%)')
makepretty
ax1(3)=subplot(333),PlotErrorBarN_KJ({percREM_basal_tot,percREM_CNO_tot},'newfig',0,'paired',0,'ShowSigstar','none');
xticks([1:2]); xticklabels({'C57Bl6/J','CRH-Cre'}); xtickangle(45)
ylabel('Percentage of REM (%)')
makepretty

set(ax1,'ylim',[0 100]);



%%Number
ax2(1)=subplot(334),PlotErrorBarN_KJ({NumWAKE_basal_tot,NumWAKE_CNO_tot},'newfig',0,'paired',0,'ShowSigstar','none');
xticks([1:2]); xticklabels({'C57Bl6/J','CRH-Cre'}); xtickangle(45)
ylabel('Number of WAKE bouts')
makepretty
ax2(2)=subplot(335),PlotErrorBarN_KJ({NumSWS_basal_tot,NumSWS_CNO_tot},'newfig',0,'paired',0,'ShowSigstar','none');
xticks([1:2]); xticklabels({'C57Bl6/J','CRH-Cre'}); xtickangle(45)
ylabel('Number of NREM bouts')
makepretty
ax2(3)=subplot(336),PlotErrorBarN_KJ({NumREM_basal_tot,NumREM_CNO_tot},'newfig',0,'paired',0,'ShowSigstar','none');
xticks([1:2]); xticklabels({'C57Bl6/J','CRH-Cre'}); xtickangle(45)
ylabel('Number of REM bouts')
makepretty

set(ax2,'ylim',[0 300]);




%%Duration
ax3(1)=subplot(337),PlotErrorBarN_KJ({durWAKE_basal_tot,durWAKE_CNO_tot},'newfig',0,'paired',0,'ShowSigstar','none');
xticks([1:2]); xticklabels({'C57Bl6/J','CRH-Cre'}); xtickangle(45)
ylabel('Mean duration of WAKE bouts (s)')
makepretty
ax3(2)=subplot(338),PlotErrorBarN_KJ({durSWS_basal_tot,durSWS_CNO_tot},'newfig',0,'paired',0,'ShowSigstar','none');
xticks([1:2]); xticklabels({'C57Bl6/J','CRH-Cre'}); xtickangle(45)
ylabel('Mean duration of NREM bouts (s)')
makepretty
ax3(3)=subplot(339),PlotErrorBarN_KJ({durREM_basal_tot,durREM_CNO_tot},'newfig',0,'paired',0,'ShowSigstar','none');
xticks([1:2]); xticklabels({'C57Bl6/J','CRH-Cre'}); xtickangle(45)
ylabel('Mean duration of REM bouts (s)')
makepretty

set(ax3,'ylim',[0 300]);