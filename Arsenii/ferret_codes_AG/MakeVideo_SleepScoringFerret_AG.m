
caxis([22 45])
caxis([25 85])
%% Parameters
vid_name = 'Ferret_SleepScoringVideo_3400-3400_01-05_x4_upd';
bin = 0.8; % 0.2 = x1; 0.4 = x2; 0.8 = x4
rec = 'Arb'; % 'Full_Rec', 'Thirds', 'Arb'
sub_rec = 'First'; % 'First', 'Second', 'Third'
SS_base = '0.1-0.5'; % '0.1-0.5', '1-8'

% In case you want to set your own beginning and end, define it here:
arb_begin = 3400;
arb_end = 4000;

%% Load data 
disp('load scoring')
load('StateEpochSB.mat')
load('behavResources.mat')

%% Defining Epochs 
TotalEpoch=intervalSet(0*1e4,max(Range(smooth_ghi)));
% TotalEpoch = TotalEpoch-TotalNoiseEpoch;

smooth_ghi_new = Restrict(smooth_ghi,TotalEpoch);
smooth_1_8_new = Restrict(smooth_1_8,TotalEpoch);
smooth_01_05_new = Restrict(smooth_01_05, TotalEpoch);
% theta_new=Restrict(smooth_Theta,TotalEpoch);

t=Range(smooth_1_8_new);
ti=t(5:500:end);

smooth_ghi_new = Restrict(smooth_ghi_new,ts(ti));
smooth_1_8_new = Restrict(smooth_1_8_new,ts(ti));
smooth_01_05_new = Restrict(smooth_01_05_new,ts(ti));
% theta_new=(Restrict(theta_new,ts(ti)));

begin=Start(TotalEpoch)/1e4;
begin=begin(1);
endin=Stop(TotalEpoch)/1e4;
endin=endin(end);

%% Load spectrum 
disp('load spectra')
load('B_Middle_Spectrum.mat')
Spectro_B = Spectro;
sptsdB=tsd(Spectro_B{2}*1e4,Spectro_B{1});
fB=Spectro{3};

load(['LFPData/LFP','26','.mat'])
LFPB1 = FilterLFP(LFP,[1 200],1024);
load(['LFPData/LFP','24','.mat'])
LFPB2 = FilterLFP(LFP,[1 200],1024);

load('B_Low_Spectrum.mat')
Spectro_H = Spectro;
sptsdH=tsd(Spectro_H{2}*1e4,Spectro_H{1});
fH=Spectro{3};

load('B_UltraLow_Spectrum.mat')
Spectro_UL = Spectro;
sptsdUL=tsd(Spectro_UL{2}*1e4,Spectro_UL{1});
sptsdUL = Restrict(sptsdUL, TotalEpoch);
fUl=Spectro{3};

%% Select the case 

switch rec
    case 'Full_Rec'
        % Record and display full
        begin_recording = 1;
        stop_recording = max(Range(LFPB2,'s'));
        spectro_window = [min(Range(LFPB2,'s')) max(Range(LFPB2,'s'))];
    case 'Thirds'
        switch sub_rec
            case 'First'
                % Record and display splitting by thirds
                %1st
                begin_recording = 1;
                stop_recording = max(Range(LFPB2,'s'))/3;
                spectro_window = [0 max(Range(LFPB2,'s'))/3];
            case 'Second'
                %2nd
                begin_recording = max(Range(LFPB2,'s'))/3;
                stop_recording = 2*(max(Range(LFPB2,'s'))/3);
                spectro_window = [max(Range(LFPB2,'s'))/3 2*(max(Range(LFPB2,'s'))/3)];
            case 'Third'
                %3rd
                begin_recording = 2*(max(Range(LFPB2,'s'))/3);
                stop_recording = max(Range(LFPB2,'s'));
                spectro_window = [2*(max(Range(LFPB2,'s'))/3) max(Range(LFPB2,'s'))];
        end
    case 'Arb'
        begin_recording = arb_begin;
        stop_recording = arb_end;  
end

switch SS_base
    case '0.1-0.5'
        disp(['You chose ' SS_base ' case'])
        
        Selected_S2 = and(Sleep,Epoch_01_05);
        Selected_S1 = and(Sleep,TotalEpoch-Epoch_01_05);
        Selected_smooth = smooth_01_05_new;
        
        Selected_Spectro = Spectro_UL;
        Selected_sptsd = sptsdUL;
        Selected_f = fUl;
    case '1-8'
        disp(['You chose ' SS_base ' case'])
        
        Selected_S2 = S2_epoch;
        Selected_S1 = S1_epoch;
        Selected_smooth = smooth_1_8_new;
        
        Selected_Spectro = Spectro_H;
        Selected_sptsd = sptsdH;
        Selected_f = fH;
