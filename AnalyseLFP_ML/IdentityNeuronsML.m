function [DirFigure,Epochs,NamesEp,FR,FRez,FRe2,DurEp,ZTFR,ZTFRz,ZTFR2,CrRip,B,timeZT,Windo] = IdentityNeuronsML(S,option)
% 
% [DirFigure,Epochs,NamesEp,FR,FRez,FRe2,DurEp,ZTFR,ZTFRz,ZTFR2,CrRip,B,timeZT,Windo] = IdentityNeuronsML(S,option)
% 
% see utilisation in AnalyseNREMsubstages_ORspikes.m
%
% input:
% S = ts array of spike trains
%
% option (optional) :
% option.TT = tetrode number
% option.waveform = matrice of mean waveform per tetrode channel

% option.OB = tsd LFP from OB channel
% option.PFC = tsd LFP from PFC channel
% option.HPC = tsd LFP from HPC channel
% option.RIP = ts of Ripples

% option.ZT = tsd absolute time (see GetZT_ML.m)
% option.timeZT = division of time for plotting (default [9:0.5:21])
% option.Windo = minimum time of epoch (default 2s)
%
% option.WAKE = intervalset
% option.REM= intervalset
% option.NREM= intervalset
% option.N1= intervalset
% option.N2= intervalset
% option.N3 = intervalset

% option.ref = image ref
% option.mask = mask
% option.X = tsd X position
% option.Y = tsd Y position



%% %%%%%%%%%%%%%%%%%%%%%%%%% INITIALISATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

colori=[0.5 0.5 0.5;0 0 1 ;0.5 0.2 0.1;0.1 0.7 0 ;0 0 0;0.7 0.2 1 ; 1 0.5 0.8 ;0.9 0 0.9  ];

% ------------------------ Saving figue in -------------------------------
res='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_OR_spikes';
DirFigure=[res,'/IdentityNeuronsML_',date];
n=2;
while exist(DirFigure,'dir')~=0
    DirFigure=[res,'/IdentityNeuronsML_',date,sprintf('_%d',n)];
    n=n+1;
end
mkdir(DirFigure);


% ------------------------ BEHAVIOR -------------------------------
try
    i=find(mean(option.mask,1)>0);
    mask_x1=min(i); mask_x2=max(i);
    i=find(mean(option.mask,2)>0);
    mask_y1=min(i); mask_y2=max(i);
    sizeMap=[mask_x2-mask_x1,mask_y2-mask_y1];
catch
    disp('No mask information')
    sizeMap=[50,50];
end
xl=floor(sizeMap(1)/2);
yl=floor(sizeMap(2)/2);

try 
    TrackEpoch=intervalSet(min(Range(option.X)),max(Range(option.X)));
    x=Restrict(option.X,TrackEpoch);
    y=Restrict(option.Y,TrackEpoch);
    DoBehav=1;
catch
    disp('No position information')
    DoBehav=0;
    TrackEpoch=intervalSet([],[]);
end


% ------------------------ SLEEP EPOCHS -------------------------------
try
    NREM=option.NREM;
catch
    try
        NREM=or(or(option.N1,option.N2),option.N3);
        NREM=mergeCloseIntervals(NREM,10);
    catch
        disp('No sleep scoring information')
    end
end
SLEEP=or( option.NREM, option.REM);
SLEEP=mergeCloseIntervals(SLEEP,10);

try 
    TotalEpoch=or(or(option.WAKE,option.REM),NREM);
    TotalEpoch=mergeCloseIntervals(TotalEpoch,10);
catch
    TotalEpoch=intervalSet(min(Range(S{1})),max(Range(S{1})));
end

try
    Epochs={TotalEpoch,TrackEpoch,option.WAKE,option.REM, NREM,option.N1,option.N2,option.N3};
    NamesEp={'tot','behav','WAKE','REM','NREM','N1','N2','N3'};
catch
    try
        Epochs={TotalEpoch,TrackEpoch,option.WAKE,option.REM,NREM};
        NamesEp={'tot','behav','WAKE','REM','NREM'};
    catch
        Epochs={TotalEpoch,TrackEpoch};
        NamesEp={'tot','behav'};
    end
end

% ------------------------ ZT evolution -------------------------------
try timeZT=option.timeZT; catch, timeZT=[9:21];end
try Windo = option.Windo; catch, Windo=2;end

try
    ZTtsd = option.ZT;
catch
    timeZT=[0:1:ceil(max(Stop(TotalEpoch,'s'))/3600)];
    ZTtsd = tsd(timeZT*3600*1E4,timeZT*3600*1E4);
end
rgZT=Range(ZTtsd);

% ------------------------------ LFPs ---------------------------------
DoModu=0;
disp('Filtering LFP... (wait!)')
try filOB=FilterLFP(option.OB,[2 5],2048); DoModu=1; disp('OB 2-5Hz done.');end
try filPFC=FilterLFP(option.PFC,[2 5],2048);DoModu=1; disp('PFC 2-5Hz done.');end
try filPFCt=FilterLFP(Restrict(option.PFC,TrackEpoch),[5 8],1024);DoModu=1; disp('PFC 5-8Hz done.');end
try filHPCt=FilterLFP(Restrict(option.HPC,TrackEpoch),[5 8],1024);DoModu=1; disp('HPC 5-8Hz done.');end
if ~DoModu, disp('No LFP information');end

 % ------------------------------ Ripples ------------------   
