
m=0;
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126';
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170127';
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170130';
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170131';
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202';
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170203';
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170207';
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170208';

AllFreq=[1,2,4,7,10,13,15,20];
for mm=1:m
    cd(Filename{m})
    load('ChannelsToAnalyse/Bulb_deep_left.mat')
    load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
    SptsdBL=tsd(t*1e4,Sp);
    load('ChannelsToAnalyse/Bulb_deep_right.mat')
    load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
    SptsdBR=tsd(t*1e4,Sp);
    load('ChannelsToAnalyse/PFCx_deep_left.mat')
    load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
    SptsdPL=tsd(t*1e4,Sp);
    load('ChannelsToAnalyse/PFCx_deep_right.mat')
    load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
    SptsdPR=tsd(t*1e4,Sp);
    
    load('StimInfo.mat')
    
    for f=1:length(AllFreq)
        LitEpoch=intervalSet(StimInfo.StartTime(find(StimInfo.Freq==AllFreq(f)))*1e4,StimInfo.StopTime(find(StimInfo.Freq==AllFreq(f)))*1e4);
        MeanSpec.BL{m,f}=nanmean(Data(Restrict(SptsdBL,LitEpoch)))
        MeanSpec.BR{m,f}=nanmean(Data(Restrict(SptsdBR,LitEpoch)))
        MeanSpec.PL{m,f}=nanmean(Data(Restrict(SptsdPL,LitEpoch)))
        MeanSpec.PR{m,f}=nanmean(Data(Restrict(SptsdPR,LitEpoch)))        
    end
end