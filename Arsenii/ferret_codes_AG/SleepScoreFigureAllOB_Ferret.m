%% Old version of the script (21/10/2024)
function SleepScoreFigureAllOB_Ferret(filename,PlotEp,OBfrequency,name_to_use,smooth_Freq1Freq2, SS_base)

try
    filename;
catch
    filename=[pwd,'/'];
end

load(name_to_use)
if exist('StateEpochSB.mat')>0
    load(strcat(filename,'StateEpochSB'),'NoiseEpoch','GndNoiseEpoch','smooth_ghi','gamma_thresh')
else
    load('SleepScoring_OBGamma.mat','SubNoiseEpoch','SmoothGamma','Info')
    NoiseEpoch = SubNoiseEpoch.HighNoiseEpoch;
    GndNoiseEpoch = SubNoiseEpoch.GndNoiseEpoch;
    smooth_ghi = SmoothGamma;
    gamma_thresh = Info.gamma_thresh;
end

sleepper = Sleep; 

load(strcat(filename,'B_High_Spectrum.mat'));
sptsdB=tsd(Spectro{2}*1e4,Spectro{1});
fB=Spectro{3};
clear Spectro
switch SS_base
    case '1-8'
        load(strcat(filename,'B_Low_Spectrum.mat'))
        sptsdH=tsd(Spectro{2}*1e4,Spectro{1});
        fH=Spectro{3};
        clear Spectro
    case '0.1-0.5'
        load(strcat(filename,'B_UltraLow_Spectrum.mat'))
        sptsdUL=tsd(Spectro{2}*1e4,Spectro{1});
        fUl=Spectro{3};
        clear Spectro
end

try
    ghi_new=Restrict(smooth_ghi,PlotEp);
    theta_new=Restrict(smooth_Freq1Freq2,PlotEp);
catch
    ghi_new=smooth_ghi;
    theta_new=smooth_Freq1Freq2;
end

% need to think about this
t=Range(theta_new);
ti=t(5:1200:end);
ghi_new=(Restrict(ghi_new,ts(ti)));
theta_new=(Restrict(theta_new,ts(ti)));

try
    begin=Start(PlotEp)/1e4;
    begin=begin(1);
    endin=Stop(PlotEp)/1e4;
    endin=endin(end);
catch
    begin=t(1)/1e4;
    endin=t(end)/1e4;
end


%% Plot figure
h=figure;
set(h,'color',[1 1 1],'Position',[1 1 1600 600])
subplot(6,3,[1:2,4:5])

switch SS_base
    case '1-8'
        imagesc(Range(sptsdH,'s'),fH,10*log10(Data(sptsdH))'), axis xy, caxis([20 60]);
        coord_evol_line = [19 19];
    case '0.1-0.5'
        imagesc(Range(sptsdUL,'s'),fUl,10*log10(Data(sptsdUL))'), axis xy, caxis([20 65]);
        coord_evol_line = [.95 .95];
end

hold on
line([begin endin],coord_evol_line,'linewidth',10,'color','w')
sleepstart=Start(S2_epoch);
sleepstop=Stop(S2_epoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4], coord_evol_line,'color',[1 0 0],'linewidth',5); % color changed on the 12th of june. RED - (NREM) - S2
end
sleepstart=Start(S1_epoch);
sleepstop=Stop(S1_epoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],coord_evol_line,'color',[0 1 0]  ,'linewidth',5); % color changed on the 12th of june
end
sleepstart=Start(Wake);
sleepstop=Stop(Wake);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],coord_evol_line,'color',[0 0 1]  ,'linewidth',5);
end


 % modif KB----------------------------------------------------------------------------
 % ------------------------------------------------------------------------------------
     
 try
     sleepstart=Start(TotalNoiseEpoch);
     sleepstop=Stop(TotalNoiseEpoch);
 catch
     sleepstart=Start(GndNoiseEpoch);
     sleepstop=Stop(GndNoiseEpoch);
 end

 % modif KB----------------------------------------------------------------------------
 % ------------------------------------------------------------------------------------
     
 
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],coord_evol_line,'color','w','linewidth',5);
end
xlim([begin endin])
set(gca,'XTick',[])
switch SS_base
    case '1-8'
        title('OB low spectrum')
    case '0.1-0.5'
        title('OB Ultralow spectrum')
