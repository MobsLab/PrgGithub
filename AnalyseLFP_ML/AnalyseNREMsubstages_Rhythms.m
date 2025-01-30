% AnalyseNREMsubstages_Rhythms.m
%
% list of related scripts in NREMstages_scripts.m 



% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
res='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';
%res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
%FolderToSave='/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureNREMstages';
FolderToSave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_Spikes';
%FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/NREMsubRhythm';
savFig=0; clear MATEP Dir

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<< INITIATE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
nbin=600;
%colori=[0.5 0.2 0.1; 0.1 0.7 0; 0.7 0.2 0.8;1 0.7 0.6 ; 1 0 1 ];
colori=[0.5 0.5 0.5;0 0 0; 0.7 0.2 0.8 ; 1 0.2 0.8 ;1 0 0; 0 0 1;0.5 0.5 0.8;0 1 0];
NamesEp={'WAKE','REM','N1','N2','N3','SLEEP','NREM'}; 
ZTearly=[1 3]; % early epoch in hours
ZTlate=[8 10]; % late epoch in hours

windRipDel=400;%ms
NameVar={'rip','RipInDelta','RipOutDelta','RipInSpin','RipOutSpin','Dpfc','DeltPostRip','DeltOutRip','Spfc','SpiSH','SpiSL','SpiDH','SpiDL'};
chToAv={'HPClfp','HPClfp','HPClfp','HPClfp','HPClfp','PFClfp','PFClfp','PFClfp','PFClfp','PFClfp','PFClfp','PFClfp','PFClfp'}; 
InfoSpinName={'AmpSH','AmpSL','AmpDH','AmpDL','FreqSH','FreqSL','FreqDH','FreqDL'};

NameLeg={'All Ripples','Ripples with Delta','Ripples out Delta','Ripples in Spindles','Ripples out Spindles','All Delta',...
    'Delta after Ripples','Delta out Ripples','All Spindles','Sup High Spindles','Sup Low Spindles','Deep High Spindles','Deep Low Spindles'};
colori2={'k','g','b','k','g','b','k','g','b'};
ploAllindiv=1;

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


try
    %load([res,'/AnalySubStages-Rhythms.mat'])
    load([res,'/AnalySubStages-RhythmsNew.mat'])
    NbRhythm;MatRipN;RythmShape;
