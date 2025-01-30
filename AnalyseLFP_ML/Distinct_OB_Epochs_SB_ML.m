function OBEp=Distinct_OB_Epochs_SB_ML(res,channelBulb,NameEpoch)

%  OBEp=Distinct_OB_Epochs_SB_ML(res,channelBulb,NameEpoch)
%
% inputs :
% res (optional) = directory, default pwd
% channelBulb (optional) = channel, default UniqueChannelBulb or Bulb_deep
% NameEpoch (optional) = SWSEpoch, REMEpoch, MovEpoch, default SWSEpoch

%% INPUTS

FreqBOoscil=[1.5 5];
DoBootstrap=0;

foldertosave='DistinctOBepochs';
erasePreviousAnaly=0;

%% INITIATE

if ~exist('res','var')
    res=pwd;
end

if ~exist('channelBulb','var')
    try
        tempload=load([res,'/SpectrumDataL/UniqueChannelBulb.mat']);
        channelBulb=tempload.channelToAnalyse;
    catch
        try
            tempload=load([res,'/ChannelsToAnalyse/Bulb_deep.mat']);
            channelBulb=tempload.channel;
        catch
            disp('No UniqueChannelBulb or Bulb_deep!')
            channelBulb=input('Enter Channel to Analyze: ');
        end
    end
end

if ~exist('NameEpoch','var')
    NameEpoch='SWSEpoch';
end

disp(['finding OB Epochs, ',NameEpoch,' - frequency [',num2str(FreqBOoscil),']Hz'])
if ~exist([res,'/',foldertosave],'file')
    mkdir([res,'/',foldertosave])
end

Doanaly=1;
try
    tempload=load([res,'/',foldertosave,'/',foldertosave,NameEpoch,'.mat']);
    tempload.name; tempload.OBEp;
    Doanaly=0;
    disp('Analysis already done...')
end

