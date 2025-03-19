% HCStim_trigLFP_ML.m


%% inputs
structureToAnalyze='dHPC'; %'Bulb'
plotForCheck=1;
firstMethod=0;
StartBlockON=0; % do not separate into blocks according to frequency
plotPETH=0;
saveFig=1;

%% load stim

load('LFPData/InfoLFP.mat')

try
    load('StimHCS.mat'); Stim;
catch
    
    disp('Calculating Stim ...')
    
    % load session and events
    SetCurrentSession
    evt=GetEvents('output','Descriptions');
    chStim=[];
    for i=1:length(evt)
        if length(evt{i})<3 || (~strcmp(evt{i}(1:3),'beg') && ~strcmp(evt{i}(1:3),'end'))
            disp(['name evt{',num2str(i),'}=',evt{i}]);
            chStim=[chStim,i];
        end
    end
    if isempty(chStim)
        error('No evt for stim')
    elseif length(chStim)>1
        chStim=input('Enter the num of event you want to use: ');
    end
    disp(['Loading Events from evt{',num2str(chStim),'}...'])
    
    
    % Sort stim and make it LFP
    StimRow=GetEvents(evt{chStim});
    Stim=floor(sort(StimRow*1E4));
    
    % remove really short stim intervals
    DifStimON=diff([Stim;0]);
    indextemp=find(DifStimON>30);
    Stim=Stim(indextemp);
    
        
    DifStimON=diff([0;Stim]);
    indexON=find(DifStimON>2E3);
    StimON=Stim(indexON);
   
    if plotForCheck
        figure('Color',[ 1 1 1]),
        plot(Stim/1E4,ones(1,length(Stim)),'.k')
        hold on, plot(StimON/1E4,ones(1,length(StimON)),'.r')
        legend({'row','Stim ON'})
        xlabel('Time (s)');
        
        ok=input('Are you satisfied with the threshold for stim? (y/n): ','s');
        if ~strcmp(ok,'y'), keyboard;end
        close
    end
    
    disp('Saving StimLFP in StimHCS.mat ...');
    Stim=StimON;
    save StimHCS StimRow Stim
    
end

Stim=ts(Stim);

%% ImagePETH for each LFP of structureToAnalyze
colori={'r','m','k','b',};

disp(' ')
ChLFP=InfoLFP.channel(strcmp(InfoLFP.structure,structureToAnalyze));
ChLFP=ChLFP(1:min(4,length(ChLFP)));
LegendMet=[];
LFParray=tsdArray;
for i=1:length(ChLFP)
    LegendMet{i}=['LFP',num2str(ChLFP(i))];
    disp(['Loading LFP',num2str(ChLFP(i)),' (',structureToAnalyze,')... ']);
    load(['LFPData/LFP',num2str(ChLFP(i)),'.mat'],'LFP')
    LFParray{i}=LFP;
end

sizBin=10; %ms
nbin=100;
figure('Color',[1 1 1]), numF=gcf;
for ch=1:length(ChLFP)
    
    [m,s,tps]=mETAverage(Range(Stim),Range(LFParray{ch}),Data(LFParray{ch}),sizBin,nbin);
    legendnumF{ch}=['LFP',num2str(ChLFP(ch))];
    figure(numF), hold on, plot(tps/1E3,m/1E3-(ch-1)*3,colori{ch})
    
    figure('Color',[1 1 1]),
    [fh, rasterAx, histAx, matVal]=ImagePETH(LFParray{ch},Stim, -5E2, +5E2,'BinSize',1000);
%     close
%     matvalD=Data(matVal);
%     matvalT=Range(matVal);
%     [B,iX] = sort(matvalD(:,floor(size(matvalT,1)/2)));
%     
%     figure('Color',[1 1 1]),imagesc(matvalD(iX,:))
    numPethF(ch)=gcf; 
    
    
    title(['LFP',num2str(ChLFP(ch))])
end
figure(numF), legend(legendnumF)
xlabel('time (s)'); xlim([-1 1]*sizBin*nbin/2E3)
ylabel('averaged LFP'); ylim([-12,5]),

%% save figures

if saveFig
    if ~exist('FigureHCStimEffect','dir'), mkdir('FigureHCStimEffect');end
    saveFigure(numF,'MeanHCStimEffect','FigureHCStimEffect')
    for ch=1:length(ChLFP)
        saveFigure(numPethF(ch),['HCStimEffect_PETHlfp',num2str(ChLFP(ch))],'FigureHCStimEffect')
    end
end


