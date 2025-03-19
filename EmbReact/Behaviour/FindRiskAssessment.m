%% Compress frames
clear all
Options.DownSample=1;
Options.RemoveMask=1;
Options.Visualization=0;
MouseToAvoid=[560,117,431]; % mice with noisy data to exclude
SessNames={ 'HabituationNight' 'TestPreNight' 'UMazeCond_EyeShock' 'TestPostNight',...
     'ExtinctionNight'}


% {'Habituation24HPre_EyeShock' 'Habituation_EyeShock',...
%     'TestPre_EyeShock' 'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock',...
%     'TestPost_EyeShock' 'Extinction_EyeShock'};
%     'Habituation_EyeShockTempProt' 'TestPre_EyeShockTempProt' 'WallHabSafe_EyeShockTempProt' 'WallHabShock_EyeShockTempProt' 'WallCondShock_EyeShockTempProt' 'WallCondSafe_EyeShockTempProt' ,...
%     'TestPost_EyeShockTempProt' 'WallExtShock_EyeShockTempProt' 'WallExtSafe_EyeShockTempProt',...
% 'Habituation' 'TestPre' 'UMazeCond' 'TestPost' 'Extinction',...
%     'HabituationNight' 'TestPreNight' 'UMazeCondNight' 'TestPostNight' 'ExtinctionNight',...
Lim=0.55;
MakePlot=0;

pb=1;
figure
for ss=3%length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            disp(Dir.path{d}{dd})
            load('behavResources_SB.mat')
            if 1%not(isfield(Behav,'RAUser'))
                tps=Range(Behav.LinearDist);
                
                rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/chronux2/spectral_analysis/continuous')
                [YMax,XMax]=findpeaks(-runmean(Data(Behav.LinearDist),5),'MaxPeakWidth',300,'MinPeakHeight',-Lim,'MinPeakDistance',100,'MinPeakProminence',0.1);
                YMax=-YMax;
                XMax(YMax<0.2)=[];
                YMax(YMax<0.2)=[];
                addpath('/home/vador/Dropbox/Kteam/PrgMatlab/chronux2/spectral_analysis/continuous')
                RAEpoch=intervalSet(tps(XMax)-2*1e4,tps(XMax)+2*1e4);
%                 RAEpoch=and(RAEpoch,intervalSet(0,200*1e4));
                if exist('TTLInfo')
                    if not(isempty(TTLInfo))
                    if not(isempty(TTLInfo.StimEpoch))
                        StimEpoch=intervalSet(Start(TTLInfo.StimEpoch)-2*1e4,Stop(TTLInfo.StimEpoch)+2*1e4);
                    else
                        StimEpoch=intervalSet(0,0.1);
                    end
                    else
                        StimEpoch=intervalSet(0,0.1);
                    end
                else
                    StimEpoch=intervalSet(0,0.1);
                    
                end
                RAEpochTemp=RAEpoch-StimEpoch;
                DurEp=Stop(RAEpochTemp,'s')-Start(RAEpochTemp,'s');
                ToKeep=find(DurEp>3.5);
                RAEpoch=subset(RAEpoch,ToKeep);
                RAEpoch=intervalSet(Start(RAEpoch)+1.5*1e4,Start(RAEpoch)+2.5*1e4);
                clf
                subplot(211)
                plot(Range(Behav.LinearDist,'s'),Data(Behav.LinearDist))
                hold on
                plot(Range(Restrict(Behav.LinearDist,RAEpoch),'s'),Data(Restrict(Behav.LinearDist,RAEpoch)),'r*')
                try,
                    plot(Start(TTLInfo.StimEpoch,'s'),0.9,'k.','MarkerSize',40)
                    plot(Start(TTLInfo.StimEpoch,'s'),0.9,'y.','MarkerSize',30), end
                line(xlim,[1 1]*0.5,'linewidth',3,'color','b')
                line(xlim,[1 1]*0.2,'linewidth',2,'color','k')
                line(xlim,[1 1]*0.8,'linewidth',2,'color','k')
                RAEp.ToShock=RAEpoch;
                size(Start(RAEpoch))
                
                clear RAEpoch
                rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/chronux2/spectral_analysis/continuous')
                [YMax,XMax]=findpeaks(runmean(Data(Behav.LinearDist),5),'MaxPeakWidth',300,'MinPeakHeight',Lim,'MinPeakDistance',100,'MinPeakProminence',0.1);
                XMax(YMax>0.8)=[];
                YMax(YMax>0.8)=[];
                addpath('/home/vador/Dropbox/Kteam/PrgMatlab/chronux2/spectral_analysis/continuous')
                RAEpoch=intervalSet(tps(XMax)-2*1e4,tps(XMax)+2*1e4);
