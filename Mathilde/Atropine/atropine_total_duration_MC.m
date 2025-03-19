
%% DIR ATROPINE
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);
% DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1105 1106 1107 1245 1247 1248]); %1112
% 
% DirAtropine = PathForExperimentsAtropine_MC('Atropine');


%% FLX
%saline PFC experiment
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
%saline VLPO experiment
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
%merge saline path
Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
DirBasal_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
DirBasal_dreadd_PFC = RestrictPathForExperiment(DirBasal_dreadd_PFC,'nMice',[1197 1198 1235 1236 1237 1238]);
Dir_sal2 = MergePathForExperiment(DirBasal_dreadd_PFC,DirSaline_retoCre);
DirSaline = MergePathForExperiment(Dir_sal,Dir_sal2);
DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1196 1237 1238 1245 1248 1247]);

%%PathForExperimentsFLX_MC
DirAtropine = PathForExperimentsFLX_MC('dreadd_PFC_saline_flx');

%% parameters
st_epoch_preInj = 0*1E8;
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;
en_epoch_postInj = 3*1E8;


%% saline
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    a{i}.SWSEpoch = mergeCloseIntervals(a{i}.SWSEpoch, 1e4);
    a{i}.REMEpoch = mergeCloseIntervals(a{i}.REMEpoch, 1e4);
    a{i}.Wake = mergeCloseIntervals(a{i}.Wake, 1e4);
    
    durtotal_saline{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
    %pre njection
    epoch_pre_saline{i}=intervalSet(0,en_epoch_preInj);
    %post ubjection
    epoch_post_saline{i}=intervalSet(st_epoch_postInj,durtotal_saline{i});
    
    if isempty(a{i})==0
        %total duration (pre)
        durTREM_allPre_saline(i) = sum(End(and(a{i}.REMEpoch,epoch_pre_saline{i}),'s')-Start(and(a{i}.REMEpoch,epoch_pre_saline{i}),'s'));
        durTSWS_allPre_saline(i) = sum(End(and(a{i}.SWSEpoch,epoch_pre_saline{i}),'s')-Start(and(a{i}.SWSEpoch,epoch_pre_saline{i}),'s'));
        durTWAKE_allPre_saline(i) = sum(End(and(a{i}.Wake,epoch_pre_saline{i}),'s')-Start(and(a{i}.Wake,epoch_pre_saline{i}),'s'));
        
        %total duration (all post session)
        durTREM_allPost_saline(i) = sum(End(and(a{i}.REMEpoch,epoch_post_saline{i}),'s')-Start(and(a{i}.REMEpoch,epoch_post_saline{i}),'s'));
        durTSWS_allPost_saline(i) = sum(End(and(a{i}.SWSEpoch,epoch_post_saline{i}),'s')-Start(and(a{i}.SWSEpoch,epoch_post_saline{i}),'s'));
        durTWAKE_allPost_saline(i) = sum(End(and(a{i}.Wake,epoch_post_saline{i}),'s')-Start(and(a{i}.Wake,epoch_post_saline{i}),'s'));
    else
    end
end

%% atropine
for n=1:length(DirAtropine.path)
    cd(DirAtropine.path{n}{1});
    e{n} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    e{n}.SWSEpoch = mergeCloseIntervals(e{n}.SWSEpoch, 1e4);
    e{n}.REMEpoch = mergeCloseIntervals(e{n}.REMEpoch, 1e4);
    e{n}.Wake = mergeCloseIntervals(e{n}.Wake, 1e4);
    
    durtotal_atropine{n} = max([max(End(e{n}.Wake)),max(End(e{n}.SWSEpoch))]);
    %pre njection
    epoch_pre_atropine{n}=intervalSet(0,en_epoch_preInj);
    %post ubjection
    epoch_post_atropine{n}=intervalSet(st_epoch_postInj,durtotal_atropine{n});
    
    if isempty(e{n})==0
        %total duration (pre)
        durTREM_allPre_atropine(n) = sum(End(and(e{n}.REMEpoch,epoch_pre_atropine{n}),'s')-Start(and(e{n}.REMEpoch,epoch_pre_atropine{n}),'s'));
        durTSWS_allPre_atropine(n) = sum(End(and(e{n}.SWSEpoch,epoch_pre_atropine{n}),'s')-Start(and(e{n}.SWSEpoch,epoch_pre_atropine{n}),'s'));
        durTWAKE_allPre_atropine(n) = sum(End(and(e{n}.Wake,epoch_pre_atropine{n}),'s')-Start(and(e{n}.Wake,epoch_pre_atropine{n}),'s'));
        
        %total duration (all post session)
        durTREM_allPost_atropine(n) = sum(End(and(e{n}.REMEpoch,epoch_post_atropine{n}),'s')-Start(and(e{n}.REMEpoch,epoch_post_atropine{n}),'s'));
        durTSWS_allPost_atropine(n) = sum(End(and(e{n}.SWSEpoch,epoch_post_atropine{n}),'s')-Start(and(e{n}.SWSEpoch,epoch_post_atropine{n}),'s'));
        durTWAKE_allPost_atropine(n) = sum(End(and(e{n}.Wake,epoch_post_atropine{n}),'s')-Start(and(e{n}.Wake,epoch_post_atropine{n}),'s'));
    else
    end
end

%%

col_pre_saline = [.8 .8 .8];
col_post_saline = [.8 .8 .8];

col_pre_cno = [.2 .8 0];
col_post_cno = [.2 .8 0];



figure,
MakeSpreadAndBoxPlot2_SB({durTREM_allPre_saline, durTREM_allPre_atropine, durTREM_allPost_saline, durTREM_allPost_atropine},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','ShowPoints',0,'showsigstar','none');
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Total REM duration (s)')
makepretty

[h,p_pre]=ttest(durTREM_allPre_saline, durTREM_allPre_atropine);
%p_pre=signrank(avRippPerMin_Wakebefore_sal,avRippPerMin_Wakebefore_cno);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end

[h,p_post]=ttest(durTREM_allPost_saline, durTREM_allPost_atropine);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end

title(sprintf(['p pre = ', num2str(p_pre), ' \np post = ', num2str(p_post)]))


%%


figure,
MakeSpreadAndBoxPlot2_SB({durTREM_allPre_saline./60, durTREM_allPre_atropine./60, durTREM_allPost_saline./60, durTREM_allPost_atropine./60},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','ShowPoints',0,'showsigstar','none');
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Total REM duration (min)')
makepretty

[h,p_pre]=ttest(durTREM_allPre_saline, durTREM_allPre_atropine);
%p_pre=signrank(avRippPerMin_Wakebefore_sal,avRippPerMin_Wakebefore_cno);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end

[h,p_post]=ttest(durTREM_allPost_saline, durTREM_allPost_atropine);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end

title(sprintf(['p pre = ', num2str(p_pre), ' \np post = ', num2str(p_post)]))