catch
    for n=1:3, for v=1:4*length(NameVar), MatRipN{n,v}=nan(nbin+1,length(Dir.path)); end;end
    for n=1:length(NamesEp), for v=1:length(NameVar), RythmShape{n,v}=nan(length(Dir.path),4,nbin+1);end;end
    NbRhythm={};
    WidthDelta=nan(length(Dir.path),3*length(NamesEp));
    InfoSpin=nan(length(Dir.path),3*length(NamesEp),length(InfoSpinName));
            
    YL1=[];YL2=[];
    if ploAllindiv
        figure('Color',[1 1 1]); Fhpc=gcf;
        figure('Color',[1 1 1]); Fpfc=gcf;
    end
    
    for man=1:length(Dir.path)
        
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        
        NbRytemp=nan(3,length(NameVar)+2);
        
        % %%%%%%%%%%%%%%%%%%%%%%% get substages %%%%%%%%%%%%%%%%%%%%%%%%%%%
        clear WAKE REM N1 N2 N3 NREM SLEEP
        [WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;close
        NREM=or(or(N1,N2),N3);
        NREM=mergeCloseIntervals(NREM,10);
        SLEEP=or(NREM,REM);
        SLEEP=mergeCloseIntervals(SLEEP,10);
        Total=or(SLEEP,WAKE);
        Total=mergeCloseIntervals(Total,10);
        
        
        % %%%%%%%%%%%%%%%%%%%%%%%%% GET ZT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        disp('... loading rec time with GetZT_ML.m')
        NewtsdZT=GetZT_ML(Dir.path{man});
        rgZT=Range(NewtsdZT);
        manDate=str2num(Dir.path{man}(strfind(Dir.path{man},'/201')+[1:8]));
        if manDate>20160701, hlightON(man)=9; else, hlightON(man)=8;end
            
        tsdZT=tsd(Data(NewtsdZT)-hlightON(man)*3600*1E4,Range(NewtsdZT));
        
        rgT=Data(Restrict(tsdZT,intervalSet(ZTearly(1)*3600*1E4,ZTearly(2)*3600*1E4)));
        Early=intervalSet(min(rgT),max(rgT));
        
        rgT=Data(Restrict(tsdZT,intervalSet(ZTlate(1)*3600*1E4,ZTlate(2)*3600*1E4)));
        Late=intervalSet(min(rgT),max(rgT));
        
        % %%%%%%%%%%%%%%%%%%%%%%%% get delta %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [tDelta,DeltaEpoch]=GetDeltaML;
        Dpfc=ts(tDelta);
        tDelta(tDelta<windRipDel*10)=[];
        DpfcRip=ts(tDelta);
        
        % %%%%%%%%%%%%%%%%%%%%%%%% get ripples %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        dHPCrip=[];
        try [dHPCrip,~,chHPC]=GetRipplesML;end
        try rip=ts(dHPCrip(:,2)*1E4); catch, rip=ts([]);end
        
        % %%%%%%%%%%%%%%%%%%%%%%%% get spindles %%%%%%%%%%%%%%%%%%%%%%%%%%%
        Spi=[]; SpiSH=[]; SpiSL=[]; SpiDH=[]; SpiDL=[];
        Spi1=intervalSet([],[]); Spi2=Spi1; Spi3=Spi1; Spi4=Spi1;
        AmpSH=tsd([],[]); AmpSL=AmpSH; AmpDH=AmpSH; AmpDL=AmpSH; 
        FreqSH=tsd([],[]); FreqSL=FreqSH; FreqDH=FreqSH; FreqDL=FreqSH;
        try
            [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_sup');
            if ~isempty(SpiHigh) 
                SpiSH=SpiHigh(:,2); Spi=[Spi;SpiSH]; 
                Spi1=intervalSet(SpiHigh(:,1)*1E4,SpiHigh(:,3)*1E4);
                AmpSH=tsd(SpiHigh(:,2)*1E4,SpiHigh(:,2)-SpiHigh(:,1)); 
                FreqSH=tsd(SpiHigh(:,2)*1E4,SpiHigh(:,6));
            end
            if ~isempty(SpiLow) 
                SpiSL=SpiLow(:,2); Spi=[Spi;SpiSL]; 
                Spi2=intervalSet(SpiLow(:,1)*1E4,SpiLow(:,3)*1E4);  
                AmpSL=tsd(SpiLow(:,2)*1E4,SpiLow(:,2)-SpiLow(:,1)); 
                FreqSL=tsd(SpiLow(:,2)*1E4,SpiLow(:,6));
            end
        end
        try
            [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_deep');% [start_t end_t fqcy]
            if ~isempty(SpiHigh)
                SpiDH=SpiHigh(:,2); Spi=[Spi;SpiDH]; 
                Spi3=intervalSet(SpiHigh(:,1)*1E4,SpiHigh(:,3)*1E4);
                AmpDH=tsd(SpiHigh(:,2)*1E4,SpiHigh(:,2)-SpiHigh(:,1)); 
                FreqDH=tsd(SpiHigh(:,2)*1E4,SpiHigh(:,6)); 
            end
            if ~isempty(SpiLow)
                SpiDL=SpiLow(:,2); Spi=[Spi;SpiDL]; 
                Spi4=intervalSet(SpiLow(:,1)*1E4,SpiLow(:,3)*1E4); 
                AmpDL=tsd(SpiLow(:,2)*1E4,SpiLow(:,2)-SpiLow(:,1)); 
                FreqDL=tsd(SpiLow(:,2)*1E4,SpiLow(:,6));
            end
        end
        %AmpSH AmpSL AmpDH AmpDL FreqSH FreqSL FreqDH FreqDL
        Spfc=sort(Spi);
        Spfc(find(diff(Spfc)<0.5)+1)=[];%same spindles
        Spfc=ts(Spfc*1E4);
        SpiSH=ts(SpiSH*1E4);
        SpiSL=ts(SpiSL*1E4);
        SpiDH=ts(SpiDH*1E4);
        SpiDL=ts(SpiDL*1E4);
        
        % separate ripples inside spindles or not
        if ~isempty(dHPCrip) && ~isempty(Spi)
            TotalRipEpoch=intervalSet(tDelta(1)-1000,tDelta(end)+1000);
            SpiEpoch=or(or(Spi1,Spi2),or(Spi3,Spi4));
            stSp=Start(SpiEpoch);enSp=End(SpiEpoch);
            SpiEpoch=intervalSet(stSp-0.5*1E4,enSp+0.5*1E4);
            SpiEpoch=mergeCloseIntervals(SpiEpoch,1);% if delta closer than windRipDel
            RipInSpin=Restrict(rip,SpiEpoch);
            RipOutSpin=Restrict(rip,TotalRipEpoch-SpiEpoch);
        end
            
        % %%%%%%%%%%%%%%%%%%%%% ripples by delta %%%%%%%%%%%%%%%%%%%%%%%%%%
        if ~isempty(dHPCrip) && ~isempty(tDelta)
            % separate ripples followed by delta or not
            clear PreDelt OutDelt RipInDelta RipOutDelta
            PreDelt=intervalSet(tDelta-windRipDel*10,tDelta);
            PreDelt=mergeCloseIntervals(PreDelt,1);% if delta closer than windRipDel
            OutDelt=intervalSet(min(dHPCrip(:,2)*1E4),max(dHPCrip(:,2)*1E4))-PreDelt;
            RipInDelta=Restrict(rip,PreDelt);% ripples before delta
            RipOutDelta=Restrict(rip,OutDelt);% ripples without delta
            
            % separate Deltas Preceeded by Ripples or not
            clear PostRip OutRip DeltPostRip DeltOutRip
            PostRip=intervalSet(dHPCrip(:,2)*1E4,dHPCrip(:,2)*1E4+windRipDel*10);
            PostRip=mergeCloseIntervals(PostRip,1);% if ripples closer than windRipDel
            OutRip=intervalSet(min(tDelta),max(tDelta))-PostRip;
            DeltPostRip=Restrict(DpfcRip,PostRip);% delta after ripples
            DeltOutRip=Restrict(DpfcRip,OutRip);% delta without ripples
        end
        
        % %%%%%%%%%%%%%%%%%%%%%%%%%%% Get LFPs %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % InfoLFP
        disp('Getting InfoLFP...')
        load('LFPData/InfoLFP.mat','InfoLFP');
        chansHPC=InfoLFP.channel(strcmp(InfoLFP.structure,'dHPC'));
        clear HPClfp PFClfp
        
        %load LFP from chHPC channel
        if ~isempty(dHPCrip)
            ch=chansHPC([find(chansHPC==chHPC),min(find(chansHPC~=chHPC))]);
            for i=1:length(ch)
                clear LFP
                disp('Loading HPC channel... WAIT')
                eval(['load(''LFPData/LFP',num2str(ch(i)),'.mat'')'])
                HPClfp{i}=LFP;
            end
        end
        
        %load LFP from PFCx_deep
        try
            clear channel LFP
            disp('Loading PFCx_deep channel... WAIT')
            load('ChannelsToAnalyse/PFCx_deep.mat');
            eval(['load(''LFPData/LFP',num2str(channel),'.mat'')'])
            PFClfp{1}=LFP;
        catch
            PFClfp{1}=tsd([],[]);
        end
        
        %load LFP from PFCx_sup
        try
            clear channel LFP
            disp('Loading PFCx_sup channel... WAIT')
            load('ChannelsToAnalyse/PFCx_sup.mat');
            eval(['load(''LFPData/LFP',num2str(channel),'.mat'')'])
            PFClfp{2}=LFP;
        catch
            PFClfp{2}=tsd([],[]);
        end
        
        % %%%%%%%%%%%%%% get LFP according to stages and ZT %%%%%%%%%%%%%%
        for n=1:length(NamesEp)
            eval(['epoch=',NamesEp{n},';'])
            
            for v=1:length(NameVar)
                m1e=nan(nbin+1,1); m1l=m1e; m2e=m1e; m2l=m1e;
                try
                    eval(['TStemp=',NameVar{v},'; Chlfp=',chToAv{v},';'])
                    tp=Range(Restrict(TStemp,and(epoch,Early))); if length(tp)>4, [m1e,s,tps]=mETAverage(tp,Range(Chlfp{1}),Data(Chlfp{1}),1,nbin);end
                    tp=Range(Restrict(TStemp,and(epoch,Late))); if length(tp)>4, [m1l,s,tps]=mETAverage(tp,Range(Chlfp{1}),Data(Chlfp{1}),1,nbin);end
                    tp=Range(Restrict(TStemp,and(epoch,Early))); if length(tp)>4, [m2e,s,tps]=mETAverage(tp,Range(Chlfp{2}),Data(Chlfp{2}),1,nbin);end
                    tp=Range(Restrict(TStemp,and(epoch,Late))); if length(tp)>4, [m2l,s,tps]=mETAverage(tp,Range(Chlfp{2}),Data(Chlfp{2}),1,nbin);end
                end
                RythmShape{n,v}(man,:,:)=[m1e';m1l';m2e';m2l'];
            end
        end
        
        
        % %%%%%%%%%%%%%% get ripples LFP according to stages %%%%%%%%%%%%%%
        % get ripples LFP according to stages
        for n=1:3
            eval(['epoch=',NamesStages{n+2},';'])
            
            Idelta=and(epoch,DeltaEpoch);
            WidthDelta(man,n)=mean(Stop(Idelta,'s')-Start(Idelta,'s'));
            WidthDelta(man,3+n)=mean(Stop(and(Idelta,Early),'s')-Start(and(Idelta,Early),'s'));
            WidthDelta(man,6+n)=mean(Stop(and(Idelta,Late),'s')-Start(and(Idelta,Late),'s'));
                         
            %InfoSpinName={'AmpSH','AmpSL','AmpDH','AmpDL','FreqSH','FreqSL','FreqDH','FreqDL'};
            for isn=1:length(InfoSpinName)
                eval(['vartempSpi=',InfoSpinName{isn},';'])
                 InfoSpin(man,n,isn)=nanmean(Data(Restrict(vartempSpi,epoch)));
                 InfoSpin(man,3+n,isn)=nanmean(Data(Restrict(vartempSpi,and(epoch,Early))));
                 InfoSpin(man,6+n,isn)=nanmean(Data(Restrict(vartempSpi,and(epoch,Late))));
            end
            
            % -----------------------------------------------------
            % generate Poisson delta and ripples for control
            % caracteristics of occurance respected for substages
            clear durEp Prip Pdel
            rgPrip=[]; rgPdel=[];
            durEp=Stop(epoch,'s')-Start(epoch,'s');
            disp(['Creating Poisson times for Delta and Ripples from ',NamesStages{n+2},'... WAIT'])
            h = waitbar(0,['Generating Poisson for ',NamesStages{n+2}]);
            for ep=1:length(Start(epoch))
                % ripples
                FRr=length(Range(Restrict(rip,subset(epoch,ep))))/durEp(ep);
                Prip=poissonKB(FRr,durEp(ep));
                rgPrip=[rgPrip,Start(subset(epoch,ep))+Prip*1E4];
                % delta
                FRd=length(Range(Restrict(DpfcRip,subset(epoch,ep))))/durEp(ep);
                Pdel=poissonKB(FRd,durEp(ep));
                rgPdel=[rgPdel,Start(subset(epoch,ep))+Pdel*1E4];
                waitbar(ep/length(Start(epoch)),h);
            end
            close(h);
            Prip=ts(rgPrip);
            Pdel=ts(rgPdel);
            NbRytemp(n,length(NameVar)+1)=length(Range(Pdel));
            NbRytemp(n,length(NameVar)+2)=length(Range(Restrict(Pdel,PostRip)));
            NbRytemp(n,length(NameVar)+3)=length(Range(Prip));
            NbRytemp(n,length(NameVar)+4)=length(Range(Restrict(Prip,PreDelt)));
            % -----------------------------------------------------
            
            % save nb of rhythms
            for v=1:length(NameVar)
                eval(['TStemp=',NameVar{v},';'])
                NbRytemp(n,v)=length(Range(Restrict(TStemp,epoch)));
                
                clear m1 m2 m3 m4 s tps
                if ~isempty(dHPCrip)
                    %hpc
                    [m1,s,tps]=mETAverage(Range(Restrict(TStemp,epoch)),Range(HPClfp{1}),Data(HPClfp{1}),1,nbin);
                    MatRipN{n,v}(:,man)=m1;
                    %hpc other
                    [m4,s,tps]=mETAverage(Range(Restrict(TStemp,epoch)),Range(HPClfp{2}),Data(HPClfp{2}),1,nbin);
                    MatRipN{n,3*length(NameVar)+v}(:,man)=m4;
                else
                    m1=nan(nbin+1,1); m4=nan(nbin+1,1);
                end
                %pfc_deep
                [m2,s,tps]=mETAverage(Range(Restrict(TStemp,epoch)),Range(PFClfp{1}),Data(PFClfp{1}),1,nbin);
                MatRipN{n,length(NameVar)+v}(:,man)=m2;
                %pfc_sup
                [m3,s,tps]=mETAverage(Range(Restrict(TStemp,epoch)),Range(PFClfp{2}),Data(PFClfp{2}),1,nbin);
                MatRipN{n,2*length(NameVar)+v}(:,man)=m3;
                
            end
            
            if ploAllindiv
                figure(Fhpc),
                subplot(floor(sqrt(length(Dir.path))),ceil(sqrt(length(Dir.path))),man),
                hold on, plot(tps,m1,'Color',colori(n+2,:))
                figure(Fpfc),
                subplot(floor(sqrt(length(Dir.path))),ceil(sqrt(length(Dir.path))),man),
                hold on, plot(tps,m2,'Color',colori(n+2,:)),plot(tps,m3,'Color',colori(n+2,:))
            end
        end
        
        if ploAllindiv
            YL1=[YL1,min(m1),max(m1)];
            YL2=[YL2,min(m2),max(m2)];
            figure(Fpfc),
            xlim([-nbin/2 nbin/2]);title(sprintf(['%d-',Dir.name{man}],man));
            xlabel(sprintf('Rip %d/%d/%d',NbRytemp(1,1),NbRytemp(2,1),NbRytemp(3,1)))
            figure(Fhpc),xlim([-nbin/2 nbin/2]);title(sprintf(['%d-',Dir.name{man}],man));
            xlabel(sprintf('Rip %d/%d/%d',NbRytemp(1,1),NbRytemp(2,1),NbRytemp(3,1)))
        end
        
        % terminate and save
        NbRhythm{man}=NbRytemp;
    end
    
    
    
    if ploAllindiv
        for man=1:length(Dir.path)
            figure(Fhpc),
            subplot(floor(sqrt(length(Dir.path))),ceil(sqrt(length(Dir.path))),man),
            ylim([min(YL1),max(YL1)]);
            figure(Fpfc),
            subplot(floor(sqrt(length(Dir.path))),ceil(sqrt(length(Dir.path))),man),
            ylim([min(YL2),max(YL2)]);
        end
    end
    
    
    %save([res,'/AnalySubStages-Rhythms.mat'],'Dir','MatRipN','tps','nbin','NbRhythm','NameVar','NameLeg','NamesStages','windRipDel')
    save([res,'/AnalySubStages-RhythmsNew.mat'],'Dir','MatRipN','tps','nbin','NbRhythm','NameVar','chToAv',...
    'NameLeg','NamesStages','NamesEp','windRipDel','RythmShape','InfoSpinName','WidthDelta','InfoSpin')
end

%% bar plot Delta
figure('Color',[1 1 1])
for n=3:5
    subplot(2,3,n-2)
    A=WidthDelta(:,n-2+[0,3,6])*1E3;
    plotSpread(A,'distributionColors','k');
    for i=1:size(A,2), line(i+[-0.2 0.2],nanmean(A(:,i))+[0 0],'Color','k','Linewidth',2);end
    %PlotErrorBarN(WidthDelta(:,n-2+[0,3,6]),0)
        
    title(['Delta ',NamesStages{n}])
    set(gca,'Xtick',1:3); set(gca,'XtickLabel',{'All','Early','Late'}); set(gca,'XtickLabelRotation',45);
    ylabel('Delta duration (ms)'); ylim([0 150])
    pval=addSigStarML(A);
%     pval=nan(3); stats = []; groups = cell(0);
%     for c1=1:3
%         for c2=c1+1:3
%             try
%                 idx=find(~isnan(A(:,c1)) & ~isnan(A(:,c2)));
%                 [p,h]= signrank(A(idx,c1),A(idx,c2));
%                 pval(c1,c2)=p; pval(c2,c1)=p;
%                 if h==1, groups{length(groups)+1}=[c1 c2]; stats = [stats p];end
%             end
%         end
%     end
%     stats(stats>0.05)=nan;
%     sigstar(groups,stats)
end
subplot(2,3,4:6)

set(gca,'Xtick',1:3); set(gca,'XtickLabel',{'All','Early','Late'}); set(gca,'XtickLabelRotation',45);

%% bar plot spindles
%InfoSpinName={'AmpSH','AmpSL','AmpDH','AmpDL','FreqSH','FreqSL','FreqDH','FreqDL'};
%isn=1; nameisn='Spindles sup high';
%isn=2; nameisn='Spindles sup low';
%isn=3; nameisn='Spindles deep high';
isn=4; nameisn='Spindles deep low';

mice=unique(Dir.name);

figure('Color',[1 1 1])
for n=1:3
    Amp=squeeze(InfoSpin(:,n+[0,3,6],isn));
    Freq=squeeze(InfoSpin(:,n+[0,3,6],4+isn));
    
    if 1 % pool per mice
        Ampmi=nan(length(mice),size(Amp,2));
        Freqmi=nan(length(mice),size(Freq,2));
        for mi=1:length(mice)
            ind=find(strcmp(Dir.name,mice{mi}));
            Ampmi(mi,:)=nanmean(Amp(ind,:),1);
            Freqmi(mi,:)=nanmean(Freq(ind,:),1);
        end
        Amp=Ampmi;
        Freq=Freqmi;
    end
    
    for i=1:2
        if i==1, A=Amp; leg=['Spind Amp ',NamesStages{n+2}]; else, A=Freq; leg=['Spind Freq ',NamesStages{n+2}];end
        subplot(2,3,3*(i-1)+n)
%         plotSpread(A,'distributionColors','k');
%         for i=1:size(A,2), line(i+[-0.2 0.2],nanmean(A(:,i))+[0 0],'Color','k','Linewidth',2);end
        PlotErrorBarN(A,0,0);
        
        title(leg)
        set(gca,'Xtick',1:3); set(gca,'XtickLabel',{'All','Early','Late'}); set(gca,'XtickLabelRotation',45);
        ylabel(leg); %ylim([0 150])
        
        pval=nan(3); stats = []; groups = cell(0);
        for c1=1:3
            for c2=c1+1:3
                try
                    idx=find(~isnan(A(:,c1)) & ~isnan(A(:,c2)));
                    [p,h]= signrank(A(idx,c1),A(idx,c2));
                    pval(c1,c2)=p; pval(c2,c1)=p;
                    if h==1, groups{length(groups)+1}=[c1 c2]; stats = [stats p];end
                end
            end
        end
        stats(stats>0.05)=nan;
        sigstar(groups,stats)
    end
end

%% plt indiv
for man=1:length(Dir.path)
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.7 0.9]);Fman1=gcf;
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.7 0.9]);Fman2=gcf;
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.7 0.9]);Fman3=gcf;
    NbRytemp=NbRhythm{man};
    for n=1:3
        for v=1:length(NameVar)
            m1=MatRipN{n,v}(:,man);
            m2=MatRipN{n,length(NameVar)+v}(:,man);
            m3=MatRipN{n,2*length(NameVar)+v}(:,man);
            
            % -----------------------------------
            %plot depending on stage
            figure(Fman1),
            subplot(3,length(NameVar),length(NameVar)*(n-1)+v),hold on,
            plot(tps,m1,'Color',[0.3 0.3 0.3]); plot(tps,m2+500,'k','Linewidth',2); plot(tps,m3+500,'k');
            if v==1, ylabel(NamesStages{n+2},'Color',colori(n+2,:));end;
            title(sprintf([NameLeg{v},' (%d)'],NbRytemp(n,v)),'Color',colori(n+2,:)); xlim([-150 300])
            if v==3 && n==1, title({Dir.path{man},' ',sprintf([NameLeg{v},' (%d)'],NbRytemp(n,v))});end
            
            % -----------------------------------
            %plot depending on structure
            figure(Fman2),
            subplot(3,length(NameVar),v), hold on, plot(tps,m1,'Color',colori(n+2,:));
            if v==1, ylabel('dHPC');end; xlim([-150 300])
            if n==1, if v==3,title({Dir.path{man},' ',NameLeg{v}});else, title(NameLeg{v});end;end;
            subplot(3,length(NameVar),length(NameVar)+v), hold on, plot(tps,m2,'Color',colori(n+2,:));
            if v==1, ylabel('PFCdeep');end; if n==1, title(NameLeg{v});end; xlim([-150 300])
            subplot(3,length(NameVar),2*length(NameVar)+v), hold on, plot(tps,m3,'Color',colori(n+2,:));
            if v==1, ylabel('PFCsup');end; if n==1, title(NameLeg{v});end; xlim([-150 300])
            
            % -----------------------------------
            %plot depending on rhythms
            figure(Fman3),
            subplot(3,6,3*floor(v/4)+n), hold on, plot(tps,m1,'Color',colori2{v});
            ylabel('dHPC'); title(NamesStages{n+2},'Color',colori(n+2,:));xlim([-150 300])
            if v==1 && n==3, title({Dir.path{man},' ',NamesStages{n+2}});end
            subplot(3,6,6+3*floor(v/4)+n), hold on, plot(tps,m2,'Color',colori2{v});
            ylabel('PFCdeep');title(NamesStages{n+2},'Color',colori(n+2,:));xlim([-150 300])
            subplot(3,6,12+3*floor(v/4)+n), hold on, plot(tps,m3,'Color',colori2{v});
            ylabel('PFCsup'); title(NamesStages{n+2},'Color',colori(n+2,:));xlim([-150 300])
        end
    end
    keyboard
    figure(Fman3),legend(NameLeg(4:6)); subplot(3,6,15),legend(NameLeg(1:3));
    saveFigure(Fman3.Number,sprintf('AnalyseNREMRhythm-DelRip%d',man),FolderToSave)
    close;
    figure(Fman2), legend(NamesStages(3:5))
    saveFigure(Fman2.Number,sprintf('AnalyseNREMRhythm-Struct%d',man),FolderToSave)
    close;
    figure(Fman1),legend({'dHPC','PFCdeep','PFCsup'})
    saveFigure(Fman1.Number,sprintf('AnalyseNREMRhythm-Stages%d',man),FolderToSave)
    close;
