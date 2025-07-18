%PSTH_behav_duoCS(datalocation, manipname,varargin)

% 05.09.2016 from PSTH_behav, but plot the CS- abd following CS+ on the same row
% 22.08.2015
% from FigBILANObsFreez_Nov15

%09.12.2015
%different way to get TTL

%23.12.2014 aims at giving an overview of the behavioral results of Fear Conditionning(oct-nov2014)

% INPUTS
% datalocation : 'server' 'DataMOBs14' or 'manip' -> to build path : [FolderPath manipname]
% manipname : 'ManipDec14Bulbectomie' or 'ManipFeb15Bulbectomie' -> define name of EXT 24h and mice names
% smoothing : parameter for SmoothDec
% plo : if =1  individual plot are created (time consuming)

% OUTPUTS
% a figure for each mouse of PSTH (averaged CS-, first CS+, last CS+) ->  BulbectomiePSTHdata.mat
% a matrix for all mice of PSTH (averaged CS-, first CS+, last CS+) color coded)
% the average of these matrices by group (sham/ bulb)
% the compartison of Pre/Post sound period by group 

% e.g. Marie: FigBILANObsFreez('Marie','FearMLavr2015','smoothing',1);

% INPUTS

datalocation='server';
manipname='LaserChR2-Jul16';


cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear
res=pwd;
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir = RestrictPathForExperiment(Dir,'nMice',[363 367]);
[nameMice, IXnameMice]=unique(Dir.name);
nameGroups={'OBX', 'CTRL'};


 
lim=140; % nb bins
bi=1000; % bin size
smo=1;
plo=1;
sav=0;

FolderPath='/media/DataMOBsRAID/ProjetAversion/';

StepName={'HAB';'EXT-24';'EXT-48';'EXT-72'};
%ColorPSTH={ [0.3 0 0],[1 0 0],[0 0 1]};% [1 0.5 0]
ColorPSTH={ [1 0.7 0.7],[0 0 1],[1 0 0],[0.7 0.7 1]};% [1 0.5 0]

% group CS+=bip
CSplu_bip_GpNb=[];
CSplu_bip_Gp={};
for k=1:length(CSplu_bip_GpNb)
    CSplu_bip_Gp{k}=num2str(CSplu_bip_GpNb(k));
end
CSplu_bip_Gp=CSplu_bip_Gp';

% group CS+=WN
CSplu_WN_GpNb=[363 367];
CSplu_WN_Gp={};
for k=1:length(CSplu_WN_GpNb)
    CSplu_WN_Gp{k}=num2str(CSplu_WN_GpNb(k));
end
CSplu_WN_Gp=CSplu_WN_Gp';

%% GET DATA TO PLOT
try
    load(['PSTH_behav_' manipname ]);MatInfo;
    disp(['Loading existing data from PSTH_behav_' manipname '.mat']);
    [B,IX] = sort(Dir.group);
    Dir.path=Dir.path(IX);
    Dir.name=Dir.name(IX);
    Dir.manipe=Dir.manipe(IX);
    Dir.group=B;
    Dir.Session=Dir.Session(IX);
    [nameMice, IXnameMice]=unique(Dir.name);
    IX2=sort(IXnameMice);
    nameMice=nameMice(IX_IX2);

