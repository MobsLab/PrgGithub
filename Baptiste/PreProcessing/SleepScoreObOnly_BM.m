
function SleepScoreObOnly_BM


if exist('StateEpochSBAllOB.mat')~=2
    
    %% Parameters initialisation
    load('ChannelsToAnalyse/Bulb_deep.mat')
    chB=channel;
    
    filename=cd;
    if filename(end)~='/'
        filename(end+1)='/';
    end
    scrsz = get(0,'ScreenSize');
    
    load(['LFPData/LFP',num2str(chB),'.mat']);
    
    % defining total epoch
    r=Range(LFP);
    TotalEpoch=intervalSet(0*1e4,r(end));
    mindur=3; %abs cut off for events;
    ThetaI=[3 3]; %merge and drop
    mw_dur=5; %max length of microarousal
    sl_dur=15; %min duration of sleep around microarousal
    ms_dur=10; % max length of microsleep
    wa_dur=20; %min duration of wake around microsleep
    minduration = 3; % bout min duration (from sleep scoring algo)
    smootime = 3; % smooth time from sleep scoring algo
    
    % Create OB Low spectrum
    if exist('B_Low_Spectrum.mat')==0
        LowSpectrumSB(filename,chB,'B');
        disp('Bulb Spectrum done')
    end
    
    % Create OB High spectrum
    if exist('B_High_Spectrum.mat')==0
        HighSpectrum(filename,chB,'B');
        disp('Bulb Spectrum done')
    end
    
    % % Middle Spectrum
    % if exist('B_Middle_Spectrum.mat')==0
    %     MiddleSpectrum_BM(filename,chB,'B');
    %     disp('Bulb Spectrum done')
    % end
    
    % defining noise and epochs
    if exist('StateEpochSB.mat')==0
        ThreshEpoch=TotalEpoch;
        FindNoiseEpoch_BM([cd filesep],channel,0);
        load('StateEpochSB.mat')
        ThreshEpoch = Epoch-TotalNoiseEpoch;
    else
        load('StateEpochSB.mat')
        ThreshEpoch = Epoch-TotalNoiseEpoch;
    end
    
    % create gamma tsd and sleep epoch
    FindGammaEpoch(ThreshEpoch,chB,mindur,filename);
%     FindGammaEpoch_AG(ThreshEpoch,chB,mindur,filename); % with ferret values, 40-60Hz

    
    %% SleepScoring on OB 10-20 Hz
    load('StateEpochSB.mat', 'sleepper')
    save('StateEpochSBAllOB.mat','chB','sleepper')
    Find1020Epoch(ThreshEpoch,ThetaI,chB,filename);
    close all
    
    name_to_use=strcat(filename,'StateEpochSBAllOB');
    OBfrequency='1020';
    
    load('StateEpochSBAllOB.mat', 'TenTwentyEpoch', 'smooth_1020', 'TenTwenty_thresh')
    TenFifEpoch = TenTwentyEpoch;
    TenFif_thresh = TenTwenty_thresh;
    save('StateEpochSBAllOB.mat', 'TenFifEpoch','TenFif_thresh','-append')
    
    FindBehavEpochsAllOB(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename,name_to_use)
    
    PlotEp=TotalEpoch;
    SleepScoreFigureAllOB(filename,PlotEp,OBfrequency,name_to_use,smooth_1020)
    close all
    
%     %% SleepScoring on OB 15-25 Hz
%     save('StateEpochSBAllOB_Bis.mat','chB')
%     Find1525Epoch(ThreshEpoch,ThetaI,chB,filename);
%     close all
%     
%     name_to_use=strcat(filename,'StateEpochSBAllOB_Bis')
%     OBfrequency='1525';
%     
%     load('StateEpochSBAllOB_Bis.mat','smooth_1525')
%     FindBehavEpochsAllOB(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename,name_to_use)
%     PlotEp=TotalEpoch;
%     SleepScoreFigureAllOB(filename,PlotEp,OBfrequency,name_to_use,smooth_1525)
%     
%     close all
%     
%     %% SleepScoring on OB 20-30 Hz
%     save('StateEpochSBAllOB_Ter.mat','chB')
%     Find2030Epoch(ThreshEpoch,ThetaI,chB,filename);
%     close all
%     name_to_use=strcat(filename,'StateEpochSBAllOB_Ter')
%     OBfrequency='2030';
%     
%     load('StateEpochSBAllOB_Ter.mat', 'smooth_2030')
%     FindBehavEpochsAllOB(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename,name_to_use)
%     PlotEp=TotalEpoch;
%     SleepScoreFigureAllOB(filename,PlotEp,OBfrequency,name_to_use,smooth_2030)
%     
    close all
end

