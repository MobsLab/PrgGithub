%==========================================================================
% Details: Output behavioral data from the First exploration of UMaze
%
% INPUTS:
%       - None
%
% OUTPUT:
%       - figures including:
%           - Trajectories
%           - Heatmaps
%           - Speed per sections
%
% NOTES:
%
%   Written by Dmitri Bryzgalov and was based on the code by Samuel Laventure - 27-02-2019
%       edited SL - 20-11-2019
%==========================================================================

clear all

%#####################################################################
%#
%#                   P A R A M E T E R S
%#
%#####################################################################

% ---------- HARDCODED -----------
% bootsrapping options
    bts=1;      %bootstrap: 1 = yes; 0 = no
    draws=50;   %nbr of draws for the bts
    rnd=0;      %test against a random sampling of pre-post maps

% stats correction 
    alpha=.001; % p-value seeked for significance
        % only one must be chosen
        %----------
        fdr_corr=0;
        bonfholm=0;
        bonf=1;
        %----------
    corr = {'uncorr','fdr','bonfholm','bonf'};

%----------- SAVING PARAMETERS ----------
% Outputs
    dirout = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Behavior/';
    if ~exist(dirout, 'dir')
        mkdir(dirout);
    end
    sav=0;      % Do you want to save a figure? Y=1; N=0

%     %-- Current folder
%     [parentFolder deepestFolder] = fileparts(pwd);
% 
%     %-- Folder with data
%     dataPath = [parentFolder '/eeglab_files/' datype '/'];


Dir = PathForExperimentsERC_Dima('HabBehav');

nmice = length(Dir.path); % Nbr of mouse
ntest = 1; % Nbr of trials per test
nsess = 6; % Nbr of sesion
sect_order = [4,3,5,1,0,2];  %order of U-maze section creation
sect_name = {'Left corner', 'Center middle', 'Right corner', 'Left arm', '', 'Right arm'};

%-------------- MAP PARAMETERS -----------
freqVideo=15;       %frame rate
smo=2;            %smoothing factor
sizeMap=50;         %Map size

%------------- FIGURE PARAMETERS -------------
clrs = {'ko', 'bo', 'ro','go', 'co', 'mo'; 'w','y', 'r', 'g', 'c', 'm'; 'kp', 'bp', 'rp', 'gp', 'cp', 'mp'};
xsub = 4; % Tiling of the subplot
ysub = 4; % Tiling of the subplot


%#####################################################################
%#
%#                           M A I N
%#
%#####################################################################

%GET DATA
for imice=1:nmice
    dat{imice} = load([Dir.path{imice}{1} 'behavResources.mat'], ...
        'Occup', 'Xtsd', 'Ytsd', 'AlignedXtsd', 'AlignedYtsd', 'Vtsd',...
        'ZoneIndices', 'Zone','PosMat', 'Ratio_IMAonREAL');
    
    % GET OCCUPANCY
    [occH, x1, x2] = hist2(Data(dat{imice}.Xtsd), Data(dat{imice}.Ytsd), 240, 320);
    occHS(imice,1:320,1:240) = SmoothDec(occH/freqVideo,[smo,smo]);
    x(imice,1:240)=x1;
    y(imice,1:320)=x2;
    for isect=1:5
        occup(imice,isect) = dat{imice}.Occup(1,isect);
        
        % Get speed
        tmpV = Data(dat{imice}.Vtsd);
        Speedz = tmpV(dat{imice}.ZoneIndices{isect}(1:end-1));
        SpeedZm(imice,isect) = squeeze(mean(Speedz));
    end %loop u-mze sections
end % loop nb mice

%% INDIVIDUAL FIGURES

% FIGURE 1 - Trajectories and heatmap per mouse
supertit = ['First exploration of the UMaze by all mice'];
figure('Color',[1 1 1], 'rend','painters','pos',[10 10 1400 700],'Name', supertit, 'NumberTitle','off')

