Mouse_names_Nic_Sleep = {'M1500','M1531','M1742','M1743','M1745','M1746','M1747'};

for i = 1:length(Mouse_names_Nic_Sleep)
    
    MouseName = Mouse_names_Nic_Sleep{i};
    MouseNumber = i;
    
    figure
    subplot(667)
    
    durWakePre = sum(Stop(WakeWithNoise.NicotineOFSleep.Pre.(MouseName)) - Start(WakeWithNoise.NicotineOFSleep.Pre.(MouseName)));
    durREMPre  = sum(Stop(REMWithNoise.NicotineOFSleep.Pre.(MouseName))  - Start(REMWithNoise.NicotineOFSleep.Pre.(MouseName)));
    durSWSPre  = sum(Stop(SWSWithNoise.NicotineOFSleep.Pre.(MouseName))  - Start(SWSWithNoise.NicotineOFSleep.Pre.(MouseName)));
    
    dataPre = [durWakePre, durREMPre, durSWSPre];
    labels = {'Wake', 'REM', 'SWS'};
    percentagesPre = 100 * dataPre / sum(dataPre);
    labelsWithPercentPre = strcat(labels, {' - '}, string(round(percentagesPre,1)), {'%'});
    pre = pie(dataPre, labelsWithPercentPre);
    
    
    colors = [0 0 1; 0 1 0;1 0 0 ];
    
    for i = 1:2:length(pre)
        set(pre(i), 'FaceColor', colors((i+1)/2, :))
    end
    
    title('Pre')
    
    subplot(668)
    
    durWakePost = sum(Stop(WakeWithNoise.NicotineOFSleep.Post.(MouseName)) - Start(WakeWithNoise.NicotineOFSleep.Post.(MouseName)));
    durREMPost  = sum(Stop(REMWithNoise.NicotineOFSleep.Post.(MouseName))  - Start(REMWithNoise.NicotineOFSleep.Post.(MouseName)));
    durSWSPost  = sum(Stop(SWSWithNoise.NicotineOFSleep.Post.(MouseName))  - Start(SWSWithNoise.NicotineOFSleep.Post.(MouseName)));
    
    dataPost = [durWakePost, durREMPost, durSWSPost];
    labels = {'Wake', 'REM', 'SWS'};
    percentagesPost = 100 * dataPost / sum(dataPost);
    labelsWithPercentPost = strcat(labels, {' - '}, string(round(percentagesPost,1)), {'%'});
    
    post = pie(dataPost, labelsWithPercentPost);
    
    colors = [0 0 1; 0 1 0;1 0 0 ];
    
    for i = 1:2:length(post)
        set(post(i), 'FaceColor', colors((i+1)/2, :))
    end
    
    title('Post')
    
    subplot(337)
    
    x = categorical({'Pre','Post'});
    x = reordercats(x,{'Pre','Post'});
    vals = [length(Start(WakeWithNoise.NicotineOFSleep.Pre.(MouseName))) ;
        length(Start(WakeWithNoise.NicotineOFSleep.Post.(MouseName)))];
    b = bar(x,vals);
    
    b.FaceColor = 'flat';
    b.CData(1,:) = [1.0 0.6 0.8];
    b.CData(2,:) = [1.0 0.7 0.3];
    
    title('Number of wake episodes');
    
    subplot(334)
     x = categorical({'Pre','Post'});
    x = reordercats(x,{'Pre','Post'});
    vals = [nanmean(DurationEpoch(WakeWithNoise.NicotineOFSleep.Pre.(MouseName),'s')) ;
        nanmean(DurationEpoch(WakeWithNoise.NicotineOFSleep.Post.(MouseName),'s'))];
    b = bar(x,vals);
    
    b.FaceColor = 'flat';
    b.CData(1,:) = [1.0 0.6 0.8];
    b.CData(2,:) = [1.0 0.7 0.3];
    
    title('Mean duration of wake episodes');
    
    
    subplot(338)
    
    first_stop_Pre = Stop(WakeWithNoise.NicotineOFSleep.Pre.(MouseName), 's');
    first_stop_Pre = first_stop_Pre(1);
    first_stop_Post = Stop(WakeWithNoise.NicotineOFSleep.Post.(MouseName), 's');
    first_stop_Post = first_stop_Post(1);
    x = categorical({'Pre','Post'});
    x = reordercats(x,{'Pre','Post'});
    vals = [first_stop_Pre ; first_stop_Post];
    b = bar(x,vals);
    
    b.FaceColor = 'flat';
    b.CData(1,:) = [1.0 0.6 0.8];
    b.CData(2,:) = [1.0 0.7 0.3];
    
    title('Latency to sleep')
    
    % subplot(334)
    %
    % plot(Data(SpeedWake.NicotineOFSleep.Pre.(MouseName), Data(HRWake.NicotineOFSleep.Pre.(MouseName))), 'Color', [1.0 0.6 0.8]);
    % hold on
    % plot(Data(SpeedWake.NicotineOFSleep.Post.(MouseName)), Data(HRWake.NicotineOFSleep.Post.(MouseName))), 'Color', [1.0 0.7 0.3]);
    %
    % xlabel('vitesse')
    % ylabel('HR (Hz)')
    % title('HR en fonction de la vitesse')
    
    subplot(335)
    x = categorical({'SWS','REM'});
    x = reordercats(x,{'SWS','REM'});
    vals = [HRnorm_SWS_mean.NicotineOFSleep(MouseNumber) ;
        HRnorm_REM_mean.NicotineOFSleep(MouseNumber)];
    b = bar(x,vals);
    
    b.FaceColor = 'flat';
    b.CData(1,:) = [1 0 0];
    b.CData(2,:) = [0 1 0];
    
    title('HR normalized by Pre')
    
    mtitle(MouseName);
end