end
%% plot % of Rip followed by delta, and proportion of Delta versus Ripples in N1, N2, N3

MATbar1=nan(length(Dir.path),3);% rip trig delta
MATbar2=nan(length(Dir.path),3);% rip total
MATbar3=nan(length(Dir.path),3);% delta post rip
MATbar4=nan(length(Dir.path),3);% delta total
MATbar5=nan(length(Dir.path),3);% Poisson delta post rip
MATbar6=nan(length(Dir.path),3);% Poisson rip trig delta
MATbar7=nan(length(Dir.path),3);% Poisson delta total
MATbar8=nan(length(Dir.path),3);% Poisson rip total
% NbRhytemp(n,7)=Pdel 8=PdelPostRip 9=Prip 10=PripPreDelt
for man=1:length(Dir.path)
    if ~isempty(NbRhythm{man})
        NbRhytemp=NbRhythm{man};
        for n=1:3
            MATbar2(man,n)=NbRhytemp(n,1);
            MATbar4(man,n)=NbRhytemp(n,4);
            MATbar7(man,n)=NbRhytemp(n,7);
            MATbar8(man,n)=NbRhytemp(n,9);
            if NbRhytemp(n,1)>0
                MATbar1(man,n)=100*NbRhytemp(n,2)/NbRhytemp(n,1);
            end
            if NbRhytemp(n,4)>0
                MATbar3(man,n)=100*NbRhytemp(n,5)/NbRhytemp(n,4);
            end
            if NbRhytemp(n,7)>0
                MATbar5(man,n)=100*NbRhytemp(n,8)/NbRhytemp(n,7);
            end
            if NbRhytemp(n,9)>0
                MATbar6(man,n)=100*NbRhytemp(n,10)/NbRhytemp(n,9);
            end
        end
    end
