%SpkPowerPerSleepCycle

%cd /Users/Bench/Documents/Data/DataSleep244

if 1
    
    try
        load Sleep244
        S;
    catch
        freqSlow=[6 9];
        freqUSlow=[1 5];

        [SleepCycle,Mat,SleepStagesC, SWSEpochC, REMEpochC, WakeC, NoiseC, TotalNoiseEpoch]=ComputeSleepCycle(15,1);
 try
            %need to load the substages of NREM sleep
            load NREMsubstages
            N1;
            N2;
            N3;
        catch
        load StateEpochSB TotalNoiseEpoch
        % dans un dossier particulier
        [op,NamesOp,Dpfc,Epoch,noise]=FindNREMepochsML;
        %NamesOp={'PFsupOsci','PFdeepOsci','BurstDelta','REM','WAKE','SWS','PFswa','OBswa'}
        [MATEP,nameEpochs]=DefineSubStages(op,TotalNoiseEpoch);
        N1=MATEP{1};
        N2=MATEP{2};
        N3=MATEP{3};
        save NREMsubstages N1 N2 N3 MATEP nameEpochs op NamesOp Dpfc Epoch noise TotalNoiseEpoch
        end
        
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


        res=pwd;
        tempchBulb=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
        chBulb=tempchBulb.channel;
        eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chBulb),'.mat'');'])
        SpBulb=Sp;
        fBulb=f;
        tBulb=t;
        tempchHPC=load([res,'/ChannelsToAnalyse/dHPC_deep.mat'],'channel');
        chHPC=tempchHPC.channel;
        eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chHPC),'.mat'');'])
        SpHpc=Sp;
        fHpc=f;
        tHpc=t;
        tempchPFC=load([res,'/ChannelsToAnalyse/PFCx_deep.mat'],'channel');
        chPFC=tempchPFC.channel;
        eval(['load(''',res,'','/SpectrumDataL/Spectrum',num2str(chPFC),'.mat'');'])
        SpPfc=Sp;
        fPfc=f;
        tPfc=t;
        
        SlowHpc=tsd(tHpc*1E4,mean(SpHpc(:,find(fHpc>freqSlow(1)&fHpc<freqSlow(2))),2));
        USlowHpc=tsd(tHpc*1E4,mean(SpHpc(:,find(fHpc>freqUSlow(1)&fHpc<freqUSlow(2))),2));

        SlowBulb=tsd(tBulb*1E4,mean(SpBulb(:,find(fBulb>freqSlow(1)&fBulb<freqSlow(2))),2));
        USlowBulb=tsd(tBulb*1E4,mean(SpBulb(:,find(fBulb>freqUSlow(1)&fBulb<freqUSlow(2))),2));
        
        SlowPfc=tsd(tPfc*1E4,mean(SpPfc(:,find(fPfc>freqSlow(1)&fPfc<freqSlow(2))),2));
        USlowPfc=tsd(tPfc*1E4,mean(SpPfc(:,find(fPfc>freqUSlow(1)&fPfc<freqUSlow(2))),2));
