function [Mat1,CSlCy]=LastFigureBilanParcoursSleepCycle(str,listMice,nbSlCy,power)

% try
%  cd /media/mobssenior/Data2/Dropbox/Kteam
% catch
%  cd /Users/Bench/Dropbox/Kteam
% end
% load DataParcoursSleepCycle


% Mat(:,1)=DurSleepCycle;
% Mat(:,2)=TimeSleepCycleMin;
% Mat(:,3)=TotalTimeREMPerCycle;
% Mat(:,4)=RatioTimeREMPerCycle;
% Mat(:,5)=NbSWSPerCycle;
% Mat(:,6)=MeanTimeSWSPerCycle;
% Mat(:,7)=TotalTimeSWSPerCycle;
% Mat(:,8)=RatioTimeSWSPerCycle;
% Mat(:,9)=NbWakePerCycle;
% Mat(:,10)=MeanTimeWakePerCycle;
% Mat(:,11)=TotalTimeWakePerCycle;
% Mat(:,12)=RatioTimeWakePerCycle;
% Mat(:,13)=TimeDebRecording;
% Mat(:,14)=TimeSleepCycle;

% 
% CaracSlCy(1,1)=mean(End(SleepCycle,'s')-Start(SleepCycle,'s'));
% CaracSlCy(1,2)=length(Start(SleepCycle));
% CaracSlCy(1,3)=mean(diff(Start(SleepCycle,'s')));
% CaracSlCy(1,4)=mean(End(SleepCycle2,'s')-Start(SleepCycle2,'s'));
% CaracSlCy(1,5)=length(Start(SleepCycle2));
% CaracSlCy(1,6)=mean(diff(Start(SleepCycle2,'s')));
% CaracSlCy(1,7)=mean(End(SleepCycle3,'s')-Start(SleepCycle3,'s'));
% CaracSlCy(1,8)=length(Start(SleepCycle3));
% CaracSlCy(1,9)=mean(diff(Start(SleepCycle3,'s')));


%-----------------------------------------------------------------
%-----------------------------------------------------------------

filenma='/media/mobssenior/Data2/Dropbox/Kteam/';
% filenma='/Users/Bench/Dropbox/Kteam/';
disp('')
disp('***********************************************')
if str==1
load([filenma,'DataParcoursSleepCycleMLBulb15secWakeControlled.mat'])
    disp('wt Bulb')
elseif str==2
    load([filenma,'DataParcoursSleepCycleMLPfc15secWakeControlled.mat'])
    disp('wt PFC')
elseif str==3
    load([filenma,'DataParcoursSleepCycleMLHpc15secWakeControlled.mat'])
    disp('wt HPC')
elseif str==4
    load([filenma,'DataParcoursSleepCycleMLBulb15secWakeControlledKO.mat'])
%     load('/Users/Bench/Dropbox/Kteam/DataParcoursSleepCycleMLBulb15secWakeControlled.mat')
disp('dKO Bulb')
elseif str==5
    load([filenma,'DataParcoursSleepCycleMLPfc15secWakeControlledKO.mat'])
disp('dKO Pfc')    
end

disp('***********************************************')
disp('')


try
    nbSlCy;
catch
    nbSlCy=44; % 35;% 28; %44;
end



try
    listMice;
catch
    if str>3
    listMice=1:length(ReNormT);
    %disp(num2str(length(ReNormT)))
    end
    % listMice=[[1:13],[24:28]];
    %listMice=[[1:8],[10:13],[24:28]];
    listMice=1:28; %13; %28;%13;
    %listMice=1:13; %28;%13;
    % listMice(18)=[];
    % listMice(6)=[];
end

try
    power;
catch
    power=[2 4];
    %power=[10 15];
    %power=[6 9];
end

%-----------------------------------------------------------------
%-----------------------------------------------------------------
 
for i=listMice%1:length(ReNormT)
    try
        Rt=Rt+ReNormT{i}';
    catch
        Rt=ReNormT{i}';
    end    
end


temps=tps{1};
fff=ff{1}(1,:);


k=1;
clear pow
clear var
clear varz
for i=listMice
pow(k,:)=mean(ReNormT{i}(:,find(fff>power(1)&fff<power(2))),2);
var(k,:)=polyfit(temps(1,:),log(pow(k,:)),1);
varz(k,:)=polyfit(temps(1,:),log(4+zscore(pow(k,:))),1);
k=k+1;
end


