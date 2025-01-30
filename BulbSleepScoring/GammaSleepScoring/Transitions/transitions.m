for m=3:5
     cd(filename{m})
load('StateEpochSB.mat');
load('diffmethods.mat');
load(strcat(filename2{m},'StateEpoch.mat'))
load(strcat(filename2{m},'behavResources.mat'))

 h=figure(10);
set(h,'color',[1 1 1],'Position',[60 80 3800 500])
 r=Range(smooth_ghi{1});
 TotalEpoch=intervalSet(0,r(end)); 
PlotEp=TotalEpoch-NoiseEpoch-GndNoiseEpoch;
try
    PlotEp=And(PlotEp,PreEpoch);
end
    
for i=1:length(smooth_ghi)
ghi_new=Restrict(smooth_ghi{i},PlotEp);
theta_new=Restrict(smooth_Theta,PlotEp);
%need to think about this
t=Range(theta_new);
ti=t(5:5:end);
ghi_new=Restrict(ghi_new,ts(ti));
theta_new=Restrict(theta_new,ts(ti));

begin=Start(PlotEp)/1e4;
begin=begin(1);
endin=Stop(PlotEp)/1e4;
endin=endin(end);

subplot(2,14,i)
sleeptheta=(Restrict(theta_new,And(PlotEp,SWSEpoch)));
ghi_new_s=Restrict(ghi_new,ts(Range(sleeptheta)));
plot(log(Data(ghi_new_s)),log(Data(sleeptheta)),'.','color',[0 0.8 1],'MarkerSize',5);
hold on
remtheta=(Restrict(theta_new,And(PlotEp,REMEpoch)));
ghi_new_r=Restrict(ghi_new,ts(Range(remtheta)));
plot(log(Data(ghi_new_r)),log(Data(remtheta)),'.','color',[0.8 0.2 0.1],'MarkerSize',5);
waketheta=(Restrict(theta_new,And(PlotEp,MovEpoch)));
ghi_new_w=Restrict(ghi_new,ts(Range(waketheta)));
plot(log(Data(ghi_new_w)),log(Data(waketheta)),'.','color',[0.2 0.2 0.2],'MarkerSize',5);
subplot(2,14,i+14)
[Y,X]=hist(log(Data(ghi_new)),700);
plot(X,Y/sum(Y))

end
saveFigure(h,'phasespacesmoothhist1',filename{m})
saveas(h,'phasespacesmoothhist1.fig')

clf
 h=figure(10);
set(h,'color',[1 1 1],'Position',[60 80 3800 500])

for i=1:length(smooth_ghi_fil)
    ghi_new=Restrict(smooth_ghi_fil{i},PlotEp);
theta_new=Restrict(smooth_Theta,PlotEp);
%need to think about this
t=Range(theta_new);
ti=t(5:5:end);
ghi_new=Restrict(ghi_new,ts(ti));
theta_new=Restrict(theta_new,ts(ti));

begin=Start(PlotEp)/1e4;
begin=begin(1);
endin=Stop(PlotEp)/1e4;
endin=endin(end);

subplot(2,14,i)
sleeptheta=(Restrict(theta_new,And(PlotEp,SWSEpoch)));
ghi_new_s=Restrict(ghi_new,ts(Range(sleeptheta)));
plot(log(Data(ghi_new_s)),log(Data(sleeptheta)),'.','color',[0 0.8 1],'MarkerSize',5);
hold on
remtheta=(Restrict(theta_new,And(PlotEp,REMEpoch)));
ghi_new_r=Restrict(ghi_new,ts(Range(remtheta)));
plot(log(Data(ghi_new_r)),log(Data(remtheta)),'.','color',[0.8 0.2 0.1],'MarkerSize',5);
waketheta=(Restrict(theta_new,And(PlotEp,MovEpoch)));
ghi_new_w=Restrict(ghi_new,ts(Range(waketheta)));
plot(log(Data(ghi_new_w)),log(Data(waketheta)),'.','color',[0.2 0.2 0.2],'MarkerSize',5);
subplot(2,14,i+14)
[Y,X]=hist(log(Data(ghi_new)),700);
plot(X,Y/sum(Y))
end
saveFigure(h,'phasespacesmoothhist2',filename{m})
saveas(h,'phasespacesmoothhist2.fig')

