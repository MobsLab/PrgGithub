function [tps, val, tps2, val2, p, p2, x, reg, reg2]=SleepHomeostasisSleepCycle

limREM=60;
deltadensityfactor=60;

try
load('SleepSubstages.mat')
N1=Epoch{1};
N2=Epoch{2};
N3=Epoch{3};
REM=Epoch{4};
Wake=Epoch{5};
swaPF=Epoch{8};
swaOB=Epoch{9};
SWSEpoch=or(or(N1,N2),N3);
catch
    try
        load SleepScoring_OBGamma Epoch REMEpoch SWSEpoch Wake
        REM=REMEpoch;
    catch
        [SWSEpoch, REM, Wake, TotalNoiseEpoch] = GetSleepScoring;       
    end
end



load('DeltaWaves.mat', 'deltas_PFCx')

load behavResources NewtsdZT
rg=Data(NewtsdZT);
night_duration = max(Range(NewtsdZT));

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------


colorUp=[207 35 35]/255;
colorDown=[32 215 28]/255;
colorBox=[205 225 255]/255; %[197 246 2]

SleepStages=PlotSleepStage(Wake,SWSEpoch,REM); close
[REM,WakeC,idbad]=CleanREMEpoch(SleepStages,REM,Wake);
REMm=mergeCloseIntervals(REM,limREM*1E4);
Wake=Wake-REMm; SWSEpoch=SWSEpoch-REMm;
EnRem=End(REMm);
SleepCycle=intervalSet(EnRem(1:end-1),EnRem(2:end));
firstSleepCycle=intervalSet(0, EnRem(1));
SleepCycle=or(firstSleepCycle,SleepCycle);

%[SleepCycle,SleepCycle2,SleepCycle3]=FindSleepCycles_KB(Wake,SWSEpoch,REMm,15);

clear dur
clear stok
for i=1:length(Start(SleepCycle))
    clear dur
    stok(i)=Start(subset(SleepCycle,i));
    dur=End(and(Wake,subset(SleepCycle,i)),'s')-Start(and(Wake,subset(SleepCycle,i)),'s');
    if length(dur)>0

   %%     
        for j=1:length(dur)
            if dur(j)>10
                try
                    if dur(j)>dur(j-1)
                    stok(i)=End(subset(and(Wake,subset(SleepCycle,i)),j));%stok(i), disp('check 1')
                    end
                catch
                    stok(i)=End(subset(and(Wake,subset(SleepCycle,i)),j));%stok(i), disp('check 2')
                end
            end
        end
        
        
    else
         stok(i)=Start(subset(SleepCycle,i)); %stok(i), disp('check 4')
    end
end

SleepCycleOK=intervalSet(stok, End(SleepCycle));
SleepStagesC=PlotSleepStage(Wake,SWSEpoch,REMm);close

% 
% SleepStagesC=PlotSleepStage(Wake,SWSEpoch,REMm);
% YL=ylim;    
% boxbottom = YL(1);
% boxhight = YL(2);
% st=Start(SleepCycleOK,'s');
% en=End(SleepCycleOK,'s');
% for i=1:length(Start(SleepCycleOK))
% rectangle('Position', [st(i) boxbottom en(i)-st(i) boxhight-boxbottom], 'LineStyle', 'none', 'FaceColor', colorBox);line([st(i) st(i)],YL,'color',[0.7 0.7 0.7 ])
% end 
% SleepStagesC=PlotSleepStage(Wake,SWSEpoch,REMm,0); title(pwd)


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

smoothing = 2;
windowsize = deltadensityfactor*1E4; %60s
intervals_start = 0:windowsize:night_duration;
x_intervals = (intervals_start + windowsize/2)/3600e4 + rg(1)/3600e4;

start_delta1 = ts(Start(and(deltas_PFCx,SWSEpoch)));
%start_delta1 = ts(Start(deltas_PFCx));

%compute density
density_delta1 = zeros(length(intervals_start),1);
for t=1:length(intervals_start)
intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
density_delta1(t) = length(Restrict(start_delta1,intv))/60; %per sec
end

