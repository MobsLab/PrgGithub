m(1)=percentile(Data(temp),1);
m(2)=percentile(Data(temp),99.9);
m(3)=percentile(Data(temp),99.5);
m(4)=percentile(Data(temp),99);
m(4)=percentile(Data(temp),95);
m(5)=percentile(Data(temp),90);
m(6)=percentile(Data(temp),85);
m(7)=percentile(Data(temp),80);
for i=1:7
EpochOK{i}=thresholdIntervals(temp,m(i),'Direction','Below');
end
 figure,hold on
 for i=1:7
plot(f,10*log10(mean(Data(Restrict(stsd,EpochOK{i})))),'color',[i/7 (7-i)/7 0])
end

voieB=7;
voieH=17;
 
% load data
load(strcat('/media/DataMOBs/ProjetDPCPX/Mouse051/20121227/BULB-Mouse-51-27122012/LFPData/LFP',num2str(voieB),'.mat'))
load('StateEpoch.mat')
 
params.Fs=1/median(diff(Range(LFP,'s')));params.trialave=0;
params.fpass=[20 200];
params.tapers=[3 5];
movingwin=[0.1 0.005];
params.Fs=1250;
suffix='H';
 
%     [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
    sptsd=tsd(t*10000,Sp);
    Epoch=SWSEpoch-GndNoiseEpoch-NoiseEpoch;
    SWSsp=Restrict(sptsd,Epoch);
    startg=find(f<50,1,'last');
    stopg=find(f>70,1,'first');
%     starthi=find(f<180,1,'last');
%     stophi=find(f>190,1,'first');
    a=Data(SWSsp);
%     aorder=sort(a(:));
% %     [row,col]=find(a>aorder(size(aorder,1)-ceil(size(aorder,1)/200)));
%     a(row,col)=NaN;
%  
    SWS_ghi=tsd(Range(Restrict(SWSsp,Epoch))*10000,sum(a(:,startg:stopg)')');
        figure
%  
%     subplot(1,3,1)
%     [y,x]=hist(sum(a(:,startg:stopg)')./sum(a(:,starthi:stophi)'),50);
%     plot(x,y,'r','linewidth',2)
%     hold on
    Epoch=REMEpoch-GndNoiseEpoch-NoiseEpoch;
    REMsp=Restrict(sptsd,Epoch);
    a=Data(REMsp);
    REM_ghi=tsd(Range(Restrict(REMsp,Epoch))*10000,sum(a(:,startg:stopg)')');
%     subplot(1,3,1)
%     [y,x]=hist(sum(a(:,startg:stopg)')./sum(a(:,starthi:stophi)'),50);
%     figure
%     plot(x,y,'b','linewidth',2)
%     hold on
 
    Epoch=MovEpoch-GndNoiseEpoch-NoiseEpoch;
    MOVsp=Restrict(sptsd,Epoch);
    a=Data(MOVsp);
    MOV_ghi=tsd(Range(Restrict(MOVsp,Epoch))*10000,sum(a(:,startg:stopg)')');
%     subplot(1,3,1)
%     [y,x]=hist(sum(a(:,startg:stopg)')./sum(a(:,starthi:stophi)'),50);
%     figure
%     plot(x,y,'b','linewidth',2)
%     hold on
 
load(strcat('/media/DataMOBs/ProjetDPCPX/Mouse051/20121227/BULB-Mouse-51-27122012/LFPData/LFP',num2str(voieH),'.mat'))
 
    params.err=[1 0.0500];
params.pad=2;
params.fpass=[0.1 20];
movingwin=[3 0.2];
params.tapers=[3 5];
 
 [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
    sptsd=tsd(t*10000,Sp);
    
    startt=find(f<6,1,'last');
    stopt=find(f>9,1,'first');
    startd=find(f<1.5,1,'last');
    stopd=find(f>4.5,1,'first');
    Epoch=SWSEpoch-GndNoiseEpoch-NoiseEpoch;
    SWSsp=Restrict(sptsd,Epoch);
     a=Data(SWSsp);
    SWS_td=tsd(Range(Restrict(SWSsp,Epoch))*10000,(sum(a(:,startt:stopt)')./sum(a(:,startd:stopd)'))');
%     subplot(1,3,1)
%     [y,x]=hist(sum(a(:,startt:stopt)')./sum(a(:,startd:stopd)'),50);
%     figure
%     plot(x,y,'r','linewidth',2)
%     hold on
    Epoch=REMEpoch-GndNoiseEpoch-NoiseEpoch;
    REMsp=Restrict(sptsd,Epoch);
    a=Data(REMsp);
    REM_td=tsd(Range(Restrict(REMsp,Epoch))*10000,(sum(a(:,startt:stopt)')./sum(a(:,startd:stopd)'))');
%     subplot(1,3,1)
%     [y,x]=hist(sum(a(:,startt:stopt)')./sum(a(:,startd:stopd)'),50);
%     figure
%     plot(x,y,'b','linewidth',2)
%     hold on
 
    Epoch=MovEpoch-GndNoiseEpoch-NoiseEpoch;
    MOVsp=Restrict(sptsd,Epoch);
    a=Data(MOVsp);
    MOV_td=tsd(Range(Restrict(MOVsp,Epoch))*10000,(sum(a(:,startt:stopt)')./sum(a(:,startd:stopd)'))');
%     subplot(1,3,1)
%     [y,x]=hist(sum(a(:,startt:stopt)')./sum(a(:,startd:stopd)'),50);
%     figure
%     plot(x,y,'b','linewidth',2)
%     hold on
% 
% 






