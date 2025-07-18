
%% MANUAL INPUTS

%experiment='FearMLavr2015'; 
experiment='ManipFeb15Bulbectomie'; 

freezeTh=1; % freezing threshold
smo = 1; %smoothing
lim=100; % nb bins
bi=1000; % bin size
sav =1;
plo = 0;

    

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%  INITIATE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ANALYNAME=['/media/DataMOBsRAID/ProjetAstro/',experiment];
if sav && ~exist(ANALYNAME,'dir'), mkdir(ANALYNAME);end
if sav && ~exist([ANALYNAME,'/BilanFigure'],'dir'),mkdir([ANALYNAME,'/BilanFigure']);end

Dir=PathForExperimentFEAR(experiment);
[nameSession, m, n] = unique(Dir.Session);
for i=1:length(nameSession), sesstemp(i)=sum(find(n==i));end
[nn,xn]=sort(sesstemp);
nameSession=nameSession(xn);

nameMice=unique(Dir.name);
nameGroups=unique(Dir.group);
nameGroups=[nameGroups(~strcmp(nameGroups,'CTRL')),nameGroups(strcmp(nameGroups,'CTRL'))];
nameSounds={'CS-','CS+ (1-4)', 'CS+ (5-end)'};
InfoTitle={'ngroup','nMouse','nSession','nSound'}';

ColorPSTH={ 'k','r','b'};% [1 0.5 0]


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%  PERI-SOUND mETAverage  %%%%%%%%%%%%%%%%%%%%

disp(' '); disp('... PERI-SOUND mETAverage')

try
    load([ANALYNAME,'/Analysis.mat']);
    Mat; InfoMat;
    disp(['Using existing Mat from ',ANALYNAME]); 
    if sav, disp('command ''save'' is discarded for existing data protection'); sav=0;end
    