end
ylabel('Frequency, Hz')


% LFP trace
f0 = subplot(6,3,[7:8]);
% p0 = get(f0, 'position');
% p0(2) = p0(2) + 0.02;
% set(f0, 'position', p0);
try
    plot(Range(Restrict(theta_new,PlotEp),'s'),log(Data(Restrict(theta_new,PlotEp))),'linewidth',1,'color','k')
catch
    plot(Range(theta_new,'s'),Data(theta_new),'linewidth',1,'color','k')
end
xlim([begin endin])
xlabel('Time (s)')

switch SS_base
    case '1-8'
        ylabel('1-8 Hz power')
        title('Signal in 1-8 Hz range')
    case '0.1-0.5'
        ylabel('0.1-0.5 Hz power')
        title('Signal in 0.1-0.5 Hz range') 
end

% OB spectrum
f1 = subplot(6,3,[10:11,13:14]);
% p = get(f1, 'position');
% p(2) = p(2) - 0.07;
% set(f1, 'position', p);

datb=Data(sptsdB);
clear datbnew
for k=1:size(datb,2)
    datbnew(:,k)=runmean(datb(:,k),100);
end
imagesc(Range(sptsdB,'s'),fB,10*log10(datbnew')), axis xy, caxis([25 50]);
hold on
line([begin endin],[90 90],'linewidth',10,'color','w')
sleepstart=Start(S2_epoch);
sleepstop=Stop(S2_epoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],[90 90],'color',[1 0 0],'linewidth',5); % color changed on the 12th of june
end
sleepstart=Start(S1_epoch);
sleepstop=Stop(S1_epoch);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],[90 90],'color',[0 1 0]  ,'linewidth',5); % color changed on the 12th of june
end
sleepstart=Start(Wake);
sleepstop=Stop(Wake);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],[90 90],'color',[0 0 1]  ,'linewidth',5);
end

 % modif KB----------------------------------------------------------------------------
 % ------------------------------------------------------------------------------------
     
try
sleepstart=Start(TotalNoiseEpoch);
sleepstop=Stop(TotalNoiseEpoch);
catch
sleepstart=Start(GndNoiseEpoch);
sleepstop=Stop(GndNoiseEpoch);
end

 % modif KB----------------------------------------------------------------------------
 % ------------------------------------------------------------------------------------
 
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],[90 90],'color','w','linewidth',5);
end
xlim([begin endin])
set(gca,'XTick',[])
% title('OB spectrum')
ylabel('Frequency, Hz')

% Signal in gamma range
f2 = subplot(6,3,[16:17])
% p2 = get(f2, 'position');
% p2(2) = p2(2) - 0.07;
% set(f1, 'position', p2);

try
plot(Range(Restrict(ghi_new,PlotEp),'s'),Data(Restrict(ghi_new,PlotEp)),'linewidth',1,'color','k')
catch
 plot(Range(ghi_new,'s'),Data(ghi_new),'linewidth',1,'color','k')   
end
xlim([begin endin])
title('Signal in gamma range (40-60 Hz)')
ylabel('Gamma power')
xlabel('Time (s)')

clear sptsdH sptsdH sptsdUL datB

% phase space
subplot(6,12,[22:24,34:36,46:48])
try
    remtheta=(Restrict(theta_new,And(PlotEp,S1_epoch))); % S2 substituted for S1 (changed on 12062023)
catch
    remtheta=(Restrict(theta_new,S1_epoch)); % S2 substituted for S1 (changed on 12062023)
