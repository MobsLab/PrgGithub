% AnalysisPlacePreferenceDecrescendo.m
% 
% once done, run ManipeDecrescendo.m

%% inputs/ initialization
computeAllMaps=1;
saveFigures=0;
basename='wideband';
nameSaveFolder='Analy_PlacePref_Decrescendo';
nameFolder_additionalFigure='/home/karim/Dropbox/MOBS_workingON/PROJETSommeil/ManipePlacePreferenceDecrescendo';
scrz=get(0,'ScreenSize');
res=pwd;
load('MyColormaps','mycmap')
strMouse=strfind(res,'Mouse');
    


%% Create a folder to save Analysis and figures

if ~exist([res,'/',nameSaveFolder],'dir')
    mkdir([res,'/',nameSaveFolder])
end
if ~exist([res,'/',nameSaveFolder,'/behavResources.mat'],'file')
    copyfile([res,'/behavResources.mat'],[res,'/',nameSaveFolder,'/behavResources.mat'])
    if exist([res,'/xyMax.mat'],'file'), copyfile([res,'/xyMax.mat'],[res,'/',nameSaveFolder,'/xyMax.mat']);end
end

%% load stim and events
try
    load([res,'/',nameSaveFolder,'/AllEpochs.mat'],'evt','stim','tpsEvt')
    evt; rgS=Range(stim,'s');
catch
    SetCurrentSession
    SetCurrentSession('same')
    
    evt=GetEvents('output','Descriptions');
    for i=1:length(evt)
        tpsEvt{i}=GetEvents(evt{i});
    end
    
    load([res,'/behavResources.mat'],'stim')
    rgS=Range(stim,'s');
    save([res,'/',nameSaveFolder,'/AllEpochs.mat'],'evt','stim','tpsEvt')
end


%% identify files

try
    load([res,'/',nameSaveFolder,'/AllEpochs.mat'],'Manual','PREepoch','ICSSepoch','POSTepoch')
    Manual;PREepoch;ICSSepoch;POSTepoch;
    disp(['Using epochs defined in ',nameSaveFolder,'...'])
catch
    %cd([res,'-',basename]);
    Manual.voltage=[];
    a=0;b=0;astop=0;
    start_PRE=[];stop_PRE=[];
    start_ICSS=[];stop_ICSS=[];
    start_POST=[];stop_POST=[];

    for i=1:length(evt)
        filename=evt{i};
        % PRE
        if ~isempty(strfind(filename,'PRE'))
            if strcmp(filename(1:3),'beg')
                start_PRE=[start_PRE,tpsEvt{i}];
                disp([filename,' -> PRE start'])
            elseif strcmp(filename(1:3),'end')
                stop_PRE=[stop_PRE,tpsEvt{i}];
                disp([filename,' -> PRE stop'])
            end
        end
        % voltage
        index=strfind(filename,'V-wideband');
        if ~isempty(index)
            
            Volt=str2num(filename(index-1));
            if ~sum(Manual.voltage==Volt)
                Manual.voltage=[Manual.voltage,Volt];
            end
            
            % ICSS & POST
            
            if ~isempty(strfind(filename(strfind(filename,'Mouse'):end),'ICSS'))
                if strcmp(filename(1:3),'beg')
                    disp([filename,' -> ICSS start'])
                    indexStim=find(rgS>=tpsEvt{i});
                    disp(['ICSS start=',num2str(tpsEvt{i}),'; first stim=',num2str(rgS(indexStim(1)))])
                    
                    start_ICSS=[start_ICSS,rgS(indexStim(2))]; % des 2eme stim
                    a=a+1;
                    Manual.ICSSsubEpoch(Manual.voltage==Volt)=a;
                    
                elseif strcmp(filename(1:3),'end')
                    disp([filename,' -> ICSS stop'])
                    stop_ICSS=[stop_ICSS,tpsEvt{i}];
                    astop=astop+1;
                    if start_ICSS(astop)>tpsEvt{i}
                        Manual.ICSSsubEpoch(Manual.voltage==Volt)=[];
                    end

                end
                
            elseif ~isempty(strfind(filename,'POST'))
                if strcmp(filename(1:3),'beg')
                    start_POST=[start_POST,tpsEvt{i}];
                    disp([filename,' -> POST start'])
                    b=b+2;
                    Manual.POSTsubEpoch{Manual.voltage==Volt}=[b-1,b];
                elseif strcmp(filename(1:3),'end')
                    stop_POST=[stop_POST,tpsEvt{i}];
                    disp([filename,' -> POST stop'])
                end
            end
        end
    end
     
    ICSSepoch=intervalSet(start_ICSS*1E4,stop_ICSS*1E4);   
    
    staTemp=[];stpTemp=[];
    for i=1:length(start_PRE) 
        staTemp=[staTemp; start_PRE(i)*1E4; floor((stop_PRE(i)-start_PRE(i))*1E4/2)+start_PRE(i)*1E4];
        stpTemp=[stpTemp;floor((stop_PRE(i)-start_PRE(i))*1E4/2)+start_PRE(i)*1E4;stop_PRE(i)*1E4];
    end
    PREepoch=intervalSet(staTemp,stpTemp);

    staTemp=[];stpTemp=[];
    for i=1:length(start_POST) 
        staTemp=[staTemp; start_POST(i)*1E4; floor((stop_POST(i)-start_POST(i))*1E4/2)+start_POST(i)*1E4];
        stpTemp=[stpTemp;floor((stop_POST(i)-start_POST(i))*1E4/2)+start_POST(i)*1E4;stop_POST(i)*1E4];
    end
    POSTepoch=intervalSet(staTemp,stpTemp);

    disp(['Saving in ',nameSaveFolder,'...'])
    save([res,'/',nameSaveFolder,'/AllEpochs.mat'],'-append','PREepoch','ICSSepoch','POSTepoch','Manual')
