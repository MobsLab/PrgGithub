clear all
ExperimentFolder = ['/home/vador/Temporary'];
cd(ExperimentFolder)
D2 = dir;
D2 = D2(~ismember({D2.name}, {'.', '..'}));

% The ration between New Mask and original mask areas
FracArea = 0.85;

%Controls size and position of the figures
x0=500;
y0=300;
width=1100;
height=800;


%This loop goes through every subfolder in the experiment folder
for k2 = 1:numel(D2)
    clearvars -except k2 ExperimentFolder D2 FracArea x0 y0 width height EscapeWallShockPAG
    load([ExperimentFolder,'/',D2(k2).name,'/cleanBehavResources.mat']);
    
    StartTimeOK = 0;
    PauseDuration = 0.001;
    EndOfSample = 800;
    
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
    
    aux=bwboundaries(Zone{2});
    shock_mask = aux{1}./Ratio_IMAonREAL;

    
    %Gets the starting indice for the good tracking from the user
    while StartTimeOK == 0 

        traj = figure;
        set(gcf,'position',[x0,y0,width,height])
        hold on
        xlim([xmin-10,xmax+10])
        ylim([ymin-10,ymax+20])
        a=[]; 

        plot(new_mask(:,2),new_mask(:,1),'k','LineWidth',2)
        plot(shock_mask(:,2),shock_mask(:,1),'k','LineWidth',2)
        text(xmin-5,ymax+10,[num2str(k2) ' out of ' num2str(numel(D2)) ' trajectories'],'fontweight','bold','fontsize',12)

        for i=200:EndOfSample
            delete(a)
            plot(CleanPosMatInit(1:i,2),CleanPosMatInit(1:i,3),'r')
            a=text(xmax-5,ymax+10,[num2str(CleanPosMatInit(i,1)) ' s'],'fontweight','bold','fontsize',12);
            pause(PauseDuration)
        end

        answer = questdlg('Can you see where good trackin starts?', ...
            'Clean beginning of trajectories', ...
            'No, replay','No, slow down','Yes, choose starting point','No, replay');
        switch answer
            case 'No, replay'
                close(traj)
            case 'No, slow down'
                PauseDuration = PauseDuration*2;
                close(traj)
            case 'Yes, choose starting point'
                [x_init,y_init] = ginput(1);
                close(traj)
                distances = sum((CleanPosMatInit(1:EndOfSample,[2,3])-[[x_init y_init]]).^2,2);
                IndiceStartTracking = find(distances==min(distances));

                traj = figure;
                set(gcf,'position',[x0,y0,width,height])
                hold on
                xlim([xmin-10,xmax+10])
                ylim([ymin-10,ymax+20])
                a=[]; 

                plot(new_mask(:,2),new_mask(:,1),'k','LineWidth',2)
                plot(shock_mask(:,2),shock_mask(:,1),'k','LineWidth',2)

                for i=IndiceStartTracking:EndOfSample
                    delete(a)
                    plot(CleanPosMatInit(IndiceStartTracking:i,2),CleanPosMatInit(IndiceStartTracking:i,3),'r')
                    a=text(xmax-5,ymax+10,[num2str(CleanPosMatInit(i,1)) ' s'],'fontweight','bold','fontsize',12);
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
    
EscapeWallShockPAG(k2)=CleanPosMatInit(IndiceStartTracking);

EscapeWallShockMFB
EscapeWallSafeMFB
EscapeWallSafePAG

end

