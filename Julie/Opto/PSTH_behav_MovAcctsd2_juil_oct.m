% PSTH_behav_MovAcctsd2_dec16_2

% 04.01.2017 from PSTH_behav_MovAcctsd2
% deals with data from manip fear opto dec 16 : 465 466 467 468 

% similar to PSTH_behav_Movtsd, but plot 
% - either all CS +, averaged_2_by_2
% - or the first 4 CS +, no averaged

% OUTPUTS
% a figure for each mouse of PSTH (averaged CS-, first CS+, last CS+) ->  BulbectomiePSTHdata.mat
% a matrix for all mice of PSTH (averaged CS-, first CS+, last CS+) color coded)
% the average of these matrices by group (sham/ bulb)
% the compartison of Pre/Post sound period by group 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  OPTIONS   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% for all CS +, averaged_2_by_2
CSoption = 'AllCS avg2by2';
disp ('CSoption = AllCS avg2by2')

% %%% for first 4 CS +, no averaged
% CSoption = '4firstCS not averaged';
% disp ('CSoption = 4firstCS not averaged')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  INPUTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

experiment= 'Fear-electrophy-opto';
manipname='LaserChR2-fear';


%cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/
cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/367-363-458-459
res=pwd;
Dir=PathForExperimentFEAR('Fear-electrophy-opto');
Dir = RestrictPathForExperiment(Dir,'nMice',[363 367 458 459]);
%Dir = RestrictPathForExperiment(Dir,'nMice',[465 466 467 468]);ww

% Dir = RestrictPathForExperiment(Dir,'Session','EXT');
% StepName={'EXT-24';'EXT-48';'EXT-72'};
Dir = RestrictPathForExperiment(Dir,'Session',{'HAB-envC';'HAB-envB';'EXT-24'});
StepName={'HAB-envC';'HAB-envB';'EXT-24'};

[nameMice, IXnameMice]=unique(Dir.name);
% re-order Dir with Mice order (required for next loop)
[Dir.name, nameMice_indices]=sort(Dir.name);
Dir.path=Dir.path(nameMice_indices);
Dir.manipe=Dir.manipe(nameMice_indices);
Dir.Session=Dir.Session(nameMice_indices);
Dir.group=Dir.group(nameMice_indices);% same info, but just in case
Dir.Treatment=Dir.Treatment(nameMice_indices);% same info, but just in case
 
lim=160; % nb bins
bi=1000; % bin size
smo=1;
plo=1;
sav=1;

FolderPath='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/';

ColorPSTH={ [0.7 0.7 1],[1 0 0],[0 0 1],[1 0.7 0.7]};% [1 0.5 0]

% group CS+=bip
%CSplu_bip_GpNb=[];
CSplu_bip_GpNb=[467 468];
CSplu_bip_Gp={};
for k=1:length(CSplu_bip_GpNb)
    CSplu_bip_Gp{k}=num2str(CSplu_bip_GpNb(k));
end
CSplu_bip_Gp=CSplu_bip_Gp';

% group CS+=WN
CSplu_WN_GpNb=[363 367 458 459 465 466];
%CSplu_WN_GpNb=[465 466];
CSplu_WN_Gp={};
for k=1:length(CSplu_WN_GpNb)
    CSplu_WN_Gp{k}=num2str(CSplu_WN_GpNb(k));
end
CSplu_WN_Gp=CSplu_WN_Gp';

Mx={'C','P','E'};
    
%% GET DATA TO PLOT
try
    load(['MovAcctsdPSTH_ChR2/PSTH_behav_' manipname ]);
    disp(['Loading existing data from PSTH_behav_' manipname '.mat']);
    [B,IX] = sort(Dir.group);
    Dir.path=Dir.path(IX);
    Dir.name=Dir.name(IX);
    Dir.manipe=Dir.manipe(IX);
    Dir.group=B;
    Dir.Session=Dir.Session(IX);
    [nameMice, IXnameMice]=unique(Dir.name);

