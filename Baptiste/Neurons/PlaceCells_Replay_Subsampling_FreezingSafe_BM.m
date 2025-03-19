


clear all
MiceNumber = [905,911,994,1161,1162,1168,1186,1230,1239];
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data

SpeedLim = 2;
window_around_rip = [0.05 0.05];
FR_Ripples_all=[];
FR_PreRipples_all=[];
Session_type={'Hab1','Hab2','Hab','Cond'};
for sess=1:length(Session_type); FR_mov_all{sess} = []; end
A = [42 41 28 74 19 24 19 79 10];


for mm=1:length(MiceNumber)
    for sess=1:length(Session_type)
        mm
        
        load(['RippleReactInfo_NewRipples_' Session_type{sess} '_Mouse',num2str(MiceNumber(mm)),'.mat'])
        
        TotalNoiseEpoch = or(StimEpoch , NoiseEpoch);
        
        MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
        MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4)-FreezeEpoch;
        MovEpoch = MovEpoch-TotalNoiseEpoch;
        
        ShockZoneEpoch = thresholdIntervals(LinPos,.2,'Direction','Below');
        B=cumsum(DurationEpoch(ShockZoneEpoch)/1e4);
        ind=find(B>A(mm),1,'first');
        WantedEpoch=intervalSet([],[]);
        for i=1:ind-1
            WantedEpoch = or(WantedEpoch , subset(ShockZoneEpoch,i));
        end
        WantedEpoch = or(WantedEpoch , intervalSet(Start(subset(ShockZoneEpoch,ind)) , Start(subset(ShockZoneEpoch,ind))+A(mm)*1e4));
        
        MovEpoch2 = or((MovEpoch-ShockZoneEpoch) , WantedEpoch);
        
        i=1;
        for neur=1:length(Spikes)
            try
                [map_mov{sess}{mm}{neur}, mapNS_mov{sess}{mm}{neur}, stats{sess}{mm}{neur}, px{sess}{mm}{neur}, py{sess}{mm}{neur}, FR_pre{sess}{mm}(neur)] = PlaceField_DB(Spikes{neur}, Xtsd,...
                    Ytsd , 'PlotResults' , 0 , 'PlotPoisson' ,0 , 'epoch' , MovEpoch);
                
                [map_mov2{sess}{mm}{neur}, mapNS_mov2{sess}{mm}{neur}, stats2{sess}{mm}{neur}, px2{sess}{mm}{neur}, py2{sess}{mm}{neur}, FR_pre2{sess}{mm}(neur)] = PlaceField_DB(Spikes{neur}, Xtsd,...
                    Ytsd , 'PlotResults' , 0 , 'PlotPoisson' ,0 , 'epoch' , MovEpoch2);
                if ~isempty(stats{sess}{mm}{neur})
                    if stats{sess}{mm}{neur}.spatialInfo>1
                        Place_Cells{sess}{mm}(i) = neur;
                        FR_mov{sess}{mm}(i) = FR_pre{sess}{mm}(neur);
                        i=i+1;
                    end
                end
            end
        end
        
        LinPos_Mov{sess}{mm} = Restrict(LinPos , MovEpoch);
        h=histogram(Data(LinPos_Mov{sess}{mm}),'BinLimits',[0 1],'NumBins',100);
        HistData_LinPos{sess}(mm,:)= h.Values./sum(h.Values);
        
        try, FR_mov_all{sess} = [FR_mov_all{sess} ; FR_mov{sess}{mm}']; end
        Duration_epoch(sess,mm) = sum(DurationEpoch(MovEpoch))/1e4;
        
    end
end


l=linspace(0,1,49);
clear HistData_FR2 HistData_FR
for sess=1:length(Session_type)
    m=1;
    for mm=1:length(MiceNumber)
        n=1;
        for neur=Place_Cells{1}{mm}
            if and(and(~isempty(mapNS_mov2{1}{mm}{neur}) , ~isempty(mapNS_mov2{2}{mm}{neur})) , and(~isempty(mapNS_mov2{3}{mm}{neur}) , ~isempty(mapNS_mov2{4}{mm}{neur})))
                U1 = find(mapNS_mov2{1}{mm}{neur}.rate~=0); U2 = find(mapNS_mov2{2}{mm}{neur}.rate~=0);
                U3 = find(mapNS_mov2{3}{mm}{neur}.rate~=0); U4 = find(mapNS_mov2{4}{mm}{neur}.rate~=0);
                if and(and(~isempty(U1) , ~isempty(U2)) , and(~isempty(U1) , ~isempty(U2)))
                    
                    % linearized coordinate Hab
                    clear U, U=find(mapNS_mov2{sess}{mm}{neur}.rate~=0);
                    if ~isempty(U) % no spikes
                        
                        [Y,X] = ind2sub(size(mapNS_mov2{sess}{mm}{neur}.rate) , U);
                        [~,~,t_hab] = distance2curve([.15 .15 .85 .85; 0 .96 .96 0]',[l(X-7);l(Y-7)]','linear');
                        [C,IA,IC] = unique(t_hab);
                        for j=1:length(C)
                            FiringRATE2{sess}{mm}{neur}(j,:) = [C(j) sum(mapNS_mov2{sess}{mm}{neur}.rate(U(IC==j)))];
                        end
                        clear a b
                        [a,b]=sort(FiringRATE2{sess}{mm}{neur}(:,1));
                        FiringRATE2{sess}{mm}{neur}=FiringRATE2{sess}{mm}{neur}(b,:);
                        for bin=1:100
                            ind=find(and(FiringRATE2{sess}{mm}{neur}(:,1)>=((bin-1)/100) , FiringRATE2{sess}{mm}{neur}(:,1)<(bin/100)));
                            if ~isempty(ind)
                                HistData_FR2{sess}(m,bin) = sum(FiringRATE2{sess}{mm}{neur}(ind,2));
                            end
                        end
                        HistData_FR2{sess}(m,:) = HistData_FR2{sess}(m,:)./sum(HistData_FR2{sess}(m,:));
                        
                    else
                        HistData_FR2{sess}(m,:) = 0;
                    end
                    
                    % linearized coordinate Hab
                    clear U, U=find(mapNS_mov{sess}{mm}{neur}.rate~=0);
                    if ~isempty(U) % no spikes
                        
                        [Y,X] = ind2sub(size(mapNS_mov{sess}{mm}{neur}.rate) , U);
                        [~,~,t_hab] = distance2curve([.15 .15 .85 .85; 0 .96 .96 0]',[l(X-7);l(Y-7)]','linear');
                        [C,IA,IC] = unique(t_hab);
                        for j=1:length(C)
                            FiringRATE{sess}{mm}{neur}(j,:) = [C(j) sum(mapNS_mov{sess}{mm}{neur}.rate(U(IC==j)))];
                        end
                        clear a b
                        [a,b]=sort(FiringRATE{sess}{mm}{neur}(:,1));
                        FiringRATE{sess}{mm}{neur}=FiringRATE{sess}{mm}{neur}(b,:);
                        for bin=1:100
                            ind=find(and(FiringRATE{sess}{mm}{neur}(:,1)>=((bin-1)/100) , FiringRATE{sess}{mm}{neur}(:,1)<(bin/100)));
                            if ~isempty(ind)
                                HistData_FR{sess}(m,bin) = sum(FiringRATE{sess}{mm}{neur}(ind,2));
                            end
                        end
                        HistData_FR{sess}(m,:) = HistData_FR{sess}(m,:)./sum(HistData_FR{sess}(m,:));
                        
                    else
                        HistData_FR{sess}(m,:) = 0;
                    end
                    
                    
                    m=m+1;
                    n=n+1;
                end
            end
        end
        disp(mm)
    end
end




clear b d
for sess=1:length(Session_type)
    [~,b{sess}]=max(HistData_FR{sess}'); [~,d{sess}]=sort(b{sess});
end

clear b2 d2
for sess=1:length(Session_type)
    [~,b2{sess}]=max(HistData_FR{sess}'); [~,d2{sess}]=sort(b2{sess});
end


figure
subplot(141), sess=1;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR{sess}(d{sess},:)]',2)')
caxis([0 .05])
colormap viridis
ylabel('HPC neurons no'), xlabel('linear UMaze distance')
vline(.2,'--r')
makepretty
title('Hab 1')

subplot(142), sess=2;
imagesc( linspace(0,1,100) , [1:size(HistData_FR{sess},1)] ,runmean([HistData_FR2{sess}(d{1},:)]',2)')
caxis([0 .05])
xlabel('linear UMaze distance'), yticklabels({''})
vline(.2,'--r')
makepretty
title('Hab2 subsampled on Hab1 order')

subplot(243)
PlotCorrelations_BM(b{1}/100,b2{2}/100)
axis square
line([0 1],[0 1],'LineStyle','--','Color','r','LineWidth',2)

subplot(247)
imagesc(linspace(0,1,100) , linspace(0,1,100) , SmoothDec(HistData_FR{1}(d{1},:).*HistData_FR2{2}(d{1},:),1)), caxis([0 5e-4]), colormap viridis
axis square
line([0 1],[0 1],'LineStyle','--','Color','r','LineWidth',2)
xlabel('Place cells, Hab1 (linear dist)'), ylabel('Place cells, Hab2 (linear dist)')
makepretty

subplot(144)
imagesc(linspace(0,1,100) , [1:size(HistData_FR2{2},1)] ,runmean([HistData_FR2{2}(d{2},:)]',2)')
caxis([0 .05])
xlabel('linear UMaze distance'), yticklabels({''})
vline(.2,'--r')
makepretty
title('Hab2 subsampled on Hab2 subsampled order')





