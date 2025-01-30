inter=2;%sec
PlotEp=Epoch;
ghi_new=Restrict(smooth_ghi,PlotEp);
theta_new=Restrict(smooth_Theta,PlotEp);
%need to think about this
t=Range(theta_new);
ti=t(5:5:end);
ghi_new=Restrict(ghi_new,ts(ti));
theta_new=Restrict(theta_new,ts(ti));

for k=1:length(stimEpoch)
    Ep=stimEpoch{k}.st;
    stims=Restrict(stim,Ep);
    befEpoch=intervalSet(Range(stims)-inter*1e4,Range(stims));
    aftEpoch=intervalSet(Range(stims),Range(stims)+inter*1e4);
    
    for i=1:length(stims)
        bef{k}(i,1)=mean(Restrict(ghi_new,subset(befEpoch,i)));
        bef{k}(i,2)=mean(Restrict(theta_new,subset(befEpoch,i)));
        aft{k}(i,1)=mean(Restrict(ghi_new,subset(aftEpoch,i)));
        aft{k}(i,2)=mean(Restrict(theta_new,subset(aftEpoch,i)));
        
    end
            netdeplacement(k,1)=mean(aft{k}(:,1)-bef{k}(:,1));
            netdeplacement(k,2)=mean(aft{k}(:,2)-bef{k}(:,2));
            netposa(k,1)=mean(aft{k}(:,1));
            netposa(k,2)=mean(aft{k}(:,2));
            netposb(k,1)=mean(bef{k}(:,1));
            netposb(k,2)=mean(bef{k}(:,2));

end
h=figure;
set(h,'color',[1 1 1])
subplot(121)
sleeptheta=(Restrict(theta_new,And(PlotEp,SWSEpoch)));
ghi_new_s=Restrict(ghi_new,ts(Range(sleeptheta)))
plot(log(Data(ghi_new_s)),log(Data(sleeptheta)),'.','color',[0 0.8 1],'MarkerSize',8);
hold on
remtheta=(Restrict(theta_new,And(PlotEp,REMEpoch)));
ghi_new_r=Restrict(ghi_new,ts(Range(remtheta)));
plot(log(Data(ghi_new_r)),log(Data(remtheta)),'.','color',[0.8 0.2 0.1],'MarkerSize',8);
waketheta=(Restrict(theta_new,Wake));
ghi_new_w=Restrict(ghi_new,ts(Range(waketheta)));
plot(log(Data(ghi_new_w)),log(Data(waketheta)),'.','color',[0.2 0.2 0.2],'MarkerSize',8);
legend('SWS','REM','Wake')
l=findobj(gcf,'tag','legend')
a=get(l,'children');
set(a(1),'markersize',20); % This line changes the legend marker size
set(a(4),'markersize',20); % This line changes the legend marker size
set(a(7),'markersize',20); % This line changes the legend marker size

subplot(122)
plot(log(Data(ghi_new)),log(Data(theta_new)),'.','color',[0.8 0.8 0.8],'MarkerSize',8);
hold on
for k=1:10
    try
   plot(log([bef{k}(:,1),aft{k}(:,1)]'),log([bef{k}(:,2),aft{k}(:,2)]'),'c')
    end
end
figure
  plot(log(tot_ghi),log(tot_theta),'.k','MarkerSize',5)

for k=1:j
  hold on
  k
    try
plot(log(aft{k}(:,1)),log(aft{k}(:,2)),'+b')
plot(log(bef{k}(:,1)),log(bef{k}(:,2)),'+m')
    end
    
end

for k=1:length(stimEpoch)
    Ep=And(SWSEpoch,stimEpoch{k}.st);
    stims=Restrict(stim,Ep);
    befEpoch=intervalSet(Range(stims)-inter*1e4,Range(stims));
    aftEpoch=intervalSet(Range(stims),Range(stims)+inter*1e4);
    
    for i=1:length(stims)
        bef{k}(i,1)=mean(Restrict(ghi_new,subset(befEpoch,i)));
        bef{k}(i,2)=mean(Restrict(theta_new,subset(befEpoch,i)));
        aft{k}(i,1)=mean(Restrict(ghi_new,subset(aftEpoch,i)));
        aft{k}(i,2)=mean(Restrict(theta_new,subset(aftEpoch,i)));
        
    end
            netdeplacement(k,1)=mean(aft{k}(:,1)-bef{k}(:,1));
            netdeplacement(k,2)=mean(aft{k}(:,2)-bef{k}(:,2));
            netposaS(k,1)=mean(aft{k}(:,1));
            netposaS(k,2)=mean(aft{k}(:,2));
            netposbS(k,1)=mean(bef{k}(:,1));
            netposbS(k,2)=mean(bef{k}(:,2));