trghs = LocalMaxima(density_delta1);

%intervals_start(trghs)
%x_intervals(trghs)
%density_delta1(trghs)
%
%temp=tsd(intervals_start(trghs),x_intervals(trghs)');
temp2=tsd(intervals_start(trghs),trghs);
trghs=Data(Restrict(temp2,SWSEpoch));

trghs2=Data(Restrict(temp2,SleepCycleOK));

%smooth
smooth_delta1 = Smooth(density_delta1, smoothing);
idx_delta1 = find(density_delta1(trghs) > max(density_delta1(trghs))/3);
trghs=trghs(idx_delta1);

idx_delta2 = find(density_delta1(trghs2) > max(density_delta1(trghs))/3);
trghs2=trghs2(idx_delta2);



%regression
[p_delta1,~] = polyfit(x_intervals(trghs), density_delta1(trghs)', 1);
reg_delta1 = polyval(p_delta1,x_intervals);

[p_delta2,~] = polyfit(x_intervals(trghs2), density_delta1(trghs2)', 1);
reg_delta2 = polyval(p_delta2,x_intervals);

%plot
% figure, hold on
% plot(x_intervals, density_delta1,'-','color', 'k', 'Linewidth', 1), hold on
% plot(x_intervals, smooth_delta1,'-','color', 'r', 'Linewidth', 1), hold on
% plot(x_intervals, reg_delta1, 'color', 'b'), hold on
% scatter(x_intervals, smooth_delta1',20, smooth_delta1/max(smooth_delta1),'filled');
% plot(x_intervals(idx_delta1), smooth_delta1(idx_delta1)', 'bo','markerfacecolor','b');
% xlabel('Time(h)'), ylabel('per sec');
% title('delta waves')
% 
% 



temp3=tsd(Range(NewtsdZT), rescale(Data(Restrict(SleepStagesC,NewtsdZT)),0,0.3));

figure, hold on
YL=ylim;    
boxbottom = 0;
boxhight = 1.5;
st=Data(Restrict(NewtsdZT,ts(Start(SleepCycleOK))))/1E4/3600;
en=Data(Restrict(NewtsdZT,ts(End(SleepCycleOK))))/1E4/3600;
for i=1:length(Start(SleepCycleOK))
    rectangle('Position', [st(i) boxbottom en(i)-st(i) boxhight-boxbottom], 'LineStyle', 'none', 'FaceColor', colorBox);line([st(i) st(i)],YL,'color',[0.7 0.7 0.7 ])
end
plot(Data(NewtsdZT)/3600e4, rescale(Data(Restrict(SleepStagesC,NewtsdZT)),0,0.3),'color',[0.4 0.4 0.4])
plot(Data(Restrict(NewtsdZT,REMm))/3600e4,Data(Restrict(temp3,REMm)),'r.')

plot(x_intervals, density_delta1,'-','color', 'k', 'Linewidth', 1), hold on
%plot(x_intervals, smooth_delta1,'-','color', 'r', 'Linewidth', 1), hold on
plot(x_intervals, reg_delta1, 'color', 'k','linewidth',2), hold on
plot(x_intervals, reg_delta2, 'color', 'r','linewidth',2), hold on

hold on, plot(x_intervals(trghs),density_delta1(trghs),'ko','markerfacecolor','y')
hold on, plot(x_intervals(trghs2),density_delta1(trghs2),'ko','markerfacecolor','r')

%scatter(x_intervals, smooth_delta1',20, smooth_delta1/max(smooth_delta1),'filled');

xlabel('Time(h)'), ylabel('per sec');
title(['Delta waves, fit - slope: ', num2str(p_delta2(1)),',   origin: ',num2str(p_delta2(2))])




tps=x_intervals(trghs);
val=density_delta1(trghs);

tps2=x_intervals(trghs2);
val2=density_delta1(trghs2);

p= p_delta1;
p2=p_delta2;

x=x_intervals;
reg=reg_delta1; 
reg2=reg_delta2;

end