if Doanaly && erasePreviousAnaly==0
    
    
    if isempty(channelBulb)
        disp('No Bulb Channel')
    else
        %% load epochs
        
        tempload=load([res,'/StateEpoch.mat']);
        NoiseEpoch=tempload.NoiseEpoch;
        GndNoiseEpoch=tempload.GndNoiseEpoch;
        SWSEpoch=tempload.SWSEpoch;
        REMEpoch=tempload.REMEpoch;
        MovEpoch=tempload.MovEpoch;
        
        
        eval(['epoch=',NameEpoch,';']);
        try
            tempload=load([res,'behavResources.mat'],'PreEpoch');
            epoch=and(epoch,tempload.PreEpoch);
        end
        
        
        %% Get OB Epochs
        %%%%
        clear t Sp f
        
        disp(['loading Spectrum',num2str(channelBulb),'...'])
        load([res,'/SpectrumDataL/Spectrum',num2str(channelBulb),'.mat']);
        rg=t(length(t))*1e4;
        TotalEpoch=intervalSet(0,rg(end))-NoiseEpoch-GndNoiseEpoch;
        
        Spectsd=tsd(t*1e4,Sp);
        Spectsd=Restrict(Spectsd,epoch);
        
        
        disp('   getting Epochs')
        % First Way : divide into four parts
        sptsd=tsd(t*1e4,mean(Sp(:,find(f>1.5,1,'first'):find(f<5,1,'last'))')');
        sptsd=Restrict(sptsd,epoch);
        [Sc,Th,CleanEp]=CleanSpectro(Spectsd,f,4);
        disp(size(Range(Restrict(sptsd,CleanEp)))./size(Range(Restrict(sptsd,epoch))))
        sptsd=Restrict(sptsd,CleanEp);
        
        dat=Data(sptsd);
        lim(1)=percentile(dat,0.75);
        lim(2)=percentile(dat,0.90);
        lim(3)=percentile(dat,0.25);
        lim(4)=percentile(dat,0.10);
        
        tempEp=thresholdIntervals(sptsd,lim(1),'Direction','Above');
        tempEp=mergeCloseIntervals(tempEp,2*1E4);
        tempEp=dropShortIntervals(tempEp,2*1E4);
        OBEp{1}=tempEp;
        name{1}=['Top 25% -',num2str(floor(size(Data(Restrict(sptsd,OBEp{1})))/size(Data(sptsd))*100)),'%'];
        
        tempEp=thresholdIntervals(sptsd,lim(3),'Direction','Below');
        tempEp=mergeCloseIntervals(tempEp,2*1E4);
        tempEp=dropShortIntervals(tempEp,2*1E4);
        OBEp{2}=tempEp;
        name{2}=['Bottom 25% -',num2str(floor(size(Data(Restrict(sptsd,OBEp{2})))/size(Data(sptsd))*100)),'%'];
        
        tempEp=thresholdIntervals(sptsd,lim(2),'Direction','Above');
        tempEp=mergeCloseIntervals(tempEp,2*1E4);
        tempEp=dropShortIntervals(tempEp,2*1E4);
        OBEp{3}=tempEp;
        name{3}=['Top 10% -',num2str(floor(size(Data(Restrict(sptsd,OBEp{3})))/size(Data(sptsd))*100)),'%'];
        
        tempEp=thresholdIntervals(sptsd,lim(4),'Direction','Below');
        tempEp=mergeCloseIntervals(tempEp,2*1E4);
        tempEp=dropShortIntervals(tempEp,2*1E4);
        OBEp{4}=tempEp;
        name{4}=['Bottom 10% -',num2str(floor(size(Data(Restrict(sptsd,OBEp{4})))/size(Data(sptsd))*100)),'%'];
        
        
        
        % Second Way : get bursts
        disp(['loading LFP',num2str(channelBulb),'...'])
        tempload=load([res,'/LFPData/LFP',num2str(channelBulb),'.mat']);
        FilOB=FilterLFP(tempload.LFP,FreqBOoscil,1024);
        FilOB=Restrict(FilOB,epoch);
        mnOB=nanmean(Data(FilOB));
        stdOB=nanstd(Data(FilOB));
        
        disp('   getting Epochs')
        pks=findpeaks(Data(FilOB),mnOB+2*stdOB);
        r=Range(FilOB,'s');
        BRST=burstinfo(r(pks.loc),0.5);
        OBEp{5}=intervalSet(BRST.t_start*1e4,BRST.t_end*1e4);
        name{5}=['2stddev burst 0.5s -',num2str(floor(size(Data(Restrict(sptsd,OBEp{5})))/size(Data(sptsd))*100)),'%'];
        
        pks=findpeaks(Data(FilOB),mnOB+2*stdOB);
        r=Range(FilOB,'s');
        BRST=burstinfo(r(pks.loc),1);
        OBEp{6}=intervalSet(BRST.t_start*1e4,BRST.t_end*1e4);
        name{6}=['2stddev burst 1s -',num2str(floor(size(Data(Restrict(sptsd,OBEp{6})))/size(Data(sptsd))*100)),'%'];
        
        pks=findpeaks(Data(FilOB),mnOB+stdOB);
        r=Range(FilOB,'s');
        BRST=burstinfo(r(pks.loc),0.5);
        OBEp{7}=intervalSet(BRST.t_start*1e4,BRST.t_end*1e4);
        name{7}=['1stddev burst 0.5s -',num2str(floor(size(Data(Restrict(sptsd,OBEp{7})))/size(Data(sptsd))*100)),'%'];
        OBEp{8}=epoch;
        
        
        if DoBootstrap
            % Random simulation of such low percentages
            durations=(Stop(OBEp{5})-Start(OBEp{5}));
            durationS=(Stop(epoch)-Start(epoch));
            sumdurS=cumsum(durationS);
            sumdurS=sumdurS/max(sumdurS);
            clear BootEp
            for rep=1:50
                BootEp{rep}=intervalSet(0,0);
                for k=1:length(durations)
                    go=0;
                    while go==0
                        pick=find(sumdurS>rand,1,'first');
                        if durationS(pick)>durations(k)
                            go=1;
                            window=[Start(subset(epoch,pick)),Stop(subset(epoch,pick))-durations(k)];
                            begin=window(1)+rand*(window(2)-window(1));
                            BootEp{rep}=Or(BootEp{rep},intervalSet(begin,begin+durations(k)));
                        else
                            go=0;
                        end
                    end
                end
            end
            BootEp{51}=epoch;
        end
        
        %% SAVE
        disp(['Saving OBEp in ',foldertosave,'/',foldertosave,NameEpoch,'...'])
        save([res,'/',foldertosave,'/',foldertosave,NameEpoch,'.mat'],'name','OBEp','FreqBOoscil','NameEpoch')
        if DoBootstrap, save([res,'/',foldertosave,'/',foldertosave,NameEpoch,'.mat'],'-append','BootEp');end
        
    end
end