catch

    % Matrix of data; mice in lines
    for k=0:7
        eval(['C' num2str(k) '=[];']);% EXT24
        eval(['P' num2str(k) '=[];']);% EXT-48
        eval(['E' num2str(k) '=[];']);% EXT-72
    end
    C={};P={};E={};
    a=1; %counter for MouseList COND
    
    i=1;
    Mousename='MXXX';
    for man=1:length(Dir.path) 
        Dir.path{man}
        Mousename=['M' Dir.name{man}(end-2:end)];
        MouseListC{a}=Mousename;
        disp(Mousename)
        a=a+1;
        
        cd ([Dir.path{man}])
        if ~isempty(strfind(Dir.path{man},'Mouse363/20160714-HAB-envC-laser4')) ||~isempty(strfind(Dir.path{man},'Mouse-363/20160714-HAB-envC-laser4'))
            % use Movtsd because pb intan -> accelero data not available for a long period
            load ('behavResources.mat', 'Movtsd','TTL')
            MovAcctsd=tsd(Range(Movtsd)-4*1E4,Data(Movtsd)*1E7);
            disp('for Mouse363/20160714-HAB-envC-laser4 use of Movtsd because large noise on MovAcctsd')
        else
            load ('behavResources.mat', 'MovAcctsd','TTL')
        end

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
        save behavResources csp csm -Append

        if isempty(strfind(Dir.path{man}, 'HABgrille')) % EXT-24
            
            if strcmp(CSoption, 'AllCS avg2by2')
                try
                [m0,s0,t0]=mETAverage(csm([1 3])*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);
                [m1,s1,t1]=mETAverage(csm([2 4])*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);
                [m2,s2,t2]=mETAverage(csp([1 3])*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);% un son sur 2 laser 0FF (en commencant par OFF)
                [m3,s3,t3]=mETAverage(csp([2 4])*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);% un son sur 2 laser ON 

                [m4,s4,t4]=mETAverage(csp(5:2:7)*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);% un son sur 2 laser 0FF (en commencant par OFF)
                [m5,s5,t5]=mETAverage(csp(6:2:8)*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);% un son sur 2 laser ON 
                [m6,s6,t6]=mETAverage(csp(9:2:11)*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);% un son sur 2 laser 0FF (en commencant par OFF)
                [m7,s7,t7]=mETAverage(csp(10:2:12)*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);% un son sur 2 laser ON 

                catch
                    if strcmp(Dir.path{man},'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161019-EXT-24h-laser10') % experiment interrupted by error
                        [m0,s0,t0]=mETAverage(csm([1 3])*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);
                        [m1,s1,t1]=mETAverage(csm([2 4])*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);
                        [m2,s2,t2]=mETAverage(csp(1)*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);% un son sur 2 laser 0FF (en commencant par OFF)
                        [m3,s3,t3]=mETAverage(csp(2)*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);% un son sur 2 laser ON     
                        m4=nan(size(m2)); s4=nan(size(s2)); t4=t2;
                        m5=nan(size(m2)); s5=nan(size(s2)); t5=t2;
                        m6=nan(size(m2)); s6=nan(size(s2)); t6=t2;
                        m7=nan(size(m2)); s7=nan(size(s2)); t7=t2;
                    else
                        keyboard
                    end
                end   

            elseif strcmp(CSoption, '4firstCS not averaged')
                try
                    [m0,s0,t0]=mETAverage(csm(1)*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);
                    [m1,s1,t1]=mETAverage(csm(2)*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);
                    [m2,s2,t2]=mETAverage(csm(3)*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);
                    [m3,s3,t3]=mETAverage(csm(4)*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);

                    [m4,s4,t4]=mETAverage(csp(1)*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);% un son sur 2 laser 0FF (en commencant par OFF)
                    [m5,s5,t5]=mETAverage(csp(2)*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);% un son sur 2 laser ON 
                    [m6,s6,t6]=mETAverage(csp(3)*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);% un son sur 2 laser 0FF (en commencant par OFF)
                    [m7,s7,t7]=mETAverage(csp(4)*1E4,Range(MovAcctsd),Data(MovAcctsd),bi,lim);% un son sur 2 laser 0FF (en commencant par OFF)
                catch
                    if strcmp(Dir.path{man},'/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161019-EXT-24h-laser10')
                        m6=nan(size(m2)); s6=nan(size(s2)); t6=t2;
                        m7=nan(size(m2)); s7=nan(size(s2)); t7=t2;
                    end
                end
            end
            
        end

        if ~isempty(strfind(Dir.path{man}, StepName{1})) % EXT-24
            disp(StepName{1})
             for k=0:7
                 eval(['C' num2str(k) '=[C' num2str(k) ',m' num2str(k) '];']);
                 eval(['C{i}.m' num2str(k) '=m' num2str(k) ';C{i}.s' num2str(k) '=s' num2str(k) ';C{i}.t' num2str(k) '=t' num2str(k) ';']);
             end
            
        elseif ~isempty(strfind(Dir.path{man}, StepName{2})) % EXT-48
            disp(StepName{2})
            for k=0:7
                eval(['P' num2str(k) '=[P' num2str(k) ',m' num2str(k) '];']);
                eval(['P{i}.m' num2str(k) '=m' num2str(k) ';P{i}.s' num2str(k) '=s' num2str(k) ';P{i}.t' num2str(k) '=t' num2str(k) ';']);
            end

        elseif ~isempty(strfind(Dir.path{man}, StepName{3})) % EXT-72
            disp(StepName{3})
            for k=0:7
                eval(['E' num2str(k) '=[E' num2str(k) ',m' num2str(k) '];']);
                eval(['E{i}.m' num2str(k) '=m' num2str(k) ';E{i}.s' num2str(k) '=s' num2str(k) ';E{i}.t' num2str(k) '=t' num2str(k) ';']);
            end
            
        end

        if man<length(Dir.path)
            if strcmp(Dir.name{man+1}(end-2:end),Dir.name{man}(end-2:end))% same mouse, following recording
            else
                i=i+1;
            end
        end
    end
    
    clear m0 s0 t0 m1 s1 t1 m2 s2 t2 m3 s3 t3 m4 s4 t4 m5 s5 t5 m6 s6 t6 m7 s7 t7
    
    cd(res)
    disp(['Saving data in local path' ]);
    if ~isdir([ res '/MovAcctsdPSTH_ChR2'])
        mkdir([ res '/MovAcctsdPSTH_ChR2']);
    end
    save ([res '/MovAcctsdPSTH_ChR2/PSTH_behav_' manipname  ],'C','P','E', 'C0','C1','C2', 'C3','C4','C5','C6','C7','P0','P1','P2','P3','P3','P4','P5','P6','P7','E0','E1','E2','E3','C3','E4','E5','E6','E7',...
        'csm','csp','CStimes','CSevent','times','event','MouseListC','TTL','StepName','ColorPSTH', 'CSoption')