for l=1:imice
    % Trajectories superposed on heatmaps
    subplot(xsub,ysub,l),
    
    box off
    
    % -- heatmap
    % --- set x and y vector data for image
    xx=squeeze(x(l,:));
    yi=permute(y,[2,1]);
    yy=yi(:,l);
    % --- image
    imagesc(xx,yy,squeeze(occHS(l,:,:)))
    caxis([0 .1]) % control color intensity here
    colormap(hot)
    hold on
    % -- trajectories
    p1 = plot((dat{l}.PosMat(:,3)),(dat{l}.PosMat(:,2)),...
        'w', 'linewidth',.05)  ;
    p1.Color(4) = .3;    %control line color intensity here
    hold on
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    
    title(Dir.name{l})
end

% Supertitle
mtit(supertit, 'fontsize',14, 'xoff', 0, 'yoff', 0.03);

% script name at bottom
AddScriptName

if sav
    saveas(f1,[dirout 'FirstUMaze_Trajectories_byMouse.fig']);
    saveFigure(f1,'FirstUMaze_Trajectories_byMouse', dirout);
end

%% GROUP STATISTICS AND FIGURES

% Make heatmap on morphed data
% GET OCCUPANCY
for imice=1:nmice
    [occH_av, x1_av, x2_av] = hist2(Data(dat{imice}.AlignedXtsd), Data(dat{imice}.AlignedYtsd), 240, 320);
    occHS_av(imice,1:320,1:240) = SmoothDec(occH_av/freqVideo,[smo,smo]);
    x_av(imice,1:240)=x1_av;
    y_av(imice,1:320)=x2_av;
end

occHm = squeeze(mean(occHS_av(:,:,:)));
mocc=squeeze(mean(occup(:,:)));
Speedavg = squeeze(nanmean(SpeedZm(:,:)));


% FIGURE 2 - Trajectories and heatmap averaged
supertit = 'Averaged occupancy heatmaps - First UMaze';
f2 = figure('Color',[1 1 1], 'rend','painters','pos',[10 10 1400 700],'Name', supertit, 'NumberTitle','off')

% Trajectories superposed on heatmaps
box off

%heatmap
imagesc(x1_av,x2_av,occHm(:,:))
caxis([0 .1]);
colormap(hot)

hold on
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);

% Supertitle
mtit(supertit, 'fontsize',14, 'xoff', 0, 'yoff', 0.03);

% script name at bottom
AddScriptName

if sav
    saveas (f2,[dirout 'FirstUMaze_Trajectories.fig']);
    saveFigure (f2,'FirstUMaze_Trajectories', dirout);
end


% FIGURE 3 - Occupancy % per section - AVERAGE
supertit = 'Percentage of occupancy by section of U-Maze';
f3 = figure('Color',[1 1 1], 'rend','painters','pos',[10 10 1400 700],'Name',supertit, 'NumberTitle','off')
si = 0;
PlotErrorBarN_DB(occup, 'barcolors', [0.3 0.266 0.613], 'newfig', 0);
ylim([0 0.35])
set(gca,'Xtick',[1:1:6]);
xlabel('Sessions number');
ylabel('% time spent in zone');

% Supertitle
mtit(supertit, 'fontsize',14, 'xoff', 0, 'yoff', 0.03);

% script name at bottom
AddScriptName

%save
if sav
    saveas (f3,[dirout 'FirstUMaze_Occup_all.fig']);
    saveFigure (f3,'FirstUMaze_Occup_all', dirout);
end

% FIGURE 4 - Speed per section
supertit = ['Average speed by section of U-Maze'];
f4 = figure('Color',[1 1 1], 'rend','painters','pos',[10 10 1400 700],'Name',supertit, 'NumberTitle','off')
PlotErrorBarN_DB(SpeedZm, 'barcolors', [0.3 0.266 0.613], 'newfig', 0);
ylim([0 12])
set(gca,'Xtick',[1:1:6]);
xlabel('Sessions number');
ylabel('cm/sec');

% Supertitle
mtit(supertit, 'fontsize',14, 'xoff', 0, 'yoff', 0.03);

% script name at bottom
AddScriptName

%save
if sav
    saveas (f4,[dirout 'FirstUMaze_Speed_all.fig']);
    saveFigure (f4,'FirstUMaze_Speed_all', dirout);
end



