function [Mat1,Mat2,Mat3,Mat4,CaracSlCy,freq,Spect,B,C,ReNormTnew,tpsb,ReNormT,tps,ReNormT2,tps2,ff,M1,S1,t1,M2,S2,t2,M3,S3,t3,R1,R2,R3,R4,R5,M1b,S1b,t1b,M2b,S2b,t2b,M3b,S3b,t3b,M4,S4,t4,M4b,S4b,t4b,H,H1,X]=AnalysisSleepCycle(DoAnlysisSB)

part=1;

try
    DoAnlysisSB;
catch
    DoAnlysisSB=0;
end


[SleepCycle,Mat1,CaracSlCy,SleepStagesC, SWSEpochC, REMEpochC, WakeC, NoiseC, TotalNoiseEpoch,N1,N2,N3]=ComputeSleepCycle(15,0,DoAnlysisSB);

  
if 1 %part
    load('B_High_Spectrum.mat')
    Spb=Spectro{1}; tb=Spectro{2};fb=Spectro{3};
    Sstdb=tsd(tb*1E4,Spb);

    Mat2(1,:)=fb;
    Mat2(2,:)=mean(Data(Restrict(Sstdb,WakeC)));
    Mat2(3,:)=mean(Data(Restrict(Sstdb,N1)));

    for i=1:length(Start(WakeC))
    dd(i)=End(subset(WakeC,i),'s')-Start(subset(WakeC,i),'s');
    end
    idx=find(dd<15);
    Mat2(4,:)=mean(Data(Restrict(Sstdb,subset(WakeC,idx))));
    try
    for i=1:length(Start(WakeC))
    Mat3(i,:)=mean(Data(Restrict(Sstdb,subset(WakeC,i))));
    end
    catch
      Mat3=[];  
    end
    
    try
    for i=1:length(Start(N1))
    Mat4(i,:)=mean(Data(Restrict(Sstdb,subset(N1,i))));
    end   
    catch
     Mat4=[];   
    end
    
 else
     Mat2=[];
     Mat3=[];
     Mat4=[];
end

[C,B]=CrossCorr(Start(SleepCycle),Start(SleepCycle),1E4,600);C(B==0)=0; 
[H,X]=hist(diff(Start(SleepCycle,'s')),[0:60:5000]);
[H1,X]=hist(diff(End(REMEpochC,'s')),[0:60:5000]);
figure, hold on
plot(X,H,'ro-','markerfacecolor','r')
plot(X,H1,'ko-')

t=(B-B(1))/1E3/60;
y=C-mean(C);
chF=1/median(diff(t));
L = length(y);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
yf  = fft(y-mean(y),NFFT)/L;
freq = chF*1/2*linspace(0,1,NFFT/2+1);
Spect=abs(yf(1:NFFT/2+1));
Spect=Spect';


if part
    res=pwd;
    tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
    chBulb=tempchBulb.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
    SpBulb=Sp;
    fBulb=f;
    tBulb=t;
    try
    tempchHPC=load([res,'/ChannelsToAnalyse/dHPC_rip.mat'],'channel');
    catch
    tempchHPC=load([res,'/ChannelsToAnalyse/dHPC_deep.mat'],'channel');
    end
    chHPC=tempchHPC.channel;
    try
    clear Sp
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chHPC),'.mat'');'])
    Sp;
    catch
        [Sp,t,f]=LoadSpectrumML(chHPC,pwd,'low');
        eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chHPC),'.mat'');'])
    end
    
    SpHpc=Sp;
    fHpc=f;
    tHpc=t;
    tempchPFC=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
    chPFC=tempchPFC.channel;
    eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chPFC),'.mat'');'])
    SpPfc=Sp;
    fPfc=f;
    tPfc=t;

    idc=find((End(REMEpochC,'s')-Start(REMEpochC,'s'))>15); % by default 25 sc
    en=End(REMEpochC);
    StsdPfc=tsd(tPfc*1E4,SpPfc);
    [M1,S1,t1]=AverageSpectrogram(StsdPfc,fPfc,ts(en(idc)),200,200,1,[],1);  title('End REM - PFC')
    StsdHpc=tsd(tHpc*1E4,SpHpc);
    [M2,S2,t2]=AverageSpectrogram(StsdHpc,fHpc,ts(en(idc)),200,200,1,[],1);    title('End REM - HPC')       
    StsdBulb=tsd(tBulb*1E4,SpBulb);
    [M3,S3,t3]=AverageSpectrogram(StsdBulb,fBulb,ts(en(idc)),200,200,1,[],1);    title('End REM - Bulb')
    [M4,S4,t4]=AverageSpectrogram(Sstdb,fb,ts(en(idc)),200,200,1,[],1);    title('End REM - Bulb High')

    st=Start(REMEpochC);
    [M1b,S1b,t1b]=AverageSpectrogram(StsdPfc,fPfc,ts(st(idc)),200,200,1,[],1);  title('Start REM - PFC')
    [M2b,S2b,t2b]=AverageSpectrogram(StsdHpc,fHpc,ts(st(idc)),200,200,1,[],1);    title('Start REM - HPC')       
    [M3b,S3b,t3b]=AverageSpectrogram(StsdBulb,fBulb,ts(st(idc)),200,200,1,[],1);    title('Start REM - Bulb')
    [M4b,S4b,t4b]=AverageSpectrogram(Sstdb,fb,ts(st(idc)),200,200,1,[],1);    title('Start REM - Bulb High')
    
    