CrRip=[];B=[];
try
    Range(option.RIP); doRip=1;
    CrRip=nan(length(S),101);
catch
    doRip=0;disp('No Ripples');
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% COMPUTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------------------------- GET FR ---------------------------
% calculate instataneous firing rate
t_step=0:0.05:max(Stop(TotalEpoch,'s')); % 50ms step
InstantFR=nan(length(S),length(t_step));
iFRz=nan(length(S),length(t_step));
FR=nan(length(S),1);
for s=1:length(S)
    InstantFR(s,:)=hist(Range(S{s},'s'),t_step);
    iFRz(s,:)=zscore(hist(Range(S{s},'s'),t_step));
    FR(s)=length(Range(S{s}))/( max(Range(S{s},'s')) - min(Range(S{s},'s')));
end
iFRz=tsd(t_step*1E4,iFRz');
iFR=tsd(t_step*1E4,InstantFR');


%--------------------------- GET FR PER STAGES ---------------------------
FRe=nan(length(S),length(NamesEp));
FRez=FRe; FRe2=FRe;

ZTFR2=nan(length(S),length(NamesEp),length(timeZT)-1); %per 1/2hours
ZTFRz=ZTFR2; ZTFR=ZTFR2;
DurEp=nan(length(NamesEp),length(timeZT)-1);

disp('... Getting FR per stages')
for n=1:length(NamesEp)
    % -----------------------------------------------------
    % get epoch big enough
    epoch=Epochs{n}; 
    disp(NamesEp{n})
    h=waitbar(0,['Evol FR during ',NamesEp{n}]);
    dE=sum(Stop(epoch,'s')-Start(epoch,'s'));
    
    % -----------------------------------------------------
    % firing rate indiv neurons
    FRez(:,n)=mean(Data(Restrict(iFRz,epoch)));
    FRe(:,n)=mean(Data(Restrict(iFR,epoch)));
    for s=1:length(S)
        FRe2(s,n)=length(Range(Restrict(S{s},epoch)))/dE;
    end
    
    % -----------------------------------------------------
    % FR over time
    for su=1:length(timeZT)-1
        waitbar(su/(length(timeZT)-1),h);
        st1=rgZT(min((find(Data(ZTtsd)-timeZT(su)*3600*1E4>0))));
        st2=rgZT(min((find(Data(ZTtsd)-timeZT(su+1)*3600*1E4>0))));
        if ~isempty(st1) && isempty(st2),st2=max(rgZT);end
        
        epochZT=and(epoch,intervalSet(st1,st2));
        dEZT=sum(Stop(epochZT,'s')-Start(epochZT,'s'));
        DurEp(n,su)=dEZT;
        
        if dEZT~=0
            % firing rate indiv neurons
            ZTFRz(:,n,su)=mean(Data(Restrict(iFRz,epochZT)));
            ZTFR(:,n,su)=mean(Data(Restrict(iFR,epochZT)));
            for s=1:length(S)
                ZTFR2(s,n,su)=length(Range(Restrict(S{s},epochZT)))/dEZT;
            end
        end
    end
    close(h)
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for s=1:length(S)
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.9 0.8])
    
        
    try
        % ---------------- Position and Firing maps ----------------------
        if DoBehav
            Spike=Restrict(S{s},TrackEpoch);
            if ~isempty(Data(Spike))
                [map,mapS] = doPlaceField(Spike,x,y,sizeMap);
                
                try
                    subplot(3,5,1),imagesc(option.ref); title('Position & spike')
                    m=max(mask_x2-mask_x1,mask_y2-mask_y1);
                    xlim([mask_x1,mask_x1+m]); ylim([mask_y1,mask_y1+m]);
                end
                
                hold on, plot(Data(x),Data(y),'-k')
                plot(Data(Restrict(x,Spike)),Data(Restrict(y,Spike)),'.r')
                subplot(3,5,2), imagesc(mapS.time); title('Occupancy map')
                ylim([0,max(sizeMap)]); xlim([0,max(sizeMap)]);
                hold on,line([xl xl; 0 sizeMap(1)]',[0 sizeMap(2); yl yl]','Linewidth',1,'Color','w')
                
                subplot(3,5,3), imagesc(mapS.count); title('Firing map')
                ylim([0,max(sizeMap)]); xlim([0,max(sizeMap)]);
                hold on,line([xl xl; 0 sizeMap(1)]',[0 sizeMap(2); yl yl]','Linewidth',1,'Color','w')
                
                subplot(3,5,4), imagesc(mapS.rate); title('Place field')
                ylim([0,max(sizeMap)]); xlim([0,max(sizeMap)]);
                hold on,line([xl xl; 0 sizeMap(1)]',[0 sizeMap(2); yl yl]','Linewidth',1,'Color','w')
                
                for i=1:2
                    for j=1:2
                        Mat=map.time(xl*(i-1)+1:xl*i,yl*(j-1)+1:yl*j);% occupancy
                        MatPF=map.rate(xl*(i-1)+1:xl*i,yl*(j-1)+1:yl*j);
                        Fsq(i,j)=mean(MatPF(Mat(:)>0));
                    end
                end
                subplot(3,5,5), bar(Fsq); title('PF per zone')
                legend({sprintf('%d-%d',0,yl),sprintf('%d-%d',yl,2*yl)},'Location','North')
                set(gca,'Xtick',[1 2]); set(gca,'XtickLabel',{sprintf('%d-%d',0,xl),sprintf('%d-%d',xl,2*xl)})
            end
        end
        
        % ---------------- neuronal modulation to rythms ---------------
        if DoModu
            subplot(3,5,6),
            try [ph1,mu1, Kappa1, pval1,B1,C1]=ModulationTheta(S{s},filOB,SLEEP,25,0);end
            xlabel('SLEEP OB 2-5Hz Phase (rad)')
            
            subplot(3,5,7),
            try [ph2,mu2, Kappa2, pval2,B2,C2]=ModulationTheta(S{s},filPFC,SLEEP,25,0);end
            xlabel('SLEEP PFC 2-5Hz Phase (rad)')
            
            subplot(3,5,8),
            try [ph3,mu3, Kappa3, pval3,B3,C3]=ModulationTheta(S{s},filPFCt,TrackEpoch,25,0);end
            xlabel('BEHAV PFC 5-8Hz Phase (rad)')
            
            subplot(3,5,9),
            try [ph4,mu4, Kappa4, pval4,B4,C4]=ModulationTheta(S{s},filHPCt,TrackEpoch,25,0);end
            xlabel('BEHAV HPC 5-8Hz Phase (rad)')
            
        end
        
        % ---------------- RIPPLES ----------------------
        if doRip
            try
                [C, B] = CrossCorrKB(Range(option.RIP), Range(S{s}), 15, 100);
                CrRip(s,:)=C;
                subplot(3,5,10),  bar(B/1E3,C,1,'k'); hold on, plot(B/1E3,smooth(C,3),'r','Linewidth',2);
                xlabel('Time of Ripples (ms)');title('Spike at HPC ripples')
                xlim([min(B),max(B)]/1E3); line([0 0],ylim,'Color',[0.5 0.5 0.5])
            end
        end
            
        
        % ---------------- neuronal waveform ----------------------
        try
            wvf=option.waveform{s};
            subplot(3,5,11), hold on,
            for i=1:size(wvf,1),plot(wvf(i,:)+4*(i-1)*mean(std(wvf')),'linewidth',2); end
            axis off; title('Waveforms')
        end
        
        
        % ---------------- plot evol per stages ----------------------
        subplot(3,5,12:13), bar(FRe2(s,:))
        set(gca,'Xtick',[1:length(NamesEp)]);
        set(gca,'XtickLabel',NamesEp);
        ylabel('FR (Hz)');
        title(['Firing max in ',NamesEp{find(FRe2(s,:)==max(FRe2(s,:)))}])
        
        subplot(3,5,14:15), hold on,
        for n=1:length(NamesEp)
            ttd=squeeze(ZTFR2(s,n,:));
            plot(timeZT(1:end-1),ttd,'Linewidth',2,'Color',colori(n,:))
        end
        xlim([timeZT(1),timeZT(end-1)]);legend(NamesEp);
        
        % ---------------- Save figure ----------------------
        numF=gcf;
        saveFigure(numF.Number,sprintf('IdentityNeuronsML_neuron%d',s),DirFigure)
        disp(sprintf('Saving figure for neuron %d',s)); pause(1)
        if numF.Number >20, close all;end
        
    catch
        disp(sprintf('Problem neuron %d',s)); close; %keyboard
    end
    %keyboard
end

%% %%%%%%%%%%%%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% doPlaceField
    function [map,mapS] = doPlaceField(Spike,X,Y,sizeMap)
        smo=2;
        freqVideo=30;
        
        [occH, x1, x2] = hist2d(Data(X), Data(Y), sizeMap(1), sizeMap(2));
        map.time=occH;
        
        pX = Restrict(X, Spike,'align','closest');
        pY = Restrict(Y, Spike,'align','closest');
        pfH = hist2d(Data(pX), Data(pY), x1, x2);
        map.count=pfH;
        
        pf = 30 * pfH./occH;
        map.rate=pf;
        
        pf(isnan(pf))=0;
        sg = sort(pf(~isnan(pf(:))));
        th = sg(end-5);
        pf(pf>th) = 0;
        
        mapS.rate=SmoothDec(pf,[smo,smo])';
        mapS.time=SmoothDec(occH'/freqVideo,[smo,smo]);
        mapS.count=SmoothDec(pfH',[smo,smo]);
        
    end

end