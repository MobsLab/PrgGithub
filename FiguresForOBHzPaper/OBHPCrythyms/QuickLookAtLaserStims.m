clear all
m=0;
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126/';
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170127/';
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170130/';
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170131/';
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202/';
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170203/';
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170207/';
m=m+1;FileName{m}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170208/';

Struc={'Bulb_deep_left','Bulb_deep_right','PFCx_deep_left','PFCx_deep_right'};
AllFreq=[1,2,4,7,10,13,15,20];
cd(FileName{1})
load(['ChannelsToAnalyse/',Struc{1},'.mat'])
load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
for ff=1:length(AllFreq)-1
    FreqZone(ff)=find(f>AllFreq(ff),1,'first');
end
FreqZone(8)=length(f);


for mm=1:m
    mm
    cd(FileName{mm})
    load('StimInfo.mat')
    for s=1:length(Struc)
        load(['ChannelsToAnalyse/',Struc{s},'.mat'])
        load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
        Sptsd.(Struc{s})=tsd(t*1e4,Sp);
    end
    TransferFct.LeftLog(mm,:)=mean(log(Data(Sptsd.PFCx_deep_left)./Data(Sptsd.Bulb_deep_left)));
    TransferFct.LeftNoLog(mm,:)=mean((Data(Sptsd.PFCx_deep_left)./Data(Sptsd.Bulb_deep_left)));
    
    TransferFct.RightLog(mm,:)=mean(log(Data(Sptsd.PFCx_deep_right)./Data(Sptsd.Bulb_deep_right)));
    TransferFct.RightNoLog(mm,:)= mean((Data(Sptsd.PFCx_deep_right)./Data(Sptsd.Bulb_deep_right)));
    
    for s=1:length(Struc)
        for ff=1:length(AllFreq)
            LitEpoch=intervalSet(StimInfo.StartTime(find(StimInfo.Freq==AllFreq(ff)))*1e4,StimInfo.StopTime(find(StimInfo.Freq==AllFreq(ff)))*1e4);
            AvSpecOn.(Struc{s}){ff,mm}=mean(Data(Restrict(Sptsd.(Struc{s}),LitEpoch)));
            LitEpoch=intervalSet(StimInfo.StartTime(find(StimInfo.Freq==AllFreq(ff)))*1e4-30*1e4,StimInfo.StartTime(find(StimInfo.Freq==AllFreq(ff)))*1e4);
            AvSpecOff.(Struc{s}){ff,mm}=mean(Data(Restrict(Sptsd.(Struc{s}),LitEpoch)));
            MaxSpecOn.(Struc{s})(ff,mm)=max(AvSpecOn.(Struc{s}){ff,mm}(max(FreqZone(ff)-5,0):min(FreqZone(ff)+5,length(f))));
            MaxSpecOff.(Struc{s})(ff,mm)=max(AvSpecOff.(Struc{s}){ff,mm}(max(FreqZone(ff)-5,0):min(FreqZone(ff)+5,length(f))));
        end
    end
    clear Sptsd
end

