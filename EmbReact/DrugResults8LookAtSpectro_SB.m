clear all
clear Dir
Sessnames = {'UMazeCondExplo_PostDrug','UMazeCondBlockedShock_PostDrug','UMazeCondBlockedSafe_PostDrug'};
for d = 1:3
    Dir{d} = PathForExperimentsEmbReact(Sessnames{d});
end

for mouse = 1:length(Dir{1}.path)-1
    try
        mouse
        VarCond.DrugType{mouse} = Dir{1}.ExpeInfo{mouse}{1}.DrugInjected;
        VarCond.MouseID(mouse) = Dir{1}.ExpeInfo{mouse}{1}.nmouse;
        
        AllPaths = [];
        for d = 1:3
            AllPaths = [AllPaths,Dir{d}.path{mouse}];
        end
        try
            SpecOB = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','spec_chan_num',num2str(Dir.ExpeInfo{mouse}{1}.ChannelsToAnalyse.Bulb_deep));
        catch
            SpecOB = ConcatenateDataFromFolders_SB(AllPaths,'spectrum','prefix','B_Low');
        end
        FreezeEpoch = ConcatenateDataFromFolders_SB(AllPaths,'epoch','epochname','freezeepoch');
        ZoneEpoch = ConcatenateDataFromFolders_SB(AllPaths,'epoch', 'epochname','zoneepoch');
        LinPos = ConcatenateDataFromFolders_SB(AllPaths,'linearposition');
        OBFreq_WV = ConcatenateDataFromFolders_SB(AllPaths,'instfreq','suffix_instfreq','B','method','WV');
        OBFreq_PT = ConcatenateDataFromFolders_SB(AllPaths,'instfreq','suffix_instfreq','B','method','PT');
        StimEpoch = ConcatenateDataFromFolders_SB(AllPaths,'epoch', 'epochname','stimepoch');
        Acc = ConcatenateDataFromFolders_SB(AllPaths,'accelero');

        clf
        load('B_Low_Spectrum.mat')
        subplot(411)
        igesc(Range(SpecOB,'s'),Spectro{3},log(Data(SpecOB))'), axis xy
        hold on
        plot(Start(StimEpoch,'s'),18,'k*')
        line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',[Start(FreezeEpoch,'s')*0+10 Stop(FreezeEpoch,'s')*0+10]','color','k','linewidth',2)
   
        subplot(412)
        hold on
        plot(Range(OBFreq_WV,'s'),Data(OBFreq_WV),'k')
        plot(Range(OBFreq_PT,'s'),Data(OBFreq_PT),'r')
        
        subplot(413)
        hold on
        plot(Range(LinPos,'s'),Data(LinPos),'k')

        subplot(413)
        hold on
        plot(Range(LinPos,'s'),Data(LinPos),'k')
        
        subplot(414)
        hold on
        plot(Range(Acc,'s'),Data(Acc),'b')
        line([Start(FreezeEpoch,'s') Stop(FreezeEpoch,'s')]',[Start(FreezeEpoch,'s')*0+5*1E8 Stop(FreezeEpoch,'s')*0+5*1E8]','color','k','linewidth',2)
        plot(Start(StimEpoch,'s'),10*1E8,'k*')
        
        


end