clf
 h=figure(10);
set(h,'color',[1 1 1],'Position',[60 80 3800 500])

for i=1:length(smooth_ghi_hil)
    ghi_new=Restrict(smooth_ghi_hil{i},PlotEp);
theta_new=Restrict(smooth_Theta,PlotEp);
%need to think about this
t=Range(theta_new);
ti=t(5:5:end);
ghi_new=Restrict(ghi_new,ts(ti));
theta_new=Restrict(theta_new,ts(ti));

begin=Start(PlotEp)/1e4;
begin=begin(1);
endin=Stop(PlotEp)/1e4;
endin=endin(end);

subplot(2,14,i)
sleeptheta=(Restrict(theta_new,And(PlotEp,SWSEpoch)));
ghi_new_s=Restrict(ghi_new,ts(Range(sleeptheta)));
plot(log(Data(ghi_new_s)),log(Data(sleeptheta)),'.','color',[0 0.8 1],'MarkerSize',5);
hold on
remtheta=(Restrict(theta_new,And(PlotEp,REMEpoch)));
ghi_new_r=Restrict(ghi_new,ts(Range(remtheta)));
plot(log(Data(ghi_new_r)),log(Data(remtheta)),'.','color',[0.8 0.2 0.1],'MarkerSize',5);
waketheta=(Restrict(theta_new,And(PlotEp,MovEpoch)));
ghi_new_w=Restrict(ghi_new,ts(Range(waketheta)));
plot(log(Data(ghi_new_w)),log(Data(waketheta)),'.','color',[0.2 0.2 0.2],'MarkerSize',5);
subplot(2,14,i+14)
[Y,X]=hist(log(Data(ghi_new)),700);
plot(X,Y/sum(Y))
end
saveFigure(h,'phasespacesmoothhist3',filename{m})
saveas(h,'phasespacesmoothhist3.fig')
clf
close all

load StateEpochSB.mat Wake SWSEpoch REMEpoch MicroWake
h=figure;
set(h,'color',[1 1 1],'Position',[1 1 1600 600])

[aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
tval=Stop(aft_cell{1,2});
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
[Msw,Tsw]=PlotRipRaw(Restrict(smooth_ghi{6},PlotEp),tval/1e4,10000);close;


[aft_cell,bef_cell]=transEpoch(SWSEpoch,REMEpoch);
tval=Stop(aft_cell{1,2});
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
[Msr,Tsr]=PlotRipRaw(Restrict(smooth_ghi{6},PlotEp),tval/1e4,10000);close;


[aft_cell,bef_cell]=transEpoch(REMEpoch,Wake);
tval=Stop(aft_cell{1,2});
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
try
[Mrw,Trw]=PlotRipRaw(Restrict(smooth_ghi{6},PlotEp),tval/1e4,10000);close;
catch
    Mrw=[];
end
tval=Start(SWSEpoch);
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
[Mws,Tws]=PlotRipRaw(Restrict(smooth_ghi{6},PlotEp),tval/1e4,10000);close;

tval=Start(Wake);
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
[Mw,Tw]=PlotRipRaw(smooth_ghi{6},tval/1e4,10000);close;

tval=Start(MicroWake);
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
try
[Mmw,Tmw]=PlotRipRaw(Restrict(smooth_ghi{6},PlotEp),tval/1e4,10000);close;
catch
    Mmw=[];
end
save('Transitions1.mat','Mw','Msw','Msr','Mrw','Mws','Mmw','-v7.3')
figure(h)
plot(Msw(:,2),'r')
hold on
plot(Msr(:,2),'k')
try
plot(Mrw(:,2),'b')
end
plot(fliplr(Mws(:,2)'),'g')
    plot(Mw(:,2),'m')
try
    plot(Mmw(:,2),'c')
end

saveFigure(h,'transitions1',filename{m})
saveas(h,'transitions1.fig')

clf
h=figure;
set(h,'color',[1 1 1],'Position',[1 1 1600 600])


[aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
tval=Stop(aft_cell{1,2});
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
[Msw,Tsw]=PlotRipRaw(Restrict(smooth_ghi_fil{6},PlotEp),tval/1e4,10000);close;


[aft_cell,bef_cell]=transEpoch(SWSEpoch,REMEpoch);
tval=Stop(aft_cell{1,2});
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
[Msr,Tsr]=PlotRipRaw(Restrict(smooth_ghi_fil{6},PlotEp),tval/1e4,10000);close;


[aft_cell,bef_cell]=transEpoch(REMEpoch,Wake);
tval=Stop(aft_cell{1,2});
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
try
[Mrw,Trw]=PlotRipRaw(Restrict(smooth_ghi_fil{6},PlotEp),tval/1e4,10000);close;
catch
    Mrw=[];
end

tval=Start(SWSEpoch);
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
[Mws,Tws]=PlotRipRaw(Restrict(smooth_ghi_fil{6},PlotEp),tval/1e4,10000);close;

tval=Start(Wake);
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
[Mw,Tw]=PlotRipRaw(smooth_ghi_fil{6},tval/1e4,10000);close;

tval=Start(MicroWake);
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
try
[Mmw,Tmw]=PlotRipRaw(Restrict(smooth_ghi_fil{6},PlotEp),tval/1e4,10000);close;
catch
    Mmw=[];
end

save('Transitions2.mat','Mw','Msw','Msr','Mrw','Mws','Mmw','-v7.3')
figure(h)
plot(Msw(:,2),'r')
hold on
plot(Msr(:,2),'k')
try
plot(Mrw(:,2),'b')
end
plot(fliplr(Mws(:,2)'),'g')

try
    plot(Mmw(:,2),'c')
end
plot(Mw(:,2),'m')
saveFigure(h,'transitions2',filename{m})
saveas(h,'transitions2.fig')

clf
h=figure;
set(h,'color',[1 1 1],'Position',[1 1 1600 600])


[aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
tval=Stop(aft_cell{1,2});
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
[Msw,Tsw]=PlotRipRaw(Restrict(smooth_ghi_hil{6},PlotEp),tval/1e4,10000);close;


[aft_cell,bef_cell]=transEpoch(SWSEpoch,REMEpoch);
tval=Stop(aft_cell{1,2});
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
[Msr,Tsr]=PlotRipRaw(Restrict(smooth_ghi_hil{6},PlotEp),tval/1e4,10000);close;


[aft_cell,bef_cell]=transEpoch(REMEpoch,Wake);
tval=Stop(aft_cell{1,2});
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
try
[Mrw,Trw]=PlotRipRaw(Restrict(smooth_ghi_hil{6},PlotEp),tval/1e4,10000);close;
catch
    Mrw=[];
end

tval=Start(SWSEpoch);
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
[Mws,Tws]=PlotRipRaw(Restrict(smooth_ghi_hil{6},PlotEp),tval/1e4,10000);close;

tval=Start(Wake);
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
[Mw,Tw]=PlotRipRaw(smooth_ghi_hil{6},tval/1e4,10000);close;

tval=Start(MicroWake);
nogood=[];
for i=1:length(tval);
    subEp=intervalSet(tval(i)-5*1e4,tval(i)+5*1e4);
    if (size(start(And(subEp,NoiseEpoch)),1)+size(start(And(subEp,GndNoiseEpoch)),1))~=0
        nogood=[nogood,i];
    end
end
tval(nogood)=[];
try
[Mmw,Tmw]=PlotRipRaw(Restrict(smooth_ghi_hil{6},PlotEp),tval/1e4,10000);close;
catch
    Mmw=[];
end

save('Transitions3.mat','Mw','Msw','Msr','Mrw','Mws','Mmw','-v7.3')
figure(h)
plot(Msw(:,2),'r')
hold on
plot(Msr(:,2),'k')
try
plot(Mrw(:,2),'b')
end
plot(fliplr(Mws(:,2)'),'g')
plot(Mw(:,2),'m')
try
    plot(Mmw(:,2),'c')
end
saveFigure(h,'transitions3',filename{m})
saveas(h,'transitions3.fig')

close all
end


%%plot
h=figure;
set(h,'color',[1 1 1],'Position',[1 1 1600 600])

for i=1:3
Msw2=[];
Msr2=[];
Mrw2=[];
Mws2=[];
Mw2=[];
Mmw2=[];

load(strcat('/media/DataMOBs14/BulbSleepScoring/DataForFigures/Mouse83/Transitions',num2str(i),'.mat'))
Msw2=[Msw2,Msw(:,2)];
Msr2=[Msr2,Msr(:,2)];
try
Mrw2=[Mrw2,Mrw(:,2)];
end
Mws2=[Mws2,Mws(:,2)];
Mw2=[Mw,Mw(:,2)];
try
    Mmw2=[Mmw,Mmw(:,2)];
end
load(strcat('/media/DataMOBs14/BulbSleepScoring/DataForFigures/Mouse82/Transitions',num2str(i),'.mat'))
Msw2=[Msw2,Msw(:,2)];
Msr2=[Msr2,Msr(:,2)];
Mrw2=[Mrw2,Mrw(:,2)];
Mws2=[Mws2,Mws(:,2)];
Mw2=[Mw,Mw(:,2)];
Mmw2=[Mmw,Mmw(:,2)];
load(strcat('/media/DataMOBs14/BulbSleepScoring/DataForFigures/Mouse60/Transitions',num2str(i),'.mat'))
Msw2=[Msw2,Msw(:,2)];
Msr2=[Msr2,Msr(:,2)];
Mrw2=[Mrw2,Mrw(:,2)];
Mws2=[Mws2,Mws(:,2)];
Mw2=[Mw,Mw(:,2)];
Mmw2=[Mmw,Mmw(:,2)];

subplot(1,3,i)
DT=10000/size(mean(Mw2'),2);
time=([DT:DT:10000]-5000)/1e3;
plot(time,mean(Msw2'),'b','linewidth',3)
hold on
% plot(mean(Msr2'),'k')
try
plot(time,mean(Mrw2'),'r','linewidth',3)
end
plot(time,fliplr(mean(Mws2')),'k','linewidth',3)
% plot(mean(Mw2'),'m')
try
%     plot(mean(Mmw2'),'c','linewidth',3)
end

end



% clf
cc=hsv(3)
smfact=[0.1,0.2,0.5,1,2,3,4,5,7,10];
clear a b c d e f 
for m=3:5
cd(filename{m})
load diffmethods2.mat rms dist
a(m,:)=rms{1}(:,5)./rms{1}(:,6);
b(m,:)=rms{2}(:,5)./rms{2}(:,6);
c(m,:)=rms{3}(:,5)./rms{3}(:,6);
d(m,:)=rms{1}(:,7)./rms{1}(:,8);
e(m,:)=rms{2}(:,7)./rms{2}(:,8);
f(m,:)=rms{3}(:,7)./rms{3}(:,8);
% a(m,:)=dist{1}(:,2);
% b(m,:)=dist{2}(:,2);
% c(m,:)=dist{3}(:,2);
% d(m,:)=dist{1}(:,1);
% e(m,:)=dist{2}(:,1);
% f(m,:)=dist{3}(:,1);


end
figure
subplot(231)
plot(smfact,mean(a(:,1:10)),'color',cc(m-2,:),'linewidth',3)
hold on
subplot(232)
plot(smfact,mean(b(:,1:10)),'color',cc(m-2,:),'linewidth',3)
hold on
subplot(233)
plot(smfact,mean(c(:,1:10)),'color',cc(m-2,:),'linewidth',3)
hold on
subplot(234)
plot(smfact,mean(d(:,1:10)),'color',cc(m-2,:),'linewidth',3)
hold on
subplot(235)
plot(smfact,mean(e(:,1:10)),'color',cc(m-2,:),'linewidth',3)
hold on
subplot(236)
plot(smfact,mean(f(:,1:10)),'color',cc(m-2,:),'linewidth',3)
hold on


subplot(231)
plot(smfact,(dist{1}(1:10,2)),'color',cc(m-2,:))
hold on
subplot(232)
plot(smfact,(dist{2}(1:10,2)),'color',cc(m-2,:))
hold on
subplot(233)
plot(smfact,(dist{3}(1:10,2)),'color',cc(m-2,:))
hold on
subplot(234)
plot(smfact,(dist{1}(1:10,1)),'color',cc(m-2,:))
hold on
subplot(235)
plot(smfact,(dist{2}(1:10,1)),'color',cc(m-2,:))
hold on
subplot(236)
plot(smfact,(dist{3}(1:10,1)),'color',cc(m-2,:))
hold on