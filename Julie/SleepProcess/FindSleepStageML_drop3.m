%FindSleepStageML.m

function [SWS,REM,WAKE,OsciEpoch,noise,SIEpoch,Immob_drop3]=FindSleepStageML_drop3(nameChannel)
% e.g.
% [SWS,REM,WAKE,OsciEpoch,noise]=FindSleepStageML('PFCx_deep');
% used in FindNREMepochsML.m

% inputs:
% nameChannel = name in channeltoAnalyse fo spindles/oscillation analy
%
% outputs:
% SWS,REM,WAKE,OsciEpoch,noise
% WAKE et Sleep are merge/drop by 5s
% REM and SWS are merge by 3s but no drop (REM and SWS are not exclusive)
sav=0;
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< MERGE/DROP CRITERIONS <<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

mergeSleep=3; % movement smaller than 3s included in sleep 
% immob smaller than 3s included in wake 
win=5; %s
dropSleep=3; %15;%s
res=pwd;
% use MovThresh if exists
try 
    load([res,'/StateEpochSubStages.mat'],'MovThresh');
catch
    if sav
    save([res,'/StateEpochSubStages.mat'],'mergeSleep');
    end
end



% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< LOADING THETA & MOVEMENT <<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

disp(' ');
try
    load StateEpoch.mat ImmobEpoch_drop3
    ImmobEpoch_drop3;
catch
    try
        % ---------------------------------------------------------------------
        % ----------------------------- theta ---------------------------------
        load StateEpoch.mat ThetaRatioTSD ThetaThresh 
        ThetaRatioTSD; ThetaThresh; 
        ThetaEpoch=thresholdIntervals(ThetaRatioTSD,ThetaThresh,'Direction','Above');
        ThetaEpoch=mergeCloseIntervals(ThetaEpoch,win*1E4);
        ThetaEpoch=dropShortIntervals(ThetaEpoch,win*1E4);
        ThetaEpoch=CleanUpEpoch(ThetaEpoch);

        % ---------------------------------------------------------------------
        % --------------------------- movement --------------------------------

        load StateEpoch.mat ImmobEpoch ManualScoring Mmov
        if ~exist('ManualScoring','var'); ManualScoring={'no'};end
        if strcmp(ManualScoring,'no')
            % use MovThresh if exists in StateEpochSubStages.mat
            if ~exist('MovThresh','var')
                % redefine Mmov only for Movtsd
                try 
                    load('behavResources.mat','Movtsd','MovAcctsd')
                    if ~exist('Movtsd','var'), Movtsd=tsd(double(Range(MovAcctsd)),double(Data(MovAcctsd)));end
                    rg=Range(Movtsd); 
                    %val=SmoothDec(Data(Movtsd),5);
                    %Mmov=tsd(rg(1:10:end),val(1:10:end));
                    Mmov=Movtsd;
                    WholeEpoch=intervalSet(min(rg),max(rg));
                end
                try
                    okThresh='n';
                    while okThresh~='y'
                        figure, plot(Range(Mmov,'s'),Data(Mmov)); numfthr=gcf;
                        MovThresh=GetGammaThresh(Data(Mmov));close
                        MovThresh=exp(MovThresh);
                        tempImmob=thresholdIntervals(Mmov,MovThresh,'Direction','Below');
                        figure(numfthr), hold on, plot(Range(Restrict(Mmov,tempImmob),'s'),Data(Restrict(Mmov,tempImmob)),'r')
                        okThresh=input('Are you ok with threshold for movement (y/n): ','s');close(numfthr)
                    end
                catch
                    load StateEpoch.mat MovThresh ; disp('using previous thresh from StateEpoch')
                end
                if sav
                save([res,'/StateEpochSubStages_drop3.mat'],'MovThresh');%save([res,'/StateEpochSubStages_drop3.mat'],'-append','MovThresh');
                end
            end
            % sleep
            Immob=thresholdIntervals(Mmov,MovThresh,'Direction','Below');
        else
            Immob=ImmobEpoch;disp ('Manual Scoring -> Immob=ImmobEpoch')
        end

        load StateEpoch.mat GndNoiseEpoch NoiseEpoch WeirdNoiseEpoch

    catch
        disp('problem defining Theta et Immob periods (StateEpoch.mat may not exist)')
        try
            load StateEpochSB.mat Sleep ThetaRatioTSD ThetaEpoch GndNoiseEpoch NoiseEpoch
            Immob=Sleep;

            load behavResources.mat NewtsdZT
            WholeEpoch=intervalSet(min(Range(NewtsdZT)),max(Range(NewtsdZT)));
            disp('Using StateEpochSB.mat')
        end
    end