end % end of catch


%% PLOT DATA
Mousename='MXXX';
a=1;
if plo
    for i=1:length(nameMice), allfig(i)=figure('Color',[1 1 1],'Position', [1000 80 560 900]);end
    i=1;
    for man=1:length(Dir.path) 
        ind_mark=strfind(Dir.path{man},'/');
        figure(allfig(i))

        Mousename=['M' Dir.name{man}(end-2:end)];
        MouseListC{a}=Mousename;
        a=a+1;
        if ~isempty(strfind(Dir.path{man}, StepName{1})) % EXT-24if 0
            subplot(3,1,1),hold on
            for k=0:7
                eval(['m' num2str(k) '=C{i}.m' num2str(k) ';s' num2str(k) '=C{i}.s' num2str(k) ';t' num2str(k) '=C{i}.t' num2str(k) ';']);
            end

        elseif ~isempty(strfind(Dir.path{man}, StepName{2})) % EXT-48
            subplot(3,1,2),hold on
            for k=0:7
                eval(['m' num2str(k) '=P{i}.m' num2str(k) ';s' num2str(k) '=P{i}.s' num2str(k) ';t' num2str(k) '=P{i}.t' num2str(k) ';']);
            end
            
        elseif ~isempty(strfind(Dir.path{man}, StepName{3})) % EXT-72
            subplot(3,1,3),hold on
            for k=0:7
                eval(['m' num2str(k) '=E{i}.m' num2str(k) ';s' num2str(k) '=E{i}.s' num2str(k) ';t' num2str(k) '=E{i}.t' num2str(k) ';']);% m0=E{i}.m0;s0=E{i}.s0;t0=E{i}.t0;
            end
        end
             % j'ai un doute sur le n du sqrt. Là j'ai mis le nb de CS (2 CS-ou CS+)
            % mais est-ce que ça ne devrait pas être nbCS*nbmice soit 2*4 ou 1*4 ?
            if strcmp(CSoption, 'AllCS avg2by2')
                NbCS=2;
            elseif strcmp(CSoption, '4firstCS not averaged')
                NbCS=1;
            end
            try
            H=shadedErrorBar(t0/1E3,SmoothDec(m0,smo),SmoothDec(s0/sqrt(NbCS),smo),{'Color',ColorPSTH{4},'Linewidth',2},1);
            H=shadedErrorBar(t1/1E3,SmoothDec(m1,smo),SmoothDec(s1/sqrt(NbCS),smo),{'Color',ColorPSTH{1},'Linewidth',2},1);
            set(get(get(H.mainLine,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            set(get(get(H.patch,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            set(get(get(H.edge(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            set(get(get(H.edge(2),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
            H=shadedErrorBar(t2/1E3,SmoothDec(m2,smo),SmoothDec(s2/sqrt(NbCS),smo),{'Color',ColorPSTH{2},'Linewidth',2},1);
            H=shadedErrorBar(t3/1E3,SmoothDec(m3,smo),SmoothDec(s3/sqrt(NbCS),smo),{'Color',ColorPSTH{3},'Linewidth',2},1);

            H=shadedErrorBar(t4/1E3,SmoothDec(m4,smo),SmoothDec(s4/sqrt(NbCS),smo),{'Color',ColorPSTH{2},'Linewidth',2},1);
            H=shadedErrorBar(t5/1E3,SmoothDec(m5,smo),SmoothDec(s5/sqrt(NbCS),smo),{'Color',ColorPSTH{3},'Linewidth',2},1);
            H=shadedErrorBar(t6/1E3,SmoothDec(m6,smo),SmoothDec(s6/sqrt(NbCS),smo),{'Color',ColorPSTH{2},'Linewidth',2},1);
            H=shadedErrorBar(t7/1E3,SmoothDec(m7,smo),SmoothDec(s7/sqrt(NbCS),smo),{'Color',ColorPSTH{3},'Linewidth',2},1);
            catch
                keyboard
            end

            yl=ylim;
            line([0 0],yl,'color',[0.7 0.7 0.7])
            line([30 30],yl,'color',[0.7 0.7 0.7])
            line([45 45],yl,'color',[0.7 0.7 0.7],'LineStyle','-')
            %ylim([0 20])
            xlim([-30 80])
            title(Dir.path{man}(ind_mark(end-1):end))
            plot([0 45],[20 20],'Color',[0.5 0.5 0.5],'LineStyle','--')
            
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
            saveas(allfig(i), ['MovAcctsdPSTH_ChR2/' nameMice{i} '_PSTH_allCS+.fig'])
            set(allfig(i),'PaperPosition',[0 0 12 20])
            saveas(allfig(i), ['MovAcctsdPSTH_ChR2/' nameMice{i} '_PSTH_allCS+.png'])
        end
    end

end

save PSTHdata.mat C0 E0 P0 C1 E1 P1 C2 E2 P2 C3 E3 P3 C4 E4 P4 C5 E5 P5 C6 E6 P6 C7 E7 P7 smo lim bi CSoption
tsdType='MovAcctsd';
PlotPSTHmatrixChR2_2(t0,t1,t2,t3,t4,t5,t6,t7,C0,P0,E0,C1,P1,E1,C2,P2,E2,C3,P3,E3,C4,E4,P4,C5,E5,P5,C6,E6,P6,C7,E7,P7,unique(MouseListC),StepName,0,1,CSoption,tsdType) % PSTH
PlotPSTHmatrixChR2_2(t0,t1,t2,t3,t4,t5,t6,t7,C0,P0,E0,C1,P1,E1,C2,P2,E2,C3,P3,E3,C4,E4,P4,C5,E5,P5,C6,E6,P6,C7,E7,P7,unique(MouseListC),StepName,1,1,CSoption,tsdType) % zscore PSTH


% %%%%%%%%%%%%%%%%%%%%%%%%%%% AVERAGE PSTH 

if strcmp(CSoption, 'AllCS avg2by2')
    ColorAvgPSTH={ [0.5 0.5 1],[1 0.5 0.5],[0 0 1],[1 0 0],[0 0 1],[1 0 0],[0 0 1],[1 0 0]};% [1 0.5 0]    
    ylabelsPSTH={'CS-';'CS- laser';'CS+';'CS+ laser';'CS+';'CS+ laser';'CS+';'CS+ laser'};
elseif strcmp(CSoption, '4firstCS not averaged')
    ColorAvgPSTH={ [0.5 0.5 1],[1 0.5 0.5],[0.5 0.5 1],[1 0.5 0.5],[0 0 1],[1 0 0],[0 0 1],[1 0 0]};% [1 0.5 0]
    ylabelsPSTH={'CS-';'CS- laser';'CS-';'CS- laser';'CS+';'CS+ laser';'CS+';'CS+ laser'};
end
sav=0;
mean_or_raw='raw';
for i=1:2;
    if i==1
        mean_or_raw='mean'; 
        text2plot='average n=4 mice';
    elseif i==2
        mean_or_raw='raw'; 
        text2plot='individual data';
    end
    PSTHfig{i}=figure('Color',  [1 1 1]);
    set(gcf, 'Position',[ 8  91  1819 887]);
    n=8; p=3; a=1;
    
   for k=0:7
       eval(['SP{a}=subplot(n,p,a); PlotAveragePSTHmatrixChR2(C' num2str(k) ',ColorAvgPSTH{k+1},StepName{1},ylabelsPSTH{k+1},sav,mean_or_raw);a=a+1;']); if k==0; title(StepName{1}); end
       eval(['SP{a}=subplot(n,p,a); PlotAveragePSTHmatrixChR2(P' num2str(k) ',ColorAvgPSTH{k+1},StepName{2},ylabelsPSTH{k+1},sav,mean_or_raw);a=a+1;']); if k==0; title(StepName{2}); end
       eval(['SP{a}=subplot(n,p,a); PlotAveragePSTHmatrixChR2(E' num2str(k) ',ColorAvgPSTH{k+1},StepName{3},ylabelsPSTH{k+1},sav,mean_or_raw);a=a+1;']); if k==0; title(StepName{3}); end
    end
   
    a_final=a-1;
    for aa=1:a_final
        subplot(SP{aa}),
        if strcmp(tsdType,'Movtsd')
            ylim([0 20])
        elseif strcmp(tsdType,'MovAcctsd') && i==1
            ylim([0 1E8])
        elseif strcmp(tsdType,'MovAcctsd') && i==2
            ylim([0 2E8])
        end
    end
    
    subplot(SP{1})
    text(-0.3,1.3,text2plot,'units','normalized')
    text(-0.3,1.5,CSoption,'units','normalized')
    
    set(gcf,'PaperPosition',[ 0  0 27 18])
    if i==1
        saveas(PSTHfig{i},'FigBilanChR2FreezingChR2_AvgPSTHmatrix.fig')
        saveas(PSTHfig{i},'FigBilanChR2FreezingChR2_AvgPSTHmatrix.png')
        
    elseif i==2
        subplot(SP{1}), legend(unique(MouseListC))
        saveas(PSTHfig{i},'FigBilanChR2FreezingChR2_indivPSTHmatrix.fig')
        saveas(PSTHfig{i},'FigBilanChR2FreezingChR2_indivPSTHmatrix.png')
    end
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% PSTH : comparison PRE/ DURING/POST sound %%%%%%%%%%%%%%%%%%%%%%%%%%

load PSTHdata
load MovAcctsdPSTH_ChR2/PSTH_behav_LaserChR2-fear StepName CSoption
PreSound=[65:80]; % 15sec before sound
Sound=[81:95]; % 15sec  
%Sound=[81:110]; % 30sec  
PostSound=[111:125];
SndDur=Sound(end)-Sound(1)+1;

QuantifFig=figure('Color',  [1 1 1], 'Position',[ 8  91  1819 887]);
n=4; p=3; a=1;
Mx={'C','P','E'};
if strcmp(CSoption,'4firstCS not averaged')
    ylabels={'first CS- pair';'second CS- pair';'first CS+ pair';'second CS+ pair'};
elseif strcmp(CSoption,'AllCS avg2by2')
    ylabels={'CS- pairs';' CS+ pairs 1:4';'CS+ pairs 5:8';'CS+ pairs 8:12'};
end

for m=1:3
    for k=0:2:6
        sub{a}=subplot(n,p,3*(k/2)+m);
        eval(['PlotErrorbarN([nanmean(' Mx{m} num2str(k) '(PreSound,:))'',nanmean(C' num2str(k) '(Sound,:))'',nanmean(' Mx{m} num2str(k) '(PostSound,:))'',nanmean(' Mx{m} num2str(k+1) '(PreSound,:))'',nanmean(' Mx{m} num2str(k+1) '(Sound,:))'',nanmean(' Mx{m} num2str(k+1) '(PostSound,:))''],0,2);'])
        eval(['p_off=signrank(nanmean(' Mx{m} num2str(k) '(PreSound,:))'',nanmean(' Mx{m} num2str(k) '(Sound,:))'');']);
        eval(['p_on=signrank(nanmean(' Mx{m} num2str(k+1) '(PreSound,:))'',nanmean(' Mx{m} num2str(k+1) '(Sound,:))'');']);
        eval(['p_snd=signrank(nanmean(' Mx{m} num2str(k) '(Sound,:))'',nanmean(' Mx{m} num2str(k+1) '(Sound,:))'');']);
        eval(['p_post=signrank(nanmean(' Mx{m} num2str(k) '(PostSound,:))'',nanmean(' Mx{m} num2str(k+1) '(PostSound,:))'');']);
        ylim([0 15E7]);
        YL=ylim;
        text(1.5,0.7*YL(2),sprintf('%.2f',(p_off)),'Color','r'), line([1 2],[0.6*YL(2) 0.6*YL(2)],'Color','r');
        text(4.5,0.7*YL(2),sprintf('%.2f',(p_on)),'Color','r'), line([4 5],[0.6*YL(2) 0.6*YL(2)],'Color','r');
        text(3.5,1*YL(2),sprintf('%.2f',(p_snd)),'Color','b'), line([2 5],[0.92*YL(2) 0.92*YL(2)],'Color','b');
        text(4.5,0.87*YL(2),sprintf('%.2f',(p_post)),'Color','b'), line([3 6],[0.8*YL(2) 0.8*YL(2)],'Color','b');

        set(gca,'XTick',[1:6],'XTickLabel',{'Pre','Snd','Post','Pre','Snd','Post'});
        a=a+1;
        if k==0
            title(StepName{m})
        end
        ylabel(ylabels{k/2+1});
    end
end
subplot(sub{1})
text(-0.3,1.3,'MovAcc','units','normalized')
text(-0.3,1.5,CSoption,'units','normalized')
text(-0.3,1.1,['snd ' num2str(SndDur) ' sec'],'units','normalized')

set(gcf,'PaperPosition',[ 0  0 27 18])
res=pwd;
saveas(gcf,['MovAccPrePost_Sound' num2str(SndDur) 'sec_' StepName{1}(1:3) '_' CSoption(1:5) '.fig'])
saveas(gcf,['MovAccPrePost_Sound' num2str(SndDur) 'sec_' StepName{1}(1:3) '_' CSoption(1:5)  '.png'])
saveFigure(QuantifFig,['MovAccPrePost_Sound' num2str(SndDur)  's_' StepName{1}(1:3) '_' CSoption(1:5) ],res)   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    load PSTHdata
    if 0
    % raw evamuation of freezing : threshold accelero data
    th_immob_Acc=0.3E8 ;
        for k=0:7
            eval(['C' num2str(k) '_=+(C' num2str(k) '<' num2str(th_immob_Acc) ')*100;C' num2str(k) '_(isnan(C' num2str(k) '))=nan;C' num2str(k) '=C' num2str(k) '_ ;']);
        end
    end
      
    
if 0
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
end