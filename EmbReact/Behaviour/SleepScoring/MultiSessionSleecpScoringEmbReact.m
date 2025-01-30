function MultiSessionSleecpScoringEmbReact(FileNames)

% This code is an adaptation of the BulbSleepScript code to be able to aply
% the same thresholds to multiple sessions
% This is useful for example when looking at sleep pre and post we want to
% apply the same thresholds for maximum rigour
%% INPUT
% FileNames is the list of folders to use

scrsz = get(0,'ScreenSize');

mindur=3; %abs cut off for events;
ThetaI=[3 3]; %merge and drop
mw_dur=5; %max length of microarousal
sl_dur=15; %min duration of sleep around microarousal
ms_dur=10; % max length of microsleep
wa_dur=20; %min duration of wake around microsleep
smootime=3; % for gamma and theta power

% Get the data for each session
sm_ghi=[];

for f=1:length(FileNames)
    
    cd(FileNames{f})
    res=pwd;

    try
        load([res,'/LFPData/InfoLFP'],'InfoLFP');
        load([res,'/LFPData/LFP',num2str(InfoLFP.channel(1))],'LFP');
    catch
        load('ChannelsToAnalyse/Bulb_deep.mat','channel')
        load([res,'/LFPData/LFP',num2str(channel)],'LFP');
    end
    r=Range(LFP);
    TotalEpoch=intervalSet(0*1e4,r(end));
    
    
    try
        load('ChannelsToAnalyse/dHPC_deep.mat')
        chH=channel;
    catch
        try
            load('ChannelsToAnalyse/dHPC_rip.mat')
            chH=channel;
        catch
            chH=input('please give hippocampus channel for theta ');
        end
    end
    
    try
        load('ChannelsToAnalyse/Bulb_deep.mat')
        chB=channel;
    catch
        chB=input('please give olfactory bulb channel ');
    end
    
    if not(exist('B_Low_Spectrum.mat'))
        HighSpectrum(filename,chB,'B');
        disp('Bulb Spectrum done')
    end
    if not(exist('H_Low_Spectrum.mat'))
        LowSpectrumSB(filename,chH,'H');
        disp('Hpc spectrum done')
    end
    
    clear Epoch PreEpoch stimEpoch
    try
        load StateEpochSB
        Epoch;
    catch
        if ~(exist('B_High_Spectrum.mat', 'file') == 2)
            HighSpectrum(filename,chB,'B');
            disp('Bulb Spectrum done')
        end
        if ~(exist('H_Low_Spectrum.mat', 'file') == 2)
            LowSpectrumSB(filename,chH,'H');
            disp('Hpc spectrum done')
        end
        Epoch=FindNoiseEpoch(filename,chH,0);
    end
    
    
    TotalEpoch=and(TotalEpoch,Epoch);
    TotalEpoch=CleanUpEpoch(TotalEpoch);
    ThreshEpoch{f}=CleanUpEpoch(TotalEpoch);
    close all;
    
    %Get gamma
    load(strcat('LFPData/LFP',num2str(chB),'.mat'));
    FilGamma=FilterLFP(LFP,[50 70],1024);
    HilGamma=hilbert(Data(FilGamma));
    H=abs(HilGamma);
    tot_ghi=Restrict(tsd(Range(LFP),H),Epoch);
    smooth_ghi_allsess{f}=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
    sm_ghi=[sm_ghi;Data(Restrict(smooth_ghi_allsess{f},ThreshEpoch{f}))];
    
    % Get theta
    load(strcat('LFPData/LFP',num2str(chH),'.mat'));
    FilTheta=FilterLFP(LFP,[5 10],1024);
    FilDelta=FilterLFP(LFP,[2 5],1024);
    HilTheta=hilbert(Data(FilTheta));
    HilDelta=hilbert(Data(FilDelta));
    H=abs(HilDelta);
    H(H<100)=100;
    ThetaRatio=abs(HilTheta)./H;
    ThetaRatioTSD=tsd(Range(FilTheta),ThetaRatio);
    smooth_Theta_allsess{f}=tsd(Range(ThetaRatioTSD),runmean(Data(ThetaRatioTSD),ceil(smootime/median(diff(Range(ThetaRatioTSD,'s'))))));
end
keyboard

% get gamma thresh
gamma_thresh=GetGammaThresh(sm_ghi);
gamma_thresh=exp(gamma_thresh);

rat_theta=[];
for f=1:length(FileNames)
    sleepper=thresholdIntervals(smooth_ghi_allsess{f},gamma_thresh,'Direction','Below');
    sleepper=mergeCloseIntervals(sleepper,mindur*1e4);
    sleepper=dropShortIntervals(sleepper,mindur*1e4);
    rat_theta=[rat_theta;log(Data(Restrict((smooth_Theta_allsess{f}),sleepper)))];
end

% get rem thresh
theta_thresh=GetThetaThresh(rat_theta);
theta_thresh=exp(theta_thresh);


for f=1:length(FileNames)
    cd(FileNames{f})
    smooth_ghi=smooth_ghi_allsess{f};
    smooth_Theta=smooth_Theta_allsess{f};
    sleepper=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Below');
    sleepper=mergeCloseIntervals(sleepper,mindur*1e4);
    sleepper=dropShortIntervals(sleepper,mindur*1e4);
    ThetaEpoch=thresholdIntervals(smooth_Theta,theta_thresh,'Direction','Above');
    ThetaEpoch=mergeCloseIntervals(ThetaEpoch,ThetaI(1)*1E4);
    ThetaEpoch=dropShortIntervals(ThetaEpoch,ThetaI(2)*1E4);
    save('StateEpochSB','sleepper','gamma_thresh','mindur','chB','smooth_ghi','ThetaEpoch','chH', 'smooth_Theta','ThetaRatioTSD','ThetaI','theta_thresh','-v7.3','-append');
    TotalEpoch=ThreshEpoch{f};
    FindBehavEpochs(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,FileNames{f})
    SleepScoreFigure(FileNames{f},TotalEpoch)
    close all
end

end