function [CleanPosMat, CleanXtsd, CleanYtsd, CleanVtsd, CleanMaskBounary] = CleanBeginnningTrajectory_DB(dirin_traj)
%%% CleanTrajectories_DB - creates clean version of a given trajectory
%   The code gets rid of:
%
%   - Mistracking in the beginning (caused usually by sloppy hands of the experimenter)
%   - Non-tracking during the experiment
%   - Mis-tracking caused by reflections from the walls
%
%   Has video-support
%

%% Parameters
try
    dirin_traj;
catch
    dirin_traj = '/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/6-Hab/';
end

cd(dirin_traj)

path_video = dir('**/*.avi');

% The ration between New Mask and original mask areas
FracArea = 0.85;

%% Load the data
load([dirin_traj 'behavResources.mat']);

%% Do the housekeeping

%Controls size and position of the figures
x0=500;
y0=300;
width=1100;
height=600;

StartTimeOK = 0;
PauseDuration = 0.01;
EndOfSample = 500;

%Creates the new mask
stats = regionprops(mask, 'Area');
tempmask=mask;
AimArea=stats.Area*FracArea;
ActArea=stats.Area;
while AimArea<ActArea
    tempmask=imerode(tempmask,strel('disk',1));
    stats = regionprops(tempmask, 'Area');
    ActArea=stats.Area;
end
aux=bwboundaries(tempmask);
new_mask=aux{1}./Ratio_IMAonREAL;

[xmin,xmax] = bounds(new_mask(:,2));
[ymin,ymax] = bounds(new_mask(:,1));

vid = VideoReader([path_video.folder '/' path_video.name]);
frames = read(vid);

%% Start of the trajectory

if isnan(CleanPosMat(1,2)) && sum(isnan(CleanPosMat(1:10,2))) > 7
    %Gets the starting indice for the good tracking from the user
    while StartTimeOK == 0
        
        % figure
        traj = figure('units', 'normalized', 'outerposition', [0.1 0.3 0.8 0.6]);
        hold on
        xlim([xmin-10,xmax+10])
        ylim([ymin-10,ymax+20])
        a=[];
        
        tps=Range(Ytsd,'s');
        tps = tps(GotFrame==1);
        
        for i=100:EndOfSample
            subplot(121)
            if GotFrame(i) == 0
                cla reset
            else
                plot(new_mask(:,2),new_mask(:,1),'k','LineWidth',2)
                text(xmin-2,ymax+5,'Trajectory','fontweight','bold','fontsize',12)
                hold on
                plot(CleanPosMat(1:i,2),CleanPosMat(1:i,3),'r')
                hold off
                a=text(xmax-2,ymax+5,[num2str(PosMatInit(i,1)) ' s'],'fontweight','bold','fontsize',12);
            end
            
            subplot(122)
            IM = squeeze(frames(:,:,:,i));
            IM = IM(:,:,1);
            IM = double(IM)/256;
            imagesc(IM)
            axis xy
            hold on
            title(num2str(tps(i)))
            plot(CleanPosMat(i,2)*Ratio_IMAonREAL,CleanPosMat(i,3)*Ratio_IMAonREAL,'*r','MarkerSize',16);
            hold off
            pause(PauseDuration)
        end
        
        
        answer = questdlg('Can you see where good trackin starts?', ...
            'Clean beginning of trajectories', ...
            'No, slow down','Yes, choose starting point', 'Yes, choose starting point');
        switch answer
            case 'No, slow down'
                PauseDuration = PauseDuration*2;
                close(traj)
            case 'Yes, choose starting point'
                [x_init,y_init] = ginput(1);
                close(traj)
                distances = sum((CleanPosMat(1:EndOfSample,[2,3])-[[x_init y_init]]).^2,2);
                IndiceStartTracking = find(distances==min(distances));
                
                traj = figure;
                set(gcf,'position',[x0,y0,width,height])
                hold on
                xlim([xmin-10,xmax+10])
                ylim([ymin-10,ymax+20])
                a=[];
                
                plot(new_mask(:,2),new_mask(:,1),'k','LineWidth',2)
                
                for i=IndiceStartTracking:EndOfSample
                    delete(a)
                    plot(CleanPosMat(IndiceStartTracking:i,2),CleanPosMat(IndiceStartTracking:i,3),'r')
                    a=text(xmax-5,ymax+10,[num2str(CleanPosMat(i,1)) ' s'],'fontweight','bold','fontsize',12);
                    pause(PauseDuration)
                    
                end
                answer2 = questdlg('Are you satisfied?', ...
                    'Clean beginning of trajectories', ...
                    'Yes','No, restart','No, restart');
                switch answer2
                    case 'Yes'
                        close(traj)
                        StartTimeOK = 1;
                    case 'No, restart'
                        close(traj)
                end
        end
        
    end
end


%Creates the clean version of behavResources.mat variables
if exist('IndiceStartTracking', 'var')
    CleanPosMat(1:IndiceStartTracking-1,2:end) = NaN;
else
    CleanPosMat = CleanPosMat;
end

%% Save the result
CleanXtsd = tsd(Range(Xtsd),CleanPosMat(:,2));
CleanYtsd = tsd(Range(Ytsd),CleanPosMat(:,3));
CleanVtsd=tsd(CleanPosMat(1:end-1,1)*1e4,(sqrt(diff(CleanPosMat(:,2)).^2+diff(CleanPosMat(:,3)).^2)./(diff(CleanPosMat(:,1)))));
CleanMaskBounary = new_mask;

% %Saves the workspace to a new variable cleanBehavResources.mat
% save([dirin_traj '/BehavResources.mat'], 'CleanPosMatInit', 'CleanPosMat', 'CleanXtsd', 'CleanYtsd',...
%     'CleanVtsd', 'CleanMaskBounary');

end