end

cd(res);



%% run QuantifExploPFControlML.m

try
    load([res,'/',nameSaveFolder,'/AnalysisPercentage.mat'])
    PercIn; PercInb;
    disp(['Using data from ',nameSaveFolder,'/AnalysisPercentage.mat...'])
    circ_map=rsmak('circle',rad_map,center_map);
catch
    load([res,'/behavResources.mat'],'stim','X','Y','TrackingEpoch')
    load([res,'/SpikeData.mat'],'S')
    
    % inputs
    thPF=0.2;  % default 0.5
    smo=3;  % default 3
    sizeMap=50;
    [X,Y,S,stim,limMaz,limM,limMaze]=RemoveFalsePosition(X,Y,S,stim,TrackingEpoch,2);

    % define exploration circle
    load xyMax
%     map=PlaceField(ts(Range(X)),X,Y,'size',sizeMap,'limitmaze',[0
%     abs(xMaz(1)-xMaz(2)) 0 abs(yMaz(1)-yMaz(2))],'smoothing',smo,'threshold',thPF);
    map=PlaceField(ts(Range(X)),X,Y,'size',sizeMap,'limitmaze',[0 abs(yMaz(1)-yMaz(2)) 0 abs(xMaz(1)-xMaz(2))],'smoothing',smo,'threshold',thPF);    
    [i_map,j_map]=find(map.rate>5);
    [center_map,rad_map] = minboundcircle(j_map,i_map);
    
    subplot(3,2,3), hold on, plot(cos([0:0.1:2*pi])*rad_map+center_map(1),sin([0:0.1:2*pi])*rad_map+center_map(2),'Color','w')
    %ok_circle=input('Are you satisfied with white circle defined?','s'); close;
    
    
    figure('color',[1 1 1],'position',scrz), FigControl=gcf;
    figure('color',[1 1 1],'position',scrz), FigControl2=gcf;
    % Restrict Exporation to epoch PRE
    EpochPRE=PREepoch;
    XE=Restrict(X,EpochPRE);
    YE=Restrict(Y,EpochPRE);
    
    PercIn=NaN(length(Manual.voltage),3); PercInb=PercIn; PercPF=NaN(length(Manual.voltage),2);
    for vv=1:length(Manual.voltage)
        
        disp(' ')
        disp(['... voltage = ',num2str(Manual.voltage(vv))])
        
        clear PercIn_PRE PercIn_ICSS PercIn_POST PercInb_PRE PercInb_ICSS PercInb_POST
        
        % define epochs of exploration ICSS/POST
        o=Manual.ICSSsubEpoch(Manual.voltage==Manual.voltage(vv));
        M=Manual.POSTsubEpoch{Manual.voltage==Manual.voltage(vv)};
        
        EpochS=subset(ICSSepoch,o);
        EpochPOST=subset(POSTepoch,M(1));
        %EpochPOST=subset(POSTepoch,M);
        stimS=Restrict(stim,EpochS);
        rgS=Range(stimS);
        EpochICSS=and(EpochS,intervalSet(rgS(1),rgS(end)));
        
        
        % Restrict Exporation to epochs
        XS=Restrict(X,EpochICSS);
        YS=Restrict(Y,EpochICSS);
        XP=Restrict(X,EpochPOST);
        YP=Restrict(Y,EpochPOST);
        
        load xyMax