end
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.5 0.5]), 
subplot(2,5,1), PlotErrorBarN(MATbar1,0,1);
set(gca,'Xtick',[1 2 3]),set(gca,'XtickLabel',NamesStages(3:5))
title('% of Ripples followed by a Delta')
ylabel('% of substage Ripples');

subplot(2,5,6), PlotErrorBarN(MATbar3,0,1);
set(gca,'Xtick',[1 2 3]),set(gca,'XtickLabel',NamesStages(3:5))
title('% of Delta preceeded by a Ripple')
ylabel('% of substage Delta');

subplot(2,5,2), PlotErrorBarN(MATbar6,0,1);
set(gca,'Xtick',[1 2 3]),set(gca,'XtickLabel',NamesStages(3:5))
title('% of POISSON Ripples followed by a Delta')

subplot(2,5,7), PlotErrorBarN(MATbar5,0,1);
set(gca,'Xtick',[1 2 3]),set(gca,'XtickLabel',NamesStages(3:5))
title('% of POISSON Delta preceeded by a Ripple')

subplot(2,5,3), PlotErrorBarN(MATbar4./MATbar2,0,1);
set(gca,'Xtick',[1 2 3]),set(gca,'XtickLabel',NamesStages(3:5))
title('ratio Delta/Ripples')

