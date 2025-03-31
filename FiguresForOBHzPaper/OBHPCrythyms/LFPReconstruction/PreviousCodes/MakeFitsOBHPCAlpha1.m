%% Try and model PFCx LFP from OB and HPC activity using sinmple alpha functions and a delay
close all

load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
OBLFP=LFP;
load('ChannelsToAnalyse/PFCx_deep.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
PFCLFP=LFP;
load('ChannelsToAnalyse/dHPC_rip.mat')
load(['LFPData/LFP',num2str(channel),'.mat'])
HPCLFP=LFP;

load('StateEpochSB.mat','SWSEpoch')
SWSEpoch=dropShortIntervals(SWSEpoch,15*1e4);

for k=1:10
    Epoch=subset(SWSEpoch,k);
    
    global dataB dataP dataH dt
    dataB=(Restrict(OBLFP,Epoch));dataB=FilterLFP(dataB,[1:20],1024);dataB=Data(dataB);dataB=dataB(1:10:end);
    dataP=(Restrict(PFCLFP,Epoch));dataP=FilterLFP(dataP,[1:20],1024);dataP=Data(dataP);dataP=dataP(1:10:end);
    dataH=(Restrict(HPCLFP,Epoch));dataH=FilterLFP(dataH,[1:20],1024);dataH=Data(dataH);dataH=dataH(1:10:end);
    dt=median(diff(Range(LFP,'s')))*10;
    time=Range(Restrict(OBLFP,Epoch),'s')-min(Range(Restrict(OBLFP,Epoch),'s'));
    time=time(1:10:end);
    x0=[-5,0.1,0.05,...
        0.4,0.05];
    options = optimset('MaxFunEvals',Inf,'MaxIter',5000,...
        'Algorithm','interior-point');
    [x,fval,exitflag,output,lambda,grad,hessian] = ConstrFit(x0,10000,10000);
    amp1=x(1);
    n1=x(2);
    tau1=x(3);
    n2=x(4);
    tau2=x(5);
    
    
    t=[0:dt:3];
    Alpha1=-amp1*(t).^n1.*exp(-(t)./tau1);
    Alpha2=-(t).^n2.*exp(-(t)./tau2);
    
    y1=conv(dataB,Alpha1);
    y2=conv(dataH,Alpha2);
    y1=y1(1:length(dataP))/max(y1);
    y2=y2(1:length(dataP))/max(y2);
    
    
    sumY=std(dataP).*(y1+y2)./std(y1+y2);
    y=sum((sumY(floor(2/dt):end)-dataP(floor(2/dt):end)).^2);
    
    
    figure
    subplot(2,4,[1:3])
    plot(time(1:length(sumY)),sumY,'k'), hold on
    plot(time,dataP,'r')
    subplot(2,4,[5:7])
    plot(time,dataB,'b'), hold on
    plot(time,dataH,'g'), hold on
    plot(time,dataP,'r')
    subplot(2,8,7)
    plot(t,Alpha1,'b')
    xlim([0 1.5])
    subplot(2,8,8)
    plot(t,Alpha2,'g')
    xlim([0 1.5])
    subplot(2,4,8)
    plot(t,Alpha1./max(Alpha1),'b')
    hold on
    plot(t,Alpha2./max(Alpha2),'g')
    xlim([0 1.5])
    
end