%                 RAEpoch=and(RAEpoch,intervalSet(0,200*1e4));
                RAEpochTemp=RAEpoch-StimEpoch;
                DurEp=Stop(RAEpochTemp,'s')-Start(RAEpochTemp,'s');
                ToKeep=find(DurEp>3.5);
                RAEpoch=subset(RAEpochTemp,ToKeep);
                RAEpoch=intervalSet(Start(RAEpoch)+1.5*1e4,Start(RAEpoch)+2.5*1e4);
                plot(Range(Restrict(Behav.LinearDist,RAEpoch),'s'),Data(Restrict(Behav.LinearDist,RAEpoch)),'g*')
                RAEp.ToSafe=RAEpoch;
                size(Start(RAEpoch))
                
                
                Behav.RAUser.ToSafe=[];
                Behav.RAUser.ToShock=[];
                Behav.RAEpoch=RAEp;

                if MakePlot & or(not(isempty(Start(RAEp.ToSafe))),not(isempty(Start(RAEp.ToShock))))
                    if exist('CompressedFramesbis.mat')
                        movefile('CompressedFramesbis.mat','CompressedFrames.mat')
                    end
                    load('CompressedFrames.mat')
                    tps=Range(Behav.Ytsd,'s');
                    FrameSize=size(Params.ref);
                    subplot(212)
                    ListOfTimes=Start(RAEp.ToShock,'s');
                    tp=1;
                    b=double(zeros(FrameSize));
                    for i=1:length(CompressionInfo.Location)
                        bnew=b(:);
                        bnew(CompressionInfo.Location{i})=bnew(CompressionInfo.Location{i})+double(CompressionInfo.Value{i});
                        bnew=reshape(bnew,FrameSize(1),FrameSize(2));
                        if sum(tps(i)>(Start(RAEp.ToShock,'s')-5)&tps(i)<(Start(RAEp.ToShock,'s')+5))>0
                            imagesc(bnew)
                            title(num2str(tps(i)))
                            pause(0.05)
                            if sum(tps(i)>(Start(RAEp.ToShock,'s')-3)&tps(i)<(Start(RAEp.ToShock,'s')+3))>0
                                colormap hot
                            else
                                colormap gray
                            end
                            
                        end
                        if tp<=length(ListOfTimes)
                            if or(tps(i)>ListOfTimes(tp)+10,tps(i)>ListOfTimes(tp)&tps(i)==max(tps))
                                Behav.RAUser.ToShock(tp)=input('RA 0,1,2?');
                                tp=tp+1;
                            end
                        end
                        b=bnew;
                    end
                    
                    ListOfTimes=Start(RAEp.ToSafe,'s');
                    tp=1;
                    b=double(zeros(FrameSize));
                    for i=1:length(CompressionInfo.Location)
                        bnew=b(:);
                        bnew(CompressionInfo.Location{i})=bnew(CompressionInfo.Location{i})+double(CompressionInfo.Value{i});
                        bnew=reshape(bnew,FrameSize(1),FrameSize(2));
                        if sum(tps(i)>(Start(RAEp.ToSafe,'s')-5)&tps(i)<(Start(RAEp.ToSafe,'s')+5))>0
                            imagesc(bnew)
                            title(num2str(tps(i)))
                            pause(0.05)
                            if sum(tps(i)>(Start(RAEp.ToSafe,'s')-3)&tps(i)<(Start(RAEp.ToSafe,'s')+3))>0
                                colormap hot
                            else
                                colormap gray
                            end
                            
                        end
                        if tp<=length(ListOfTimes)
                            if or(tps(i)>ListOfTimes(tp)+10,tps(i)>ListOfTimes(tp)&tps(i)==max(tps))
                                Behav.RAUser.ToSafe(tp)=input('RA 0,1,2?');
                                tp=tp+1;
                            end
                        end
                        b=bnew;
                    end
                end
                
                disp(['SAFE: Epochs ',num2str(length(Start(Behav.RAEpoch.ToSafe))),' UserInputs ',num2str(length(Behav.RAUser.ToSafe))])
                disp(['SHOCK: Epochs ',num2str(length(Start(Behav.RAEpoch.ToShock))),' UserInputs ',num2str(length(Behav.RAUser.ToShock))])
                keyboard
%                 save('behavResources_SB.mat','Behav','-append')
                clear Behav RAEpoch RAEp XMax YMax DurEp ToKeep StimEpoch CompressionInfo 
            end
        end
    end
end
