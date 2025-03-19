function FigBILANObsFreez2(datalocation, manipname,varargin)

% 09.12.2015
% similar to FigBILANObsFreez but modif to go into the folder in a cleaner way

% 23.12.2014 aims at giving an overview of the behavioral results of Fear Conditionning(oct-nov2014)

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
 
 
lim=100; % nb bins
bi=1000; % bin size
smo=1;
plo=0;

 for i = 1:2:length(varargin),

              switch(lower(varargin{i})),

                case 'smoothing',
                  smo = varargin{i+1};
                  if ~isa(smo,'numeric'),
                    error('Incorrect value for property ''smoothing'' ');
                  end
                  
                case 'figure',
                  plo = varargin{i+1};
                  if ~isa(plo,'numeric'),
                    error('Incorrect value for property ''figure'' ');
                  end   
  
                case 'save',
                  sav = varargin{i+1};            
                                    
              end
 end



if strcmp(datalocation, 'server')     
    FolderPath='/media/DataMOBsRAID/ProjetAversion/';
elseif strcmp(datalocation, 'DataMOBs14')    
    FolderPath='/media/DataMOBs14/ProjetAversion/';    
elseif strcmp(datalocation, 'manip')    
    FolderPath='C:\Users\Cl�mence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\';
elseif strcmp(datalocation, 'Marie')
    FolderPath='/media/DataMOBsRAID/ProjetAstro'; 
end

%StepName{1}=['HAB' hab];
StepName{2}='COND';
if strcmp(manipname,'ManipDec14Bulbectomie')
    StepName{3}='EXTpleth';
elseif strcmp(manipname,'ManipFeb15Bulbectomie')||strcmp(manipname,'ManipNov15Bulbectomie')
    StepName{3}='EXTenvC';
end
StepName{4}='EXTenvB';

if strcmp(manipname,'ManipDec14Bulbectomie')
    sham=[211;212;213;217;218;219;220];
    bulb=[207;208;209;210;214;215;216];
elseif strcmp(manipname,'ManipFeb15Bulbectomie')
    sham=[223;224;225;227;229;233;235;237;239];
    bulb=[222;226;228;232;234;236;238;240];
elseif strcmp(manipname,'FearMLavr2015')
    sham=245;bulb=246; % attention: les deux sont hemiOBX/hemiocclu
elseif strcmp(manipname,'ManipNov15Bulbectomie')
    sham=[280:290]';
    bulb=[269:279]';
end
NbOfMicePerGp=[size(sham,1) size(bulb,1)];

cd ([FolderPath manipname])
list=dir; %list of mouse folders

ColorPSTH={ 'k','r','b'};% [1 0.5 0]

% Matrix of data; mice in lines
C2=[]; % COND  first CS+    
C3=[];%        last CS+
C1=[]; %       CS-
P2=[]; % PLETH 
P3=[];
P1=[];
E2=[]; % ENV B
E3=[];
E1=[];
a=1; %counter for MouseList COND

