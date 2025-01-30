% AnalyseNREMsubstages_Rhythms.m
%
% see also
% 1. AnalyseNREMsubstagesML.m
% 2. AnalyseNREMsubstages_transitionML.m
% 3. AnalyseNREMsubstages_transitionprobML.m
% 4. AnalyseNREMsubstages_EvolRescaleML.m
% 5. AnalyseNREMsubstages_OBslowOscML.m
% 6. AnalyseNREMsubstages_EvolSlowML.m
% 7. AnalyseNREMsubstages_mergeDropML.m
% 8. AnalyseNREMsubstages_SpikesML.m
% 9. AnalyseNREMsubstages_MultiParamMatrix.m
% 10. AnalyseNREMsubstages_SpikesAndRhythms.m
% 11. AnalyseNREMsubstages_SpectrumML.m
% 12. AnalyseNREMsubstages_Rhythms.m
% 13. AnalyseNREMsubstages_N1evalML.m
% 14. AnalyseNREMsubstages_TrioTransitionML.m
% 15. AnalyseNREMsubstages_TrioTransRescaleML.m
% 16. AnalyseNREMsubstages_OBX.m
% 17. AnalyseNREMsubstages_SpikesInterPyrML.m
% 18. AnalyseNREMsubstagesdKOML.m
% 19. AnalyseNREMsubstages_SD.m
% 20. AnalyseNREMsubstages_SWA.m
% 21. AnalyseNREMsubstages_OR.m
% 22. AnalyseNREMsubstages_SD24h.m
% 23. AnalyseNREMsubstages_ORspikes.m
% CaracteristicsSubstagesML.m



% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
%FolderToSave='/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureNREMstages';
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/NREMsubRhythm';
savFig=0; clear MATEP Dir

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
nbin=600;
colori=[0.5 0.2 0.1; 0.1 0.7 0; 0.7 0.2 0.8;1 0.7 0.6 ; 1 0 1 ];
for n=1:3, for i=1:9, MatRipN{n,i}=nan(nbin+1,length(Dir.path)); end;end
NbRhythm={};
YL1=[];YL2=[];
windRipDel=400;%ms
NameVar={'rip','RipD','RipO','Dpfc','DeltR','DeltO'};
NameLeg={'All Ripples','Ripples + Delta','Ripples alone','All Delta','Delta after Ripples','Delta alone'};
colori2={'k','r','b','k','r','b'};
ploAllindiv=0;

try
    load([res,'/AnalySubStages-Rhythms.mat'])
    NbRhythm;MatRipN;
