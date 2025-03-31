
%% Maze with zone issues

OfflineTrackingFinal_CompNewTracking

clear all

load('behavResources.mat')
load('behavResources_Offline.mat')

cd('Sessions with same zone limits')

load('behavResources.mat', 'ZoneLabels')
load('behavResources.mat', 'Zone')
load('behavResources.mat', 'th_immob')

cd('session before')

try FreezeEpoch=thresholdIntervals(Imdifftsd,th_immob,'Direction','Below');
    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
    Freeze=sum(End(FreezeEpoch)-Start(FreezeEpoch));
catch
    Freeze=NaN;
    Freeze2=NaN;
end

Xtemp=Data(Xtsd);
T1=Range(Xtsd);
XXX = floor(Data(Xtsd)*Ratio_IMAonREAL);
XXX(isnan(XXX)) = 240;
YYY = floor(Data(Ytsd)*Ratio_IMAonREAL);
YYY(isnan(YYY)) = 320;
for t = 1:length(Zone)
    try
        ZoneIndices{t}=find(diag(Zone{t}(XXX,YYY)));
        Xtemp2=Xtemp*0;
        Xtemp2(ZoneIndices{t})=1;
        ZoneEpoch{t}=thresholdIntervals(tsd(T1,Xtemp2),0.5,'Direction','Above');
        Occup(t)=size(ZoneIndices{t},1)./size(XXX,1);
        FreezeTime(t)=length(Data(Restrict(Xtsd,and(FreezeEpoch,ZoneEpoch{t}))))./length(Data((Restrict(Xtsd,ZoneEpoch{t}))));
    catch
        ZoneIndices{t}=[];
        ZoneEpoch{t}=intervalSet(0,0);
        Occup(t)=0;
        FreezeTime(t)=0;
    end
end

plot(Data(Xtsd),Data(Ytsd))

delete t T1 Xtemp Xtemp2 XXX YYY
save('behavResources.mat')




