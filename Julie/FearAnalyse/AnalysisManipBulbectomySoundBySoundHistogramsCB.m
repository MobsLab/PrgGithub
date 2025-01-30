function AnalysisManipBulbectomySoundBySoundHistogramsCB(datalocation,manipname,freezeTh,varargin)

% Clara Dec 15

% Similar to AnalysisManipBulbectomySoundBySoundCB. Modif to get histograms of freezing intervals
% similar to AnalysisManipBulbectomyCB modif to compute freezing for each sound
% similar to AnalysisManipBulbectomy. Modif to deal with ManipNov15Bulbectomie

% INPUTS
% datalocation : 'server' ou 'manip' ou 'server_windows'
% manipname : 'ManipDec14Bulbectomie' or 'ManipFeb15Bulbectomie'
% freezeTh : threshold for freezing. usually =1 -> savedata as BulbAllMiceBilan_1.mat and ShamAllMiceBilan_1.mat (1: freezeTh)%
% indivfig, groupfig : switch to produce or not individual and groupfigures
% columntest : specifies the period to wiwh data are compared in ranksum test (1: no sound period, 2: CS- period) default =2
% displayed hab phase : 'envA', 'envB', 'pleth' or 'envC' for individual figures
% period : can be  'fullperiod' or 'soundonly'  for the freezing quantification

% OUTPUTS
% data : BulbAllMiceBilan_1.mat and ShamAllMiceBilan_1.mat
% individual figure : M207FigBilan_1.5.fig
% group figure :
% - with individual histogram (at 24h and 48h) : BulbAllMiceAverageL_1.5.png/ ShamAllMiceAverageL_1.5.png
% - only the average (at 24h and 48h)  : BulbAverage_1.5.png/ShamAverage_1.5.png        

% default values
ColTest=2; 
%hab='envB';
hab='grille';
period='fullperiod';
gpfg=1;
indifg=1;
sav=0;

 for i = 1:2:length(varargin),

      switch(lower(varargin{i})),

        case 'indivfig',
          indifg= varargin{i+1};
          if ~isa(indifg,'numeric'),
            error('Incorrect value for property ''figure'' ');
          end   

        case 'groupfig',
            gpfg= varargin{i+1};
            if ~isa(gpfg,'numeric'),
            error('Incorrect value for property ''figure'' ');
            end

        case 'save',
          sav = varargin{i+1};
          
        case 'columntest',
              ColTest= varargin{i+1}; % 1: compare no No sound period / 2 compare to CS- period
              
        case 'dorespi',
              dorespi= varargin{i+1};
              
        case 'displayed hab phase', % should be 'envA', 'envB', 'pleth' or 'envC'
          hab= varargin{i+1};
          
        case 'period', % should be fullperiod or soundonly
          period= varargin{i+1};
      end
 end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define the filenames for each step and each mouse
[FileInfo, FolderPath]=DefinePath(manipname, datalocation,'fear');

IntervalNameIfExtinction={'noSoundPer', 'CS-', 'CS+1', 'CS+2', 'CS+3'};

StepName{1}=['HAB ' hab];
StepName{2}='COND';
if strcmp(manipname,'ManipDec14Bulbectomie')
    StepName{3}='EXT pleth';
elseif strcmp(manipname,'ManipFeb15Bulbectomie')
    StepName{3}='EXT envC';
elseif strcmp(manipname,'ManipNov15Bulbectomie')
    StepName{3}='EXT envC';
end
StepName{4}='EXT envB';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% colours for plotting 
StimCols(1,:)=[0 1 0]; % CS- in green
StimCols(2,:)=[1 0.5 0]; % CS+ in orange
StimCols(3,:)=[1 0 0]; % shock in red


if strcmp(manipname,'ManipDec14Bulbectomie')
    shammice=[211;212;213;217;218;219;220];
    bulbmice=[207;208;209;210;214;215;216];
elseif strcmp(manipname,'ManipFeb15Bulbectomie')
    shammice=[223;224;225;227;229;233;235;237;239];
    bulbmice=[222;226;228;232;234;236;238;240];