catch
    
    if ploAllindiv
        figure('Color',[1 1 1]); Fhpc=gcf;
        figure('Color',[1 1 1]); Fpfc=gcf;
    end
    
    for man=1:length(Dir.path)
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        NbRytemp=nan(3,length(NameVar)+2);
        figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.5 0.85]);Fman1=gcf;
        figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.5 0.85]);Fman2=gcf;
        figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.5 0.85]);Fman3=gcf;
        try
            % get delta
            clear tDelta Dpfc
            load('AllDeltaPFCx.mat','tDelta');
            tDelta(tDelta<windRipDel*10)=[];
            Dpfc=ts(tDelta);
            
            % get ripples
            clear dHPCrip chHPC rip
            load('AllRipplesdHPC25.mat','dHPCrip','chHPC');
            rip=ts(dHPCrip(:,2)*1E4);
            
            % separate ripples followed by delta or not
            clear PreDelt OutDelt RipD RipO
            PreDelt=intervalSet(tDelta-windRipDel*10,tDelta);
            PreDelt=mergeCloseIntervals(PreDelt,1);% if delta closer than windRipDel
            OutDelt=intervalSet(min(dHPCrip(:,2)*1E4),max(dHPCrip(:,2)*1E4))-PreDelt;
            RipD=Restrict(rip,PreDelt);% ripples before delta
            RipO=Restrict(rip,OutDelt);% ripples without delta
            
            % separate Deltas Preceeded by Ripples or not
            clear PostRip OutRip DeltR DeltO
            PostRip=intervalSet(dHPCrip(:,2)*1E4,dHPCrip(:,2)*1E4+windRipDel*10);
            PostRip=mergeCloseIntervals(PostRip,1);% if ripples closer than windRipDel
            OutRip=intervalSet(min(tDelta),max(tDelta))-PostRip;
            DeltR=Restrict(Dpfc,PostRip);% delta after ripples
            DeltO=Restrict(Dpfc,OutRip);% delta without ripples
            
            if ~isempty(tDelta) && ~isempty(dHPCrip)
                % NREM substages
                clear WAKE REM N1 N2 N3
                [WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;close
                
                %load LFP from chHPC channel
                clear LFP LFP1
                disp('Loading HPC channel... WAIT')
                eval(['load(''LFPData/LFP',num2str(chHPC),'.mat'')'])
                LFP1=LFP;
                
                %load LFP from PFCx_deep
                clear channel LFP LFP2
                disp('Loading PFCx_deep channel... WAIT')
                load('ChannelsToAnalyse/PFCx_deep.mat');
                eval(['load(''LFPData/LFP',num2str(channel),'.mat'')'])
                LFP2=LFP;
                
                %load LFP from PFCx_sup
                clear channel LFP LFP3
                disp('Loading PFCx_sup channel... WAIT')
                load('ChannelsToAnalyse/PFCx_sup.mat');
                eval(['load(''LFPData/LFP',num2str(channel),'.mat'')'])
                LFP3=LFP;
                
                % get ripples LFP according to stages
                for n=1:3
                    eval(['epoch=',NamesStages{n+2},';'])
                    
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
                        FRd=length(Range(Restrict(Dpfc,subset(epoch,ep))))/durEp(ep); 
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
                        
                        clear m1 m2 m3 s tps
                        %hpc
                        [m1,s,tps]=mETAverage(Range(Restrict(TStemp,epoch)),Range(LFP1),Data(LFP1),1,nbin);
                        MatRipN{n,v}(:,man)=m1;
                        %pfc_deep
                        [m2,s,tps]=mETAverage(Range(Restrict(TStemp,epoch)),Range(LFP2),Data(LFP2),1,nbin);
                        MatRipN{n,length(NameVar)+v}(:,man)=m2;
                        %pfc_sup
                        [m3,s,tps]=mETAverage(Range(Restrict(TStemp,epoch)),Range(LFP3),Data(LFP3),1,nbin);
                        MatRipN{n,2*length(NameVar)+v}(:,man)=m3;
                        
                        % -----------------------------------
                        %plot depending on stage
                        figure(Fman1),
                        subplot(3,length(NameVar),length(NameVar)*(n-1)+v),hold on,plot(tps,m1,'k');
                        plot(tps,m2+500,'b','Linewidth',2); plot(tps,m3+500,'b'); xlim([-150 300])
                        if v==1, ylabel(NamesStages{n+2},'Color',colori(n+2,:));end;
                        title(sprintf([NameLeg{v},' (%d)'],NbRytemp(n,v)),'Color',colori(n+2,:))
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
                        ylabel('dHPC'); title(NamesStages{n+2},'Color',colori(n+2,:))
                        if v==1 && n==3, title({Dir.path{man},' ',NamesStages{n+2}});end
                        subplot(3,6,6+3*floor(v/4)+n), hold on, plot(tps,m2,'Color',colori2{v});
                        ylabel('PFCdeep');title(NamesStages{n+2},'Color',colori(n+2,:))
                        subplot(3,6,12+3*floor(v/4)+n), hold on, plot(tps,m3,'Color',colori2{v});
                        ylabel('PFCsup'); title(NamesStages{n+2},'Color',colori(n+2,:))
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
                    xlim([-nbin/2 nbin/2]);
                    title(sprintf(['%d-',Dir.name{man},' (%d/%d/%d)'],man,NbRip(man,1),NbRip(man,2),NbRip(man,3)))
                    figure(Fhpc),xlim([-nbin/2 nbin/2]);
                    title(sprintf(['%d-',Dir.name{man},' (%d/%d/%d)'],man,NbRip(man,1),NbRip(man,2),NbRip(man,3)))
                end
                
                % terminate and save
                NbRhythm{man}=NbRytemp;
                
                
                figure(Fman3),legend(NameLeg(4:6)); subplot(3,6,15),legend(NameLeg(1:3));
                saveFigure(gcf,sprintf('AnalyseNREMRhythm-DelRip%d',man),FolderToSave)
                close;
                figure(Fman2), legend(NamesStages(3:5))
                saveFigure(gcf,sprintf('AnalyseNREMRhythm-Struct%d',man),FolderToSave)
                close;
                figure(Fman1),legend({'dHPC','PFCdeep','PFCsup'})
                saveFigure(gcf,sprintf('AnalyseNREMRhythm-Stages%d',man),FolderToSave)
                close;
            else
                close(Fman1);close(Fman2);close(Fman3);
            end
        end
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
    
    
    save([res,'/AnalySubStages-Rhythms.mat'],'Dir','MatRipN','tps','nbin','NbRhythm','NameVar','NameLeg','NamesStages','windRipDel')
    %save([res,'/AnalySubStages-Rhythms.mat'],'-append','NbRhythm','NameVar','NameLeg')
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


saveFigure(gcf,'AnalyseNREM-RhythmsCoordinBar',FolderToSave)


%% look at PFCx Spikes  



