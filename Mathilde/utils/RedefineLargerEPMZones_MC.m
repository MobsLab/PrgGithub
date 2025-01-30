load('behavResources.mat')
load('TrObject.mat')

%%
Zone_redefined = []; ZoneEpoch_redefined = []; ZoneIndices_redefined = []; ZoneLabels_redefined = [];

%%
% figure, imagesc(Zone{1})


figure, imagesc(ref)
hold on, plot (Data(Ytsd)*Ratio_IMAonREAL, Data(Xtsd)*Ratio_IMAonREAL, 'color', 'k')

[X,Y] = ginput(1);

size_center = 35;
plot(X-size_center,Y-size_center,'ro')
plot(X+size_center,Y+size_center,'ro')

plot(X+size_center,Y-size_center,'ro')
plot(X-size_center,Y+size_center,'ro')

%%
disp('OpenArms');[x1,y1,Open,x2,y2]=roipoly; plot(x2,y2)

%%
% figure, imagesc(ref)
disp('ClosedArms');[x1,y1,Closed,x2,y2]=roipoly(); plot(x2,y2)


%%
Centre=zeros(size(TrObjLocal.ref));Centre(Open==1 & Closed==1)=1;

Open(Centre==1)=0;Closed(Centre==1)=0;

Zone_redefined{1}=uint8(Open);Zone_redefined{2}=uint8(Closed);Zone_redefined{3}=uint8(Centre);

ZoneLabels_redefined={'OpenArms','ClosedArms','Centre'};


%%
Xtemp=Data(Xtsd);
T1=Range(Xtsd);


if not(isempty('Zone_redefined'))
    XXX = floor(Data(Xtsd)*TrObjLocal.Ratio_IMAonREAL);
    XXX(isnan(XXX)) = 240;
    YYY = floor(Data(Ytsd)*TrObjLocal.Ratio_IMAonREAL);
    YYY(isnan(YYY)) = 320;
    for t = 1:length(Zone_redefined)
        %         try
        ZoneIndices_redefined{t}=find(diag(Zone_redefined{t}(XXX,YYY)));
        Xtemp2=Xtemp*0;
        Xtemp2(ZoneIndices_redefined{t})=1;
        ZoneEpoch_redefined{t}=thresholdIntervals(tsd(T1,Xtemp2),0.5,'Direction','Above');
        Occup_redefined(t)=size(ZoneIndices_redefined{t},1)./size(XXX,1);
        
    end
end 


%%
save('behavResources.mat', 'Zone_redefined','ZoneEpoch_redefined','ZoneIndices_redefined','ZoneLabels_redefined','Occup_redefined','-append')




