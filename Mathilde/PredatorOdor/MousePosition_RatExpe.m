%% Rat protocol 1 

% baseline 1 
mice = [926 928 927 923];

for i = 1:length(mice)
    cd(['/media/nas5/Thierry_DATA/Rat/Data_Tracking/SLEEP-Mouse-928&923&927&926-02102019_00/Mouse',num2str(mice(i)),'-BaselineSleep'])
    load('behavResources.mat')
    figure(1);
    subplot(2,2,i);
    plot(Data(Xtsd),Data(Ytsd)) % plot tracking position across sleep session
    title(num2str(mice(i)))
    camroll(-90)
end
% rat
mice = [926 928 927 923];

for i = 1:length(mice)
    cd(['/media/nas5/Thierry_DATA/Rat/Data_Tracking/SLEEP-Mouse-928&923&927&926-03102019_00/Mouse',num2str(mice(i)),'-BaselineSleep'])
    load('behavResources.mat')
    figure(6);
    subplot(2,2,i);
    plot(Data(Xtsd),Data(Ytsd)) % plot tracking position across sleep session
    title(num2str(mice(i)))
    camroll(-90)

end

% baseline 2
mice = [926 928 927 923];

for i = 1:length(mice)
    cd(['/media/nas5/Thierry_DATA/Rat/Data_Tracking/SLEEP-Mouse-928&923&927&926-04102019_00/Mouse',num2str(mice(i)),'-BaselineSleep'])
    load('behavResources.mat')
    figure(3);
    subplot(2,2,i);
    plot(Data(Xtsd),Data(Ytsd)) % plot tracking position across sleep session
    title(num2str(mice(i)))
    camroll(-90)
end


%% Rat protocol 2
% baseline 1
mouse = [928 927];

for j = 1:length(mouse)
    cd(['/media/nas5/Thierry_DATA/Rat_box/Data_Tracking/SLEEP-Mouse-928&927&0&1-08102019_00/Mouse',num2str(mouse(j)),'-BaselineSleep'])
    load('behavResources.mat')
    figure(4);
    subplot(2,2,j+1);
    plot(Data(Xtsd),Data(Ytsd)) % plot tracking position across sleep session
    title(num2str(mouse(j)))
    camroll(-90)

end
% rat exposure
mouse = [928 927];

for j = 1:length(mouse)
    cd(['/media/nas5/Thierry_DATA/Rat_box/Data_Tracking/SLEEP-Mouse-928&927&0&1-09102019_00/Mouse',num2str(mouse(j)),'-BaselineSleep'])
    load('behavResources.mat')
    figure(5);
    subplot(2,2,j+1);
    plot(Data(Xtsd),Data(Ytsd)) % plot tracking position across sleep session
    title(num2str(mouse(j)))
    camroll(-90)

end
% baseline 2
mouse = [928 927];

for j = 1:length(mouse)
    cd(['/media/nas5/Thierry_DATA/Rat_box/Data_Tracking/SLEEP-Mouse-928&927&0&1-10102019_00/Mouse',num2str(mouse(j)),'-BaselineSleep'])
    load('behavResources.mat')
    figure(7);
    subplot(2,2,j+1);
    plot(Data(Xtsd),Data(Ytsd)) % plot tracking position across sleep session
    title(num2str(mouse(j)))
    camroll(-90)

end