else

    M1=[];S1=[];t1=[];
    M2=[];S2=[];t2=[];
    M3=[];S3=[];t3=[];
end

NewSpleepStage=Data(SleepStagesC);

RG=Range(SleepStagesC);

RG1=Range(Restrict(SleepStagesC,N1));
RG2=Range(Restrict(SleepStagesC,N2));
RG3=Range(Restrict(SleepStagesC,N3));

id1=ismember(RG,RG1);
id2=ismember(RG,RG2);
id3=ismember(RG,RG3);

NewSpleepStage=Data(SleepStagesC);
NewSpleepStage(id1)=1.5;
NewSpleepStage(id2)=2;
NewSpleepStage(id3)=2.5;

SleepN=tsd(RG,NewSpleepStage);

tpsb=0:0.0001:1;
idx=find((End(SleepCycle,'s')-Start(SleepCycle,'s'))>100);
ReNormTnew=zeros(5,length(tpsb));
R1=[];R2=[];R3=[];R4=[];R5=[];
for i=1:length(idx) 
    Mat=Restrict(SleepN,subset(SleepCycle,idx(i)));
    rg=Range(Mat);
    MatTemp=tsd((rg-rg(1))/(rg(end)-rg(1)),Data(Mat));
    ReNormTnew(1,:)=ReNormTnew(1,:)+(Data(Restrict(MatTemp,tpsb))==1.5)';
    ReNormTnew(2,:)=ReNormTnew(2,:)+(Data(Restrict(MatTemp,tpsb))==2)';
    ReNormTnew(3,:)=ReNormTnew(3,:)+(Data(Restrict(MatTemp,tpsb))==2.5)';
    ReNormTnew(4,:)=ReNormTnew(4,:)+(Data(Restrict(MatTemp,tpsb))==3)';
    ReNormTnew(5,:)=ReNormTnew(5,:)+(Data(Restrict(MatTemp,tpsb))==4)';
    R1=[R1;(Data(Restrict(MatTemp,tpsb))==1.5)'];
    R2=[R2;(Data(Restrict(MatTemp,tpsb))==2)'];
    R3=[R3;(Data(Restrict(MatTemp,tpsb))==2.5)'];
    R4=[R4;(Data(Restrict(MatTemp,tpsb))==3)'];
    R5=[R5;(Data(Restrict(MatTemp,tpsb))==4)'];
end

ReNormTnew(1,:)=ReNormTnew(1,:)/length(idx);
ReNormTnew(2,:)=ReNormTnew(2,:)/length(idx);
ReNormTnew(3,:)=ReNormTnew(3,:)/length(idx);
ReNormTnew(4,:)=ReNormTnew(4,:)/length(idx);
ReNormTnew(5,:)=ReNormTnew(5,:)/length(idx);

if part
    fch=fBulb;
    power=[2 4];
    %power=[6 9];
    % power=[10 15];
     Stsd=tsd(tPfc*1E4,SpPfc);fch=fPfc;
    %Stsd=tsd(tHpc*1E4,SpHpc); fch=fHpc;  
   % Stsd=tsd(tBulb*1E4,SpBulb);
    tps=0:0.01:1;
    clear pow
    ReNormT2=[];
    ReNormT=zeros(length(tps),100);
    clear ReNormTemp
    for i=1:length(Start(SleepCycle))    
        [ReNormTemp{i},ff,tps]=RescaleSpectroram0to1(Stsd,fch,subset(SleepCycle,i),tps,100);
        ReNormT=ReNormT+ReNormTemp{i};
        ReNormT2=[ReNormT2;ReNormTemp{i}];
        pow(i,:)=mean(ReNormTemp{i}(:,find(ff>power(1)&ff<power(2))),2);
    end
    fs=1/median(diff(tps));
    tps2=[1:size(ReNormT2,1)]/fs;
else
    ff=[];
    ReNormT=[];
    ReNormT2=[];
    tps2=[];
    tps=[];
end


if 0
load SpikeData
[S,numNeurons]=GetSpikesFromStructure('PFCx',S);
pop=PoolNeurons(S,numNeurons);
for i=1:length(Start(SleepCycle))
    Spk(i,1)=length(Range(Restrict(pop,subset(SleepCycle,i))));
    Spk(i,2)=length(Range(Restrict(pop,and(WakeC,subset(SleepCycle,i)))));
    Spk(i,3)=length(Range(Restrict(pop,and(SWSEpochC,subset(SleepCycle,i)))));
    Spk(i,4)=length(Range(Restrict(pop,and(N1,subset(SleepCycle,i)))));
    Spk(i,5)=length(Range(Restrict(pop,and(N2,subset(SleepCycle,i)))));
    Spk(i,6)=length(Range(Restrict(pop,and(N3,subset(SleepCycle,i)))));
    Spk(i,7)=length(Range(Restrict(pop,and(REMEpochC,subset(SleepCycle,i)))));        
end
end