end
Immob_drop3_raw=Immob;
if sav
    save([res,'/StateEpochSubStages_drop3.mat'],'-append','Immob_drop3_raw');
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<< REFINE SWSEpoch, REMEpoch WITH NEW CRITERIONS <<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  
if exist('Immob','var')
    % --------------------------------------------------------------------- 
    % -------------------------- noise ------------------------------------
    noise=or(GndNoiseEpoch,NoiseEpoch);
    try noise=or(noise,WeirdNoiseEpoch);end
    noise=CleanUpEpoch(noise);
    noise=mergeCloseIntervals(noise,1);
    
    % --------------------------------------------------------------------- 
    % -------------------- immob &  SIEpoch -------------------------------
    Immob=Immob-noise;
    Immob=mergeCloseIntervals(Immob,mergeSleep*1E4);
    SIEpoch=Immob-dropShortIntervals(Immob,dropSleep*1E4);
    Immob=dropShortIntervals(Immob,mergeSleep*1E4);
    
    % --------------------------------------------------------------------- 
    % ------------------------ SWS & REM ----------------------------------
    % REM
    REM=and(Immob,ThetaEpoch)-noise;
    REM=mergeCloseIntervals(REM,win*1E4);
    REM=CleanUpEpoch(REM);
    
    % SWS (not exclusive from REM, repared in DefineSubstages.m)
    SWS=Immob-REM;
    SWS=CleanUpEpoch(SWS);
    SWS=SWS-noise;
    SWS=mergeCloseIntervals(SWS,win*1E4);
    SWS=CleanUpEpoch(SWS);
    
    % --------------------------------------------------------------------- 
    % --------------------------- wake ------------------------------------
    if ~exist('WholeEpoch','var')
        WholeEpoch=intervalSet(min(Range(ThetaRatioTSD)),max(Range(ThetaRatioTSD)));
    end
    WAKE=WholeEpoch-Immob;
    WAKE=WAKE-noise;
    WAKE=CleanUpEpoch(WAKE);
    WAKE=mergeCloseIntervals(WAKE,1);
    
    % --------------------------------------------------------------------- 
    % --------------------------- save ------------------------------------
    if sav
    save([res,'/StateEpochSubStages_drop3.mat'],'-append','win','mergeSleep','dropSleep','ThetaEpoch','Immob','SIEpoch')
    save([res,'/StateEpochSubStages_drop3.mat'],'-append','WholeEpoch','noise','SWS','REM','WAKE');
    end
end  


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< FIND OSCILLATIONS EPOCHS <<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
GotProblem=1;
% FindOsciEpochs.m
newname=nameChannel;
newname(strfind(nameChannel,'_'))=[];
if exist('SWS','var')
    try
        eval(['load(''SleepStagesML',newname,'.mat'',''OsciEpoch'',''WholeEpoch'')'])
        OsciEpoch;
        GotProblem=0;
    catch
        disp('Running FindOsciEpochs on whole sleep epoch (immob)')
        % LOAD LFP corresponding to nameChannel
        disp(['...loading ChannelsToAnalyse/',nameChannel,'.mat'])
        eval(['ch=load(''ChannelsToAnalyse/',nameChannel,'.mat'',''channel'');'])
        disp(['...loading LFPData/LFP',num2str(ch.channel),'.mat'])
        try
            eval(['load(''LFPData/LFP',num2str(ch.channel),'.mat'')'])
            [OsciEpoch, ~, ~, ~, ~, ~, ~]=FindOsciEpochs(LFP,Immob);
            % save
            if sav
            eval(['save(''SleepStagesML',newname,'.mat'',''OsciEpoch'',',...
                '''SWAEpoch'',''BurstEpoch'',''spindles'',''sdTH'',''ISI_th'')']);
            end
            GotProblem=0;
        catch 
            disp('Problem');%
            keyboard
        end
    end
end

if GotProblem
    %default if outputs undefined
    SWS=intervalSet([],[]);
    REM=intervalSet([],[]);
    WAKE=intervalSet([],[]);
    OsciEpoch=intervalSet([],[]);
    noise=intervalSet([],[]);
    SIEpoch=intervalSet([],[]);
    Immob=intervalSet([],[]);
end