subplot(2,5,8), PlotErrorBarN(MATbar2./MATbar4,0,1);
set(gca,'Xtick',[1 2 3]),set(gca,'XtickLabel',NamesStages(3:5))
title('ratio Ripples/Delta')

subplot(2,5,4), PlotErrorBarN(MATbar2,0,1);
set(gca,'Xtick',[1 2 3]),set(gca,'XtickLabel',NamesStages(3:5))
title(sprintf('Nb of Ripples (n=%d)',sum(~isnan(nanmean(MATbar2,2)))))

subplot(2,5,9), PlotErrorBarN(MATbar4,0,1);
set(gca,'Xtick',[1 2 3]),set(gca,'XtickLabel',NamesStages(3:5))
title(sprintf('Nb of Delta (n=%d)',sum(~isnan(nanmean(MATbar4,2)))))

subplot(2,5,5), PlotErrorBarN(MATbar8,0,1);
set(gca,'Xtick',[1 2 3]),set(gca,'XtickLabel',NamesStages(3:5))
title(sprintf('Nb of POISSON Ripples (n=%d)',sum(~isnan(nanmean(MATbar8,2)))))

subplot(2,5,10), PlotErrorBarN(MATbar7,0,1);
set(gca,'Xtick',[1 2 3]),set(gca,'XtickLabel',NamesStages(3:5))
title(sprintf('Nb of POISSON Delta (n=%d)',sum(~isnan(nanmean(MATbar7,2)))))