catch
    InfoMat=[];
    Mat=[];
    for mi=1:length(nameMice)
        
        indMan=find(strcmp(Dir.name,nameMice{mi}));
        
        if plo, hFigIndiv=figure('Color',[1 1 1],'Position', [1000 80 560 900]);end
        ok=0;
        
        for man=indMan
            try
                temp=load([Dir.path{man},'/Behavior.mat']);
                StimInfo=temp.StimInfo;
                Movtsd=temp.Movtsd;
                csp=StimInfo(StimInfo(:,2)==7,1); % times of CS+
                csm=StimInfo(StimInfo(:,2)==5,1); % times of CS-
                
                % compute PSTH
                [m1,s1,t1]=mETAverage(csm*1E4,Range(Movtsd),Data(Movtsd),bi,lim); % CS-
                [m2,s2,t2]=mETAverage(csp(1:4)*1E4,Range(Movtsd),Data(Movtsd),bi,lim); % 4 first CS+
                [m3,s3,t3]=mETAverage(csp(5:end)*1E4,Range(Movtsd),Data(Movtsd),bi,lim); % last CS+
                
                if plo
                    subplot(length(nameSession),1,find(strcmp(Dir.Session{man},nameSession)));
                    hold on,
                    % ------------------------------------------
                    %PlotPSTH(lim, bi, smo, m2,s2,t2,m3,s3,t3,m1,s1,t1,cd,1,ColorPSTH)
                    plot(t1/1E3,SmoothDec(m1,smo),ColorPSTH{1},'linewidth',2), % CS-
                    plot(t2/1E3,SmoothDec(m2,smo),ColorPSTH{2},'linewidth',2) % 4 first CS+
                    plot(t3/1E3,SmoothDec(m3,smo),'Color',ColorPSTH{3},'linewidth',2), % last CS+
                    
                    % with sem
                    % CS-
                    plot(t1/1E3,SmoothDec(m1+s1/sqrt(length(csm)),smo),ColorPSTH{1},'linewidth',1),
                    plot(t1/1E3,SmoothDec(m1-s1/sqrt(length(csm)),smo),ColorPSTH{1},'linewidth',1),
                    % first CS+
                    plot(t2/1E3,SmoothDec(m2+s2/sqrt(4),smo),ColorPSTH{2},'linewidth',1)
                    plot(t2/1E3,SmoothDec(m2-s2/sqrt(4),smo),ColorPSTH{2},'linewidth',1)
                    % last CS+
                    plot(t3/1E3,SmoothDec(m3+s3/sqrt(length(csp(5:end))),smo),'Color', ColorPSTH{3},'linewidth',1),
                    plot(t3/1E3,SmoothDec(m3-s3/sqrt(length(csp(5:end))),smo),'Color',ColorPSTH{3},'linewidth',1),
                    
                    legend(nameSounds, 'Location', 'NorthWest');
                    yl=ylim;line([0 0],yl,'color',[0.7 0.7 0.7])
                    title([Dir.group{man},' ',Dir.name{man},' - ',Dir.Session{man}]);
                    
                    if strcmp(Dir.Session{man}(1:4),'COND')
                        ylim([0 40])
                    elseif ~isempty(strfind(Dir.Session{man},'pleth'))
                        ylim([0 10])
                    elseif ~isempty(strfind(Dir.Session{man},'envC')) || ~isempty(strfind(Dir.Session{man},'envB'))
                        ylim([0 20])
                    end
                end
                ok=1;
                
                InfoMat=[InfoMat,[ [find(strcmp(Dir.group{man},nameGroups)),str2num(Dir.name{man}(6:8)),...
                    find(strcmp(Dir.Session{man},nameSession))]'*ones(1,3);  1:3]];
                Mat=[Mat,m1,m2,m3];
                
            catch
                disp(['PROBLEM : ',Dir.path{man},' is undefined'])
            end
        end
        
        if plo && ok==0, 
            close(hFigIndiv);
        elseif plo && ok && sav 
            saveFigure(hFigIndiv,[nameMice{mi},'_PSTH'],[ANALYNAME,'/BilanFigure']);
        end
       
    end
    if sav,
        disp(['saving in ',ANALYNAME,'/Analysis.mat']);
        save([ANALYNAME,'/Analysis.mat'],'Mat','InfoMat','Dir','nameSession','nameMice',...
            'nameGroups','nameSounds','InfoTitle','t1','t2','t3');
    end
    disp('Done')
end

    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%  POOL MICE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tempMat=Mat;
tempInfoMat=InfoMat;

% find groups and sort 
[temp,Gg] = sort(InfoMat(1,:));
InfoMat=InfoMat(:,Gg);
Mat=Mat(:,Gg);
savMat=Mat;
nameM=[]; for i=1:length(InfoMat(2,:)), if ~sum(strcmp(['M',num2str(InfoMat(2,i))],nameM)), nameM=[nameM,{['M',num2str(InfoMat(2,i))]}]; end;end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%  PlotPSTHmatrix  %%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' '); disp('... PlotPSTHmatrix')
for i=1:2
    % InfoTitle={'ngroup','nMouse','nSession','nSound'};
    % ------------------------------------------
    % get right session and do zscore
    for ss=1:length(nameSession)
        for dd=1:length(nameSounds)
            temp=find(InfoMat(3,:)==ss & InfoMat(4,:)==dd);
            if i==2
                Mat(:,temp)=zscore(Mat(:,temp));
                PSTHtext='PSTHzscores';
            else
                PSTHtext='PSTH';
            end
            ind{ss,dd}=temp;
        end
    end

    % ------------------------------------------
    % PlotPSTHmatrix
    figure('color',[1 1 1], 'Position',[ 8  91  1819 887],'PaperPosition',[ 0  0 27 18]),
    
    for ss=1:length(nameSession)
        for dd=1:length(nameSounds)
            
            eval(['t=t',num2str(dd),';'])
            temp=Mat(:,ind{ss,dd});
            
            subplot(length(nameSounds),length(nameSession),length(nameSession)*(dd-1)+ss),
            
            imagesc(t/1E3,[1:size(temp,2)],temp'),
            hold on, line([0 0],[0.5 size(temp,2)+0.5],'color',[0.7 0.7 0.7])
            line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
            set(gca, 'YTick',[1:length(nameMice)],'YTickLabel', nameM)
            
            title(nameSession{ss})
            if ss==1, ylabel(nameSounds{dd});text(-80, -2,PSTHtext, 'FontSize', 20); end
            
        end
    end
    if sav, saveFigure(gcf,['Bilan_',PSTHtext],[ANALYNAME,'/BilanFigure']);end
end
Mat=savMat;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%  AVERAGE PSTH by group  %%%%%%%%%%%%%%%%%%%%%%%%%
disp(' '); disp('... AVERAGE PSTH by group')
% plot by group
figure('Color',  [1 1 1], 'Position',[ 8  91  1819 887])
colori=[0 0.5 0 ; 1 0 0 ; 0 0 1];

for ss=1:length(nameSession)
    for dd=1:length(nameSounds)
        
        subplot(length(nameSounds),length(nameSession),length(nameSession)*(dd-1)+ss),
        hold on, leg=[];
        
        for gg=1:length(nameGroups)
            ind=find(InfoMat(1,:)==gg & InfoMat(3,:)==ss & InfoMat(4,:)==dd);
            leg=[leg,{[ nameGroups{gg},' (n=',num2str(length(unique(InfoMat(2,ind)))),')']}];
            if strcmp(nameGroups{gg},'CTRL')
                shadedErrorBar([-50:50],nanmean(Mat(:,ind),2)',stdError((Mat(:,ind)')), '-k',1);
            else
                shadedErrorBar([-50:50],nanmean(Mat(:,ind),2)',stdError((Mat(:,ind)')), {'Color', colori(dd,:)},1);
            end
        end
        
        if ss==1, legend(leg, 'Location','NorthWest');end
        ylabel(nameSounds{dd},'Color', colori(dd,:))
        title(nameSession{ss})
        xlim([-50 50]);
        if strcmp(nameSession{ss}, 'EXTpleth')
            ylim([0 10]);
        else
            ylim([0 20]);
        end
        
    end