%         [mapS,mapSs,statsS,pxS,pyS,Fr,si,PF,centre]=PlaceField(stimS,XS,Y
%         S,'size',sizeMap,'limitmaze',[0 abs(xMaz(1)-xMaz(2)) 0 abs(yMaz(1)-yMaz(2))],'smoothing',smo,'threshold',thPF);
        [mapS,mapSs,statsS,pxS,pyS,Fr,si,PF,centre]=PlaceField(stimS,XS,YS,'size',sizeMap,'limitmaze',[0 abs(yMaz(1)-yMaz(2)) 0 abs(xMaz(1)-xMaz(2))],'smoothing',smo,'threshold',thPF);        
        
        % define a circle around stim area center
        PFb=zeros(size(PF));
        for i=1:size(PFb,1)
            for j=1:size(PFb,2)
                if (round(centre(1))-j)^2+(round(centre(2))-i)^2 < 64 % rayon =8 pixel on 62
                    PFb(i,j)=1;
                end
            end
        end

        [PercIn_PRE,PercOut,PercInb_PRE,PercOutb,m1,m2_PRE,m1b,m2b,SiPF,SiPFb,SiGlob,A_PRE]=QuantifExploPFControlML(PF,PFb,XE,YE,smo); title('PRE')
        [PercIn_ICSS,PercOut,PercInb_ICSS,PercOutb,m1,m2_ICSS,m1b,m2b,SiPF,SiPFb,SiGlob,A_ICSS]=QuantifExploPFControlML(PF,PFb,XS,YS,smo); title('ICSS')
        [PercIn_POST,PercOut,PercInb_POST,PercOutb,m1,m2_POST,m1b,m2b,SiPF,SiPFb,SiGlob,A_POST]=QuantifExploPFControlML(PF,PFb,XP,YP,smo); title('POST')
        close; close; close; close;
        
        PercIn(vv,:)=[PercIn_PRE PercIn_ICSS PercIn_POST];
        PercInb(vv,:)=[PercInb_PRE PercInb_ICSS PercInb_POST];
        PercPF(vv,1:2)=[sum(sum(PF))*100/(pi*rad_map^2), sum(sum(PFb))*100/(pi*rad_map^2)];
        
                
        % -----------------------------------------------------------------
        % display maps
        figure(FigControl)
        subplot(4,length(Manual.voltage),vv), imagesc(A_PRE); title('PRE'); caxis([0 0.01])
        hold on, plot(cos([0:0.1:2*pi])*rad_map+center_map(1),sin([0:0.1:2*pi])*rad_map+center_map(2),'Color','w') 
        subplot(4,length(Manual.voltage),length(Manual.voltage)+vv), imagesc(PF), title(['Stim Area ',num2str(Manual.voltage(vv)),'V']); caxis([0 0.5])
        hold on, plot(cos([0:0.1:2*pi])*rad_map+center_map(1),sin([0:0.1:2*pi])*rad_map+center_map(2),'Color','w') 
        subplot(4,length(Manual.voltage),2*length(Manual.voltage)+vv), imagesc(A_ICSS), title(['ICSS ',num2str(Manual.voltage(vv)),'V']); caxis([0 0.01])
        hold on, plot(cos([0:0.1:2*pi])*rad_map+center_map(1),sin([0:0.1:2*pi])*rad_map+center_map(2),'Color','w') 
        subplot(4,length(Manual.voltage),3*length(Manual.voltage)+vv), imagesc(A_POST);title(['POST ',num2str(Manual.voltage(vv)),'V']); caxis([0 0.01])
        hold on, plot(cos([0:0.1:2*pi])*rad_map+center_map(1),sin([0:0.1:2*pi])*rad_map+center_map(2),'Color','w') 
        
        % -----------------------------------------------------------------
        % display row trajectories
        figure(FigControl2)
        subplot(4,length(Manual.voltage),vv), plot(Data(XE),Data(YE),'b'); 
        title('PRE'); xlim(limMaz); ylim(limMaz);
        subplot(4,length(Manual.voltage),length(Manual.voltage)+vv), plot(Data(Restrict(X,EpochS)),Data(Restrict(Y,EpochS)),'Color',[0.5 0.5 0.5]); 
        xlim(limMaz); ylim(limMaz);
        hold on, plot(Data(Restrict(X,stimS)),Data(Restrict(Y,stimS)),'.r'); title(['Stim Area ',num2str(Manual.voltage(vv)),'V']); 
        xlim(limMaz); ylim(limMaz);
        subplot(4,length(Manual.voltage),2*length(Manual.voltage)+vv), plot(Data(XS),Data(YS),'r'); title(['ICSS ',num2str(Manual.voltage(vv)),'V']); 
        xlim(limMaz); ylim(limMaz);
        subplot(4,length(Manual.voltage),3*length(Manual.voltage)+vv), plot(Data(XP),Data(YP),'k'); title(['POST ',num2str(Manual.voltage(vv)),'V']); 
        xlim(limMaz); ylim(limMaz);
    end
    
    try 
        save([res,'/',nameSaveFolder,'/AnalysisPercentage.mat'],'-append','PercIn','PercInb','PercPF','rad_map','center_map')
    catch
        save([res,'/',nameSaveFolder,'/AnalysisPercentage.mat'],'PercIn','PercInb','PercPF','rad_map','center_map')
    end