%% define HCS epochs
evt = GetEvents('output','descriptions');
HCSstart=[];HCSstop=[];
NoHCSstart=[];NoHCSstop=[];
for i=1:length(evt)
    if ~isempty(strfind(evt{i},'hcs'));
       if strcmp(evt{i}(1:3),'beg')
           HCSstart=[HCSstart,GetEvents(evt{i})]; disp(['HCSstart: ',num2str(i)])
       elseif strcmp(evt{i}(1:3),'end')
           HCSstop=[HCSstop,GetEvents(evt{i})];disp(['HCSstop: ',num2str(i)])
       end
    elseif isempty(strfind(evt{i},'hcs')) && (~isempty(strfind(evt{i},'Rest'))||~isempty(strfind(evt{i},'Sleep')))
       if strcmp(evt{i}(1:3),'beg')
           NoHCSstart=[NoHCSstart,GetEvents(evt{i})];disp(['NoHCSstart: ',num2str(i)])
       elseif strcmp(evt{i}(1:3),'end')
           NoHCSstop=[NoHCSstop,GetEvents(evt{i})];disp(['NoHCSstop: ',num2str(i)])
       end
    end
end
HCSEpoch=intervalSet(HCSstart*1E4,HCSstop*1E4);
NoHCSEpoch=intervalSet(NoHCSstart*1E4,NoHCSstop*1E4);



%% plotHCS effect in VS-VTA-dHPC

% HCS
chHPC=InfoLFP.channel(strcmp(InfoLFP.structure,'dHPC'));

ch=2; % Channel to detect Ripples
[fh, rasterAx, histAx, matVal_HCS]=ImagePETH(LFParray{ch},Stim, -5E2, +5E2,'BinSize',100);
M=Data(matVal_HCS)';
tps_HCS=Range(matVal_HCS,'ms');
m=length(tps_HCS);

[BE,id]=min(M');
id2=id;
M_HCS=[];
for k=1:length(M)
    try
        M_HCS=[M_HCS; M(k,id2(k)-50:id2(k)+30)];
    end
end

if 1
    figure('Color',[1 1 1]), imagesc(M_HCS), axis xy
    hold on, plot(rescale(mean(M_HCS),400,800),'k','linewidth',2)
end

% Ripples
Rip=FindRipplesKarim(LFParray{ch},NoHCSEpoch);
M_Rip=PlotRipRaw(LFParray{ch},Rip);

figure('Color',[1 1 1]), 
plot(M_Rip(:,1)*1000-6+13, M_Rip(:,2),'linewidth',2)
hold on, plot(tps(floor(m/2)-50:floor(m/2)+30)+13,mean(M_HCS),'r','linewidth',2)
line([0 0],ylim,'color','k')
xlabel('Time (ms)')
legend({'Ripples','HCStimulation','Detection'})
xlim([-20 35])





%% plot Ripples VS-VTA-dHPC

figure('Color',[1 1 1]), numF=gcf;
a=1;
for i=InfoLFP.channel(strcmp(InfoLFP.structure,'dHPC'))
    eval(['load(''/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse085/Day5/OPTO-Mouse-85-09082013/LFPData/LFP',num2str(i),'.mat'')'])
    N=PlotRipRaw(LFP,Rip,300);title(num2str(i)),close
    figure(numF), subplot(1,3,1), hold on, plot(N(:,1),N(:,2),'color',[0,0,a/3],'linewidth',2)
    a=a+1;
end
xlim([-0.2 0.2]); xlabel('time (s)'); ylabel('dHPC');
hold on, line([0 0],[-4000 2000],'color','k')
ylim([-3300 1700])

a=1;
for i=InfoLFP.channel(strcmp(InfoLFP.structure,'VTA'))
    eval(['load(''/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse085/Day5/OPTO-Mouse-85-09082013/LFPData/LFP',num2str(i),'.mat'')'])
    N=PlotRipRaw(LFP,Rip,300);title(num2str(i)),close
    figure(numF), subplot(1,3,2), hold on, plot(N(:,1),N(:,2),'color',[a/3,0,0],'linewidth',2)
    a=a+1;
end
xlim([-0.2 0.2]); xlabel('time (s)'); ylabel('VTA');
hold on, line([0 0],[-4000 2000],'color','k')
ylim([-1000 500])

a=1;
for i=InfoLFP.channel(strcmp(InfoLFP.structure,'NAcc'))
    eval(['load(''/media/DataMOBsRAID5/ProjetOPTO/DATAopto/Mouse085/Day5/OPTO-Mouse-85-09082013/LFPData/LFP',num2str(i),'.mat'')'])
    N=PlotRipRaw(LFP,Rip,300);title(num2str(i)),close
    figure(numF), subplot(1,3,3), hold on, plot(N(:,1),N(:,2),'color',[0,a/3,0],'linewidth',2)
    a=a+1;
end
xlim([-0.2 0.2]); xlabel('time (s)'); ylabel('NAcc');
hold on, line([0 0],[-4000 2000],'color','k')
ylim([-1000 500])

saveFigure(numF,'RipplesEvokedLFP_NaccVTA','/home/karim/Dropbox/MOBS_ProjetOpto/figuresMiThese/')