%saveFigure(gcf,'AnalyseNREM-RhythmsCoordinBar',FolderToSave)


%% evolution Ripples between N1-N2-N3, 
idEp=3:5;
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.7 0.9]);numF=gcf;
%NameVar={'rip','RipInDelta','RipOutDelta','RipInSpin','RipOutSpin','Dpfc','DeltPostRip','DeltOutRip','Spfc','SpiSH','SpiSL','SpiDH','SpiDL'};

for man=1:length(Dir.path)
    subplot(floor(sqrt(length(Dir.path))),ceil(sqrt(length(Dir.path))),man), hold on,
    leg=[];
    for n=1:length(idEp)
        temp=MatRipN{n,1}(:,man)';
        plot(tps,temp(1,:)-n*1000,'Color',colori(idEp(n),:),'Linewidth',2);
        xlim([-80 80])
    end
    title(sprintf(['%d-',Dir.name{man}],man));
end
legend(NamesEp(idEp)); xlabel('Time (ms)')
saveFigure(numF.Number,'AnalyseNREM-RhythmsRipplesN1N2N3',FolderToSave)

% indiv example
Indman=[2 11 13 15];
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.7 0.9]);numG=gcf;
for man=1:length(Indman)
    yl=[];
    for n=1:3
        subplot(length(Indman),3,3*(man-1)+n)
        temp=MatRipN{n,1}(:,Indman(man))';
        plot(tps,temp(1,:),'Color',colori(n+2,:),'Linewidth',2);
        xlim([-80 80]); yl=[yl,ylim];
        if n==2, title({sprintf(['%d-',Dir.name{Indman(man)}],Indman(man)),NamesEp{n+2}});else, title(NamesEp{n+2});end
    end
    for n=1:3, subplot(length(Indman),3,3*(man-1)+n); ylim([min(yl) max(yl)]);end
end
xlabel('Time (ms)')
%saveFigure(numG.Number,'AnalyseNREM-RhythmsRipplesN1N2N3-Examp',FolderToSave)


%% evolution Delta between N1-N2-N3, early and late

