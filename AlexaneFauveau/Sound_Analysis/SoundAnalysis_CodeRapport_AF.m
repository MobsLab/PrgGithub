clear all
%% Load the FolderPath
FolderPath_3Sound_Audiodream_AF

%% Stim counter
SoundValues = {'I50','I60','I70','I80'};
SoundTypes = {'Orage','RD','RU','S20','S80','TWN','T5','T12'};
for st = 1:length(SoundValues)
    for sid = 1:length(SoundTypes)
        n.(SoundTypes{sid}).(SoundValues{st}) = 0;
        ResponsePostStim.(SoundTypes{sid}).(SoundValues{st}) = [];
        MeanValPostStim.(SoundTypes{sid}).(SoundValues{st}) = [];
        MeanValPreStim.(SoundTypes{sid}).(SoundValues{st}) = [];
        tps_stim.(SoundTypes{sid}).(SoundValues{st}) = [];
    end
end


%% Parameters
duration_poststim = 1e8; % e4 -> en secondes
duration_endstim = 10e8 ;  %
duration_preStimSleep = 5e8;


for fol = 1:length(FolderName)
    % Load
    cd(FolderName{fol});
    disp(FolderName{fol});
    load('behavResources.mat')

    %% Get the scoring and raw daya
    %% Get stim events intan
    Stim_Event = [Start(TTLInfo.Sounds)*1e4];
    Stim_Epoch_Start = Stim_Event+duration_poststim;
    Stim_Epoch_End = Stim_Event + duration_endstim;

    %% Create the Stim Epoch
    Epoch_Stim = intervalSet(Stim_Epoch_Start, Stim_Epoch_End);
    Event_Stim = intervalSet(Stim_Event, Stim_Event+0.5e8);

    %% Get stim identity
    load('journal_sons.mat')
    SoundValueJS = cell2mat(journal_sons(:,2));

    sons = journal_sons(:,1);
    orage = strfind(sons ,'orage');
    rd = strfind(sons ,'Ramps_down');
    ru = strfind(sons ,'Ramps_up');
    s20 = strfind(sons ,'Sin20');
    s80 = strfind(sons ,'Sin80');
    twn = strfind(sons ,'Tono_70dB_WN');
    t5 = strfind(sons ,'Tono_70dB_5kHz');
    t12 = strfind(sons ,'Tono_70dB_12kHz');

    ior = [];
    for i = 1:length(sons)
        if (orage{i}==1)==1
            ior = [ior i];
        end
    end
        for sv = 1:length(SoundValues)
        tps_stim.(SoundTypes{1}).(SoundValues{sv}) = Stim_Event(ior(SoundValueJS(ior)==eval(SoundValues{sv}(2:end))));
        end

    ior = [];
    for i = 1:length(sons)
        if (rd{i}==1)==1
            ior = [ior i];
        end
    end
        for sv = 1:length(SoundValues)
        tps_stim.(SoundTypes{2}).(SoundValues{sv}) = Stim_Event(ior(SoundValueJS(ior)==eval(SoundValues{sv}(2:end))));
        end

    ior = [];   
    for i = 1:length(sons)
        if (ru{i}==1)==1
            ior = [ior i];
        end
    end  
    for sv = 1:length(SoundValues)
        tps_stim.(SoundTypes{3}).(SoundValues{sv}) = Stim_Event(ior(SoundValueJS(ior)==eval(SoundValues{sv}(2:end))));
    end

    ior = [];
    for i = 1:length(sons)
        if (s20{i}==1)==1
            ior = [ior i];
        end
    end  
    for sv = 1:length(SoundValues)
        tps_stim.(SoundTypes{4}).(SoundValues{sv}) = Stim_Event(ior(SoundValueJS(ior)==eval(SoundValues{sv}(2:end))));
    end

    ior = [];
    for i = 1:length(sons)
        if (s80{i}==1)==1
            ior = [ior i];
        end
    end  
    for sv = 1:length(SoundValues)
        tps_stim.(SoundTypes{5}).(SoundValues{sv}) = Stim_Event(ior(SoundValueJS(ior)==eval(SoundValues{sv}(2:end))));
    end

    ior = [];
    for i = 1:length(sons)
        if (twn{i}==1)==1
            ior = [ior i];
        end
    end
    for sv = 1:length(SoundValues)
        tps_stim.(SoundTypes{6}).(SoundValues{sv}) = Stim_Event(ior(SoundValueJS(ior)==eval(SoundValues{sv}(2:end))));
    end

    ior = [];
    for i = 1:length(sons)
        if (t5{i}==1)==1
            ior = [ior i];
        end
    end 
    for sv = 1:length(SoundValues)
        tps_stim.(SoundTypes{7}).(SoundValues{sv}) = Stim_Event(ior(SoundValueJS(ior)==eval(SoundValues{sv}(2:end))));
    end

    ior = [];
    for i = 1:length(sons)
        if (t12{i}==1)==1
            ior = [ior i];
        end
    end 
    for sv = 1:length(SoundValues)
        tps_stim.(SoundTypes{8}).(SoundValues{sv}) = Stim_Event(ior(SoundValueJS(ior)==eval(SoundValues{sv}(2:end))));
    end
    
    
    for nmice = 1615:1620
        filename = sprintf('%d_PiezoData_SleepScoring.mat', nmice);
        % Load the specific variable from the file
        load(filename,'Piezo_Mouse_tsd')


        Smooth_actimetry = tsd(Range(Piezo_Mouse_tsd), abs(zscore(Data(Piezo_Mouse_tsd)))); % smooth time =3s
        SlSc.Piez = load(filename,'WakeEpoch_Piezo','SleepEpoch_Piezo');
        SlSc.Piez.Wake = SlSc.Piez.WakeEpoch_Piezo;
        SlSc.Piez.Sleep = SlSc.Piez.SleepEpoch_Piezo;
        SlSc.Piez = rmfield(SlSc.Piez,{'WakeEpoch_Piezo','SleepEpoch_Piezo'});
        SlSc.Piez.Raw = Smooth_actimetry;

        %%
        for sid = 1:length(SoundTypes)
            for st = 1:length(SoundValues)
                PreStimEpoch = intervalSet(tps_stim.(SoundTypes{sid}).(SoundValues{st})-duration_preStimSleep,tps_stim.(SoundTypes{sid}).(SoundValues{st})-0.2*1e8);

                if length(Start(PreStimEpoch))>0
                    % Get the sleepy stims
                    clear PreStimSleep
                    clear StimStart_InSleep
                    clear StimStart_InSleep_vect
                    for stim = 1:length(Start(PreStimEpoch))
                        PreStimEpoch_OfInterest = subset(PreStimEpoch,stim);
                        PreStimSleep(stim) = sum(Stop(and(PreStimEpoch_OfInterest,SlSc.Piez.Sleep)) - Start(and(PreStimEpoch_OfInterest,SlSc.Piez.Sleep)));
                    end
                    StimStart_InSleep = ts(tps_stim.(SoundTypes{sid}).(SoundValues{st})(PreStimSleep>(duration_preStimSleep-0.3*1e8)));

                    if  length(Range(StimStart_InSleep))>0
                        StimStart_InSleep_vect = Range(StimStart_InSleep);

                            % Quantity of wake post stim
                            for stim = 1:length(StimStart_InSleep)  
                                EpochAfterStim = intervalSet(StimStart_InSleep_vect(stim)+duration_poststim,StimStart_InSleep_vect(stim)+duration_endstim);
                                n.(SoundTypes{sid}).(SoundValues{st}) = n.(SoundTypes{sid}).(SoundValues{st})+1;
                                WakeTimePostStim.(SoundTypes{sid}).(SoundValues{st})(n.(SoundTypes{sid}).(SoundValues{st}),1) = ...
                                    sum(Stop(and(SlSc.Piez.Wake,EpochAfterStim)) - Start(and(SlSc.Piez.Wake,EpochAfterStim)))/1e8;
                            end

                            % Response profile raw data post stim
                            [M,T] = PlotRipRaw(SlSc.Piez.Raw,Range(StimStart_InSleep,'s'),[-10 10]*1e3,0,0,0);
                            T(T==0) = NaN;
                            %                     T = naninterp(T')';
                            ResponsePostStim.(SoundTypes{sid}).(SoundValues{st}) = [ResponsePostStim.(SoundTypes{sid}).(SoundValues{st});T];
                            time.(SoundTypes{sid}) = M(:,1);
                            % Average value of raw data post stim
                            MeanValPostStim.(SoundTypes{sid}).(SoundValues{st}) = [MeanValPostStim.(SoundTypes{sid}).(SoundValues{st});nanmean(T(:,end/2+1:end),2)];
                            MeanValPreStim.(SoundTypes{sid}).(SoundValues{st}) = [ MeanValPreStim.(SoundTypes{sid}).(SoundValues{st});nanmean(T(:,1:end/2-1),2)];

                    end
                end
            end
        end
    end
end


%% Plot Duration of wake (WakeTimePostStim), with statistical tests 

cols = magma(length(SoundValues));

figure
for st = 2:length(SoundTypes)
    subplot(1,length(SoundTypes),st)
    A = {WakeTimePostStim.(SoundTypes{st}).(SoundValues{1}),WakeTimePostStim.(SoundTypes{st}).(SoundValues{2}),...
       WakeTimePostStim.(SoundTypes{st}).(SoundValues{3}),WakeTimePostStim.(SoundTypes{st}).(SoundValues{4})};
    Cols = {[0.0015 0.0005 0.0139],[0.3151 0.0712 0.4848],[0.7132    0.2139    0.4763],[0.9859    0.5300    0.3801]};
    X = [1,2,3,4];
    Legends = {'50dB','60dB','70dB','80dB'};
    ShowPoints = 1;
    [boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints);
    ylabel('Durée des épisodes de sommeil en seconde')
    title(SoundTypes{st})

    n = 1;
    for i = 1:length(A)
        for j = i+1:length(A)
            % Perform Wilcoxon-Mann-Whitney test
            p(n)= ranksum(A{i},A{j});
            % Display p-value on the plot
            disp(['Data for ' SoundTypes{st} ' with stimulation ' (SoundValues{i}) 'et' (SoundValues{j}) ' p = ' num2str(p)]);
            nbi(n) = i
            nbj(n) = j
            n = n+1;
        end
    end
    for n = 1:3
        sigstar_DB([nbi(n) nbj(n)], p(n))
    end    
end














