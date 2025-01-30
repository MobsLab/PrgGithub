%GetDeltaML
function [tDelta,DeltaEpoch]=GetDeltaML(NameStructure,Epoch,SWSEpoch)

% define SD on SWSEpoch only, then detect Delta on whole Epoch
% input:
% NameStructure = 'PFCx'
% 
% output:
% tDelta in 1E-4ms. Do tDelta=ts(tDelta);

% see also
% GetSpindlesML.m
% GetRipplesML.m


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% inputs
thD=2;% delta detected above 2SD (SD determined on sws)
th=75;% crucial element for noise detection (75ms) !!
freqDelta=[1 5];
disp('GetDeltaML...')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load if exists
try
    %error
    temp=load('AllDeltaPFCx.mat','tDelta','DeltaEpoch');
    tDelta=temp.tDelta;
    DeltaEpoch=temp.DeltaEpoch;
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% compute
if ~exist('tDelta','var')
    try
        
        %-------------------------------------------------
        % load LFP sup and LFP deep
        eval(['ch1=load(''ChannelsToAnalyse/',NameStructure,'_deep.mat'');'])
        try
            eval(['ch2=load(''ChannelsToAnalyse/',NameStructure,'_sup.mat'');'])
        catch
            eval(['ch2=load(''ChannelsToAnalyse/',NameStructure,'_deltasup.mat'');'])
        end
        eval(['temp1=load(''LFPData/LFP',num2str(ch1.channel),'.mat'');'])
        eegDeep=temp1.LFP;
        eval(['temp2=load(''LFPData/LFP',num2str(ch2.channel),'.mat'');'])
        eegSup=temp2.LFP;
        clear temp1 temp2
        
        %-------------------------------------------------
        % find factor to increase EEGsup signal compared to EEGdeep
        k=1;
        for i=0.1:0.1:4
            S(k)=std(Data(eegDeep)-i*Data(eegSup));
            k=k+1;
        end
        Factor=find(S==min(S))*0.1;
        
        %-------------------------------------------------
        % Difference between EEG deep and EEG sup (*factor)
        EEGsleepD=ResampleTSD(tsd(Range(eegDeep),Factor*Data(eegSup)-Data(eegDeep)),100);
        Filt_EEGd = FilterLFP(EEGsleepD, freqDelta, 1024);
        
        %-------------------------------------------------
        % Determine SD on sws signal
        OK_sws=max(-Data(Restrict(Filt_EEGd,SWSEpoch)),0);
        try
            SDsws=std(OK_sws(OK_sws>0));
        end
        
        %-------------------------------------------------
        % calculate delta on whole Epoch
        Filt_EEGd = Restrict(Filt_EEGd,Epoch);
        OK=max(-Data(Filt_EEGd),0);
        tDelta=[];
        try
            DeltaEpoch1=thresholdIntervals(tsd(Range(Restrict(EEGsleepD,Epoch)), OK),thD*SDsws,'Direction','Above');
            DeltaEpoch=dropShortIntervals(DeltaEpoch1,th*10); % crucial element for noise detection (75ms) !!!!!!!!!!!!!!!!!!!!!!!!!!
            tDelta=Start(DeltaEpoch)+(End(DeltaEpoch)-Start(DeltaEpoch))/2;
            disp(['number of detected Delta Waves = ',num2str(length(tDelta))])
        catch
            disp('no delta wave detected during SWS')
        end
        
        %-------------------------------------------------
        % saving
        disp('Saving in AllDeltaPFCx.mat')
        save AllDeltaPFCx tDelta DeltaEpoch SWSEpoch Epoch
        
        
        %-------------------------------------------------
        % plot
        figure('color',[1 1 1]),
        subplot(2,2,1:2), hold on
        tbins=4;nbbins=300;
        
        [ma1,sa1,tpsa1]=mETAverage(Range(ts(tDelta)), Range(eegSup),Data(eegSup),tbins,nbbins);
        [ma2,sa2,tpsa2]=mETAverage(Range(ts(tDelta)), Range(eegDeep),Data(eegDeep),tbins,nbbins);
        plot(tpsa1,ma1,'b','linewidth',2),
        plot(tpsa1,ma1+sa1,'b','linewidth',1),
        plot(tpsa1,ma1-sa1,'b','linewidth',1),
        
        plot(tpsa2,ma2,'r','linewidth',2),
        plot(tpsa2,ma2+sa2,'r','linewidth',1),
        plot(tpsa2,ma2-sa2,'r','linewidth',1),
        
        yl=ylim;
        line([0 0],[yl(1) yl(2)],'color','k')
        title(['Delta waves, Superficial (blue), deep (red), n=',num2str(length(Range(ts(tDelta))))])
        
        subplot(2,2,3), hist(End(DeltaEpoch,'s')-Start(DeltaEpoch,'s'),[0:0.001:0.4]),xlim([0 0.39])
        [C,B]=CrossCorr(tDelta,tDelta,10,500);C(B==0)=0;
        [h,b]=hist(diff(tDelta)/1E4,[0:1E-2:2.5]);h(end)=0;
        title(pwd)
        subplot(2,2,4),hold on,
        plotyy(B/1E3,C,b,h),
        
        yl=ylim; line([0 0],yl,'color','r')
        set(gcf,'position',[73   125   518   765])
        
        
        
    catch
        tDelta=[];
        DeltaEpoch=intervalSet([],[]);
    end
end