clear pow2
clear var2
clear var2z
k=1;
for i=listMice
    a=1;
    for j=1:size(ReNormT2{i},1)/length(tps(1,:))
    pow2(k,a,:)=mean(ReNormT2{i}(j:j+100,find(fff>power(1)&fff<power(2))),2);
    var2(k,a,:)=polyfit(temps(1,:)',log(squeeze(pow2(k,a,:))),1);
    var2z(k,a,:)=polyfit(temps(1,:)',log(4+zscore(squeeze(pow2(k,a,:)))),1);
    a=a+1;
    end
    k=k+1;
end


clear Rt2
clear Rt2z
a=1;b=1;
for j=1:101:nbSlCy*100
        Rt2{a}=[];
        Rt2z{a}=[];
        Nb(b)=0;
        for i=listMice
            try
            Rt2{a}=[Rt2{a};mean(ReNormT2{i}(j:j+100,find(fff>power(1)&fff<power(2))),2)'];
            Rt2z{a}=[Rt2z{a};zscore(mean(ReNormT2{i}(j:j+100,find(fff>power(1)&fff<power(2))),2))'];
            Nb(b)=Nb(b)+1;
            end
        end
        a=a+1;
        b=b+1;
end

RtsleCy=[];
RtsleCyz=[];
for i=1:length(Rt2z)
    try
    RtsleCy=[RtsleCy;mean(Rt2{i})];
    RtsleCyz=[RtsleCyz;mean(Rt2z{i})];
    end
end

lim=100;
for i=listMice%1:length(ReNormT)
    Rt3{i}=zeros(size(ReNormT2{1}(1:1+lim,:)',1),size(ReNormT2{1}(1:1+lim,:)',2));
    for j=1:lim+1:nbSlCy*(lim)       
        try
        Rt3{i}=Rt3{i}+ReNormT2{i}(j:j+lim,:)';
        end
    end  
end

for i=listMice%1:length(ReNormT)
    try
        Rt4=Rt4+Rt3{i};
    catch
        Rt4=Rt3{i};
    end    
end
Rt4=Rt4/nbSlCy/length(listMice);

%-----------------------------------------------------------------
%% figure1
%-----------------------------------------------------------------
figure('color',[1 1 1]), imagesc(0:0.1:1,fff(1,:),Rt), axis xy, title(['n=',num2str(length(listMice))])
figure('color',[1 1 1]), imagesc(0:0.1:1,fff(1,:),10*log10(Rt)), axis xy, title(['n=',num2str(length(listMice))])

figure('color',[1 1 1]), imagesc(0:0.1:1,fff(1,:),Rt4), axis xy, title(['n=',num2str(length(listMice))])
figure('color',[1 1 1]), imagesc(0:0.1:1,fff(1,:),10*log10(Rt4)), axis xy, title(['n=',num2str(length(listMice))])


%-----------------------------------------------------------------
%% figure2
%-----------------------------------------------------------------

figure('color',[1 1 1]),
k=1;
for i=listMice    
 subplot(floor(length(listMice)/5)+1,5,k), imagesc(ReNormT{i}'), axis xy, title(nameMouse(i))
 k=k+1;
end

figure('color',[1 1 1]),
k=1;
for i=listMice    
 subplot(floor(length(listMice)/5)+1,5,k), imagesc(Rt3{i}), axis xy, title(nameMouse(i))
 k=k+1;
end
%-----------------------------------------------------------------
%% figure3
%-----------------------------------------------------------------


figure('color',[1 1 1]),
subplot(2,2,1), imagesc(10*log10(RtsleCy))
subplot(2,2,2), imagesc(RtsleCyz)
 for i=1:length(Rt2z)
    subplot(2,2,3),hold on, plot(mean(10*log10(Rt2{i}))','color',[i/length(Rt2z) 0 (length(Rt2z)-i)/length(Rt2z)])    
     subplot(2,2,4),hold on, plot(mean(Rt2z{i})','color',[i/length(Rt2z) 0 (length(Rt2z)-i)/length(Rt2z)])
 end   
    
 %-----------------------------------------------------------------
%% figure4
%-----------------------------------------------------------------
figure('color',[1 1 1]), plot(Nb,'ko-','markerfacecolor','k')
yl=ylim;
ylim([0 yl(2)+1])

 
%-----------------------------------------------------------------
%% figure5
%-----------------------------------------------------------------
try
[ht,bt]=hist(temp1/60,100);
figure('color',[1 1 1]), 
subplot(1,2,1), bar(bt,ht,1,'k'), hold on, plot(bt,smooth(ht,10),'r','linewidth',2)
set(gca,'xscale','log')
set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 15 20 60])

subplot(1,2,2), plot(temp1(1:end-1)/60,temp1(2:end)/60,'k.-')
set(gca,'yscale','log')
set(gca,'xscale','log')
title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
set(gca,'xtick',[1 2 3 4 5 6 7 8 10 15 20 40 60 100 500])
set(gca,'ytick',[1 2 3 4 5 6 7 8 10 15 20 40 60 100 500])
end






CSlCy=[];
for i=1:length(CaracSlCy)
    CSlCy=[CSlCy;CaracSlCy{i}];   
end