end
if sav, saveFigure(gcf,'BilanGroup_AveragePSTH',[ANALYNAME,'/BilanFigure']);end



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  PSTH : comparison PRE/ DURING sound  %%%%%%%%%%%%%%%

if length(nameGroups)>1
    figure('Color',  [1 1 1], 'Position',[ 8  91  1819 887]);
    PreSound=[35:49]; % 15sec before sound
    Sound=[51:80]; % 15sec before sound
    
    for ss=1:length(nameSession)
        for dd=1:length(nameSounds)
            leg=[];
            ind_sham=find(InfoMat(1,:)==length(nameGroups) & InfoMat(3,:)==ss & InfoMat(4,:)==dd);
            ind_bulb=find(InfoMat(1,:)==1 & InfoMat(3,:)==ss & InfoMat(4,:)==dd);
            
            subplot(length(nameSounds),length(nameSession),length(nameSession)*(dd-1)+ss),
            
            PlotErrorbar4(nanmean(Mat(PreSound,ind_sham))',nanmean(Mat(Sound,ind_sham))',...
                nanmean(Mat(PreSound,ind_bulb))',nanmean(Mat(Sound,ind_bulb))',0,2)
            
            % difference conditions
            [p_sham,h]=ranksum(nanmean(Mat(PreSound,ind_sham))',nanmean(Mat(Sound,ind_sham))');
            ylim([0 20]);
            max=ylim;
            if p_sham<0.05
                colorp='r';
            else
                colorp='k';
            end
            text(2,0.9*max(2),sprintf('%.2f',(p_sham)),'Color',colorp)
            
            [p_bulb,h]=ranksum(nanmean(Mat(PreSound,ind_bulb))',nanmean(Mat(Sound,ind_bulb))');
            if p_bulb<0.05
                colorp='r';
            else
                colorp='k';
            end
            text(4,0.9*max(2),sprintf('%.2f',(p_bulb)),'Color',colorp)
            set(gca, 'XTick', [1 2 3 4 ],'XTickLabel', {'Pre', 'Post', 'Pre', 'Post'} )
            ylabel(nameSounds{dd},'Color',colori(dd,:))
            if ~isempty(strfind(nameSession{ss},'COND')), title('COND  Pre:[-15,0] Post:[0,30]s peri-sound'); else,  title(nameSession{ss});end
            
            text(1.2,-2,nameGroups{1},'Color',colori(dd,:), 'FontSize', 20)
            text(3.2,-2,nameGroups{length(nameGroups)},'Color',colori(dd,:), 'FontSize', 20)
        end
    end
    if sav, saveFigure(gcf,'BilanGroup_PrePostSound',[ANALYNAME,'/BilanFigure']);end
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%  PSTH : comparison PRE/ DURING sound  %%%%%%%%%%%%%%%




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%  AnalysisManipBulbectomy %%%%%%%%%%%%%%%%%%%%%%%%%% 