for i=1:length(list)
    cd ([FolderPath manipname])
    if list(i).isdir==1&list(i).name(1)~='.'&list(i).name(1)=='M' % if the folder is indeed a mouse name folder
        
        eval(['cd(list(',num2str(i),').name)'])
        
        % store the names of the mice for Y tick labeling
        Mousename=list(i).name;
        MouseListC{a}=Mousename;
        a=a+1;
        if plo
            hFigIndiv=figure('Color',[1 1 1]);
            set(hFigIndiv,'Position', [1000 80 560 900])
        end
        listdir=dir;
        %%%%%%%%%%%%%%%%%%%%%%%%%  COND  %%%%%%%%%%%%%%%%%%%%%%%%%
        % go the the COND folder
        if strcmp(manipname,'ManipDec14Bulbectomie')
            listsubdir=dir;
        elseif strcmp(manipname,'ManipFeb15Bulbectomie')
            cd(listdir(5).name)
            listsubdir=dir;
        end
        
        cond_ind=[];
        for j=1:size(listsubdir,1)
            if ~isempty(strfind(listsubdir(j).name, StepName{2})) % COND
                cond_ind=[cond_ind j];
            end
        end
        
        eval(['cd(listsubdir(' num2str(cond_ind) ').name)'])

        load Behavior.mat
        csp=StimInfo(StimInfo(:,2)==7,1); % times of CS+
        csm=StimInfo(StimInfo(:,2)==5,1); % times of CS-
        
        % compute PSTH
        [m2,s2,t2]=mETAverage(csp(1:4)*1E4,Range(Movtsd),Data(Movtsd),bi,lim); 
        [m3,s3,t3]=mETAverage(csp(5:end)*1E4,Range(Movtsd),Data(Movtsd),bi,lim);
        [m1,s1,t1]=mETAverage(csm*1E4,Range(Movtsd),Data(Movtsd),bi,lim);

        C2=[C2,m2];
        C3=[C3,m3];
        C1=[C1,m1];
        if plo
            subplot(3,1,1);
            PlotPSTH(lim, bi, smo, m2,s2,t2,m3,s3,t3,m1,s1,t1,cd,1,ColorPSTH)
            ylim([0 40])
        end
        cd .. % go backward
        cd ..
        %%%%%%%%%%%%%%%%%%%%%%%%%  PLETH  %%%%%%%%%%%%%%%%%%%%%%%%%
        % go the the EXTpleth folder
        try
            if strcmp(manipname,'ManipDec14Bulbectomie')
                listsubdir=dir;
            elseif strcmp(manipname,'ManipFeb15Bulbectomie')
                cd(listdir(6).name)
                listsubdir=dir;
            end
            
            pleth_ind=[];
            for j=1:size(listsubdir,1)
                if ~isempty(strfind(listsubdir(j).name, StepName{3}))
                    pleth_ind=[pleth_ind j];
                end
            end

            eval(['cd(listsubdir(' num2str(pleth_ind) ').name)'])

            if ((exist('Behavior.mat'))~=0)
                load Behavior.mat
                csp=StimInfo(StimInfo(:,2)==7,1);
                csm=StimInfo(StimInfo(:,2)==5,1);

                [m2,s2,t2]=mETAverage(csp(1:4)*1E4,Range(Movtsd),Data(Movtsd),bi,lim);
                [m3,s3,t3]=mETAverage(csp(5:end)*1E4,Range(Movtsd),Data(Movtsd),bi,lim);
                [m1,s1,t1]=mETAverage(csm*1E4,Range(Movtsd),Data(Movtsd),bi,lim);
            else
                m2=NaN*ones(size((P2),1),1);
                m3=NaN*ones(size((P2),1),1);
                m1=NaN*ones(size((P2),1),1);
            end

            P2=[P2,m2];
            P3=[P3,m3];
            P1=[P1,m1];
            if plo
                subplot(3,1,2);
                PlotPSTH(lim, bi, smo, m2,s2,t2,m3,s3,t3,m1,s1,t1,cd,2,ColorPSTH)
                if strcmp(StepName{3},'EXTpleth')
                    ylim([0 10])
                elseif strcmp(StepName{3},'EXTenvC')
                    ylim([0 20])
                end
            end
        
        end % try pleth
        
        cd ..
        cd ..
        %%%%%%%%%%%%%%%%%%%%%%%%%   ENVT B %%%%%%%%%%%%%%%%%%%%%%%%%  
        % go the the EXTenvB folder
        try
            if strcmp(manipname,'ManipDec14Bulbectomie')
                listsubdir=dir;
            elseif strcmp(manipname,'ManipFeb15Bulbectomie')
                cd(listdir(7).name)
                listsubdir=dir;
            end
            envB_ind=[];
            for j=1:size(listsubdir,1)
                if ~isempty(strfind(listsubdir(j).name, StepName{4})) & isempty(strfind(listsubdir(j).name, 'EXTenvB2'))
                    envB_ind=[envB_ind j];
                end
            end

            eval(['cd(listsubdir(' num2str(envB_ind) ').name)'])
            clear m2
            clear m3
            clear m1

            load Behavior.mat
            csp=StimInfo(StimInfo(:,2)==7,1);
            csm=StimInfo(StimInfo(:,2)==5,1);

            [m2,s2,t2]=mETAverage(csp(1:4)*1E4,Range(Movtsd),Data(Movtsd),bi,lim);
            [m3,s3,t3]=mETAverage(csp(5:end)*1E4,Range(Movtsd),Data(Movtsd),bi,lim);
            [m1,s1,t1]=mETAverage(csm*1E4,Range(Movtsd),Data(Movtsd),bi,lim);

            E2=[E2,m2];
            E3=[E3,m3];
            E1=[E1,m1];
            if plo
                subplot(3,1,3);
                PlotPSTH(lim, bi, smo, m2,s2,t2,m3,s3,t3,m1,s1,t1,cd, 3,ColorPSTH)
                ylim([0 20])
            end
        end % try pleth
        
        cd([FolderPath manipname])
        if sav && plo
            saveas(hFigIndiv, [ Mousename '_PSTH.fig'])
            set(hFigIndiv,'PaperPosition',[0 0 12 20])
            saveas(hFigIndiv, [ Mousename '_PSTH.png'])
        end
    end
       
