clear all,
MouseToAvoid=[431]; % mice with noisy data to exclude
FilesEPM=PathForExperimentsEmbReact('EPM');
FilesEPM=RemoveElementsFromDir(FilesEPM,'nmouse',MouseToAvoid);
FilesExplo=PathForExperimentsEmbReact('Habituation');
FilesExplo=RemoveElementsFromDir(FilesExplo,'nmouse',MouseToAvoid);
cols={'b','r','g'};
SaveFigName='/media/DataMOBsRAIDN/ProjectEmbReact/Figures/Nov2016/EPM/';
fig=figure;
warning off
for mm=1:length(FilesEPM.path)
    mm
    try
        clear TotalNoiseEpoch
        cd(FilesEPM.path{mm}{1})
        load('behavResources.mat')
        load('StateEpochSB.mat')
        ZoneEpoch{1}=ZoneEpoch{1}-ZoneEpoch{3};ZoneEpoch{1}=ZoneEpoch{1}-TotalNoiseEpoch;
        ZoneEpoch{2}=ZoneEpoch{2}-ZoneEpoch{3};ZoneEpoch{2}=ZoneEpoch{2}-TotalNoiseEpoch;
        % Check Positions
        subplot(221), hold on
        for ep=1:3
            plot(Data(Restrict(Xtsd,ZoneEpoch{ep})),Data(Restrict(Ytsd,ZoneEpoch{ep})),cols{ep})
        end
        % Speed distrib
        subplot(222)
        for ep=1:3
            a{ep} =log(Data(Restrict(Movtsd,ZoneEpoch{ep})));
        end
        nhist(a);
        legend('open','closed','centre')
        xlabel('speed - log')
        
        % Spectra
        subplot(234), hold on
        load('B_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        for ep=1:3
            plot(Spectro{3},nanmean(Data(Restrict(Sptsd,ZoneEpoch{ep}))),cols{ep},'linewidth',3)
            SaveInfo.OB{ep}(mm,:)=nanmean(Data(Restrict(Sptsd,ZoneEpoch{ep})));
        end
        subplot(235), hold on
        load('H_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        for ep=1:3
            plot(Spectro{3},nanmean(Data(Restrict(Sptsd,ZoneEpoch{ep}))),cols{ep},'linewidth',3)
            SaveInfo.HPC{ep}(mm,:)=nanmean(Data(Restrict(Sptsd,ZoneEpoch{ep})));
        end
        subplot(236), hold on
        load('PFCx_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        for ep=1:3
            plot(Spectro{3},nanmean(Data(Restrict(Sptsd,ZoneEpoch{ep}))),cols{ep},'linewidth',3)
            SaveInfo.PFC{ep}(mm,:)=nanmean(Data(Restrict(Sptsd,ZoneEpoch{ep})));
        end
        
        
        for k=1:length(FilesExplo.path)
            if FilesExplo.ExpeInfo{k}.nmouse==FilesEPM.ExpeInfo{mm}.nmouse
                cd(FilesExplo.path{k}{1})
                load('behavResources.mat')
                a{4}=log(Data((Movtsd)));
                subplot(222)
                nhist(a);
                legend('open','closed','centre','hab')
                xlabel('speed - log')
                
                % Spectra
                subplot(234), hold on
                load('B_Low_Spectrum.mat')
                Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                plot(Spectro{3},nanmean(Data(Sptsd)),'k','linewidth',3)
                SaveInfo.OB{4}(mm,:)=nanmean(Data(Sptsd));

                subplot(235), hold on
                load('H_Low_Spectrum.mat')
                Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                plot(Spectro{3},nanmean(Data(Sptsd)),'k','linewidth',3)
                SaveInfo.HPC{4}(mm,:)=nanmean(Data(Sptsd));
                subplot(236), hold on
                load('PFCx_Low_Spectrum.mat')
                Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                plot(Spectro{3},nanmean(Data(Sptsd)),'k','linewidth',3)
                SaveInfo.PFC{4}(mm,:)=nanmean(Data(Sptsd));

            end
        end
        saveas(fig,[SaveFigName,'EPMOverview-M',num2str(mm),'.png'])
        saveas(fig,[SaveFigName,'EPMOverview-M',num2str(mm),'.fig'])
        clf
    catch
keyboard
    end
end
KeepSaveInfo=SaveInfo;

for mm=1:6
    Val=nanmean([nanmean(SaveInfo.OB{1}(mm,20:end)),nanmean(SaveInfo.OB{2}(mm,20:end))]);
    SaveInfo.OB{1}=SaveInfo.OB{1}/Val;SaveInfo.OB{1}(SaveInfo.OB{1}==0)=NaN;
    SaveInfo.OB{2}=SaveInfo.OB{2}/Val;SaveInfo.OB{2}(SaveInfo.OB{2}==0)=NaN;
    SaveInfo.OB{4}=SaveInfo.OB{4}/Val;SaveInfo.OB{4}(SaveInfo.OB{4}==0)=NaN;
    
        Val=nanmean([nanmean(SaveInfo.HPC{1}(mm,20:end)),nanmean(SaveInfo.HPC{2}(mm,20:end))]);
    SaveInfo.HPC{1}=SaveInfo.HPC{1}/Val;SaveInfo.HPC{1}(SaveInfo.HPC{1}==0)=NaN;
    SaveInfo.HPC{2}=SaveInfo.HPC{2}/Val;SaveInfo.HPC{2}(SaveInfo.HPC{2}==0)=NaN;
    SaveInfo.HPC{4}=SaveInfo.HPC{4}/Val;SaveInfo.HPC{4}(SaveInfo.HPC{4}==0)=NaN;
    
    Val=nanmean([nanmean(SaveInfo.PFC{1}(mm,20:end)),nanmean(SaveInfo.PFC{2}(mm,20:end))]);
    SaveInfo.PFC{1}=SaveInfo.PFC{1}/Val;SaveInfo.PFC{1}(SaveInfo.PFC{1}==0)=NaN;
    SaveInfo.PFC{2}=SaveInfo.PFC{2}/Val;SaveInfo.PFC{2}(SaveInfo.PFC{2}==0)=NaN;
    SaveInfo.PFC{4}=SaveInfo.PFC{4}/Val;SaveInfo.PFC{4}(SaveInfo.PFC{4}==0)=NaN;

end

figure
subplot(131)
g=shadedErrorBar(Spectro{3},nanmean(SaveInfo.OB{1}),[stdError((SaveInfo.OB{1}));stdError((SaveInfo.OB{1}))],'b');
hold on
g=shadedErrorBar(Spectro{3},nanmean(SaveInfo.OB{2}),[stdError((SaveInfo.OB{2}));stdError((SaveInfo.OB{2}))],'r')
g=shadedErrorBar(Spectro{3},nanmean(SaveInfo.OB{4}),[stdError((SaveInfo.OB{4}));stdError((SaveInfo.OB{4}))],'k')
subplot(132)
g=shadedErrorBar(Spectro{3},nanmean(SaveInfo.PFC{1}),[stdError((SaveInfo.PFC{1}));stdError((SaveInfo.PFC{1}))],'b');
hold on
g=shadedErrorBar(Spectro{3},nanmean(SaveInfo.PFC{2}),[stdError((SaveInfo.PFC{2}));stdError((SaveInfo.PFC{2}))],'r')
g=shadedErrorBar(Spectro{3},nanmean(SaveInfo.PFC{4}),[stdError((SaveInfo.PFC{4}));stdError((SaveInfo.PFC{4}))],'k')
subplot(133)
g=shadedErrorBar(Spectro{3},nanmean(SaveInfo.HPC{1}),[stdError((SaveInfo.HPC{1}));stdError((SaveInfo.HPC{1}))],'b');
hold on
g=shadedErrorBar(Spectro{3},nanmean(SaveInfo.HPC{2}),[stdError((SaveInfo.HPC{2}));stdError((SaveInfo.HPC{2}))],'r')
g=shadedErrorBar(Spectro{3},nanmean(SaveInfo.HPC{4}),[stdError((SaveInfo.HPC{4}));stdError((SaveInfo.HPC{4}))],'k')

figure
subaxis(2,1,1, 'Spacing', 0.02, 'Padding', 0.04, 'Margin', 0.02);
g=shadedErrorBar(Spectro{3},nanmean(SaveInfo.OB{2}([1,2,4:6],:)),[stdError((SaveInfo.OB{2}([1,2,4:6],:)));stdError((SaveInfo.OB{2}([1,2,4:6],:)))],'b');
box off
subaxis(2,1,2, 'Spacing', 0.02, 'Padding', 0.04, 'Margin', 0.02);
g=shadedErrorBar(Spectro{3},nanmean(SaveInfo.HPC{2}),[stdError((SaveInfo.HPC{2}));stdError((SaveInfo.HPC{2}))],'c');
box off


