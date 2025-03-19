[M,~] = PlotRipRaw(LFP, events, durations, cleaning, PlotFigure,NewFig)
[M,T] = PlotRipRaw(Temp.TailTemperatureintTSD,Start(Behav.FreezeAccEpoch,'s'),2000)
xlim([-0.5 0.5])
ylim([20 32])
ylim([-5 5])

%mean temperature evolution for differents sessions
load('Temp_Freezing.mat')
for sess=1:length(Dir)
cd(Dir{sess})
load('Temperature.mat')
a(sess:sess+3,:)=TemperatureCurve_corrected;
a(a==0) = NaN;
end

a(a==0) = NaN;

if length(Dir)==1
    a(13,:)=a(1,:);
    a(14,:)=a(2,:);
    a(15,:)=a(3,:);
    a(16,:)=a(4,:);
else length(Dir)==3
    a(13,:)=(a(1,:)+a(5,:)+a(9,:))./3;
    a(14,:)=(a(2,:)+a(6,:)+a(10,:))./3;
    a(15,:)=(a(3,:)+a(7,:)+a(11,:))./3;
    a(16,:)=(a(4,:)+a(8,:)+a(12,:))./3;
end

subplot(4,1,1)
plot(a(13,:))
title('Tail Temp Evolution')
xlabel('T°C')
ylabel('time')
hline(30,'-.r')
subplot(4,1,2)
plot(a(14,:))
title('Nose Temp Evolution')
xlabel('T°C')
ylabel('time')
hline(30,'-.r')
subplot(4,1,3)
plot(a(15,:))
title('Neck Temp Evolution')
xlabel('T°C')
ylabel('time')
hline(30,'.-.r')
subplot(4,1,4)
plot(a(16,:))
title('Body Temp Evolution')
xlabel('T°C')
ylabel('time')
hline(30,'-.r')

%JumpEpoch
SessionAccEpoch=thresholdIntervals(Behav.Xtsd,10e10,'Direction','Below');

f=Data(Restrict(Temp.NoseTemperatureTSD,SessionAccEpoch-Behav.JumpEpoch));
g=Data(Temp.BodyTemperatureTSD);
h=Data(Restrict(Temp.NoseTemperatureTSD,Behav.JumpEpoch));

a=Start(Behav.JumpEpoch);
a(:,2)=a(:,1)./(4815610/4433);
d=Stop(Behav.JumpEpoch);
d(:,2)=d(:,1)./(4815610/4433);

plot(g)
vline(a(:,2),'-.g')
vline(d(:,2),'-.r')

%std for body part
std_comp(1)=nanstd(Data(Temp.TailTemperatureTSD));%corrected
std_comp(2)=nanstd(Data(Temp.NoseTemperatureTSD));
std_comp(3)=nanstd(Data(Temp.NeckTemperatureTSD));
std_comp(4)=nanstd(Data(Temp.BodyTemperatureTSD));

names = {'Tail','Nose','Neck','Body'};
names2 = {'TailTemperatureTSD','NoseTemperatureTSD','NeckTemperatureTSD','BodyTemperatureTSD'};
A.Tail=A.Nose=A.Neck=A.Body=[];
for sess=1:length(Dir)
    cd(Dir{sess})
    load('Temperature.mat')
    load('behavResources_SB.mat')
    for ind=1:length(names)
        v.(names{ind})=Data(Temp.(names2{ind}));
        a.(names{ind})(1:length(v.(names{ind})),sess)=v.(names{ind});
    end
    A.(names{ind})=[A.(names{ind});a.(names{ind})(:,sess)];
end

A=([a(:,1);a(:,2);a(:,3)]); B=([b(:,1);b(:,2);b(:,3)]);
C=([c(:,1);c(:,2);c(:,3)]); D=([d(:,1);d(:,2);d(:,3)]);
A(A==0) = NaN;B(B==0) = NaN;C(C==0) = NaN;D(D==0) = NaN;