clear PowSlowHpc
clear PowUSlowHpc
clear PowSlowBulb
clear PowUSlowBulb
clear PowSlowPfc
clear PowUSlowPfc

        for i=1:length(Start(SleepCycle))
            
            PowSlowHpc(i,1)=nanmean(Data(Restrict(SlowHpc,subset(SleepCycle,i))));
            PowUSlowHpc(i,1)=nanmean(Data(Restrict(USlowHpc,subset(SleepCycle,i))));
            PowSlowBulb(i,1)=nanmean(Data(Restrict(SlowBulb,subset(SleepCycle,i))));
            PowUSlowBulb(i,1)=nanmean(Data(Restrict(USlowBulb,subset(SleepCycle,i))));
            PowSlowPfc(i,1)=nanmean(Data(Restrict(SlowPfc,subset(SleepCycle,i))));
            PowUSlowPfc(i,1)=nanmean(Data(Restrict(USlowPfc,subset(SleepCycle,i))));

            PowSlowHpc(i,2)=nanmean(Data(Restrict(SlowHpc,and(WakeC,subset(SleepCycle,i)))));
            PowUSlowHpc(i,2)=nanmean(Data(Restrict(USlowHpc,and(WakeC,subset(SleepCycle,i)))));
            PowSlowBulb(i,2)=nanmean(Data(Restrict(SlowBulb,and(WakeC,subset(SleepCycle,i)))));
            PowUSlowBulb(i,2)=nanmean(Data(Restrict(USlowBulb,and(WakeC,subset(SleepCycle,i)))));
            PowSlowPfc(i,2)=nanmean(Data(Restrict(SlowPfc,and(WakeC,subset(SleepCycle,i)))));
            PowUSlowPfc(i,2)=nanmean(Data(Restrict(USlowPfc,and(WakeC,subset(SleepCycle,i)))));

            PowSlowHpc(i,3)=nanmean(Data(Restrict(SlowHpc,and(SWSEpochC,subset(SleepCycle,i)))));
            PowUSlowHpc(i,3)=nanmean(Data(Restrict(USlowHpc,and(SWSEpochC,subset(SleepCycle,i)))));
            PowSlowBulb(i,3)=nanmean(Data(Restrict(SlowBulb,and(SWSEpochC,subset(SleepCycle,i)))));
            PowUSlowBulb(i,3)=nanmean(Data(Restrict(USlowBulb,and(SWSEpochC,subset(SleepCycle,i)))));
            PowSlowPfc(i,3)=nanmean(Data(Restrict(SlowPfc,and(SWSEpochC,subset(SleepCycle,i)))));
            PowUSlowPfc(i,3)=nanmean(Data(Restrict(USlowPfc,and(SWSEpochC,subset(SleepCycle,i)))));

            PowSlowHpc(i,4)=nanmean(Data(Restrict(SlowHpc,and(N1,subset(SleepCycle,i)))));
            PowUSlowHpc(i,4)=nanmean(Data(Restrict(USlowHpc,and(N1,subset(SleepCycle,i)))));
            PowSlowBulb(i,4)=nanmean(Data(Restrict(SlowBulb,and(N1,subset(SleepCycle,i)))));
            PowUSlowBulb(i,4)=nanmean(Data(Restrict(USlowBulb,and(N1,subset(SleepCycle,i)))));
            PowSlowPfc(i,4)=nanmean(Data(Restrict(SlowPfc,and(N1,subset(SleepCycle,i)))));
            PowUSlowPfc(i,4)=nanmean(Data(Restrict(USlowPfc,and(N1,subset(SleepCycle,i)))));

            PowSlowHpc(i,5)=nanmean(Data(Restrict(SlowHpc,and(N2,subset(SleepCycle,i)))));
            PowUSlowHpc(i,5)=nanmean(Data(Restrict(USlowHpc,and(N2,subset(SleepCycle,i)))));
            PowSlowBulb(i,5)=nanmean(Data(Restrict(SlowBulb,and(N2,subset(SleepCycle,i)))));
            PowUSlowBulb(i,5)=nanmean(Data(Restrict(USlowBulb,and(N2,subset(SleepCycle,i)))));
            PowSlowPfc(i,5)=nanmean(Data(Restrict(SlowPfc,and(N2,subset(SleepCycle,i)))));
            PowUSlowPfc(i,5)=nanmean(Data(Restrict(USlowPfc,and(N2,subset(SleepCycle,i)))));        

            PowSlowHpc(i,6)=nanmean(Data(Restrict(SlowHpc,and(N3,subset(SleepCycle,i)))));
            PowUSlowHpc(i,6)=nanmean(Data(Restrict(USlowHpc,and(N3,subset(SleepCycle,i)))));
            PowSlowBulb(i,6)=nanmean(Data(Restrict(SlowBulb,and(N3,subset(SleepCycle,i)))));
            PowUSlowBulb(i,6)=nanmean(Data(Restrict(USlowBulb,and(N3,subset(SleepCycle,i)))));
            PowSlowPfc(i,6)=nanmean(Data(Restrict(SlowPfc,and(N3,subset(SleepCycle,i)))));
            PowUSlowPfc(i,6)=nanmean(Data(Restrict(USlowPfc,and(N3,subset(SleepCycle,i)))));

            PowSlowHpc(i,7)=nanmean(Data(Restrict(SlowHpc,and(REMEpochC,subset(SleepCycle,i)))));
            PowUSlowHpc(i,7)=nanmean(Data(Restrict(USlowHpc,and(REMEpochC,subset(SleepCycle,i)))));
            PowSlowBulb(i,7)=nanmean(Data(Restrict(SlowBulb,and(REMEpochC,subset(SleepCycle,i)))));
            PowUSlowBulb(i,7)=nanmean(Data(Restrict(USlowBulb,and(REMEpochC,subset(SleepCycle,i)))));
            PowSlowPfc(i,7)=nanmean(Data(Restrict(SlowPfc,and(REMEpochC,subset(SleepCycle,i)))));
            PowUSlowPfc(i,7)=nanmean(Data(Restrict(USlowPfc,and(REMEpochC,subset(SleepCycle,i)))));
            
        end
    
    end
    