end

for k=1:length(stimEpoch)
    Ep=And(REMEpoch,stimEpoch{k}.st);
    stims=Restrict(stim,Ep);
    befEpoch=intervalSet(Range(stims)-inter*1e4,Range(stims));
    aftEpoch=intervalSet(Range(stims),Range(stims)+inter*1e4);
    
    for i=1:length(stims)
        bef{k}(i,1)=mean(Restrict(ghi_new,subset(befEpoch,i)));
        bef{k}(i,2)=mean(Restrict(theta_new,subset(befEpoch,i)));
        aft{k}(i,1)=mean(Restrict(ghi_new,subset(aftEpoch,i)));
        aft{k}(i,2)=mean(Restrict(theta_new,subset(aftEpoch,i)));
        
    end
            netdeplacement(k,1)=mean(aft{k}(:,1)-bef{k}(:,1));
            netdeplacement(k,2)=mean(aft{k}(:,2)-bef{k}(:,2));
            netposaR(k,1)=mean(aft{k}(:,1));
            netposaR(k,2)=mean(aft{k}(:,2));
            netposbR(k,1)=mean(bef{k}(:,1));
            netposbR(k,2)=mean(bef{k}(:,2));

end

save('stimshift.mat','netposaR','netposaS','netposbR','netposbS')
saveas(h,'stimshift.fig')
saveas(h,'stimshift.png')


% 
%  disp(' ');
%     disp('... Creating Breathing Info ');
%     FilLow=FilterLFP(LFP,[4 6],1024);
%     FilHigh=FilterLFP(LFP,[8 10],1024);
%     HilLow=hilbert(Data(FilLow));
%     HilHigh=hilbert(Data(FilHigh));
%     H=abs(HilHigh);
%     LowRatio=abs(HilLow)./H;
%     rgLowRatio=Range(FilHigh,'s');
%     LowRatio=SmoothDec(LowRatio(1:pasTheta:end),50);
%     rgLowRatio=rgLowRatio(1:pasTheta:end);
%     LowRatioTSD=tsd(rgLowRatio*1E4,LowRatio);
%     smooth_Low=tsd(Range(LowRatioTSD),smooth(Data(LowRatioTSD),12));

    
  

%%%%%%%%%

tot_ghi=[];
tot_theta=[];
inter=3;
clear bef aft
j=1;
for k=1:10
    clear stimEpoch
    cd (filename{k})
    k
    scrsz = get(0,'ScreenSize');
    try
        load('LFPData/LFP1.mat');
    catch
        load('LFPData/LFP2.mat');
    end
    
    r=Range(LFP);
    TotalEpoch=intervalSet(0*1e4,r(end));
    load('StateEpochSB.mat')
    ghi_new=Restrict(smooth_ghi,TotalEpoch);
    theta_new=Restrict(smooth_Theta,TotalEpoch);
    t=Range(theta_new);
    ti=t(5:5:end);
    ghi_new=Restrict(ghi_new,ts(ti));
    theta_new=Restrict(theta_new,ts(ti));
    
    tot_ghi=[tot_ghi;Data(ghi_new)];
    tot_theta=[tot_theta;Data(theta_new)];
    try
        for s=1:size(Start(substimEpoch),1)
        Ep= And(stimEpoch,subset(substimEpoch,s));
        
        befEpoch=intervalSet(Start(Ep)-inter*1e4,Start(Ep)-0.2*1e4);
        aftEpoch=intervalSet(Start(Ep)+0.2*1e4,Start(Ep)+inter*1e4);
        
        for i=1:length(Start(befEpoch))
            
            bef{j}(i,1)=mean(Restrict(ghi_new,subset(befEpoch,i)));
            bef{j}(i,2)=mean(Restrict(theta_new,subset(befEpoch,i)));
            aft{j}(i,1)=mean(Restrict(ghi_new,subset(aftEpoch,i)));
            aft{j}(i,2)=mean(Restrict(theta_new,subset(aftEpoch,i)));
                      
            
        end
        netdeplacement(j,1)=mean(log(aft{j}(:,1))-log(bef{j}(:,1)));
            netdeplacement(j,2)=mean(log(aft{j}(:,2))-log(bef{j}(:,2)));
            netposa(j,1)=mean(aft{j}(:,1));
            netposa(j,2)=mean(aft{j}(:,2));
            netposb(j,1)=mean(bef{j}(:,1));
            netposb(j,2)=mean(bef{j}(:,2));
            j=j+1;
            k
        end
    end
end
