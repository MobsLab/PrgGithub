AllMice = [1038:1041,1044,1045];
for m = 1:length(AllMice)
    FileName{m}{1} = ['/media/nas4/TrapMice/Mouse',num2str(AllMice(m)),'/D5/TestA/'];
    FileName{m}{2} = ['/media/nas4/TrapMice/Mouse',num2str(AllMice(m)),'/D5/TestB/'];
    FileName{m}{3} = ['/media/nas4/TrapMice/Mouse',num2str(AllMice(m)),'/D5/TestC/'];
end

clear FreezeTime
for m = 1:length(AllMice)
    for c = 1:3
        cd(FileName{m}{c})
        try
            clear FreezeEpoch
            load('behavResources.mat')
            %         FreezeEpoch = and(intervalSet(0,180*1e4),FreezeEpoch);
            FreezeTime(m,c) = sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'))/(12*60);
            subplot(3,6,m+(c-1)*6)
            plot(Range(Imdifftsd,'s'),runmean(Data(Imdifftsd),2))
            ylim([0 2500])
            xlim([0 750])
            
        catch
            clear FreezeEpoch
            load('behavResources_Offline.mat')
            %         FreezeEpoch = and(intervalSet(0,180*1e4),FreezeEpoch);
            FreezeTime(m,c) = sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'))/(12*60);
            subplot(3,6,m+(c-1)*6)
            plot(Range(Imdifftsd,'s'),runmean(Data(Imdifftsd),2))
            ylim([0 2500])
            xlim([0 750])
            
            
        end
        if  FreezeTime(m,c) >1
            keyboard
        end
        
    end
end

fig = gcf;
axObjs = fig.Children;
dataObjs = axObjs.Children;
for k = 1:38
tps = dataObjs(k).XData;
dat = dataObjs(k).YData;
Imdifftsd = tsd(tps*1e4,dat');
plot(Range(Imdifftsd,'s'),Data(Imdifftsd))
pause
end

FreezeEpoch=thresholdIntervals(Imdifftsd,th_immob{1},'Direction','Below');
FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
Freeze=sum(End(FreezeEpoch)-Start(FreezeEpoch));
FreezeTime(m,c) = sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'))/(12*60);