end

%% display QuantifExploPFControlML

for vv=1:length(Manual.voltage), FigPercIn_legend{vv}=[num2str(Manual.voltage(vv)),'V'];end
    
figure('color',[1 1 1],'position',2*scrz/5), FigPercIn=gcf;
subplot(2,1,1), bar(PercIn)

set(gca,'xtick',1:length(Manual.voltage))
set(gca,'xticklabel',FigPercIn_legend)
xlabel('Voltage')
ylabel('% Time spent in StimArea (s)')
legend({'PRE','ICSS','POST'})
title([res(max(strfind(res,'Mouse')):end),' (Area=',num2str(floor(mean(PercPF(:,1)))),'% envt)'])

subplot(2,1,2), bar(PercInb)

set(gca,'xtick',1:length(Manual.voltage))
set(gca,'xticklabel',FigPercIn_legend)
xlabel('Voltage')
ylabel('% Time spent in normalized StimArea (s)')
legend({'PRE','ICSS','POST'})
title([res(max(strfind(res,'Mouse')):end),' (Area normed to ',num2str(floor(mean(PercPF(:,2)))),'% envt)'])


%% save Figures QuantifExploPFControlML

if saveFigures
    saveFigure(FigPercIn,['AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_Perc'],nameSaveFolder)
    try 
        figure(FigControl),set(gcf,'Colormap',mycmap)
        saveFigure(FigControl,['AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_PercColorMaps'],nameSaveFolder);
        saveFigure(FigControl2,['AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_PercTrajectories'],nameSaveFolder);
    end
    
    saveFigure(FigPercIn,['AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_Perc'],nameFolder_additionalFigure)
    delete([nameFolder_additionalFigure,'/AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_Perc.png']);
    try 
        saveFigure(FigControl,['AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_PercColorMaps'],nameFolder_additionalFigure);
        delete([nameFolder_additionalFigure,'/AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_PercColorMaps.png']);
        saveFigure(FigControl2,['AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_PercTrajectories'],nameFolder_additionalFigure);
        delete([nameFolder_additionalFigure,'/AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_PercTrajectories.png']);
    end
