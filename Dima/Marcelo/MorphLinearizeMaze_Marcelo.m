function MorphLinearizeMaze_Marcelo(dirin, varargin)
%
% This function morphs Umaze to the unified 0-1 coordinates and
% linearizes trajectories from 0 (shock zone) to 1 (safe zone)
%
% INPUT
%
%     nMice                     which mice do you wnat to transfer
% 
%     OPTIONAL:
% 
%     ReDoFlag   (boolean)      do you want skip if already done, or redo
%                               (default - false)
%
%  OUTPUT
%
%     It saves new variables in beahvResources.mat
%
% Coded by Dima Bryzgalov, MOBS team, Paris, France
% 16/06/2020
% github.com/bryzgalovdm

%% Default values of optional arguments
redo = false;

%% Optional parameters handling
for i=1:2:length(varargin)
    
    switch(lower(varargin{i}))
        
        case 'ReDo'
            redo = varargin{i+1};
            if length(redo)>1
                error('Incorrect value for property ''ReDo'' (type ''help MorphLinearizeMaze_DB'' for details).');
            end
            
    end
end


%% Build directories to transform

Dir = dir(dirin);

%% Main loop
% Morph first
for i = 3:length(Dir)
    MorphMaze(Dir(i).name, redo);
end
% % Then linearize
% for i = 3:length(Dir)
%     LinearizeMaze(Dir(i).name, redo);
% end

end




%% Auxiliary functions

% Morph maze
function MorphMaze(directory, redo)
load([directory '/cleanbehavResources.mat']);


if ~exist('CleanAlignedXtsd','var')
    [CleanAlignedXtsd,CleanAlignedYtsd,CleanZoneEpochAligned,CleanXYOutput] = MorphMazeToSingleShape_EmbReact_DB...
        (CleanXtsd,CleanYtsd, Zone{1}, ref, Ratio_IMAonREAL);
    
    save([directory '/cleanbehavResources.mat'], 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned',...
        'CleanXYOutput',  '-append');
else
    if redo
        [CleanAlignedXtsd,CleanAlignedYtsd,CleanZoneEpochAligned,CleanXYOutput] = MorphMazeToSingleShape_EmbReact_DB...
            (CleanXtsd,CleanYtsd, Zone{1}, ref, Ratio_IMAonREAL);
        
        save([directory '/cleanbehavResources.mat'], 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned',...
            'CleanXYOutput',  '-append');
    end
end
close all

end

% Linearize maze
function LinearizeMaze(directory, redo)

load([directory '/behavResources.mat']);

if ~exist('CleanLinearDist','var')
    
    figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);
    
    
    imagesc(mask+Zone{1})
    curvexy=ginput(4);
    clf
    
    xxx = Data(CleanYtsd)';
    yyy = Data(CleanXtsd)';
    mapxy=[Data(CleanYtsd)'; Data(CleanXtsd)']';
    [xy,distance,t] = distance2curve(curvexy,mapxy*Ratio_IMAonREAL,'linear');
    
    t(isnan(xxx))=NaN;
    
    subplot(211)
    imagesc(mask+Zone{1})
    hold on
    plot(Data(CleanYtsd)'*Ratio_IMAonREAL,Data(CleanXtsd)'*Ratio_IMAonREAL)
    subplot(212)
    plot(t), ylim([0 1])
    
    saveas(gcf,[directory 'Cleanlineartraj.fig']);
    saveFigure(gcf,'Cleanlineartraj', directory);
    close(gcf);
    
    CleanLinearDist=tsd(Range(CleanXtsd),t);
    
    save([directory 'behavResources.mat'], 'CleanLinearDist','-append');
else
    if redo
        figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);
        
        
        imagesc(mask+Zone{1})
        curvexy=ginput(4);
        clf
        
        xxx = Data(CleanYtsd)';
        yyy = Data(CleanXtsd)';
        mapxy=[Data(CleanYtsd)'; Data(CleanXtsd)']';
        [xy,distance,t] = distance2curve(curvexy,mapxy*Ratio_IMAonREAL,'linear');
        
        t(isnan(xxx))=NaN;
        
        subplot(211)
        imagesc(mask+Zone{1})
        hold on
        plot(Data(CleanYtsd)'*Ratio_IMAonREAL,Data(CleanXtsd)'*Ratio_IMAonREAL)
        subplot(212)
        plot(t), ylim([0 1])
        
        saveas(gcf,[directory 'Cleanlineartraj.fig']);
        saveFigure(gcf,'Cleanlineartraj', directory);
        close(gcf);
        
        CleanLinearDist=tsd(Range(CleanXtsd),t);
        
        save([directory 'behavResources.mat'], 'CleanLinearDist','-append');
    end
end

end