%         shammice=[231];
%     bulbmice=[230];
elseif strcmp(manipname,'ManipNov15Bulbectomie')
    shammice=[280:290]';
    bulbmice=[269:279]';
end



% Define groups for CS+ CS-
% group CS+=bip
CSplu_bip_GpNb=[270:274, 280:284];
for k=1:length(CSplu_bip_GpNb)
    CSplu_bip_Gp{k}=num2str(CSplu_bip_GpNb(k));
end
CSplu_bip_Gp=CSplu_bip_Gp';

% group CS+=WN
CSplu_WN_GpNb=[275:279,285:289,290,269];
for k=1:length(CSplu_WN_GpNb)
    CSplu_WN_Gp{k}=num2str(CSplu_WN_GpNb(k));
end
CSplu_WN_Gp=CSplu_WN_Gp';


NbOfMicePerGp=[size(shammice,1) size(bulbmice,1)];
CStimesNb=[8;16;16;16];
expgroup={shammice,bulbmice};
groupname={'sham','bulb'};

%%%%%%%%%
if gpfg
    %bilanFig=figure;
    groupFig=figure;
    %set(bilanFig,'color',[1 1 1],'Position',[1 1 600 1000])
end
for  g=1:2
    group=expgroup{g};
   

    for mousenb=1:length(group)
        m=group(mousenb);
        if indifg
            mouseindifg=figure;
            set(mouseindifg,'color',[1 1 1],'Position',[1 1 1000 1000])
        end
        
        for step=1:4
                cd(FileInfo{step,m})
                load('Behavior.mat')
                

                    Ep=thresholdIntervals(Movtsd,freezeTh,'Direction','Below');
                    Ep=mergeCloseIntervals(Ep,0.3*1E4);
                    Ep=dropShortIntervals(Ep,2*1E4);
                    
                    durFr=Stop(Ep)-Start(Ep);
                    
                    subplot(4,2,step)
                    [Y,X]=hist(durFr,[0:1E4:1E6]);
                    Y=Y/sum(Y);%normalize
                    plot(X,Y)
                    xlim([0 1E6])
                    ylim([0 20])
                    
                    if g==1
                        bilan_sham{step,mousenb}(1,:)=durFr;
                        %bilan_sham{step,mousenb}(2,:)=Start(Ep);
                    elseif g==2
                        bilan_bulb{step,mousenb}(1,:)=durFr;
                        %bilan_bulb{step,mousenb}(2,:)=Start(Ep);
                    end

        cd ..
        cd([FolderPath manipname])

        end

    end
    
    % Hist all mice
    if gpfg
        figure(groupFig)
        set(groupFig,'color',[1 1 1],'Position',[81 324 560 420])
        for step=1:4
            subplot(2,2,step)
            if g==1
                allShamFr=[];
                for iii=1:length(shammice)
                    allShamFr=[allShamFr bilan_sham{step,iii}];
                end
                [Y,X]=hist(allShamFr,[0:1E4:1E6]);
 %               titre='AllSham';
            elseif g==2                
                allBulbFr=[];
                for iii=1:length(bulbmice)
                    allBulbFr=[allBulbFr bilan_bulb{step,iii}];
                end
                [Y,X]=hist(allBulbFr,[0:1E4:1E6]);
 %               titre='AllBulb';
            end
            Y=Y/sum(Y); %normalize
            histo{g}=plot(X,Y), hold on;
            xlim([0 2*1E5])
            ylim([0 0.5])
            title(StepName{step})
        end
%        text(-1,1.05, titre, 'FontSize', 15)
        if sav==1
         saveFigure(groupFig, [titre],FolderPath)
        end

    end

end
legend(histo{g},groupname{g});

bilan=[bilan_bulb bilan_sham];
save([groupname{g} 'AllMiceBilan_' num2str(freezeTh) '_' hab '.mat'],  'bilan', 'bilan_bulb', 'bilan_sham', 'freezeTh', 'StepName', 'groupname', 'hab','ColTest','period', 'IntervalNameIfExtinction', 'shammice', 'bulbmice')


end
