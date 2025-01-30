clear all
load('behavResources.mat')
figure
Xtsd=tsd(PosMat(:,1)*1e4,PosMat(:,2));
Ytsd=tsd(PosMat(:,1)*1e4,PosMat(:,3));
cols=lines(5);
ZonEpochOld=ZoneEpoch;
ZoneEpoch{1}=ZonEpochOld{2};
ZoneEpoch{2}=ZonEpochOld{1};
ZoneEpoch{4}=ZonEpochOld{5};
ZoneEpoch{5}=ZonEpochOld{4};
cols=lines(5);
for k=1:5
    plot(Data(Restrict(Xtsd,ZoneEpoch{k})),Data(Restrict(Ytsd,ZoneEpoch{k})),'color',cols(k,:)), hold on
end



%% A faire en cas d'erreur
clear all
load('behavResourcesnew.mat')
PosMatInt=PosMat;
x=PosMatInt(:,2);
nanx = isnan(x);
t    = 1:numel(x);
x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
PosMatInt(:,2)=x;
x=PosMatInt(:,3);
nanx = isnan(x);
t    = 1:numel(x);
x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
PosMatInt(:,3)=x;
PosMat=PosMatInt;
PosMat(isnan(PosMat(:,2)),2)=PosMat(find(~isnan(PosMat(:,2)),1,'first'),2);
PosMat(isnan(PosMat(:,3)),3)=PosMat(find(~isnan(PosMat(:,3)),1,'first'),3);
Ytsd=tsd(PosMat(:,1)*1e4,PosMat(:,2));
Xtsd=tsd(PosMat(:,1)*1e4,PosMat(:,3));

Xtemp=Data(Xtsd); Ytemp=Data(Ytsd); T1=Range(Ytsd);
if not(isempty('Zone'))
    for t=1:length(Zone)
        try
            ZoneIndices{t}=find(diag(Zone{t}(floor(Data(Xtsd)*Ratio_IMAonREAL),floor(Data(Ytsd)*Ratio_IMAonREAL))));
            Xtemp2=Xtemp*0;
            Xtemp2(ZoneIndices{t})=1;
            ZoneEpoch{t}=thresholdIntervals(tsd(T1,Xtemp2),0.5,'Direction','Above');
            Occup(t)=size(ZoneIndices{t},1)./size(Data(Xtsd),1);
            FreezeTime(t)=length(Data(Restrict(Xtsd,and(FreezeEpoch,ZoneEpoch{t}))))./length(Data((Restrict(Xtsd,ZoneEpoch{t}))));
        catch
            ZoneIndices{t}=[];
            ZoneEpoch{t}=intervalSet(0,0);
            Occup(t)=0;
            FreezeTime(t)=0;
        end
    end
else
    for t=1:2
        ZoneIndices{t}=[];
        ZoneEpoch{t}=intervalSet(0,0);
        Occup(t)=0;
        FreezeTime(t)=0;
    end
end
Xtsd=tsd(PosMat(:,1)*1e4,PosMat(:,2));
Ytsd=tsd(PosMat(:,1)*1e4,PosMat(:,3));
figure
cols=lines(5);
for k=1:5
    plot(Data(Restrict(Xtsd,ZoneEpoch{k})),Data(Restrict(Ytsd,ZoneEpoch{k})),'color',cols(k,:)), hold on
end
%        save('behavResourcesnew.mat','ZoneEpoch','PosMat','-append')