end

%% run AnalysisQuantifExploJan2012.m

cd([res,'/Analy_PlacePref_Decrescendo'])
if computeAllMaps
    try
        load([res,'/',nameSaveFolder,'/Analysis.mat'])
        TimeInStimAreaPre; TimeInStimAreaICSS; TimeInStimAreaPost;
        disp(['Using saved parameters from ',nameSaveFolder,'/Analysis.mat...'])
        
    catch
        ICSSEpoch=ICSSepoch;
        save behavResources -append ICSSEpoch
        
        for vv=1:length(Manual.voltage)
            disp(' ')
            disp(['... voltage = ',num2str(Manual.voltage(vv))])
            
            if ~isempty(Manual.ICSSsubEpoch(Manual.voltage==Manual.voltage(vv)))
                o=Manual.ICSSsubEpoch(Manual.voltage==Manual.voltage(vv));
                N=1:length(Start(PREepoch));
                
                % analysis PRE and ICSS exploration
                QuantifExploEpoch=intervalSet([Start(PREepoch);Start(ICSSepoch)],[Stop(PREepoch);Stop(ICSSepoch)]);
                save behavResources -append QuantifExploEpoch
                M=o+length(Start(PREepoch));
                [Res, mapS,pxS,pyS,PF,X,Y,OcRS1,OcRS2,homogeneity,temp1,temp1post,tempL1,tempL1post,CorrelationCoef,CorrelationCoefCorrected,temp2,temp2post,temp3,temp3post]=AnalysisQuantifExploJan2014(o,N,M,'positions','s');
                
                TimeInStimAreaICSS(vv,:)=temp1post;
                TimeInLargeStimAreaICSS(vv,:)=tempL1post;
                DistanceToStimZoneICSS(vv,:)=temp2post';
                DelayToStimZoneICSS(vv,:)=temp3post';
                
                OccICSSm{vv}=mapS.rate;
                OccICSS{vv}=OcRS2;
                
                
                % analysis PRE and POST exploration
                QuantifExploEpoch=intervalSet([Start(PREepoch);Start(POSTepoch)],[Stop(PREepoch);Stop(POSTepoch)]);
                save behavResources -append QuantifExploEpoch
                M=Manual.POSTsubEpoch{Manual.voltage==Manual.voltage(vv)}+length(Start(PREepoch));
                disp(['ICSS n°',num2str(o),'; PreExplo=',num2str(N),'; PostExplo=',num2str(M)])
                
                [Res, mapS,pxS,pyS,PF,X,Y,OcRS1,OcRS2,homogeneity,temp1,temp1post,tempL1,tempL1post,CorrelationCoef,CorrelationCoefCorrected,temp2,temp2post,temp3,temp3post]=AnalysisQuantifExploJan2014(o,N,M,'positions','s');
                close all
                TimeInStimAreaPre(vv,:)=temp1;
                TimeInStimAreaPost(vv,:)=temp1post;
                
                TimeInLargeStimAreaPre(vv,:)=tempL1;
                TimeInLargeStimAreaPost(vv,:)=tempL1post;
                
                DistanceToStimZonePre(vv,:)=temp2';
                DistanceToStimZonePost(vv,:)=temp2post';
                
                DelayToStimZonePre(vv,:)=temp3';
                DelayToStimZonePost(vv,:)=temp3post';
                
                OccPRE{vv}=OcRS1;
                OccPOST{vv}=OcRS2;
                
            else
                disp('No stim received')
            end
        end
        
        save([res,'/',nameSaveFolder,'/Analysis.mat'],'TimeInStimAreaPre','TimeInStimAreaICSS','TimeInStimAreaPost')
        save([res,'/',nameSaveFolder,'/Analysis.mat'],'-append','TimeInLargeStimAreaPre','TimeInLargeStimAreaICSS','TimeInLargeStimAreaPost')
        save([res,'/',nameSaveFolder,'/Analysis.mat'],'-append','DistanceToStimZonePre','DistanceToStimZoneICSS','DistanceToStimZonePost')
        save([res,'/',nameSaveFolder,'/Analysis.mat'],'-append','DelayToStimZonePre','DelayToStimZoneICSS','DelayToStimZonePost')
        save([res,'/',nameSaveFolder,'/Analysis.mat'],'-append','OccPRE','OccICSS','OccICSSm','OccPOST')
        
    end
