%% input dir
DirAtropineMC = PathForExperimentsAtropine_MC('Atropine');
DirBaselineMC = PathForExperimentsAtropine_MC('Baseline');
DirBaselineMC = RestrictPathForExperiment(DirBaselineMC,'nMice',[1105 1106 1107]);
DirAtropineMC = RestrictPathForExperiment(DirAtropineMC,'nMice',[1105 1106 1107]);

DirAtropineTG = PathForExperiments_TG('atropine_Atropine');
DirBaselineTG = PathForExperiments_TG('atropine_Baseline');

DirAtropine = MergePathForExperiment(DirAtropineMC, DirAtropineTG);
DirBaseline = MergePathForExperiment(DirBaselineMC, DirBaselineTG);


%%
for i=1:length(DirBaselineMC.path)
    cd(DirBaselineMC.path{i}{1});
    [MStartSWS,TStartSWS,MStartREM,TStartREM,MStartWake,TStartWake,MEndSWS,TEndSWS,MEndREM,TEndREM,MEndWake,TEndWake] = PlotAccAroundStim2_MC;
    startWake_saline{i}=TStartWake;

    for ii=1:length(startWake_saline)
        AvStartWake_saline(ii,:)=nanmean(startWake_saline{ii}(:,:),1);
    end
end

%%
for i=1:length(DirAtropineMC.path)
    cd(DirAtropineMC.path{i}{1});
    [MStartSWS,TStartSWS,MStartREM,TStartREM,MStartWake,TStartWake,MEndSWS,TEndSWS,MEndREM,TEndREM,MEndWake,TEndWake] = PlotAccAroundStim2_MC;
    startWake_atropine{i}=TStartWake;

    for ii=1:length(startWake_atropine)
        AvStartWake_atropine(ii,:)=nanmean(startWake_atropine{ii}(:,:),1);
    end
end

%%
figure, plot(MStartWake(:,1), runmean(mean(AvStartWake_saline)',10),'k')
hold on
plot(MStartWake(:,1), runmean(mean(AvStartWake_atropine)',10),'r')
xlim([-10 100])
line([0 0], ylim,'color','k','linestyle',':')

%%
figure,subplot(211),shadedErrorBar(MStartWake(:,1),runmean(mean(AvStartWake_saline)',35),median(AvStartWake_saline)','-k',1)
xlim([-20 120])
line([0 0], ylim,'color','k','linestyle',':')
subplot(212),shadedErrorBar(MStartWake(:,1),runmean(mean(AvStartWake_atropine)',35),median(AvStartWake_atropine)','-r',1)
xlim([-20 120])
line([0 0], ylim,'color','k','linestyle',':')