catch

    % Matrix of data; mice in lines
    C2=[]; % COND  first CS+    
    C3=[];%        last CS+
    C1=[]; %       CS-
    C0=[];
    P2=[]; % PLETH 
    P3=[];
    P1=[];
    P0=[];
    E2=[]; % ENV B
    E3=[];
    E1=[];
    E0=[];
    C={};P={};E={};
    a=1; %counter for MouseList COND
    
    
    i=1;
    Mousename='MXXX';
    for man=1:length(Dir.path) 
        
        Mousename=['M' Dir.name{man}(end-2:end)];
        MouseListC{a}=Mousename;
        a=a+1;
        
        cd ([Dir.path{man}])
        load ('behavResources.mat', 'Movtsd','TTL')

        DiffTimes=diff(TTL(:,1));
        ind=DiffTimes>2;
        times=TTL(:,1);
        event=TTL(:,2);
        CStimes=times([1; find(ind)+1]);  %temps du premier TTL de chaque s�rie de son
        CSevent=event([1; find(ind)+1]);  %valeur du premier TTL de chaque s�rie de son (CS+ ou CS-)

        %d�finir CS+ et CS- selon les groupes
        m=Mousename(2:4);
       if sum(strcmp(num2str(m),CSplu_bip_Gp))==1
            CSpluCode=4; %bip
            CSminCode=3; %White Noise
        elseif sum(strcmp(num2str(m),CSplu_WN_Gp))==1
            CSpluCode=3;
            CSminCode=4;
        end


        csp=CStimes(CSevent==CSpluCode);
        csm=CStimes(CSevent==CSminCode);
%         [m2,s2,t2]=mETAverage(csp(1:2:11)*1E4,Range(Movtsd),Data(Movtsd),bi,lim);% un son sur 2 laser 0FF (en commencant par OFF)
%         [m3,s3,t3]=mETAverage(csp(2:2:12)*1E4,Range(Movtsd),Data(Movtsd),bi,lim);% un son sur 2 laser ON 
        [m2,s2,t2]=mETAverage(csp(1:2:3)*1E4,Range(Movtsd),Data(Movtsd),bi,lim);% un son sur 2 laser 0FF (en commencant par OFF)
        [m3,s3,t3]=mETAverage(csp(2:2:4)*1E4,Range(Movtsd),Data(Movtsd),bi,lim);% un son sur 2 laser ON 
        [m1,s1,t1]=mETAverage(csm([2 4])*1E4,Range(Movtsd),Data(Movtsd),bi,lim);
        [m0,s0,t0]=mETAverage(csm([1 3])*1E4,Range(Movtsd),Data(Movtsd),bi,lim);
        if ~isempty(strfind(Dir.path{man}, StepName{2})) % EXT-24
            C2=[C2,m2];
            C3=[C3,m3];
            C1=[C1,m1];
            C0=[C0,m0];
            
            C{i}.m2=m2;C{i}.s2=s2;C{i}.t2=t2;
            C{i}.m1=m1;C{i}.s1=s1;C{i}.t1=t1;
            C{i}.m3=m3;C{i}.s3=s3;C{i}.t3=t3;
            C{i}.m0=m0;C{i}.s0=s0;C{i}.t0=t0;
            
        elseif ~isempty(strfind(Dir.path{man}, StepName{3})) % EXT-48

            P2=[P2,m2];
            P3=[P3,m3];
            P1=[P1,m1];
            P0=[P0,m0];

            P{i}.m2=m2;P{i}.s2=s2;P{i}.t2=t2;
            P{i}.m1=m1;P{i}.s1=s1;P{i}.t1=t1;
            P{i}.m3=m3;P{i}.s3=s3;P{i}.t3=t3;
            P{i}.m0=m0;P{i}.s0=s0;P{i}.t0=t0;
            
        elseif ~isempty(strfind(Dir.path{man}, StepName{4})) % EXT-72
            E2=[E2,m2];
            E3=[E3,m3];
            E1=[E1,m1];
            E0=[E0,m0];

            E{i}.m2=m2;E{i}.s2=s2;E{i}.t2=t2;
            E{i}.m1=m1;E{i}.s1=s1;E{i}.t1=t1;
            E{i}.m3=m3;E{i}.s3=s3;E{i}.t3=t3;
            E{i}.m0=m0;E{i}.s0=s0;E{i}.t0=t0;
           
        end

        if man<length(Dir.path)
            if strcmp(Dir.name{man+1}(end-2:end),Dir.name{man}(end-2:end))% same mouse, following recording
            else
                i=i+1;
            end
        end
    end
    
    cd(res)
    disp(['Saving data in local path' ]);
    save ([res '/Spectro_ChR2/PSTH_behav_' manipname  ],'C','P','E', 'C0','C1','C2', 'C3','P0','P1','P2','P3','E1','E2','E3','csm','csp','CStimes','CSevent','times','event','MouseListC','TTL','StepName','ColorPSTH')

