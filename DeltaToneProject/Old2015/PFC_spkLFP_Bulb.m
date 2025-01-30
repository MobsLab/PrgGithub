res=pwd;
load StateEpochSB
params.fpass=[0.01 20];
movingwin=[3 0.2];
params.tapers=[3 5];

%------------------------------------------------------------------------------
disp('  ')
BulbChannel=input('which LFP channel for Bulb analysis ? ');
disp('  ')

load([res,'/LFPData/LFP',num2str(BulbChannel)])
LFP_Bulb=LFP;
FilBulb=FilterLFP(LFP_Bulb,[2 4],1024);

params.Fs=1/median(diff(Range(LFP_Bulb,'s')));
[Sp,t,f]=mtspecgramc(Data(LFP_Bulb),movingwin,params);
[EpochSWS,val,val2]=FindSlowOscBulb(Sp,t,f,SWSEpoch,1,[10 12]);
mkdir([res,'/SpectrumDataL']);
save SpectrumDataL/SpectrumBulb Sp t f BulbChannel

%--------------------------------------------------------------------------------
disp('  ')
PFCxChannel=input('which LFP channel for PFCx analysis ? ');
disp('  ')

load([res,'/LFPData/LFP',num2str(PFCxChannel)])
LFP_PFC=LFP;
FilPFC=FilterLFP(LFP_PFC,[2 4],1024);
%--------------------------------------------------------------------------------


%-------------------------------------------------------------------------------
load SpikeData
S2=S;
clear S
spk=input('number of spike concern which belong to this mice ?');
a=1;
for i=spk(1):spk(end)
    S{a}=S2{i};
    a=a+1;
end
S=tsdArray(S);
%-------------------------------------------------------------------------------


%--------------------------------------------------------------------------------
for i=1:length(spk)
    try
        [ph,mu(i), Kappa(i), pval(i),B,C(i,:)]=ModulationTheta(S{i},FilBulb,EpochSWS{9},25,1); ylabel(['Bulb: ',num2str(i)])
        [phP,muP(i), KappaP(i), pvalP(i),B,CP(i,:)]=ModulationTheta(S{i},FilPFC,EpochSWS{9},25,1); ylabel(['PFC: ',num2str(i)])
    catch
        mu(i)=nan;
        Kappa(i)=nan;
        pval(i)=nan;
        muP(i)=nan;
        KappaP(i)=nan;
        pvalP(i)=nan;
    end
end

figure, plot(mu,Kappa,'ko'), hold on, plot(mu(find(pval<0.05)),Kappa(find(pval<0.05)),'ko','markerfacecolor','k')
hold on, plot(muP,KappaP,'ro'), hold on, plot(muP(find(pvalP<0.05)),KappaP(find(pvalP<0.05)),'ro','markerfacecolor','r')
figure, plot(mu,muP,'bo','markerfacecolor','b')
figure, subplot(3,1,1), plot(mu,muP,'bo','markerfacecolor','b')
subplot(3,1,2), plot(Kappa,KappaP,'bo','markerfacecolor','b')
subplot(3,1,3), plot(pval,pvalP,'bo','markerfacecolor','b')
hold on, line([0 0.20],[0 0.20],'color','r')


save PhaseMod mu Kappa pval muP KappaP pvalP
%--------------------------------------------------------------------------------------------------------------------------- 

[SpP,tP,fP]=mtspecgramc(Data(LFP),movingwin,params);
[r,p,r2,p2]=CrossFreqCoupling(Sp,t,f,SpP,tP,fP,SWSEpoch);
[r,p,r2,p2]=CrossFreqCoupling(Sp,t,f,SpP,tP,fP,Epoch{9});
figure, imagesc(r)
figure, imagesc(r), axis xy
[r,p,r2,p2]=CrossFreqCoupling(Sp,t,f,SpP,tP,fP,Epoch{10});

%--------------------------------------------------------------------------------------------------------------------------- 
load StateEpochSB SWSEpoch Wake REMEpoch

[ph,muW, KappaW, pvalW,BW,CW]=ModulationTheta(S{54},FilBulb,Wake,25,1);
[EpochW,val,val2]=FindSlowOscBulb(Sp,t,f,Wake,1,[10 12]);
[ph,muW, KappaW, pvalW,BW,CW]=ModulationTheta(S{54},FilPFC,EpochW{9},25,1);

[HS,Ph,ModTheta]=RayleighFreq(Restrict(LFP_Bulb,Wake),Restrict(S{54},Wake),0.05);
%--------------------------------------------------------------------------------------------------------------------------- 