end
ghi_new_r=Restrict(ghi_new,ts(Range(remtheta)));
plot(log(Data(ghi_new_r)),log(Data(remtheta)),'.','color',[0 1 0],'MarkerSize',1);
hold on
try
sleeptheta=(Restrict(theta_new,And(PlotEp,S2_epoch))); % S1 substituted for S2 (changed on 12062023)
catch
    sleeptheta=(Restrict(theta_new,S2_epoch)); % S1 substituted for S2 (changed on 12062023)
end
ghi_new_s=Restrict(ghi_new,ts(Range(sleeptheta)));
plot(log(Data(ghi_new_s)),log(Data(sleeptheta)),'.','color',[1 0 0]  ,'MarkerSize',1);

waketheta=(Restrict(theta_new,Wake));
ghi_new_w=Restrict(ghi_new,ts(Range(waketheta)));
plot(log(Data(ghi_new_w)),log(Data(waketheta)),'.','color',[0 0 1]  ,'MarkerSize',1);
% had to change the code to accomodate new functions in Matlab 2016 - SB
% 09/2016

try
    legend('S1','S2','Wake')
    l=findobj(gcf,'tag','legend');
    a=get(l,'children');
    try
        set(a(1),'markersize',20); % This line changes the legend marker size
        set(a(4),'markersize',20); % This line changes the legend marker size
        set(a(7),'markersize',20); % This line changes the legend marker size
    catch
        set(a(5),'markersize',20); % This line changes the legend marker size
        set(a(8),'markersize',20); % This line changes the legend marker size
        set(a(11),'markersize',20); % This line changes the legend marker size
    end
catch
    [a,icons,plots,legend_text]=legend('S1','S2','Wake');
    set(icons(5),'MarkerSize',20)
    set(icons(7),'MarkerSize',20)
    set(icons(9),'MarkerSize',20)
end

axphase=gca;
ys=get(axphase,'Ylim');
xs=get(axphase,'Xlim');
box on
set(gca,'XTick',[],'YTick',[])
subplot(6,12,[21,33,45])
switch SS_base
    case '1-8'
        [theText, rawN, x] =nhist(log(Data(Restrict(smooth_Freq1Freq2,sleepper))),'maxx',max(log(Data(Restrict(smooth_Freq1Freq2,sleepper)))),'noerror','xlabel','1-8Hz power OB','ylabel',[]); axis xy
        line([log(OneEight_thresh) log(OneEight_thresh)],[0 max(rawN)],'linewidth',4,'color','r')
    case '0.1-0.5'
        [theText, rawN, x] =nhist(log(Data(Restrict(smooth_Freq1Freq2,sleepper))),'maxx',max(log(Data(Restrict(smooth_Freq1Freq2,sleepper)))),'noerror','xlabel','0.1-0.5 Hz power OB','ylabel',[]); axis xy
        line([log(thresh_01_05) log(thresh_01_05)],[0 max(rawN)],'linewidth',4,'color','r')
end
view(90,-90)
set(gca,'YTick',[],'Xlim',ys)

subplot(6,12,[58:60])
[theText, rawN, x] =nhist(log(Data(smooth_ghi)),'maxx',max(log(Data(smooth_ghi))),'noerror','xlabel','Gamma power','ylabel',[]);
line([log(gamma_thresh) log(gamma_thresh)],[0 max(rawN)],'linewidth',4,'color','r')
set(gca,'YTick',[],'Xlim',xs)

u='SleepScoringAllOB'
FigureName=strcat(u,OBfrequency)

try
saveFigure(h,FigureName,filename)
catch
saveFigure(h.Number,FigureName,filename)
end

[aft_cell,bef_cell]=transEpoch(wakeper,S2_epoch);

disp( ' ')
disp(strcat('wake to S2 transitions :',num2str(size(Start(aft_cell{1,2}),1))))
disp( ' ')

end