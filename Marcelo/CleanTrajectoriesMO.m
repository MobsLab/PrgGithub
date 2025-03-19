

ExperimentFolder = ['/media/vador/DataMOBS104/Marcelo/M913/20190702/ReversalControl'];
cd(ExperimentFolder)
D = dir;
D = D(~ismember({D.name}, {'.', '..'}));

% The ration between New Mask and original mask areas
FracArea = 0.85;

%Controls size and position of the figures
x0=500;
y0=300;
width=1100;
height=800;


%This loop goes through every subfolder in the experiment folder
for k = 1:numel(D)
    clearvars -except k ExperimentFolder D FracArea x0 y0 width height
    load([ExperimentFolder,'/',D(k).name,'/behavResources.mat']);
    
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

    
    %Gets the starting indice for the good tracking from the user
    while StartTimeOK == 0 

        traj = figure;
        set(gcf,'position',[x0,y0,width,height])
        hold on
        xlim([xmin-10,xmax+10])
        ylim([ymin-10,ymax+20])
        a=[]; 

        plot(new_mask(:,2),new_mask(:,1),'k','LineWidth',2)
        text(xmin-5,ymax+10,[num2str(k) ' out of ' num2str(numel(D)) ' trajectories'],'fontweight','bold','fontsize',12)

        for i=200:EndOfSample
            delete(a)
            plot(PosMatInit(1:i,2),PosMatInit(1:i,3),'r')
            a=text(xmax-5,ymax+10,[num2str(PosMatInit(i,1)) ' s'],'fontweight','bold','fontsize',12);
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
                distances = sum((PosMatInit(1:EndOfSample,[2,3])-[[x_init y_init]]).^2,2);
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
                    plot(PosMatInit(IndiceStartTracking:i,2),PosMatInit(IndiceStartTracking:i,3),'r')
                    a=text(xmax-5,ymax+10,[num2str(PosMatInit(i,1)) ' s'],'fontweight','bold','fontsize',12);
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
    
    %Creates the clean version of behavResources.mat variables

    CleanPosMatInit = PosMatInit;
    CleanPosMatInit(1:IndiceStartTracking-1,2:end) = NaN;
    CleanXtsd = tsd(Range(Xtsd),CleanPosMatInit(:,2));
    CleanYtsd = tsd(Range(Ytsd),CleanPosMatInit(:,3));
    Vtsd=tsd(CleanPosMatInit(1:end-1,1)*1e4,(sqrt(diff(CleanPosMatInit(:,2)).^2+diff(CleanPosMatInit(:,3)).^2)./(diff(CleanPosMatInit(:,1)))));
    CleanMaskBounary = new_mask;

    %Saves the workspace to a new variable cleanBehavResources.mat
    save([ExperimentFolder,'/',D(k).name,'/cleanBehavResources.mat'])
    

end

