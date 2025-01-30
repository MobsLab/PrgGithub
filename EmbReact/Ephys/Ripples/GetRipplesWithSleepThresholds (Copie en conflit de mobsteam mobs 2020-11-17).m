%% Ripple detection
%Info structure

Info.hemisphere = 'R';
Info.scoring = [];

Info.threshold = [5 7];
Info.durations = [150 20 200];
Info.frequency_band = [120 250];
Info.EventFileName='HPCRipplesSleepThresh.evt.s01';
MouseToAvoid=[560,425,117]; % mice with noisy data to exclude

for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
%             if (Dir.ExpeInfo{d}{dd}.nmouse==MouseToDo)
                            if (Dir.ExpeInfo{d}{dd}.nmouse>568)
                
             %   if not(isempty(Dir.ExpeInfo{d}{dd}.Ripples)) & not(isnan(Dir.ExpeInfo{d}{dd}.Ripples))
                    cd(Dir.path{d}{dd})
                    if exist('ChannelsToAnalyse/dHPC_rip.mat')>0 
                    disp(Dir.path{d}{dd})
                        delete('Ripples_WholeSession.mat');
                        load('ExpeInfo.mat')
                        load('ChannelsToAnalyse/dHPC_rip.mat')
                        load(['LFPData/LFP',num2str(channel),'.mat'])
                        load('StateEpochSB.mat','TotalNoiseEpoch')
                        Info.channel = channel;
                        TotalEpoch = intervalSet(0,max(Range(LFP)));
                        
                        if ExpeInfo.SleepSession==0
                            load('behavResources_SB.mat')
                            Info.Epoch=TotalEpoch-TotalNoiseEpoch;
                            clear Behav
                        else
                            load('StateEpochSB.mat','SWSEpoch')
                            Info.Epoch=SWSEpoch-TotalNoiseEpoch;
                            clear SWSEpoch
                        end
                        
                        %Get Ripple lims from sleep
                        FileName=FindSleepFile_EmbReact_SB(ExpeInfo.nmouse,ExpeInfo.date);
                        if not(isempty(FileName.UMazeDay))
                            cd(FileName.UMazeDay)
                            load('StateEpochSB.mat','SWSEpoch')
                            if sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))>500
                                load('Ripples.mat','meanValR','stdValR')
                                Info.MeanStdVals=[meanValR,stdValR];
                            elseif ExpeInfo.nmouse==569
                                cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse569/20170817/ProjectEmbReact_M569_20170817_SleepPre
                                load('Ripples.mat','meanValR','stdValR')
                                Info.MeanStdVals=[meanValR,stdValR];
                            else
                                keyboard
                            end
                        else
                            cd(FileName.Base)
                            load('StateEpochSB.mat','SWSEpoch')
                            if sum(Stop(SWSEpoch,'s')-Start(SWSEpoch,'s'))>600
                                load('Ripples.mat','meanValR','stdValR')
                                Info.MeanStdVals=[meanValR,stdValR];
                            else
                                keyboard
                            end
                        end
                        
                        clear SWSEpoch meanValR stdValR
                        
                        cd(Dir.path{d}{dd})
                        if not(isempty(Start(Info.Epoch)))
                            %% ripples detection SB
                            [Ripples, meanVal, stdVal] = FindRipplesKJ(LFP, Info.Epoch, 'frequency_band',Info.frequency_band,...
                                'threshold',Info.threshold, 'durations',Info.durations,'mean_std_values',Info.MeanStdVals);
                            RipplesEpoch = intervalSet(Ripples(:,1)*10, Ripples(:,3)*10);
                            
                            eval(['RipplesEpoch' Info.hemisphere '= RipplesEpoch;']);
                            eval(['ripples_Info' Info.hemisphere '= Info;']);
                            eval(['Ripples' Info.hemisphere '= Ripples;']);
                            eval(['meanVal' Info.hemisphere '= meanVal;']);
                            eval(['stdVal' Info.hemisphere '= stdVal;']);
                            
                            PlotRipRaw(LFP,RipplesR(:,2)/1e3);
                            saveas(1,'RipplesSleepThresh.fig');
                            saveas(1,'RipplesSleepThresh.png');
                            close all
                            %% save
                            save('RipplesSleepThresh.mat', ['RipplesEpoch' Info.hemisphere], ['ripples_Info' Info.hemisphere], ['Ripples' Info.hemisphere], ['meanVal' Info.hemisphere], ['stdVal' Info.hemisphere],'Info')
                            %evt classic
                            clear evt
                            extens = 'rip';
                            if ~isempty(Info.hemisphere)
                                extens(end) = lower(Info.hemisphere(1));
                            end
                            
                            evt.time = Ripples(:,2)/1e3; %peaks
                            for i=1:length(evt.time)
                                evt.description{i}= ['ripples' Info.hemisphere];
                            end
                            delete([Info.EventFileName '.evt.' extens]);
                            CreateEvent(evt, Info.EventFileName, extens);
                            
                            clear stdVal meanVal Ripples RipplesEpoch
                            clear(['RipplesEpoch' Info.hemisphere], ['ripples_Info' Info.hemisphere], ['Ripples' Info.hemisphere], ['meanVal' Info.hemisphere], ['stdVal' Info.hemisphere])
                        end
                        
                        Info=rmfield(Info,'Epoch');
                        Info=rmfield(Info,'channel');
                        Info=rmfield(Info,'MeanStdVals');
                        
                        
                    end
                end
    %        end
        end
    end
end