end

%             
% figure('color',[1 1 1]), 
% subplot(4,2,1), hold on, plot(Mat(:,2),Mat(:,1),'ko-','markerfacecolor','k'), title('Duration Sleep Cycle')
% subplot(4,2,2), hold on, plot(Mat(:,2),Spk./(Mat(:,1)*ones(1,7)),'o-'), title('FIring Rate Sleep Cycle')
% subplot(4,2,3), hold on, plot(Mat(:,2),PowSlowHpc,'o-'), title('PowSlowHpc')
% subplot(4,2,4), hold on, plot(Mat(:,2),PowUSlowHpc,'o-'), title('PowUSlowHpc')
% subplot(4,2,5), hold on, plot(Mat(:,2),PowSlowBulb,'o-'), title('PowSlowBulb')
% subplot(4,2,6), hold on, plot(Mat(:,2),PowUSlowBulb,'o-'), title('PowUSlowBulb')
% subplot(4,2,7), hold on, plot(Mat(:,2),PowSlowPfc,'o-'), title('PowSlowPfc')
% subplot(4,2,8), hold on, plot(Mat(:,2),PowUSlowPfc,'o-'), title('PowUSlowPfc')
% 
% subplot(4,2,1), plot(Mat(:,2),Mat(:,1),'ko','markerfacecolor','k'), title('Duration Sllep Cycle')
% subplot(4,2,2), plot(Mat(:,2),Spk(:,1)./(Mat(:,1)),'ko','markerfacecolor','k'), title('FIring Rate Sleep Cycle')
% subplot(4,2,3), plot(Mat(:,2),PowSlowHpc(:,1),'ko','markerfacecolor','k'), title('PowSlowHpc')
% subplot(4,2,4), plot(Mat(:,2),PowUSlowHpc(:,1),'ko','markerfacecolor','k'), title('PowUSlowHpc')
% subplot(4,2,5), plot(Mat(:,2),PowSlowBulb(:,1),'ko','markerfacecolor','k'), title('PowSlowBulb')
% subplot(4,2,6), plot(Mat(:,2),PowUSlowBulb(:,1),'ko','markerfacecolor','k'), title('PowUSlowBulb')
% subplot(4,2,7), plot(Mat(:,2),PowSlowPfc(:,1),'ko','markerfacecolor','k'), title('PowSlowPfc')
% subplot(4,2,8), plot(Mat(:,2),PowUSlowPfc(:,1),'ko','markerfacecolor','k'), title('PowUSlowPfc')



[C,B]=CrossCorr(Start(SleepCycle),Start(SleepCycle),1E5,100);C(B==0)=0; 
t=(B-B(1))/1E3/60;
y=C-mean(C);
chF=1/median(diff(t));
L = length(y);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
yf  = fft(y-mean(y),NFFT)/L;
freq = chF*1/2*linspace(0,1,NFFT/2+1);
Spect=abs(yf(1:NFFT/2+1));