for subplot(2,2,1)
histfit(A,100)
title('TailTemperature')
pd1=fitdist(A,'Normal');
xlabel('Temperature')
char_1=['mu = ' num2str(pd1.mu) '     sigma = ' num2str(pd1.sigma)];
legend([char_1])
subplot(2,2,2)
histfit(B,100)
title('NoseTemperature')
pd2=fitdist(B,'Normal');
xlabel('Temperature')
char_2=['mu = ' num2str(pd2.mu) '     sigma = ' num2str(pd2.sigma)];
legend([char_2])
subplot(2,2,3)
histfit(C,100)
title('NeckTemperature')
pd3=fitdist(C,'Normal');
xlabel('Temperature')
char_3=['mu = ' num2str(pd3.mu) '     sigma = ' num2str(pd3.sigma)];
legend([char_3])
subplot(2,2,4)
histfit(D,100)
title('BodyTemperature')
pd4=fitdist(D,'Normal');
xlabel('Temperature')
char_4=['mu = ' num2str(pd4.mu) '     sigma = ' num2str(pd4.sigma)];
legend([char_4])
suptitle('Mouse 667 CondBlockShock')





Videotimes=Range(Behav.Xtsd);

Temp.BodyTemperatureTSD=tsd(Videotimes,TemperatureCurve_corrected(4,:)');%create tsd for temperature
std_comp(2)=std(Data(Temp.BodyTemperatureTSD));

%norm distrib
subplot(2,2,1)
histfit(Data(Temp.TailTemperatureTSD))
title('Tail Temperature')
subplot(2,2,2)
histfit(Data(Temp.NoseTemperatureTSD))
title('Nose Temperature')
subplot(2,2,3)
histfit(Data(Temp.NeckTemperatureTSD))
title('Neck Temperature')
subplot(2,2,4)
histfit(Data(Temp.BodyTemperatureTSD))
title('Body Temperature')


clear all
%for cond=1:
for sess=1:length(Dir)
    cd(Dir{sess})
    load('Temperature.mat')
    load('behavResources_SB.mat')
    TotalEpoch = intervalSet(0,max(Range(Behav.Xtsd)));
    Non_FreezingAccEpoch=TotalEpoch-Behav.FreezeAccEpoch;
    v=Data(Restrict(Temp.TailTemperatureTSD,Non_FreezingAccEpoch));
    a(1:length(v),sess)=v;
    w=Data(Restrict(Temp.TailTemperatureTSD,Behav.FreezeAccEpoch));
    c(1:length(w),sess)=w;
end

b=([a(:,1);a(:,2);a(:,3)]);
d=([c(:,1);c(:,2);c(:,3)]);
b(b==0) = NaN;
d(d==0) = NaN;
histfit(b,120)
hold on
histfit(d,120)
legend('Explo std=2.4715','','Freezing std=1.4696')
xlabel('Temperature')
title('TailTemperature Global')
std1=nanstd(b);
std2=nanstd(d);

%look for zone 4 also
for sess=1:length(Dir)
    cd(Dir{sess})
    load('Temperature.mat')
    load('behavResources_SB.mat')
    TotalEpoch = intervalSet(0,max(Range(Behav.Xtsd)));
    Non_FreezingAccEpoch=TotalEpoch-Behav.FreezeAccEpoch;
    v=Data(Restrict(Temp.TailTemperatureTSD,and(Non_FreezingAccEpoch,Behav.ZoneEpoch{1})));
    a(1:length(v),sess)=v;
    w=Data(Restrict(Temp.TailTemperatureTSD,and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{1})));
    c(1:length(w),sess)=w;
end

b=([a(:,1);a(:,2);a(:,3)]);
d=([c(:,1);c(:,2);c(:,3)]);
b(b==0) = NaN;
d(d==0) = NaN;
histfit(b,100)
hold on
histfit(d,100)
xlabel('Temperature')
title('TailTemperature Shock Zone')
pd1=fitdist(b,'Normal');
pd2= fitdist(d,'Normal');
char_1=['mu = ' num2str(pd1.mu) '     sigma = ' num2str(pd1.sigma)];
char_2=['mu = ' num2str(pd2.mu) '     sigma = ' num2str(pd2.sigma)];
legend(['Explo ' char_1],'',['Freezing ' char_2])


%%qqplot
subplot(2,2,1)
normplot(Data(Temp.TailTemperatureTSD))
title('Tail Temperature')
subplot(2,2,2)
normplot(Data(Temp.NoseTemperatureTSD))
title('Nose Temperature')
subplot(2,2,3)
normplot(Data(Temp.NeckTemperatureTSD))
title('Neck Temperature')
subplot(2,2,4)
normplot(Data(Temp.BodyTemperatureTSD))
title('Body Temperature')

