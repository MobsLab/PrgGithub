%Ce fichier correspond environ à
%Dur564=(sum(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s')))./sum(sum((Zone{1})));
%sans utiliser d'epoch



Filename564={
   '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_Habituation'
 %  '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_TestPre/TestPre1'
  % '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_TestPre/TestPre2'
  % '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_TestPre/TestPre3'
  % '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_TestPre/TestPre4'
}

Filename565={
   '/media/DataMOBS65/EmbReact_Eyeshock/Mouse565/20170726/ProjectEmbReact_M565_20170726_Habituation'
 %  '/media/DataMOBS65/EmbReact_Eyeshock/Mouse565/20170706/ProjectEmbReact_M565_20170706_TestPre/TestPre1'
 %  '/media/DataMOBS65/EmbReact_Eyeshock/Mouse565/20170706/ProjectEmbReact_M565_20170706_TestPre/TestPre2'
 %  '/media/DataMOBS65/EmbReact_Eyeshock/Mouse565/20170706/ProjectEmbReact_M565_20170706_TestPre/TestPre3'
 %  '/media/DataMOBS65/EmbReact_Eyeshock/Mouse565/20170706/ProjectEmbReact_M565_20170706_TestPre/TestPre4'
}

Filename560={
   '/media/DataMOBS65/EmbReact_Eyeshock/Mouse560/20170706/ProjectEmbReact_M560_20170706_Habituation'
 %  '/media/DataMOBS65/EmbReact_Eyeshock/Mouse560/20170706/ProjectEmbReact_M560_20170706_TestPre/TestPre1'
 %  '/media/DataMOBS65/EmbReact_Eyeshock/Mouse560/20170706/ProjectEmbReact_M560_20170706_TestPre/TestPre2'
  % '/media/DataMOBS65/EmbReact_Eyeshock/Mouse560/20170706/ProjectEmbReact_M560_20170706_TestPre/TestPre3'
  % '/media/DataMOBS65/EmbReact_Eyeshock/Mouse560/20170706/ProjectEmbReact_M560_20170706_TestPre/TestPre4'
}

figure    
for ff=1:length(Filename564)
    cd(Filename564{ff})
    load('behavResources.mat')
    Xtsd564=tsd(PosMat(:,1)*1e4,PosMat(:,2));
    Ytsd564=tsd(PosMat(:,1)*1e4,PosMat(:,3));

    plot(Data(Xtsd564),Data(Ytsd564)) % toute la trajectoire
    title('Mouse 564')
    hold on
    plot(Data(Restrict(Xtsd564,ZoneEpoch{1})),Data(Restrict(Ytsd564,ZoneEpoch{1})))
    %plot(Data(Restrict(Ytsd,ZoneEpoch{1})),Data(Restrict(Xtsd,ZoneEpoch{1}))) % seulement une zone
    %   plot(Data(Restrict(Ytsd,FreezeEpoch)),Data(Restrict(Xtsd,FreezeEpoch)),'.') % seulement une zone
    
    Temps564={Range(Restrict(Xtsd564,ZoneEpoch{1})),Range(Restrict(Xtsd564,ZoneEpoch{1}))};
    DeltaT564=zeros(length(Temps564{1,1})-1,1);
    
    for k=1:length(Temps564{1,1})-1
    DeltaT564(k)=Temps564{1,1}(k+1)-Temps564{1,1}(k);
    end
    
    l=1;
    tp564=0;
    for k=1:length(DeltaT564)
        if DeltaT564(k)>1000
            tp564=tp564+Temps564{1,1}(k)-Temps564{1,1}(l);
            l=k+1;
        end
    end
    display(tp564/sum(sum((Zone{1}))))
    
    Dur564=(sum(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s')))./sum(sum((Zone{1})));
    display(Dur564)
end
cd ..


figure
for ff=1:length(Filename565)
    cd(Filename565{ff})
    load('behavResources.mat')
    Xtsd565=tsd(PosMat(:,1)*1e4,PosMat(:,2));
    Ytsd565=tsd(PosMat(:,1)*1e4,PosMat(:,3));

    plot(Data(Xtsd565),Data(Ytsd565)) % toute la trajectoire
    title('Mouse 565')
    hold on
    plot(Data(Restrict(Xtsd565,ZoneEpoch{1})),Data(Restrict(Ytsd565,ZoneEpoch{1})))
    %plot(Data(Restrict(Xtsd565,ZoneEpoch{1})),Data(Restrict(Ytsd565,ZoneEpoch{1}))) % seulement une zone
    %   plot(Data(Restrict(Ytsd,FreezeEpoch)),Data(Restrict(Xtsd,FreezeEpoch)),'.') % seulement une zone
    
    Temps565={Range(Restrict(Xtsd565,ZoneEpoch{1})),Range(Restrict(Xtsd565,ZoneEpoch{1}))};
    DeltaT565=zeros(length(Temps565{1,1})-1,1);
    for k=1:length(Temps565{1,1})-1
    DeltaT565(k)=Temps565{1,1}(k+1)-Temps565{1,1}(k);
    end
    
    l=1;
    tp565=0;
    for k=1:length(DeltaT565)
        if DeltaT565(k)>1000
            tp565=tp565+Temps565{1,1}(k)-Temps565{1,1}(l);
            l=k+1;
        end
    end
    display(tp565/sum(sum((Zone{1}))))
    
    Dur565=(sum(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s')))./sum(sum((Zone{1})));
    display(Dur565)
end
cd ..

figure
for ff=1:length(Filename560)
    cd(Filename560{ff})
    load('behavResources.mat')
    Xtsd560=tsd(PosMat(:,1)*1e4,PosMat(:,2));
    Ytsd560=tsd(PosMat(:,1)*1e4,PosMat(:,3));

    plot(Data(Xtsd560),Data(Ytsd560)) % toute la trajectoire
    title('Mouse 560')
    hold on
    plot(Data(Restrict(Xtsd560,ZoneEpoch{1})),Data(Restrict(Ytsd560,ZoneEpoch{1})))
    %plot(Data(Restrict(Xtsd560,ZoneEpoch{1})),Data(Restrict(Ytsd560,ZoneEpoch{1}))) % seulement une zone
    %   plot(Data(Restrict(Ytsd,FreezeEpoch)),Data(Restrict(Xtsd,FreezeEpoch)),'.') % seulement une zone

    Temps560={Range(Restrict(Xtsd560,ZoneEpoch{1})),Range(Restrict(Xtsd560,ZoneEpoch{1}))};
    DeltaT560=zeros(length(Temps560{1,1})-1,1);
    for k=1:length(Temps560{1,1})-1
    DeltaT560(k)=Temps560{1,1}(k+1)-Temps560{1,1}(k);
    end
    
    l=1;
    tp560=0;
    for k=1:length(DeltaT560)
        if DeltaT560(k)>1000
            tp560=tp560+Temps560{1,1}(k)-Temps560{1,1}(l);
            l=k+1;
        end
    end
    display(tp560/sum(sum((Zone{1}))))
    
     Dur560=(sum(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s')))./sum(sum((Zone{1})));
    display(Dur560)
    
end

