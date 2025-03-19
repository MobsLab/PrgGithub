Dir = PathForExperimentsERC('UMazePAG');
mice_PAG_neurons = [905,906,911,994,1161,1162,1168,1182,1186,1199,1230,1239];

%% Look at how many neurons we have per session
nn=0;
for ff = 1:length(Dir.name)
    if ismember(eval(Dir.name{ff}(6:end)),mice_PAG_neurons)
        cd(Dir.path{ff}{1})
        load('SpikeData.mat')
        nn = nn+1;
        NumNeurons(nn) = length(S);
    end
end

%% Look at how many neurons we have per session
close all
FolderToSave = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/DataCheck/';
mkdir(FolderToSave)
nn=0;

for ff = 1:length(Dir.name)
    if ismember(eval(Dir.name{ff}(6:end)),mice_PAG_neurons)
        try
        fig = figure('Position',[1 1 1000 600]);
        nn=nn+1;
        cd(Dir.path{ff}{1})
        
        load('SleepScoring_Accelero.mat','Sleep')
        load('behavResources.mat')
        load('B_Low_Spectrum.mat')
        load('SWR.mat')
        
        Sptsd = tsd(Spectro{2}*1e4,log(Spectro{1}));
        FzShock = and(FreezeAccEpoch,ZoneEpoch.Shock) - Sleep;
        FzSafe = and(FreezeAccEpoch,ZoneEpoch.NoShock) - Sleep;
        
        subplot(121)
        plot(Spectro{3},nanmean(Data(Restrict(Sptsd,FzShock))),'r')
        hold on
        plot(Spectro{3},nanmean(Data(Restrict(Sptsd,FzSafe))),'b')
        xlim([0 10])
        makepretty_DB
        xlabel('Frequency (Hz)')
        title('OB')
        legend('Shock','Safe')
        
        subplot(122)
        RipDensity = [length(Start(and(RipplesEpoch,FzSafe))) / sum(Stop(FzSafe,'s') - Start(FzSafe,'s')),...
            length(Start(and(RipplesEpoch,FzShock))) / sum(Stop(FzShock,'s') - Start(FzShock,'s'))];
        bar([1,2],RipDensity)
        set(gca,'XTickLabel',{'Safe','Shock'})
        ylabel('Rip / s')
        makepretty_DB
        
        fig.Name = [Dir.name{ff}, '  nSU= ' num2str( NumNeurons(nn))];
        saveas(fig.Number,[FolderToSave,'Fig_',Dir.name{ff},'.png']);
        end
    end
end