figure
for s=1:length(Struc)
    subplot(2,2,s)
    plot(AllFreq,(mean((MaxSpecOff.(Struc{s})(:,:)'))),'k*-')
    hold on
    plot(AllFreq,(mean((MaxSpecOn.(Struc{s})(:,:)'))),'r*-')
    title((Struc{s}))
end

figure
for s=1:length(Struc)
    subplot(2,2,s)
    plot(AllFreq,AllFreq.*(mean((MaxSpecOff.(Struc{s})(:,:)'))),'k*-')
    hold on
    plot(AllFreq,AllFreq.*(mean((MaxSpecOn.(Struc{s})(:,:)'))),'r*-')
    title((Struc{s}))
end

figure
for s=1:length(Struc)
    subplot(2,2,s)
    hold on
    plot(AllFreq,((mean((MaxSpecOn.(Struc{s})(:,:)')))-(mean((MaxSpecOff.(Struc{s})(:,:)'))))./(mean((MaxSpecOff.(Struc{s})(:,:)'))),'r*-')
    title((Struc{s}))
end

figure
subplot(2,1,1)
hold on
plot(AllFreq,((mean((MaxSpecOn.PFCx_deep_left(:,:)')))-(mean((MaxSpecOn.Bulb_deep_left(:,:)'))))./(mean((MaxSpecOn.Bulb_deep_left(:,:)'))),'r*-')
plot(AllFreq,((mean((MaxSpecOff.PFCx_deep_left(:,:)')))-(mean((MaxSpecOff.Bulb_deep_left(:,:)'))))./(mean((MaxSpecOff.Bulb_deep_left(:,:)'))),'k*-')
subplot(2,1,2)
hold on
plot(AllFreq,((mean((MaxSpecOn.PFCx_deep_right(:,:)')))-(mean((MaxSpecOn.Bulb_deep_right(:,:)'))))./(mean((MaxSpecOn.Bulb_deep_right(:,:)'))),'r*-')
plot(AllFreq,((mean((MaxSpecOff.PFCx_deep_right(:,:)')))-(mean((MaxSpecOff.Bulb_deep_right(:,:)'))))./(mean((MaxSpecOff.Bulb_deep_right(:,:)'))),'k*-')


figure
for s=1:length(Struc)
    subplot(2,2,s)
    plot(AllFreq,log(mean((MaxSpecOff.(Struc{s})(:,:)))),'k*-')
    hold on
    plot(AllFreq,log(mean((MaxSpecOn.(Struc{s})(:,:)))),'r*-')
    title((Struc{s}))
end

figure
for s=1:length(Struc)
    subplot(2,2,s)
    %     plot(AllFreq,mean(zscore(MaxSpecOn.(Struc{s})(:,:))'),'r')
    errorbar(AllFreq,mean(zscore(MaxSpecOn.(Struc{s})(:,:))'),stdError(zscore(MaxSpecOn.(Struc{s})(:,:))'),'r')
    hold on
    %     plot(AllFreq,mean(zscore(MaxSpecOff.(Struc{s})(:,:))'),'k')
    errorbar(AllFreq,mean(zscore(MaxSpecOff.(Struc{s})(:,:))'),stdError(zscore(MaxSpecOff.(Struc{s})(:,:))'),'k')
    
end


figure
for s=1:length(Struc)
    subplot(2,2,s)
    plot(AllFreq,(zscore(MaxSpecOn.(Struc{s})(:,:))),'r')
    hold on
    plot(AllFreq,(zscore(MaxSpecOff.(Struc{s})(:,:))),'k')
    
end

figure
for s=1:length(Struc)
    subplot(2,2,s)
    tempOn=MaxSpecOn.(Struc{s});
    tempOff=MaxSpecOff.(Struc{s});
    
    for mm=1:8
        tempOn(:,mm)=tempOn(:,mm)./tempOff(1,mm);
        tempOff(:,mm)=tempOff(:,mm)./tempOff(1,mm);
    end
    errorbar(AllFreq,mean(tempOn'),stdError(tempOn'),'r')
    hold on
    
    errorbar(AllFreq,mean(tempOff'),stdError(tempOff'),'k')
    
end


figure
for s=1:length(Struc)
    subplot(2,2,s)
    tempOn=MaxSpecOn.(Struc{s});
    tempOff=MaxSpecOff.(Struc{s});
    
    for mm=1:8
        tempOn(:,mm)=tempOn(:,mm)./tempOff(1,mm);
        tempOff(:,mm)=tempOff(:,mm)./tempOff(1,mm);
    end
    plot(AllFreq,tempOn,'r')
    hold on
    
    plot(AllFreq,tempOff,'k')
    
end

figure
subplot(2,1,1)
hold on
temp=MaxSpecOn.PFCx_deep_left(:,:)./MaxSpecOn.Bulb_deep_left(:,:);
plot(AllFreq,zscore(temp),'r*-')
temp=MaxSpecOff.PFCx_deep_left(:,:)./MaxSpecOff.Bulb_deep_left(:,:);
plot(AllFreq,zscore(temp),'k*-')
subplot(2,1,2)
hold on
temp=MaxSpecOn.PFCx_deep_right(:,:)./MaxSpecOn.Bulb_deep_right(:,:);
plot(AllFreq,zscore(temp),'r*-')
temp=MaxSpecOff.PFCx_deep_right(:,:)./MaxSpecOff.Bulb_deep_right(:,:);
plot(AllFreq,zscore(temp),'k*-')


figure
subplot(2,1,1)
hold on
temp=MaxSpecOn.PFCx_deep_left(:,:)./MaxSpecOn.Bulb_deep_left(:,:);
plot(AllFreq,mean(zscore(temp)'),'r*-')
temp=MaxSpecOff.PFCx_deep_left(:,:)./MaxSpecOff.Bulb_deep_left(:,:);
plot(AllFreq,mean(zscore(temp)'),'k*-')
subplot(2,1,2)
hold on
temp=MaxSpecOn.PFCx_deep_right(:,:)./MaxSpecOn.Bulb_deep_right(:,:);
plot(AllFreq,mean(zscore(temp)'),'r*-')
temp=MaxSpecOff.PFCx_deep_right(:,:)./MaxSpecOff.Bulb_deep_right(:,:);
plot(AllFreq,mean(zscore(temp)'),'k*-')