%NameVar={'rip','RipInDelta','RipOutDelta','RipInSpin','RipOutSpin','Dpfc','DeltPostRip','DeltOutRip','Spfc','SpiSH','SpiSL','SpiDH','SpiDL'};
ind=[1,6,9];
idx{1}=260:342;
idx{2}=1:601;
idx{3}=1:601;
corrC=nan(length(Dir.path),6);corrCp=corrC;
nameCorr={'N1e-l','N2e-l','N3e-l','N1e-N2e','N1e-N3e','N2e-N3e','N1l-N2l','N1l-N3l','N2l-N3l'}; 
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.7 0.7]); numF=gcf;
for v=1:length(ind)
    for man=1:length(Dir.path)
        % on regarde correlation que sur channel 1
        mN1e=squeeze(RythmShape{3,ind(v)}(man,1,idx{v}));% N1 early deep
        mN1l=squeeze(RythmShape{3,ind(v)}(man,2,idx{v}));% N1 late deep
        mN2e=squeeze(RythmShape{4,ind(v)}(man,1,idx{v}));% N2 early deep
        mN2l=squeeze(RythmShape{4,ind(v)}(man,2,idx{v}));% N2 late deep{v}
        mN3e=squeeze(RythmShape{5,ind(v)}(man,1,idx{v}));% N3 early deep
        mN3l=squeeze(RythmShape{5,ind(v)}(man,2,idx{v}));% N3 late deep
        
        if 0
        if mod(man,3)==1, figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.9 0.9]); end
        subplot(3,3,3*mod(man-1,3)+1), plot(tps(idx{v}),mN1e','Color',colori(3,:),'linewidth',2);
        hold on, plot(tps(idx{v}),mN1l','Color',colori(3,:)); title(sprintf('M%d',man))
        subplot(3,3,3*mod(man-1,3)+2),plot(tps(idx{v}),mN2e','Color',colori(4,:),'linewidth',2);
        hold on,plot(tps(idx{v}),mN2l','Color',colori(4,:));title(NameVar(ind(v)))
        subplot(3,3,3*mod(man-1,3)+3),plot(tps(idx{v}),mN3e','Color',colori(5,:),'linewidth',2);
        hold on,plot(tps(idx{v}),mN3l','Color',colori(5,:));
        end
        
        [r,p]=corrcoef(mN1e,mN1l); corrC(man,1)=r(1,2); corrCp(man,1)=p(1,2);
        [r,p]=corrcoef(mN2e,mN2l); corrC(man,2)=r(1,2); corrCp(man,2)=p(1,2);
        [r,p]=corrcoef(mN3e,mN3l); corrC(man,3)=r(1,2); corrCp(man,3)=p(1,2);
        [r,p]=corrcoef(mN1e,mN2e); corrC(man,4)=r(1,2); corrCp(man,4)=p(1,2);
        [r,p]=corrcoef(mN1e,mN3e); corrC(man,5)=r(1,2); corrCp(man,5)=p(1,2);
        [r,p]=corrcoef(mN2e,mN3e); corrC(man,6)=r(1,2); corrCp(man,6)=p(1,2);
        [r,p]=corrcoef(mN1l,mN2l); corrC(man,7)=r(1,2); corrCp(man,7)=p(1,2);
        [r,p]=corrcoef(mN1l,mN3l); corrC(man,8)=r(1,2); corrCp(man,8)=p(1,2);
        [r,p]=corrcoef(mN2l,mN3l); corrC(man,9)=r(1,2); corrCp(man,9)=p(1,2);
    end
    
    % bar plot quantif
    figure(numF), subplot(3,1,v)
    plotSpread(corrC,'distributionColors','k');
    for i=1:size(corrC,2), line(i+[-0.2 0.2],nanmean(corrC(:,i))+[0 0],'Color','k','Linewidth',2);end
    set(gca,'Xtick',1:9); set(gca,'XtickLabel',nameCorr)
    title(NameVar(ind(v))); ylabel('CorrCoeff')
    ylim([0 1])
end

%saveFigure(numF.Number,'AnalyseNREM-RhythmsRipDeltSpi-N1N2N3-EarlyLate',FolderToSave)



%% evolution delta between N2-N3, early and late
idEp=4:5;
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.7 0.9]);numF=gcf;
%NameVar={'rip','RipInDelta','RipOutDelta','RipInSpin','RipOutSpin','Dpfc','DeltPostRip','DeltOutRip','Spfc','SpiSH','SpiSL','SpiDH','SpiDL'};
for man=1:length(Dir.path)
    subplot(floor(sqrt(length(Dir.path))),ceil(sqrt(length(Dir.path))),man), hold on,
    leg=[];
    for n=1:length(idEp)
        temp=squeeze(RythmShape{idEp(n),6}(man,:,:));% Dpfc
        plot(tps,temp(1,:)-n*1000,'Color',colori(idEp(n),:),'Linewidth',2);
        plot(tps,temp(2,:)-n*1000,'Color',colori(idEp(n),:));xlim([-200 250])
        plot(tps,temp(3,:)-n*1000,':','Color',colori(idEp(n),:),'Linewidth',2);
        plot(tps,temp(4,:)-n*1000,':','Color',colori(idEp(n),:));xlim([-200 250])
        leg=[leg,{['Deep ',NamesEp{idEp(n)},' early']},{['Deep ',NamesEp{idEp(n)},' late']},...
            {['Sup ',NamesEp{idEp(n)},' early']},{['Sup ',NamesEp{idEp(n)},' late']}];
    end
    title(sprintf(['%d-',Dir.name{man}],man));
end
legend(leg)
saveFigure(numF.Number,'AnalyseNREM-RhythmsDeltaN2N3',FolderToSave)

% indiv example
Indman=[2 7 17 22];
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.35 0.7]);numG=gcf;
for man=1:length(Indman)
    yl=[];
    for n=1:length(idEp)
        temp=squeeze(RythmShape{idEp(n)}(Indman(man),:,:));
        subplot(length(Indman),4,4*(man-1)+2*(n-1)+1), hold on
        plot(tps,temp(5,:),'Color',colori(idEp(n),:),'Linewidth',2);
        plot(tps,temp(7,:),'Color',colori(idEp(n),:));
        yl=[yl,ylim];
        title(['Early ',NamesEp{idEp(n)}]);xlim([-250 250])
        if n==1, ylabel(sprintf(['%d-',Dir.name{Indman(man)}],man));end
        
        subplot(length(Indman),4,4*(man-1)+2*(n-1)+2), hold on
        plot(tps,temp(6,:),'Color',colori(idEp(n),:),'Linewidth',2);
        plot(tps,temp(8,:),'Color',colori(idEp(n),:));
        yl=[yl,ylim];
        title(['Late ',NamesEp{idEp(n)}]);xlim([-250 250])
    end
    for n=1:length(idEp)
        subplot(length(Indman),4,4*(man-1)+n),ylim([min(yl) max(yl)])
        subplot(length(Indman),4,4*(man-1)+n+2), ylim([min(yl) max(yl)])
    end
end
legend({'Deep','Sup'})
saveFigure(numG.Number,'AnalyseNREM-RhythmsDeltaN2N3-Examp',FolderToSave)

%% bar plot quantif
%id=[1,4,7,2,5,8,3,6,9];
id=[2,5,8,3,6,9];
idname={'N1','N2','N3','N1e','N2e','N3e','N1l','N2l','N3l'};

% delta
figure('Color',[1 1 1]); numG=gcf;
subplot(2,3,1), PlotErrorBarN(WidthDelta(:,id),0,1);
set(gca,'Xtick',1:length(id)); set(gca,'XtickLabel',idname(id))
Wd=100*WidthDelta(:,id)./(WidthDelta(:,2)*ones(1,length(id)));
titn=sprintf('n=%d',size(WidthDelta,1));
title({'Deep PFCx',titn});

titN=titn;
mice=unique(Dir.name);
if 1 % pool per mice
    Wdmi=nan(length(mice),size(Wd,2));
    for mi=1:length(mice)
        ind=find(strcmp(Dir.name,mice{mi}));
        Wdmi(mi,:)=nanmean(Wd(ind,:),1);
    end
    Wd=Wdmi;
    titN=sprintf('N=%d',length(mice));
end
    
subplot(2,3,2), bar(nanmean(Wd))
hold on, errorbar(1:length(id),nanmean(Wd),stdError(Wd),'+k')
set(gca,'Xtick',1:length(id)); set(gca,'XtickLabel',idname(id))
ylabel('Delta width (%N2)'); xlim([0 length(id)+1])
pval=addSigStarML(Wd,'ttest'); title({'Deep PFCx',titN});

idEp=4:5;
leg={'N2e','N2l','N3e','N3l'};
clear matAmp
a=0;
for l=1:2%[m2e';m2l'];
    for i=1:length(idEp)
        a=a+1;
        for man=1:length(Dir.path)
            AA=squeeze(RythmShape{idEp(i),6}(man,l,:));
            matAmp(man,a)=max(AA)-min(AA);
        end
    end
end

subplot(2,3,4),PlotErrorBarN(matAmp,0,1)
set(gca,'Xtick',1:4); set(gca,'XtickLabel',leg)
titn=sprintf('n=%d',size(WidthDelta,1));
title({'Deep PFCx',titn});

Wd=100*matAmp./(matAmp(:,1)*ones(1,4));
titN=titn;
mice=unique(Dir.name);
if 1 % pool per mice
    Wdmi=nan(length(mice),size(Wd,2));
    for mi=1:length(mice)
        ind=find(strcmp(Dir.name,mice{mi}));
        Wdmi(mi,:)=nanmean(Wd(ind,:),1);
    end
    Wd=Wdmi;
    titN=sprintf('N=%d',length(mice));
end

subplot(2,3,5),bar(nanmean(Wd))
hold on, errorbar(1:4,nanmean(Wd),stdError(Wd),'+k')
set(gca,'Xtick',1:4); set(gca,'XtickLabel',leg)
ylabel('Delta amp (%N2e)'); xlim([0 5])
pval=addSigStarML(Wd,'ttest');title({'Deep PFCx',titN});

saveFigure(numG.Number,'AnalyseNREM-Rhythms_DeltaBarQuantif',FolderToSave)

%% spindles
figure('Color',[1 1 1]);numG=gcf;
titSpi={'Sup High','Sup Low','Deep High','Deep Low'};
mice=unique(Dir.name);
for isn=1:8
    Wd=100*squeeze(InfoSpin(:,id,isn))./(squeeze(InfoSpin(:,2,isn))*ones(1,length(id)));
    
    titN=sprintf('n=%d',size(Wd,1));
    if 1 % pool per mice
        Wdmi=nan(length(mice),size(Wd,2));
        for mi=1:length(mice)
            ind=find(strcmp(Dir.name,mice{mi}));
            Wdmi(mi,:)=nanmean(Wd(ind,:),1);
        end
        Wd=Wdmi;
        titN=sprintf('N=%d',length(mice));
    end
    
    subplot(2,4,isn),bar(nanmean(Wd))
    hold on, errorbar(1:length(id),nanmean(Wd),stdError(Wd),'+k')
    set(gca,'Xtick',1:length(id)); set(gca,'XtickLabel',idname(id))
    if isn<5, ylabel('Spindles Amp (%N2)'); else, ylabel('Spindles Freq (%N2)'); end
    xlim([0 length(id)+1])
    
    pval=addSigStarML(Wd,'ttest');
    title({titSpi{mod(isn-1,4)+1},titN})
end
saveFigure(numG.Number,'AnalyseNREM-Rhythms_SpindlesBarQuantif',FolderToSave)


%% bar plot quantif ripples

idEp=4:5;
leg={'N2e','N2l','N3e','N3l'};
clear matAmp
a=0;
for l=1:2%[m2e';m2l'];
    for i=1:length(idEp)
        a=a+1;
        for man=1:length(Dir.path)
            AA=squeeze(RythmShape{idEp(i),1}(man,l,:));
            matAmp(man,a)=max(AA)-min(AA);
        end
    end
end

figure('Color',[1 1 1]); numG=gcf;
subplot(2,3,1),PlotErrorBarN(matAmp,0,1)
set(gca,'Xtick',1:4); set(gca,'XtickLabel',leg)
title('dHPC');
Wd=100*matAmp./(matAmp(:,1)*ones(1,4));

subplot(2,3,2),bar(nanmean(matAmp))
hold on, errorbar(1:4,nanmean(matAmp),stdError(matAmp),'+k')
set(gca,'Xtick',1:4); set(gca,'XtickLabel',leg)

ylabel('Ripples amp (%N2e)'); xlim([0 5])
pval=nan(length(id),length(id)); stats = []; groups = cell(0);
for c1=1:length(id)
    for c2=c1+1:length(id)
        try
            idx=find(~isnan(matAmp(:,c1)) & ~isnan(matAmp(:,c2)));
            [h,p]= ttest(matAmp(idx,c1),matAmp(idx,c2));
            pval(c1,c2)=p; pval(c2,c1)=p;
            if h==1, groups{length(groups)+1}=[c1 c2]; stats = [stats p];end
        end
    end
end
stats(stats>0.05)=nan;
sigstar(groups,stats)

%saveFigure(numG.Number,'AnalyseNREM-Rhythms_RipplesBarQuantif',FolderToSave)









