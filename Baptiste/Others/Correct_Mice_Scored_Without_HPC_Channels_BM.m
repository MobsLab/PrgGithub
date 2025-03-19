clear all
GetEmbReactMiceFolderList_BM
for mouse =1:length(Mouse) % generate all sessions of interest
    AllSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
end

Mouse = [1144 1146 1147 1174 9184 11147 11184 1184];

for mouse = 1:length(Mouse)
    
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    for sess = 1:length( AllSleepSess.(Mouse_names{mouse}))
        
        cd(AllSleepSess.(Mouse_names{mouse}){sess})
        if ~exist('StateEpochSBAllOB.mat')
            
            delete H_Low_Spectrum.mat
            delete SleepScoring.png
            delete SleepScoring.eps
            
            load('StateEpochSB.mat', 'chB')
            load('StateEpochSB.mat', 'TotalNoiseEpoch')
            load('StateEpochSB.mat', 'Epoch')
            
            filename=cd;
            if filename(end)~='/'
                filename(end+1)='/';
            end
            scrsz = get(0,'ScreenSize');
            load('ChannelsToAnalyse/Bulb_deep.mat')
            chB=channel;
            
            load(['LFPData/LFP',num2str(chB),'.mat']);
            LFP;
            
            r=Range(LFP);
            TotalEpoch=intervalSet(0*1e4,r(end));
            mindur=3; %abs cut off for events;
            ThetaI=[3 3]; %merge and drop
            mw_dur=5; %max length of microarousal
            sl_dur=15; %min duration of sleep around microarousal
            ms_dur=10; % max length of microsleep
            wa_dur=20; %min duration of wake around microsleep
            ThreshEpoch=TotalEpoch;
            
            TotalEpoch=and(TotalEpoch,Epoch);
            TotalEpoch=CleanUpEpoch(TotalEpoch);
            ThreshEpoch=and(ThreshEpoch,Epoch);
            ThreshEpoch=CleanUpEpoch(ThreshEpoch);
            save('StateEpochSBAllOB.mat','chB')
            Find1520Epoch(ThreshEpoch,ThetaI,chB,filename);
            
            close
            
            name_to_use=strcat(filename,'StateEpochSBAllOB')
            OBfrequency='1520';
            
            %% Step 3 - Behavioural Epochs
            FindBehavEpochsAllOB(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename,name_to_use)
            
            %% Step 4 - Sleep scoring figure
            PlotEp=TotalEpoch;
            
            load('StateEpochSBAllOB.mat', 'smooth_1520')
            SleepScoreFigureAllOB(filename,PlotEp,OBfrequency,name_to_use,smooth_1520)
            close 
            delete StateEpochSB.mat
            
            clearvars -except mouse sess Mouse Mouse_names AllSleepSess
        end
    end
end
