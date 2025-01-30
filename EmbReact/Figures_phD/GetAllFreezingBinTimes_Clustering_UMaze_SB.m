clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MouseToAvoid=[117,431,795]; % mice with noisy data to exclude

% Everything Together
SessionType{1} =  GetRightSessionsUMaze_SB('AllCondSessions');
Name{1} = 'AllCondSessions';
% PAG Only
SessionType{2} =  {'UMazeCond'};
Name{2} = 'PagDay';
% PAG Night only
SessionType{3} =  {'UMazeCondNight'};
Name{3} = 'PagNight';
% Eyeshock only
SessionType{4} =  GetRightSessionsUMaze_SB('AllCondSessions_Eyeshock');
Name{4} = 'Eyeshock';
% Eyeshock only but with no doors
SessionType{5} =  GetRightSessionsUMaze_SB('AllCond_EyeShock_NoDoors');
Name{5} = 'EyeshockNoDoors';
% TestSessionWithNoShockGiven
SessionType{6} =  GetRightSessionsUMaze_SB('TestSessionDoors_EyeShock');
Name{6} = 'EyeshockNoShockExt';

SaveLocation = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice';

for SOI = 1%:length(SessionType)
    clear MouseByMouse MouseNum
    for ss=1:length(SessionType{SOI})
        Dir=PathForExperimentsEmbReact(SessionType{SOI}{ss});
        Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
        disp(SessionType{SOI}{ss})
        for d=1:length(Dir.path)
            MouseByMouse.IsSession{Dir.ExpeInfo{d}{1}.nmouse} = nan(length(SessionType{SOI}{ss}),length(Dir.path{d}));
        end
    end
    
    
    for ss=1:length(SessionType{SOI})
        Dir=PathForExperimentsEmbReact(SessionType{SOI}{ss});
        Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
        disp(SessionType{SOI}{ss})
        for d=1:length(Dir.path)
            
            for dd=1:length(Dir.path{d})
                go=0;
                if isfield(Dir.ExpeInfo{d}{dd},'DrugInjected')
                    if strcmp(Dir.ExpeInfo{d}{dd}.DrugInjected,'SAL')
                        go=1;
                    end
                else
                    go=1;
                end
                
                if go ==1
                    cd(Dir.path{d}{dd})
                    disp(Dir.path{d}{dd})
                    
                    
                clear StimEpoch SleepyEpoch TotalNoiseEpoch
                load('behavResources_SB.mat')
                load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
                RemovEpoch=or(or(TTLInfo.StimEpoch,SleepyEpoch),TotalNoiseEpoch);
                load([Struc{ss},'_Low_Spectrum.mat'])
                Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                
                % On the safe side
                LitEp=and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch;
                % Average Spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        SaveSpec{mm,1}(c,:)=nanmean((Data(Restrict(Sptsd,LitEp))));
                    else
                        SaveSpec{mm,1}(c,:)=nan(1,length(Spectro{3}));
                    end
                else
                    SaveSpec{mm,1}(c,:)=nan(1,length(Spectro{3}));
                    
                end
                
                %Individual Spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        for s=1:length(Start(LitEp))
                            dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
                            Str=Start(subset(LitEp,s));
                            if  dur<3.5*1e4 & dur>1.5*1e4
                                SaveSpecNoShck{mm,c}(count1,:)=nanmean(Data(Restrict(Sptsd,subset(LitEp,s))));
                                count1=count1+1;
                            else
                                numbins=round(dur/WndwSz);
                                epdur=dur/numbins;
                                for nn=1:numbins
                                    SaveSpecNoShck{mm,c}(count1,:)=nanmean(Data(Restrict(Sptsd,intervalSet(Str+epdur*(nn-1),Str+epdur*(nn)))));
                                    count1=count1+1;
                                end
                                
                            end
                        end
                    end
                end
                
                % On the shock side
                LitEp=and(Behav.FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch;
                % Average Spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        SaveSpec{mm,2}(c,:)=nanmean((Data(Restrict(Sptsd,LitEp))));
                    else
                        SaveSpec{mm,2}(c,:)=nan(1,length(Spectro{3}));
                    end
                else
                    SaveSpec{mm,2}(c,:)=nan(1,length(Spectro{3}));
                    
                    
                end
                
                % Individual spectra
                if not(isempty(Start(LitEp)))
                    if sum(Stop(LitEp)-Start(LitEp))>2*1e4
                        for s=1:length(Start(LitEp))
                            dur=(Stop(subset(LitEp,s))-Start(subset(LitEp,s)));
                            Str=Start(subset(LitEp,s));
                            if  dur<3.5*1e4 & dur>1.5*1e4
                                SaveSpecShck{mm,c}(count2,:)=nanmean(Data(Restrict(Sptsd,subset(LitEp,s))));
                                count2=count2+1;
                            else
                                numbins=round(dur/WndwSz);
                                epdur=dur/numbins;
                                for nn=1:numbins
                                    SaveSpecShck{mm,c}(count2,:)=nanmean(Data(Restrict(Sptsd,intervalSet(Str+epdur*(nn-1),Str+epdur*(nn)))));
                                    count2=count2+1;
                                end
                                
                            end
                        end
                    end
                end
                
                
            end
        else
            SaveSpec{mm,1}=[];
            SaveSpec{mm,2}=[];
            for c=1:size(Files.path{mm},2)
                SaveSpecShck{mm,c}=[];
                SaveSpecNoShck{mm,c}=[];
            end
        end
    end
    keyboard
    
    fig=figure;fig.Name=[Struc{ss},' Av spec Sep Animals onf'];
    for mm=1:size(Files.path,2)
        subplot(ceil(size(Files.path,2)/2),2,mm)
        plot(Spectro{3},Spectro{3}.*(nanmean(SaveSpec{mm,1})),'r')
        hold on
        plot(Spectro{3},Spectro{3}.*(nanmean(SaveSpec{mm,2})),'b')
        title(MouseName{mm})
        xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    end
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    fig=figure;fig.Name=[Struc{ss},'Av spec Sep Animals'];
    for mm=1:size(Files.path,2)
        subplot(ceil(size(Files.path,2)/2),2,mm)
        plot(Spectro{3},(nanmean(SaveSpec{mm,1})),'r')
        hold on
        plot(Spectro{3},(nanmean(SaveSpec{mm,2})),'b')
        title(MouseName{mm})
        xlim([1 15]),line([3 3],ylim,'color','k','linewidth',2,'linestyle',':'),line([5 5],ylim,'color','k','linewidth',2,'linestyle',':')
    end
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    fig=figure;fig.Name=[Struc{ss},'Av spec onf'];
    MeanSpecShk=[];    MeanSpecNoShk=[];
    for mm=1:size(Files.path,2)
        if not(isempty(SaveSpec{mm,1}))
            % normalize by total power for between mice
            % averaging
            MeanSpecNoShk=[MeanSpecNoShk;Spectro{3}.*(nanmean(SaveSpec{mm,1})./nanmean(nanmean(SaveSpec{mm,1}(:,LimFreq:end))))];
        end
        if not(isempty(SaveSpec{mm,2}))
            MeanSpecShk=[MeanSpecShk;Spectro{3}.*(nanmean(SaveSpec{mm,2})./nanmean(nanmean(SaveSpec{mm,2}(:,LimFreq:end))))];
        end
    end
    hold on
    g=shadedErrorBar(Spectro{3},nanmean(MeanSpecShk),[stdError(MeanSpecShk);stdError(MeanSpecShk)],'b')
    g=shadedErrorBar(Spectro{3},nanmean(MeanSpecNoShk),[stdError(MeanSpecNoShk);stdError(MeanSpecNoShk)],'r')
    xlim([1 15]),line([3 3],ylim,'color','k'),line([5 5],ylim,'color','k')
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    fig=figure;fig.Name=[Struc{ss},'Av spec'];
    MeanSpecShk=[];    MeanSpecNoShk=[];
    for mm=1:size(Files.path,2)
        if not(isempty(SaveSpec{mm,1}))
            MeanSpecNoShk=[MeanSpecNoShk;nanmean((SaveSpec{mm,1}))];
        end
        if not(isempty(SaveSpec{mm,2}))
            MeanSpecShk=[MeanSpecShk;nanmean((SaveSpec{mm,2}))];
        end
    end
    hold on
    g=shadedErrorBar(Spectro{3},nanmean(log(MeanSpecShk)),[stdError(log(MeanSpecShk));stdError(log(MeanSpecShk))],'b')
    g=shadedErrorBar(Spectro{3},nanmean(log(MeanSpecNoShk)),[stdError(log(MeanSpecNoShk));stdError(log(MeanSpecNoShk))],'r')
    xlim([1 15]),line([3 3],ylim,'color','k'),line([5 5],ylim,'color','k')
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.png'])
    saveas(fig.Number,[SaveFigName,strrep(fig.Name,' ','_'),'.fig'])
    close(fig)
    
    % Look at distributions of peak frequencies
    fig=figure;fig.Name=[Struc{ss},'Freq Dist'];
    f=Spectro{3};
    fShck=[];fNoShck=[];
    for mm=1:size(Files.path,2)
        mm
        for c=1:size(Files.path{mm},2)
            if not(isempty(SaveSpecNoShck{mm,c}))
                for k=1:size(SaveSpecNoShck{mm,c},1)
                    [val,ind]=max(SaveSpecNoShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                    fNoShck=[fNoShck,f(ind)];
                end
            end
        end
        for c=1:size(Files.path{mm},2)
            try
                if not(isempty(SaveSpecShck{mm,c}))
                    for k=1:size(SaveSpecShck{mm,c},1)
                        [val,ind]=max(SaveSpecShck{mm,c}(k,LimFreq:end)); ind=ind+LimFreq;
                        fShck=[fShck,f(ind)];
                    end
                end
            end
        end
        
    end