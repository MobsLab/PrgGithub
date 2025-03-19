clear all

%% input dir
Dir_ctrl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
Dir_ctrl=RestrictPathForExperiment(Dir_ctrl,'nMice',[1423 1424 1425 1426 1433 1434 1449 1450 1451 1414 1439 1440 1437]);
DirSocialDefeat_classic1 = PathForExperiments_SD_MC('SleepPostSD');


%% GET DATA - ctrl group (mCherry saline injection 10h without stress)
clear SFI LatencyToState
time_start = 0*3600*1e4; % first hour
time_end = 1*3600*1e4; % first hour
for i=1:length(Dir_ctrl.path)
    cd(Dir_ctrl.path{i}{1});
    clear AlignedXtsd AlignedYtsd
    load('behavResources.mat')
    clf
    plot(Data(Xtsd),Data(Ytsd))
    
    % Get the points and transform
    [x,y]  = ginput(3);
    
    Coord1 = [x(2)-x(1),y(2)-y(1)];
    Coord2 = [x(3)-x(1),y(3)-y(1)];
    TranssMat = [Coord1',Coord2'];
    XInit = Data(Xtsd)-x(1);
    YInit = Data(Ytsd)-y(1);
    
    % The Xtsd and Ytsd in new coordinates
    A = ((pinv(TranssMat)*[XInit,YInit]')');
    AlignedXtsd = tsd(Range(Xtsd),40*A(:,1));
    AlignedYtsd= tsd(Range(Ytsd),20*A(:,2));
    
    
    plot(Data(AlignedXtsd),Data(AlignedYtsd))
    rectangle('Position',[0 0 40 20])
    xlim([-10 50])
    ylim([-10 30])
    axis square
    
    satisfied = input('happy?')
    while satisfied==0
        [x,y]  = ginput(3);
        
        Coord1 = [x(2)-x(1),y(2)-y(1)];
        Coord2 = [x(3)-x(1),y(3)-y(1)];
        TranssMat = [Coord1',Coord2'];
        XInit = Data(AlignedXtsd)-x(1);
        YInit = Data(AlignedYtsd)-y(1);
        
        % The Xtsd and Ytsd in new coordinates
        A = ((pinv(TranssMat)*[XInit,YInit]')');
        AlignedXtsd = tsd(Range(AlignedXtsd),40*A(:,1));
        AlignedYtsd = tsd(Range(AlignedYtsd),20*A(:,2));
        clf
        %
        %             subplot(2,10,(group-1)*10+mouse)
        plot(Data(AlignedXtsd),Data(AlignedYtsd))
        rectangle('Position',[0 0 40 20])
        
        xlim([-10 50])
        ylim([-10 30])
        axis square
        satisfied = input('happy?')
    end
    save('AlignedCagePos.mat', 'AlignedYtsd','AlignedXtsd')
    
end
clear DirSocialDefeat_classic1
DirSocialDefeat_classic1.path{1}{1} = '/media/nas5/Thierry_DATA/M1112/20201228/SocialDefeat/SleepPostSD/SD_1112_SD1_201228_094818/';
DirSocialDefeat_classic1.path{2}{1} ='/media/nas5/Thierry_DATA/M1075_processed/20201228/SocialDefeat/SleepPostSD/SD_1075_SD1_201228_094818/';
DirSocialDefeat_classic1.path{3}{1} ='/media/nas5/Thierry_DATA/M1107/20201228/SocialDefeat/SleepPostSD/SD_1107_SD1_201228_094818/';

%% GET DATA - ctrl group (mCherry saline injection 10h without stress)
clear SFI LatencyToState
time_start = 0*3600*1e4; % first hour
time_end = 1*3600*1e4; % first hour
for i=2:length(DirSocialDefeat_classic1.path)
    cd(DirSocialDefeat_classic1.path{i}{1});
    clear AlignedXtsd AlignedYtsd
    load('behavResources.mat')
    clf
    %     plot(Data(Xtsd),Data(Ytsd))
    imagesc(ref')
    hold on
    % plot(Data(Xtsd)*Ratio_IMAonREAL,Data(Ytsd)*Ratio_IMAonREAL)
    plot(Data(Xtsd)*Ratio_IMAonREAL,Data(Ytsd)*Ratio_IMAonREAL,'w')
    
    % Get the points and transform
    [x,y]  = ginput(3);
    x = x/Ratio_IMAonREAL;
    y = y/Ratio_IMAonREAL;
    
    Coord1 = [x(2)-x(1),y(2)-y(1)];
    Coord2 = [x(3)-x(1),y(3)-y(1)];
    TranssMat = [Coord1',Coord2'];
    XInit = Data(Xtsd)-x(1);
    YInit = Data(Ytsd)-y(1);
    
    % The Xtsd and Ytsd in new coordinates
    A = ((pinv(TranssMat)*[XInit,YInit]')');
    AlignedXtsd = tsd(Range(Xtsd),40*A(:,1));
    AlignedYtsd= tsd(Range(Ytsd),20*A(:,2));
    
    clf
    plot(Data(AlignedXtsd),Data(AlignedYtsd))
    rectangle('Position',[0 0 40 20])
    xlim([-10 50])
    ylim([-10 30])
    axis square
    
    satisfied = input('happy?')
    while satisfied==0
        [x,y]  = ginput(3);
        
        Coord1 = [x(2)-x(1),y(2)-y(1)];
        Coord2 = [x(3)-x(1),y(3)-y(1)];
        TranssMat = [Coord1',Coord2'];
        XInit = Data(AlignedXtsd)-x(1);
        YInit = Data(AlignedYtsd)-y(1);
        
        % The Xtsd and Ytsd in new coordinates
        A = ((pinv(TranssMat)*[XInit,YInit]')');
        AlignedXtsd = tsd(Range(AlignedXtsd),40*A(:,1));
        AlignedYtsd = tsd(Range(AlignedYtsd),20*A(:,2));
        clf
        %
        %             subplot(2,10,(group-1)*10+mouse)
        plot(Data(AlignedXtsd),Data(AlignedYtsd))
        rectangle('Position',[0 0 40 20])
        
        xlim([-10 50])
        ylim([-10 30])
        axis square
        satisfied = input('happy?')
    end
    save('AlignedCagePos.mat', 'AlignedYtsd','AlignedXtsd')
    
end