end % end of catch


%% PLOT DATA
Mousename='MXXX';
if plo
    for i=1:length(nameMice), allfig(i)=figure('Color',[1 1 1],'Position', [305          63        1552         891]);end
    i=1;
    for man=1:length(Dir.path) 
        ind_mark=strfind(Dir.path{man},'/');
        figure(allfig(i))

        Mousename=['M' Dir.name{man}(end-2:end)];
        MouseListC{a}=Mousename;
        a=a+1;
        if ~isempty(strfind(Dir.path{man}, StepName{2})) % EXT-24
            u=subplot(3,2,1);hold on
            v=subplot(3,2,2);hold on
            m2=C{i}.m2;s2=C{i}.s2;t2=C{i}.t2;
            m1=C{i}.m1;s1=C{i}.s1;t1=C{i}.t1;
            m3=C{i}.m3;s3=C{i}.s3;t3=C{i}.t3;
            m0=C{i}.m0;s0=C{i}.s0;t0=C{i}.t0;
            
        elseif ~isempty(strfind(Dir.path{man}, StepName{3})) % EXT-48
            u=subplot(3,2,3);hold on
            v=subplot(3,2,4);hold on
            m2=P{i}.m2;s2=P{i}.s2;t2=P{i}.t2;
            m1=P{i}.m1;s1=P{i}.s1;t1=P{i}.t1;
            m3=P{i}.m3;s3=P{i}.s3;t3=P{i}.t3;
            m0=P{i}.m0;s0=P{i}.s0;t0=P{i}.t0;
            
        elseif ~isempty(strfind(Dir.path{man}, StepName{4})) % EXT-72
            u=subplot(3,2,5);hold on
            v=subplot(3,2,6);hold on
            
            m2=E{i}.m2;s2=E{i}.s2;t2=E{i}.t2;
            m1=E{i}.m1;s1=E{i}.s1;t1=E{i}.t1;
            m3=E{i}.m3;s3=E{i}.s3;t3=E{i}.t3;
            m0=E{i}.m0;s0=E{i}.s0;t0=E{i}.t0;
           
        end
            % CS-
            subplot(u)
            H=shadedErrorBar(t0/1E3,SmoothDec(m0,smo),SmoothDec(s0/sqrt(6),smo),{'Color',ColorPSTH{4},'Linewidth',2},1);% CS- un son sur 2 laser 0FF (en commencant par OFF)
            H=shadedErrorBar(t1/1E3,SmoothDec(m1,smo),SmoothDec(s1/sqrt(2),smo),{'Color',ColorPSTH{1},'Linewidth',2},1);% CS- un son sur 2 laser ON 
            set(get(get(H.mainLine,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            set(get(get(H.patch,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            set(get(get(H.edge(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            set(get(get(H.edge(2),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            yl=ylim;
            line([0 0],yl,'color',[0.7 0.7 0.7])
            ylim([0 20])
            title(Dir.path{man}(ind_mark(end-1):end))
            
            % CS+
            subplot(v)
            H=shadedErrorBar(t2/1E3,SmoothDec(m2,smo),SmoothDec(s2/sqrt(2),smo),{'Color',ColorPSTH{2},'Linewidth',2},1);% CS+ un son sur 2 laser 0FF (en commencant par OFF)
            H=shadedErrorBar(t3/1E3,SmoothDec(m3,smo),SmoothDec(s3/sqrt(6),smo),{'Color',ColorPSTH{3},'Linewidth',2},1);% CS+  un son sur 2 laser ON 
            set(get(get(H.mainLine,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            set(get(get(H.patch,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            set(get(get(H.edge(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            set(get(get(H.edge(2),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            
            
            yl=ylim;
            line([0 0],yl,'color',[0.7 0.7 0.7])
            ylim([0 20])
            title(Dir.path{man}(ind_mark(end-1):end))
            
            
%             H=shadedErrorBar(t0/1E3,SmoothDec(m0,smo),SmoothDec(s0/sqrt(6),smo),{'Color',ColorPSTH{4},'Linewidth',2},1);
%             H=shadedErrorBar(t1/1E3,SmoothDec(m1,smo),SmoothDec(s1/sqrt(2),smo),{'Color',ColorPSTH{1},'Linewidth',2},1);
%             
%             H=shadedErrorBar(t2/1E3,SmoothDec(m2,smo),SmoothDec(s2/sqrt(2),smo),{'Color',ColorPSTH{2},'Linewidth',2},1);
%             H=shadedErrorBar(t3/1E3,SmoothDec(m3,smo),SmoothDec(s3/sqrt(6),smo),{'Color',ColorPSTH{3},'Linewidth',2},1);
           


        if man<length(Dir.path)
            if strcmp(Dir.name{man+1}(end-2:end),Dir.name{man}(end-2:end))% same mouse, following recording
            else
                i=i+1;
            end
        end
        

    end
    cd(res)
    if sav 
        for i=1:length(nameMice), 
            saveas(allfig(i), ['Spectro_ChR2/' nameMice{i} '_PSTH_4firstCS+.fig'])
            set(allfig(i),'PaperPosition',[0 0 12 20])
            saveas(allfig(i), ['Spectro_ChR2/' nameMice{i} '_PSTH_4firstCS+.png'])
        end
    end

end

%% Sort matrices to correspond to  BULBECTOMY (1:7) and SHAM (7:14)
if strcmp(manipname,'ManipDec14Bulbectomie')
    
    % BULBECTOMY (1:7) and SHAM (8:14)
     MouseListC_sorted=MouseListC(:,[[1:4] [8:10] [11:14] [5:7]]);
    C2=C2(:,[[1:4] [8:10] [11:14] [5:7]]);% first CS+
    E2=E2(:,[[1:4] [8:10] [11:14] [5:7]]);
    P2=P2(:,[[1:4] [8:10] [11:14] [5:7]]);

    C3=C3(:,[[1:4] [8:10] [11:14] [5:7]]);% last CS+
    E3=E3(:,[[1:4] [8:10] [11:14] [5:7]]);
    P3=P3(:,[[1:4] [8:10] [11:14] [5:7]]);

    C1=C1(:,[[1:4] [8:10] [11:14] [5:7]]);% CS-
    E1=E1(:,[[1:4] [8:10] [11:14] [5:7]]);
    P1=P1(:,[[1:4] [8:10] [11:14] [5:7]]);

elseif strcmp(manipname,'ManipFeb15Bulbectomie')||strcmp(manipname,'ManipNov15Bulbectomie')
     [B,IX]=sort([sham; bulb]);
     [A,IX2]=sort(IX);
     MouseListC_sorted=MouseListC(:,IX2');
     
     ind_sham=IX2(1:size(sham,1));
     ind_bulb=IX2(size(sham,1)+1:end);
     C2_sort=C2(:,IX2');% first CS+
    E2_sort=E2(:,IX2');
    P2_sort=P2(:,IX2');

    C3_sort=C3(:,IX2');% last CS+
    E3_sort=E3(:,IX2');
    P3_sort=P3(:,IX2');

    C1_sort=C1(:,IX2');% CS-
    E1_sort=E1(:,IX2');
    P1_sort=P1(:,IX2');
end

% Figure BILAN
if ~isdir([ FolderPath manipname '/BilanFreezing'])
        mkdir([ FolderPath manipname '/BilanFreezing']);
end

cd ([ FolderPath manipname '/BilanFreezing'])
save BulbectomiePSTHdata.mat C2 E2 P2 C3 E3 P3 C1 E1 P1 smo lim bi

PlotPSTHmatrix(t2,t3,t1,C2_sort,P2_sort,E2_sort,C3_sort,P3_sort,E3_sort,C1_sort,P1_sort,E1_sort,MouseListC_sorted,StepName,0,1) % PSTH
PlotPSTHmatrix(t2,t3,t1,C2_sort,P2_sort,E2_sort,C3_sort,P3_sort,E3_sort,C1_sort,P1_sort,E1_sort,MouseListC_sorted,StepName,1,1) % zscore PSTH


% %%%%%%%%%%%%%%%%%%%%%%%%%%% AVERAGE PSTH by group Bulb/Sham
% plot by group
figure('Color',  [1 1 1])
set(gcf, 'Position',[ 8  91  1819 887]);
% first CS+
subplot(3,3,1), PlotAveragePSTHmatrix(C2,'r',StepName{2}, 'cs+ (1-4)',sav,StepName,ind_sham,ind_bulb)
hleg=legend('bulb');set(hleg, 'Location','NorthWest')
subplot(3,3,2), PlotAveragePSTHmatrix(P2,'r',StepName{3},'cs+ (1-4)',sav,StepName,ind_sham,ind_bulb)
subplot(3,3,3), PlotAveragePSTHmatrix(E2,'r',StepName{4},'cs+ (1-4)',sav,StepName,ind_sham,ind_bulb)
% last CS+
%colorLastCSp=[0.7 0.2 0];
colorLastCSp=[0 0 1];
subplot(3,3,4), PlotAveragePSTHmatrix(C3,colorLastCSp,StepName{2},'cs+ (end)',sav,StepName,ind_sham,ind_bulb) % rouge fonc�
hleg=legend('bulb');set(hleg, 'Location','NorthWest')
subplot(3,3,5), PlotAveragePSTHmatrix(P3,colorLastCSp,StepName{3},'cs+ (end)',sav,StepName,ind_sham,ind_bulb)
subplot(3,3,6), PlotAveragePSTHmatrix(E3,colorLastCSp,StepName{4},'cs+ (end)',sav,StepName,ind_sham,ind_bulb)
% CS-
colorCSm=[0 0.5 0]; % vert fonc�
subplot(3,3,7), PlotAveragePSTHmatrix(C1,colorCSm,StepName{2},'cs-',sav,StepName,ind_sham,ind_bulb)
hleg=legend('bulb');set(hleg, 'Location','NorthWest')
subplot(3,3,8), PlotAveragePSTHmatrix(P1,colorCSm,StepName{3},'cs-',sav,StepName,ind_sham,ind_bulb)
subplot(3,3,9), PlotAveragePSTHmatrix(E1,colorCSm,StepName{4},'cs-',sav,StepName,ind_sham,ind_bulb)

  
%%%%%% PSTH : comparison PRE/ DURING sound
figure('Color',  [1 1 1])
set(gcf, 'Position',[ 8  91  1819 887]);
PreSound=[35:49]; % 15sec before sound
Sound=[51:80]; % 15sec before sound
subplot(3,3,1),BarPlotPrePost(C2,PreSound,Sound,ind_sham,ind_bulb), title([StepName{2} ' Pre -15 0   Post  0  30']), ylabel('cs+ (1-4)'), %xlabel('Pre -15 0   Post  0  30'),
subplot(3,3,2),BarPlotPrePost(P2,PreSound,Sound,ind_sham,ind_bulb),title(StepName{3})
subplot(3,3,3),BarPlotPrePost(E2,PreSound,Sound,ind_sham,ind_bulb),title(StepName{4})

subplot(3,3,4),BarPlotPrePost(C3,PreSound,Sound,ind_sham,ind_bulb),ylabel('cs+ (5-end)')
subplot(3,3,5),BarPlotPrePost(P3,PreSound,Sound,ind_sham,ind_bulb)
subplot(3,3,6),BarPlotPrePost(E3,PreSound,Sound,ind_sham,ind_bulb)

subplot(3,3,7),BarPlotPrePost(C1,PreSound,Sound,ind_sham,ind_bulb),ylabel('cs-'),
subplot(3,3,8),BarPlotPrePost(P1,PreSound,Sound,ind_sham,ind_bulb)
subplot(3,3,9),BarPlotPrePost(E1,PreSound,Sound,ind_sham,ind_bulb)
%set(gca, 'XTick', [1 2 3 4 ],'XTickLabel', {'sham Pre', 'sham Post', 'bulb Pre', 'bulb Post'} )
if sav
    set(gcf,'PaperPosition', [1 1 28 21])
    saveas (gcf, 'MvtPrePostSound.fig')
    saveas (gcf, 'MvtPrePostSound.png')
end


% 
% function BarPlotPrePost(matrix, PreSound, Sound,ind_sham,ind_bulb)
%     PlotErrorbar4(nanmean(matrix(PreSound,ind_sham))',nanmean(matrix(Sound,ind_sham))',nanmean(matrix(PreSound,ind_bulb))',nanmean(matrix(Sound,ind_bulb))',0,2)
%     
%     [p_sham,h]=ranksum(nanmean(matrix(PreSound,ind_sham))',nanmean(matrix(Sound,ind_sham))');
%     max=YLim;
%     if p_sham<0.05
%         colorp='r';
%     else
%         colorp='k';
%     end
%     text(2,0.9*max(2),sprintf('%.2f',(p_sham)),'Color',colorp)
%     [p_bulb,h]=ranksum(nanmean(matrix(PreSound,ind_bulb))',nanmean(matrix(Sound,ind_bulb))');
%     if p_bulb<0.05
%         colorp='r';
%     else
%         colorp='k';
%     end
%     text(4,0.9*max(2),sprintf('%.2f',(p_bulb)),'Color',colorp) 
%     set(gca, 'XTick', [1 2 3 4 ],'XTickLabel', {'sham Pre', 'sham Post', 'bulb Pre', 'bulb Post'} )
%     %set(gca, 'XTick', [])
% end
% 
% function PlotAveragePSTHmatrix(matrix, color,plottitle, yaxistitle,sav,StepName,ind_sham,ind_bulb)
%     shadedErrorBar([-50:50],nanmean((matrix(:,ind_bulb')'))',stdError((matrix(:,ind_bulb')')), {'Color', color},1), hold on;
%     shadedErrorBar([-50:50],nanmean((matrix(:,ind_sham')'))',stdError((matrix(:,ind_sham')')),'-k',1);
% %     % be careful, now the matrices are sorted: first sham, then bulb
% %     shadedErrorBar([-50:50],nanmean((matrix(:,size(sham,1)+1:end)'))',stdError((matrix(:,size(sham,1)+1:end)')), {'Color', color},1), hold on;
% %     shadedErrorBar([-50:50],nanmean((matrix(:,1:size(sham,1))'))',stdError((matrix(:,1:size(sham,1))')),'-k',1);
% %         shadedErrorBar([-50:50],nanmean((matrix(:,1:7)'))',nanstd((matrix(:,1:7)')), {'Color', color},1), hold on;
% %         shadedErrorBar([-50:50],nanmean((matrix(:,8:14)'))',nanstd((matrix(:,8:14)')),'-k',1);
%     ylabel(yaxistitle)
%     title(plottitle)
%     xlim([-50 50])
%     if strcmp(plottitle, StepName{2})
%         ylim([0 20])
%     elseif strcmp(plottitle, 'EXTpleth')
%         ylim([0 10])
%     elseif strcmp(plottitle, StepName{4})
%         ylim([0 20])
%     else 
%         ylim([0 20])
%     end
%     
%     if sav
%         set(gcf,'PaperPosition', [1 1 28 21])
%         saveas (gcf, 'PSTHaveraged.fig')
%         saveas (gcf, 'PSTHaveraged.png')
%     end
% end
% 
% 
