

StartTimeOK = 0;
PauseDuration = 0.01;

stats = regionprops(mask, 'Area');
tempmask=mask;
AimArea=stats.Area*0.81;
ActArea=stats.Area;
while AimArea<ActArea
    tempmask=imerode(tempmask,strel('disk',1));
    stats = regionprops(tempmask, 'Area');
    ActArea=stats.Area;
end
new_mask=bwboundaries(tempmask);
new_mask{1}=new_mask{1}./Ratio_IMAonREAL;

plot(new_mask{1}(:,2),new_mask{1}(:,1),'LineWidth',2)

while StartTimeOK == 0 

    traj = figure;
    hold on
    xlim([0 60])
    ylim([0 50])
    a=[]; 
    
    plot(new_mask{1}(:,2),new_mask{1}(:,1),'k','LineWidth',2)
    
    for i=200:600
        delete(a)
        plot(PosMatInit(1:i,2),PosMatInit(1:i,3),'r')
        a=text(30,45,[num2str(TimePosMFB(i,1)) ' s'],'fontweight','bold','fontsize',12);
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
            distances = sum((PosMatInit(1:600,[2,3])-[[x_init y_init]]).^2,2);
            IndiceStartTracking = find(distances==min(distances));

            traj = figure;
            hold on
            xlim([0 60])
            ylim([0 50])
            a=[]; 

            plot(new_mask{1}(:,2),new_mask{1}(:,1),'k','LineWidth',2)

            for i=IndiceStartTracking:600
                delete(a)
                plot(PosMatInit(IndiceStartTracking:i,2),PosMatInit(IndiceStartTracking:i,3),'r')
                a=text(30,45,[num2str(TimePosMFB(i,1)) ' s'],'fontweight','bold','fontsize',12);
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