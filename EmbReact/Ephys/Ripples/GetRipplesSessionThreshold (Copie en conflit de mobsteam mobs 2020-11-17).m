%% Ripple detection
%Info structure


Info.hemisphere = 'R';
Info.scoring = [];

Info.threshold = [5 7];
Info.durations = [150 20 200];
Info.frequency_band = [120 250];
Info.EventFileName='HPCRipples.evt.s00';
MouseToAvoid=[560,117]; % mice with noisy data to exclude

for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
%             if (Dir.ExpeInfo{d}{dd}.nmouse==MouseToDo)
                            if (Dir.ExpeInfo{d}{dd}.nmouse>568)

%                     if not(isempty(Dir.ExpeInfo{d}{dd}.Ripples)) & not(isnan(Dir.ExpeInfo{d}{dd}.Ripples))
                cd(Dir.path{d}{dd})
                go = 0;
                if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                    if (exist('Ripples.mat'))>0
                        clear RipplesEpochR
                        load('Ripples.mat')
                        try RipplesEpochR
                        catch
                            go = 1;
                        end
                    else go=1;
                    end
                end
                
                if go
                    disp(Dir.path{d}{dd})
                    delete('HPCRipplesSleepThresh.evt.s01')
                    delete('HPCRipplesSleepThresh.evt.s00.evt.rir')
                    delete('HPCRipples.evt.s00.evt.rir')
                    delete('HPCRipples.evt.s00')
                    
                    load('ExpeInfo.mat')
                    load('ChannelsToAnalyse/dHPC_rip.mat')
                    load(['LFPData/LFP',num2str(channel),'.mat'])
                    Info.channel = channel;
                    
                    load('StateEpochSB.mat','TotalNoiseEpoch')
                    
                    if ExpeInfo.SleepSession==0
                        load('behavResources_SB.mat')
                        if isempty(Behav.FreezeAccEpoch)
                            Info.Epoch=Behav.FreezeEpoch-TotalNoiseEpoch;
                        else
                            Info.Epoch=Behav.FreezeAccEpoch-TotalNoiseEpoch;
                        end
                        clear Behav
                    else
                        load('StateEpochSB.mat','SWSEpoch')
                        Info.Epoch=SWSEpoch-TotalNoiseEpoch;
                        clear SWSEpoch
                    end
                    
                        %% ripples detection SB
                        [Ripples, meanVal, stdVal] = FindRipplesKJ(LFP, Info.Epoch, 'frequency_band',Info.frequency_band, 'threshold',Info.threshold, 'durations',Info.durations);
                        RipplesEpoch = intervalSet(Ripples(:,1)*10, Ripples(:,3)*10);
                        
                        eval(['RipplesEpoch' Info.hemisphere '= RipplesEpoch;']);
                        eval(['ripples_Info' Info.hemisphere '= Info;']);
                        eval(['Ripples' Info.hemisphere '= Ripples;']);
                        eval(['meanVal' Info.hemisphere '= meanVal;']);
                        eval(['stdVal' Info.hemisphere '= stdVal;']);
                        
                        PlotRipRaw(LFP,Ripples(:,2)/1e3);
                        
                        saveas(1,'Ripples.fig');
                        saveas(1,'Ripples.png');
                        close all
                        
                        %% save
                        save('Ripples.mat', ['RipplesEpoch' Info.hemisphere], ['ripples_Info' Info.hemisphere], ['Ripples' Info.hemisphere], ['meanVal' Info.hemisphere], ['stdVal' Info.hemisphere])
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
                    
                    
                    Info=rmfield(Info,'Epoch');
                    Info=rmfield(Info,'channel');
                    
                    if exist('H_VHigh_Spectrum.mat')==0
                        VeryHighSpectrum([cd filesep],channel,'H')
                    end
                    clear LFP channel ExpeInfo
                    
                end
                %   end
            end
        end
    end
end