end

%% Total spectro
figure
SP = subplot(3,5,[1,2]);
SP.Position = [0.05 0.675 0.35 0.247];

try
    datb=Data(sptsdB);
    for k=1:size(datb,2)
        datbnew(:,k)=runmean(datb(:,k),100);
    end
    imagesc(Range(sptsdB,'s'),fB,10*log10(datbnew')), axis xy, caxis([27 40]);
    colormap('jet')
    ylim([20 100])
    hold on
    line([begin endin],[94 94],'linewidth',10,'color','w')
    sleepstart=Start(Selected_S2);
    sleepstop=Stop(Selected_S2);
    for k=1:length(sleepstart)
        line([sleepstart(k)/1e4 sleepstop(k)/1e4],[94 94],'color',[0.4660 0.6740 0.1880],'linewidth',5);
    end
    sleepstart=Start(Selected_S1);
    sleepstop=Stop(Selected_S1);
    for k=1:length(sleepstart)
        line([sleepstart(k)/1e4 sleepstop(k)/1e4],[94 94],'color',[1 0.2 0.2],'linewidth',5);
    end
    sleepstart=Start(Wake);
    sleepstop=Stop(Wake);
    for k=1:length(sleepstart)
        line([sleepstart(k)/1e4 sleepstop(k)/1e4],[94 94],'color',[0 0.4470 0.7410],'linewidth',5);
    end
catch
    title('No Middle OB spectrum')
end
ylabel('Frequency (Hz)')
% clim([26 54])
yyaxis right
plot(Range(smooth_ghi,'s'),Data(smooth_ghi),'-k','linewidth',1.5)
ylim([0 2000])
TotalLine1 = line([1 1],ylim,'linewidth',2,'color','k');

line(xlim,[1 1]*gamma_thresh,'linewidth',2,'color','r')
ylabel('Gamma power')
set(gca,'FontSize',12)

%% Plot 2D figure 

PS = subplot(3,5,[6,7,11,12]);
PS.Position = [0.05 0.07 0.35 0.547];

switch SS_base
    case '0.1-0.5'
        t1 = sgtitle('Sleep separation based on 0.1-0.5 Hz', 'FontSize', 23, 'FontWeight', 'bold');
%         t1_pos = t1.NodeChildren.Children(2);
%         t1_pos.Position(2) = 0.925;
    case '1-8'
        t1 = sgtitle('Sleep separation based on 1-8 Hz', 'FontSize', 23, 'FontWeight', 'bold');
%         t1_pos = t1.NodeChildren.Children(2);
%         t1_pos.Position(2) = 0.925;
end

%S1
plot(log(Data(Restrict(smooth_ghi_new,Selected_S1))),log(Data(Restrict(Selected_smooth,Selected_S1))),'.','color',[1 0.2 0.2],'MarkerSize',3);
hold on
%S2
plot(log(Data(Restrict(smooth_ghi_new,Selected_S2))),log(Data(Restrict(Selected_smooth,Selected_S2))),'.','color',[0.4660 0.6740 0.1880],'MarkerSize',3);
%Wake
plot(log(Data(Restrict(smooth_ghi_new,Wake))),log(Data(Restrict(Selected_smooth,Wake))),'.','color',[.2 .2 1],'MarkerSize',3);
%Trace
Worm = plot(log(Data(Restrict(smooth_ghi_new,intervalSet(5*1e4,15*1e4)))),log(Data(Restrict(Selected_smooth,intervalSet(5*1e4,15*1e4)))),'linewidth',2,'color','k');

% Make it pretty
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
xlabel('OB Gamma Power')
switch SS_base
    case '0.1-0.5'
        ylabel('0.1-0.5 Hz power')
    case '1-8'
        ylabel('1-8 Hz power')
end

set(gca,'FontSize',12)

%% Plot LFP traces 
SB{1} = subplot(6,5,[3,4,5,8,9,10]);
SB{1}.Position = [0.49 0.675 0.448 0.247];

% plot(Range(LFPB1,'s'),zscore(Data(LFPB1))-3,'k','color',[0.6 0 0])
% hold on
% plot(Range(LFPB2,'s'),zscore(Data(LFPB2))-6,'color',[1 0.6 0.2])
% clear A, A=log(Data(MovAcctsd)); A(A==-Inf)=0;
% plot(Range(MovAcctsd,'s'),zscore(A)-8,'color',[0.8 0.4 0.1])

plot(Range(LFPB1,'s'),zscore(Data(LFPB1))-4,'k','color',[0.6 0 0])
hold on
plot(Range(LFPB2,'s'),zscore(Data(LFPB2))-10,'color',[1 0.6 0.2])

clear A, A=log(Data(MovAcctsd)); A(A==-Inf)=15; A = runmean_BM(A , ceil(.05/median(diff(Range(MovAcctsd,'s'))))); 
B=runmean_BM(A , ceil(3/median(diff(Range(MovAcctsd,'s'))))); 
A=(A-min(B)); A=A/max(B);
area(Range(MovAcctsd,'s'),A*8)
u=hline((log(Immobility_thresh)-min(B))/max(B) , '--k'); u.LineWidth = 4;



LFPLine1 = line([1 1],ylim,'linewidth',2,'color','k');
% Accelero_thresh_line = 

% This might need to be modified, come back here
FrameDur = line([1e2 1e2],[1e2 1e2],'color','k','linewidth',3);
FrameDur_txt = text(0+1.45,-52500,'500ms');

% set(gca,'XTick',[],'YTick',[-8 -2 4],'YTickLabel',{'Accelero', '24th ch.','26th ch.'});
set(gca,'YTick',[-10 -4 0],'YTickLabel',{'24th ch.','26th ch.', 'Accelero'});

ylim([-16 5])
% xlim([0 max(Range(MovAcctsd))])
% xlim([CentreValue-3 CentreValue+3])
set(gca,'FontSize',14)

%% Spectrogram Gamma Middle
SB{2} = subplot(6,5,[13,14,15,18,19,20]);
SB{2}.Position = [0.49 0.37 0.448 0.247];

try
    datb=Data(sptsdB);
    for k=1:size(datb,2)
        datbnew(:,k)=runmean(datb(:,k),100);
    end
    imagesc(Range(sptsdB,'s'),fB,10*log10(datbnew')), axis xy, caxis([27 40]);
    colormap('jet')
    ylim([20 100])
    hold on
    line([begin endin],[94 94],'linewidth',10,'color','w')
    sleepstart=Start(Selected_S2);
    sleepstop=Stop(Selected_S2);
    for k=1:length(sleepstart)
        line([sleepstart(k)/1e4 sleepstop(k)/1e4],[94 94],'color',[0.4660 0.6740 0.1880],'linewidth',5);
    end
    sleepstart=Start(Selected_S1);
    sleepstop=Stop(Selected_S1);
    for k=1:length(sleepstart)
        line([sleepstart(k)/1e4 sleepstop(k)/1e4],[94 94],'color',[1 0.2 0.2],'linewidth',5);
    end
    sleepstart=Start(Wake);
    sleepstop=Stop(Wake);
    for k=1:length(sleepstart)
        line([sleepstart(k)/1e4 sleepstop(k)/1e4],[94 94],'color',[0 0.4470 0.7410],'linewidth',5);
    end
catch
    title('No Middle OB spectrum')
end
ylabel('Frequency (Hz)')
% clim([26 54])
yyaxis right
plot(Range(smooth_ghi,'s'),Data(smooth_ghi),'-k','linewidth',1.5)
ylim([0 2000])
MiddleLine1 = line([1 1],ylim,'linewidth',2,'color','k');

line(xlim,[1 1]*gamma_thresh,'linewidth',2,'color','r')
ylabel('Gamma power')
set(gca,'FontSize',12)

% SB{3} = subplot(6,5,[18,19,20]);
% SB{3}.Position = [0.45 0.31 0.5 0.13];
% hold on
% plot(Range(LFPH1,'s'),Data(LFPH1),'k')
% plot(Range(LFPH1,'s'),Data(LFPH2)-8000,'k')
% plot(Range(LFPH1,'s'),Data(LFPH3)-16000,'k')
% set(gca,'XTick',[],'YTick',[])
% title('HPC')
% ylim([-20000 20000]) 

%% Low Spectrogram 0.1-0.5/1-8 Hz
SB{4} = subplot(6,5,[23,24,25,28,29,30]);
SB{4}.Position = [0.49 0.07 0.448 0.247];

imagesc(Range(Selected_sptsd,'s'),Selected_f,10*log10(Data(Selected_sptsd))'), axis xy;
colormap('jet')
hold on
switch SS_base
    case '0.1-0.5'
        caxis([25 60])
        line_height = [0.95 0.95];
    case '1-8'
        caxis([30 55])
        line_height = [19 19];
end

line([begin endin],line_height,'linewidth',10,'color','w')

% S2
sleepstart=Start(Selected_S2);
sleepstop=Stop(Selected_S2);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],line_height,'color',[0.4660 0.6740 0.1880],'linewidth',5);
end
% S1
sleepstart=Start(Selected_S1);
sleepstop=Stop(Selected_S1);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],line_height,'color',[1 0.2 0.2],'linewidth',5);
end
% Wake
sleepstart=Start(Wake);
sleepstop=Stop(Wake);
for k=1:length(sleepstart)
    line([sleepstart(k)/1e4 sleepstop(k)/1e4],line_height,'color',[0 0.4470 0.7410],'linewidth',5);
end
% clim([34 62])
ylabel('Frequency (Hz)')
LowLine1 = line([1 1],ylim,'linewidth',2,'color','k');

yyaxis right
% ylim([0 30])
% ylim([0 35])
switch SS_base
    case '0.1-0.5'
        plot(Range(smooth_01_05_new,'s'),Data(smooth_01_05_new),'-k','linewidth',1)
        line(xlim,[1 1]*thresh_01_05,'linewidth',2,'color','r')
        ylabel('0.1-0.5 Hz')
    case '1-8'
        plot(Range(smooth_1_8_new,'s'),Data(smooth_1_8_new),'-k','linewidth',1)
        line(xlim,[1 1]*OneEight_thresh,'linewidth',2,'color','r')
        ylabel('1-8 Hz')
end
xlabel('Time (s)')
set(gca,'FontSize',12)

%% Record the video

writerObj = VideoWriter(vid_name);
writerObj.FrameRate = 5;
writerObj.Quality = 100;

open(writerObj);

State= {'S1','S2','Wake'};
for k = begin_recording :bin: stop_recording
%     CentreValue = 500+k;
    CentreValue = k;
    
    set(gcf,'CurrentAxes',PS)
    set(Worm,'XData',runmean(log(Data(Restrict(smooth_ghi_new,intervalSet((CentreValue-5)*1e4,(CentreValue+5)*1e4)))),3),...
        'YData',runmean(log(Data(Restrict(Selected_smooth,intervalSet((CentreValue-5)*1e4,(CentreValue+5)*1e4)))),3));

    LitEpoch = intervalSet((CentreValue-5)*1e4,(CentreValue+5)*1e4);
    S1_overlap = sum(Stop(and(LitEpoch,Selected_S1))-Start(and(LitEpoch,Selected_S1)));
    if isempty(S1_overlap), S1_overlap = 0; end
    S2_overlap = sum(Stop(and(LitEpoch,Selected_S2))-Start(and(LitEpoch,Selected_S2)));
    if isempty(S2_overlap), S2_overlap = 0; end
    Wake_overlap = sum(Stop(and(LitEpoch,Wake))-Start(and(LitEpoch,Wake)));
    if isempty(Wake_overlap), Wake_overlap = 0; end
    [val,ind] = max([S1_overlap,S2_overlap,Wake_overlap]);
    
    set(gcf,'CurrentAxes',SP)
    set(TotalLine1,'XData',[CentreValue CentreValue])
    
    set(gcf,'CurrentAxes',SB{1})
    xlim([CentreValue-3 CentreValue+3])
    set(LFPLine1,'XData',[CentreValue CentreValue])
    title(State{ind})
    FrameDur.XData = [CentreValue+1.3 CentreValue+1.8];
    FrameDur_txt.Position = [CentreValue+1.45 -52500 0];
    
    set(gcf,'CurrentAxes',SB{2})
    xlim([CentreValue-250 CentreValue+250])
    %     xlim(spectro_window) %this also to be changed
    set(MiddleLine1,'XData',[CentreValue CentreValue])
    
%     set(gcf,'CurrentAxes',SB{3})
%     xlim([CentreValue-2 CentreValue+2])
%     
    set(gcf,'CurrentAxes',SB{4})
    xlim([CentreValue-250 CentreValue+250])
%     xlim(spectro_window)
    set(LowLine1,'XData',[CentreValue CentreValue])

    %     pause(0)
    writeVideo(writerObj,getframe(gcf));
end

 close(writerObj);
 
 