end

cd(res)


%% display AnalysisQuantifExploJan2012

if computeAllMaps
    
    figure('Color',[1 1 1],'position',scrz), numF=gcf;
    subplot(2,2,1), bar([mean(TimeInStimAreaPre,2),mean(TimeInStimAreaICSS,2),mean(TimeInStimAreaPost,2)])
    set(gca,'xtick',1:length(Manual.voltage))
    set(gca,'xticklabel',Manual.voltage)
    xlabel('Voltage')
    ylabel('Time spent in StimArea (s)')
    title(res(strfind(res,'ICSS-'):end)); legend('PRE','ICSS','POST')
    
    subplot(2,2,2), bar([mean(TimeInLargeStimAreaPre,2),mean(TimeInLargeStimAreaICSS,2),mean(TimeInLargeStimAreaPost,2)])
    set(gca,'xtick',1:length(Manual.voltage))
    set(gca,'xticklabel',Manual.voltage)
    xlabel('Voltage')
    ylabel('Time spent in LargeStimArea (s)')
    
    subplot(2,2,3), bar([mean(DistanceToStimZonePre,2),mean(DistanceToStimZoneICSS,2),mean(DistanceToStimZonePost,2)])
    set(gca,'xtick',1:length(Manual.voltage))
    set(gca,'xticklabel',Manual.voltage)
    xlabel('Voltage')
    ylabel('Distance to StimArea')
    
    subplot(2,2,4), bar([mean(DelayToStimZonePre,2),mean(DelayToStimZoneICSS,2),mean(DelayToStimZonePost,2)])
    set(gca,'xtick',1:length(Manual.voltage))
    set(gca,'xticklabel',Manual.voltage)
    xlabel('Voltage')
    ylabel('Delay to StimArea (s)')
    
    
    
    
    figure('color',[1 1 1],'position',scrz), numFima=gcf;
    for vv=1:length(Manual.voltage)
        subplot(4,length(Manual.voltage),vv),imagesc(OccPRE{vv}),axis xy,
        hold on, plot(cos([0:0.1:2*pi])*rad_map+center_map(1),sin([0:0.1:2*pi])*rad_map+center_map(2),'Color','w') 
        set(gcf,'Colormap',mycmap),title('Explo Pre'); caxis([0 0.4])
        
        subplot(4,length(Manual.voltage),vv+length(Manual.voltage)),imagesc(OccICSSm{vv}),axis xy,
        hold on, plot(cos([0:0.1:2*pi])*rad_map+center_map(1),sin([0:0.1:2*pi])*rad_map+center_map(2),'Color','w') 
        title('ICSS Area'); caxis([0 5])
        
        subplot(4,length(Manual.voltage),vv+2*length(Manual.voltage)),imagesc(OccICSS{vv}),axis xy,
        hold on, plot(cos([0:0.1:2*pi])*rad_map+center_map(1),sin([0:0.1:2*pi])*rad_map+center_map(2),'Color','w') 
        set(gcf,'Colormap',mycmap),title(['Explo ICSS ',num2str(Manual.voltage(vv)),'V']); caxis([0 0.4])
        
        subplot(4,length(Manual.voltage),vv+3*length(Manual.voltage)),imagesc(OccPOST{vv}),axis xy,
        hold on, plot(cos([0:0.1:2*pi])*rad_map+center_map(1),sin([0:0.1:2*pi])*rad_map+center_map(2),'Color','w') 
        set(gcf,'Colormap',mycmap),title('Explo Post'); caxis([0 0.4])
    end
    