smo=5;
figure('color',[1 1 1]),
subplot(1,2,1),hold on, 
area(B/1E3/60,C)
plot(B/1E3/60,smooth(C,smo/2),'r','linewidth',1)
subplot(1,2,2),hold on,
plot(freq,Spect,'k')
plot(freq,smooth(Spect,smo),'r','linewidth',2)



% 
% [C,B]=CrossCorr(End(N1),End(N1),1E5,100);C(B==0)=0;
% [C,B]=CrossCorr(End(N2),End(N2),1E5,100);C(B==0)=0;
% [C,B]=CrossCorr(End(N3),End(N3),1E5,100);C(B==0)=0;
% [C,B]=CrossCorr(End(WakeC),End(WakeC),1E5,100);C(B==0)=0;
% [C,B]=CrossCorr(End(SWSEpochC),End(SWSEpochC),1E5,100);C(B==0)=0;


[C,B]=CrossCorr(End(REMEpochC),End(REMEpochC),1E5,100);C(B==0)=0; 
t=(B-B(1))/1E3/60;
y=C-mean(C);
chF=1/median(diff(t));
L = length(y);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
yf  = fft(y-mean(y),NFFT)/L;
freq = chF*1/2*linspace(0,1,NFFT/2+1);
Spect=abs(yf(1:NFFT/2+1));

smo=10;
figure('color',[1 1 1]),
subplot(1,2,1),area(B/1E3/60,C)
subplot(1,2,2),hold on,
plot(freq,Spect,'k')
plot(freq,smooth(Spect,smo),'r','linewidth',2)



[C,B]=CrossCorr(Start(REMEpochC),Start(REMEpochC),1E5,100);C(B==0)=0; 
t=(B-B(1))/1E3/60;
y=C-mean(C);
chF=1/median(diff(t));
L = length(y);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
yf  = fft(y-mean(y),NFFT)/L;
freq = chF*1/2*linspace(0,1,NFFT/2+1);
Spect=abs(yf(1:NFFT/2+1));

smo=10;
figure('color',[1 1 1]),
subplot(1,2,1),area(B/1E3/60,C)
subplot(1,2,2),hold on,
plot(freq,Spect,'k')
plot(freq,smooth(Spect,smo),'r','linewidth',2)






% load Sleep244 Mat
% load Sleep244 SleepCycle
idx=find(Mat(:,1)>100);
Mat=Mat(idx,:);
SleepCycle=subset(SleepCycle,idx);
clear Spk
for i=1:length(Start(SleepCycle))
        Spk(i,1)=length(Range(Restrict(pop,subset(SleepCycle,i))));
        Spk(i,2)=length(Range(Restrict(pop,and(WakeC,subset(SleepCycle,i)))));
        Spk(i,3)=length(Range(Restrict(pop,and(SWSEpochC,subset(SleepCycle,i)))));
        Spk(i,4)=length(Range(Restrict(pop,and(N1,subset(SleepCycle,i)))));
        Spk(i,5)=length(Range(Restrict(pop,and(N2,subset(SleepCycle,i)))));
        Spk(i,6)=length(Range(Restrict(pop,and(N3,subset(SleepCycle,i)))));
        Spk(i,7)=length(Range(Restrict(pop,and(REMEpochC,subset(SleepCycle,i)))));        
end
clear PowSlowHpc
clear PowUSlowHpc
clear PowSlowBulb
clear PowUSlowBulb
clear PowSlowPfc
clear PowUSlowPfc