end
% 
% % Sort matrices to correspond to  BULBECTOMY (1:7) and SHAM (7:14)
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

elseif strcmp(manipname,'ManipFeb15Bulbectomie')
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

end

function BarPlotPrePost(matrix, PreSound, Sound,ind_sham,ind_bulb)
    PlotErrorbar4(nanmean(matrix(PreSound,ind_sham))',nanmean(matrix(Sound,ind_sham))',nanmean(matrix(PreSound,ind_bulb))',nanmean(matrix(Sound,ind_bulb))',0,2)
    
    [p_sham,h]=ranksum(nanmean(matrix(PreSound,ind_sham))',nanmean(matrix(Sound,ind_sham))');
    max=YLim;
    if p_sham<0.05
        colorp='r';
    else
        colorp='k';
    end
    text(2,0.9*max(2),sprintf('%.2f',(p_sham)),'Color',colorp)
    [p_bulb,h]=ranksum(nanmean(matrix(PreSound,ind_bulb))',nanmean(matrix(Sound,ind_bulb))');
    if p_bulb<0.05
        colorp='r';
    else
        colorp='k';
    end
    text(4,0.9*max(2),sprintf('%.2f',(p_bulb)),'Color',colorp) 
    set(gca, 'XTick', [1 2 3 4 ],'XTickLabel', {'sham Pre', 'sham Post', 'bulb Pre', 'bulb Post'} )
    %set(gca, 'XTick', [])
end

function PlotAveragePSTHmatrix(matrix, color,plottitle, yaxistitle,sav,StepName,ind_sham,ind_bulb)
    shadedErrorBar([-50:50],nanmean((matrix(:,ind_bulb')'))',stdError((matrix(:,ind_bulb')')), {'Color', color},1), hold on;
    shadedErrorBar([-50:50],nanmean((matrix(:,ind_sham')'))',stdError((matrix(:,ind_sham')')),'-k',1);
%     % be careful, now the matrices are sorted: first sham, then bulb
%     shadedErrorBar([-50:50],nanmean((matrix(:,size(sham,1)+1:end)'))',stdError((matrix(:,size(sham,1)+1:end)')), {'Color', color},1), hold on;
%     shadedErrorBar([-50:50],nanmean((matrix(:,1:size(sham,1))'))',stdError((matrix(:,1:size(sham,1))')),'-k',1);
%         shadedErrorBar([-50:50],nanmean((matrix(:,1:7)'))',nanstd((matrix(:,1:7)')), {'Color', color},1), hold on;
%         shadedErrorBar([-50:50],nanmean((matrix(:,8:14)'))',nanstd((matrix(:,8:14)')),'-k',1);
    ylabel(yaxistitle)
    title(plottitle)
    xlim([-50 50])
    if strcmp(plottitle, StepName{2})
        ylim([0 20])
    elseif strcmp(plottitle, 'EXTpleth')
        ylim([0 10])
    elseif strcmp(plottitle, StepName{4})
        ylim([0 20])
    else 
        ylim([0 20])
    end
    
    if sav
        set(gcf,'PaperPosition', [1 1 28 21])
        saveas (gcf, 'PSTHaveraged.fig')
        saveas (gcf, 'PSTHaveraged.png')
    end
end