end


%% save Figures

if saveFigures

    if computeAllMaps
        saveFigure(numF,['AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_bars'],nameSaveFolder)
        saveFigure(numFima,['AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_ColorMaps'],nameSaveFolder)
        
        saveFigure(numF,['AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_bars'],nameFolder_additionalFigure)
        delete([nameFolder_additionalFigure,'/AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_bars.png']);
        saveFigure(numFima,['AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_ColorMaps'],nameFolder_additionalFigure)
        delete([nameFolder_additionalFigure,'/AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_ColorMaps.png']);
        
        figure(numFima), colormap('jet')
        saveFigure(numFima,['AnalyPPdecrescendo_',res(strMouse(length(strMouse)):end),'_ColorMapsJET'],nameSaveFolder)
        
    end
end


%% compare with NosePoke
try
    NumMouse=str2num(res(strMouse(length(strMouse))+6:strMouse(length(strMouse))+8));
    load([res,'/NosePoke',num2str(NumMouse),'.mat'])
    
    Matcorr=nan(length(Manual.voltage),3);
    for vv=1:length(Manual.voltage),
        temp=NosePokeMat(NosePokeMat(:,4)==2 & NosePokeMat(:,1)==Manual.voltage(vv),2);
        Matcorr(vv,1)=nanmean(temp);
    end
    Matcorr(:,2:3)=PercIn(:,2:3)./mean(PercPF(:,1));
    
    save([res,'/',nameSaveFolder,'/AnalysisPercentage.mat'],'-append','Matcorr')
end

%% control Stim time
% 
% filename=input('Enter the name of the last ICSS session: ','s');
% load([res,'-',basename,'/',filename,'.mat']);
% 
% % single session
% for i=1:length(evt)
%     if length(filename)<length(evt{i}) && sum(strfind(evt{i},filename))
%         if strcmp(evt{i}(1:3),'beg')
%             sta=GetEvents(evt{i});
%         elseif strcmp(evt{i}(1:3),'end')
%             sto=GetEvents(evt{i});
%         end
%     end
% end
% epochFilename=intervalSet(sta*1E4,sto*1E4);
% 
% EvtFilename=LoadEvents([filename,'.e00.evt']);
% temp=EvtFilename.time*1E4;
% if ~issorted(temp)
%     disp('WARNING FilenameStim is not sorted... discarding all redondant values')
%     temp=sort(temp);
%     temp(diff(temp)==0)=[];
% end
% StimFilename=tsd(sta*1E4+temp,sta*1E4+temp);
% 
% for i=1:length(temp)
%     [m,ind]=min(abs(Pos(:,1)-temp(i)/1E4));
%     stimInd(i)=ind;
% end
% 
% % in concatenate sessions
% load('behavResources.mat','stim','X','Y')
% temp=Data(Restrict(stim,epochFilename));
% rgX=Range(Restrict(X,epochFilename));
% for i=1:length(temp)
%     [m,ind]=min(abs(rgX-temp(i)));
%     time(i)=rgX(ind);
% end
% timeStim=ts(time);
% 
% % display
% 
% figure('Color',[1 1 1])
% 
% subplot(1,2,1), plot(Pos(:,2),Pos(:,3))
% hold on, plot(Pos(stimInd,2),Pos(stimInd,3),'r.')
% title('Single Session')
% 
% subplot(1,2,2), plot(Data(Restrict(X,epochFilename)),Data(Restrict(Y,epochFilename)))
% hold on, plot(Data(Restrict(X,timeStim)),Data(Restrict(Y,timeStim)),'r.')
% title('concatenated Session')
% 