for i=1:length(Start(SleepCycle))

    PowSlowHpc(i,1)=nanmean(Data(Restrict(SlowHpc,subset(SleepCycle,i))));
    PowUSlowHpc(i,1)=nanmean(Data(Restrict(USlowHpc,subset(SleepCycle,i))));
    PowSlowBulb(i,1)=nanmean(Data(Restrict(SlowBulb,subset(SleepCycle,i))));
    PowUSlowBulb(i,1)=nanmean(Data(Restrict(USlowBulb,subset(SleepCycle,i))));
    PowSlowPfc(i,1)=nanmean(Data(Restrict(SlowPfc,subset(SleepCycle,i))));
    PowUSlowPfc(i,1)=nanmean(Data(Restrict(USlowPfc,subset(SleepCycle,i))));

    PowSlowHpc(i,2)=nanmean(Data(Restrict(SlowHpc,and(WakeC,subset(SleepCycle,i)))));
    PowUSlowHpc(i,2)=nanmean(Data(Restrict(USlowHpc,and(WakeC,subset(SleepCycle,i)))));
    PowSlowBulb(i,2)=nanmean(Data(Restrict(SlowBulb,and(WakeC,subset(SleepCycle,i)))));
    PowUSlowBulb(i,2)=nanmean(Data(Restrict(USlowBulb,and(WakeC,subset(SleepCycle,i)))));
    PowSlowPfc(i,2)=nanmean(Data(Restrict(SlowPfc,and(WakeC,subset(SleepCycle,i)))));
    PowUSlowPfc(i,2)=nanmean(Data(Restrict(USlowPfc,and(WakeC,subset(SleepCycle,i)))));

    PowSlowHpc(i,3)=nanmean(Data(Restrict(SlowHpc,and(SWSEpochC,subset(SleepCycle,i)))));
    PowUSlowHpc(i,3)=nanmean(Data(Restrict(USlowHpc,and(SWSEpochC,subset(SleepCycle,i)))));
    PowSlowBulb(i,3)=nanmean(Data(Restrict(SlowBulb,and(SWSEpochC,subset(SleepCycle,i)))));
    PowUSlowBulb(i,3)=nanmean(Data(Restrict(USlowBulb,and(SWSEpochC,subset(SleepCycle,i)))));
    PowSlowPfc(i,3)=nanmean(Data(Restrict(SlowPfc,and(SWSEpochC,subset(SleepCycle,i)))));
    PowUSlowPfc(i,3)=nanmean(Data(Restrict(USlowPfc,and(SWSEpochC,subset(SleepCycle,i)))));

    PowSlowHpc(i,4)=nanmean(Data(Restrict(SlowHpc,and(N1,subset(SleepCycle,i)))));
    PowUSlowHpc(i,4)=nanmean(Data(Restrict(USlowHpc,and(N1,subset(SleepCycle,i)))));
    PowSlowBulb(i,4)=nanmean(Data(Restrict(SlowBulb,and(N1,subset(SleepCycle,i)))));
    PowUSlowBulb(i,4)=nanmean(Data(Restrict(USlowBulb,and(N1,subset(SleepCycle,i)))));
    PowSlowPfc(i,4)=nanmean(Data(Restrict(SlowPfc,and(N1,subset(SleepCycle,i)))));
    PowUSlowPfc(i,4)=nanmean(Data(Restrict(USlowPfc,and(N1,subset(SleepCycle,i)))));

    PowSlowHpc(i,5)=nanmean(Data(Restrict(SlowHpc,and(N2,subset(SleepCycle,i)))));
    PowUSlowHpc(i,5)=nanmean(Data(Restrict(USlowHpc,and(N2,subset(SleepCycle,i)))));
    PowSlowBulb(i,5)=nanmean(Data(Restrict(SlowBulb,and(N2,subset(SleepCycle,i)))));
    PowUSlowBulb(i,5)=nanmean(Data(Restrict(USlowBulb,and(N2,subset(SleepCycle,i)))));
    PowSlowPfc(i,5)=nanmean(Data(Restrict(SlowPfc,and(N2,subset(SleepCycle,i)))));
    PowUSlowPfc(i,5)=nanmean(Data(Restrict(USlowPfc,and(N2,subset(SleepCycle,i)))));        

    PowSlowHpc(i,6)=nanmean(Data(Restrict(SlowHpc,and(N3,subset(SleepCycle,i)))));
    PowUSlowHpc(i,6)=nanmean(Data(Restrict(USlowHpc,and(N3,subset(SleepCycle,i)))));
    PowSlowBulb(i,6)=nanmean(Data(Restrict(SlowBulb,and(N3,subset(SleepCycle,i)))));
    PowUSlowBulb(i,6)=nanmean(Data(Restrict(USlowBulb,and(N3,subset(SleepCycle,i)))));
    PowSlowPfc(i,6)=nanmean(Data(Restrict(SlowPfc,and(N3,subset(SleepCycle,i)))));
    PowUSlowPfc(i,6)=nanmean(Data(Restrict(USlowPfc,and(N3,subset(SleepCycle,i)))));

    PowSlowHpc(i,7)=nanmean(Data(Restrict(SlowHpc,and(REMEpochC,subset(SleepCycle,i)))));
    PowUSlowHpc(i,7)=nanmean(Data(Restrict(USlowHpc,and(REMEpochC,subset(SleepCycle,i)))));
    PowSlowBulb(i,7)=nanmean(Data(Restrict(SlowBulb,and(REMEpochC,subset(SleepCycle,i)))));
    PowUSlowBulb(i,7)=nanmean(Data(Restrict(USlowBulb,and(REMEpochC,subset(SleepCycle,i)))));
    PowSlowPfc(i,7)=nanmean(Data(Restrict(SlowPfc,and(REMEpochC,subset(SleepCycle,i)))));
    PowUSlowPfc(i,7)=nanmean(Data(Restrict(USlowPfc,and(REMEpochC,subset(SleepCycle,i)))));

end
        
           
figure('color',[1 1 1]), 
subplot(4,2,1), hold on, plot(Mat(:,2),Mat(:,1),'ko-','markerfacecolor','k'), title('Duration Sleep Cycle')
subplot(4,2,2), hold on, plot(Mat(:,2),Spk./(Mat(:,1)*ones(1,7)),'o-'), title('FIring Rate Sleep Cycle')
subplot(4,2,3), hold on, plot(Mat(:,2),PowSlowHpc,'o-'), title('PowSlowHpc')
subplot(4,2,4), hold on, plot(Mat(:,2),PowUSlowHpc,'o-'), title('PowUSlowHpc')
subplot(4,2,5), hold on, plot(Mat(:,2),PowSlowBulb,'o-'), title('PowSlowBulb')
subplot(4,2,6), hold on, plot(Mat(:,2),PowUSlowBulb,'o-'), title('PowUSlowBulb')
subplot(4,2,7), hold on, plot(Mat(:,2),PowSlowPfc,'o-'), title('PowSlowPfc')
subplot(4,2,8), hold on, plot(Mat(:,2),PowUSlowPfc,'o-'), title('PowUSlowPfc')

subplot(4,2,1), plot(Mat(:,2),Mat(:,1),'ko','markerfacecolor','k'), title('Duration Sllep Cycle')
subplot(4,2,2), plot(Mat(:,2),Spk(:,1)./(Mat(:,1)),'ko','markerfacecolor','k'), title('FIring Rate Sleep Cycle')
subplot(4,2,3), plot(Mat(:,2),PowSlowHpc(:,1),'ko','markerfacecolor','k'), title('PowSlowHpc')
subplot(4,2,4), plot(Mat(:,2),PowUSlowHpc(:,1),'ko','markerfacecolor','k'), title('PowUSlowHpc')
subplot(4,2,5), plot(Mat(:,2),PowSlowBulb(:,1),'ko','markerfacecolor','k'), title('PowSlowBulb')
subplot(4,2,6), plot(Mat(:,2),PowUSlowBulb(:,1),'ko','markerfacecolor','k'), title('PowUSlowBulb')
subplot(4,2,7), plot(Mat(:,2),PowSlowPfc(:,1),'ko','markerfacecolor','k'), title('PowSlowPfc')
subplot(4,2,8), plot(Mat(:,2),PowUSlowPfc(:,1),'ko','markerfacecolor','k'), title('PowUSlowPfc')






