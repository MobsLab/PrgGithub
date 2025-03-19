%  05.02.2016
experiment= 'Fear-electrophy';
%experiment='ManipFeb15Bulbectomie';

plo=0;
mean_or_med='mean';
SpPplot=0;

[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high

th_immob=1; % default 1
thtps_immob=2; % minimum 2 sec of immobility
Rogne=2; % rognage des evenementde freezing
thtps_immob_for_rogne=4; % a ajuster en fonction de 'Rogne'
Ylimits_raw=[0 5E4];
Ylimits_norm=[20 60];
th_for_plot=10; %Spectrogram is not plotted if computed for less than 30sec 
fqmax_for_plot=10;
timemax_for_plot=400;
cohmin_for_plot=0.4;

namecolmn={'Freezing','No Freezing','Freezing','No Freezing'};
cohmin_for_plot=0.4;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%  MEAN SPECTRA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% remove data for Epoch below th_for plot (mimimum time window to take into consideration) : transform into NaN
for i=1:length(structlist)
    SpInfo=squeeze(MatInfo(:,i,:));
    for man=1:length(Dir.path)
        if SpInfo(man,3)<th_for_plot
            MatSpF(man,i,1:length(f))=NaN;
        end
        if SpInfo(man,4)<th_for_plot
            MatSpNoF(man,i,1:length(f))=NaN;
        end        
    end
end

% superpose group spectra for conditions
figure('Color',[1 1 1],'Position', [100 10 1600 900])
colori=jet(length(nameMice));
colori=colori-0.1;
colori(colori<0)=0;
namecolmn={'Freezing','No Freezing','Freezing','No Freezing'};
% name MatInfo: nGroup nMice duration(FreezeEpoch) duration(TotEpoch-FreezeEpoch);
clear SpF SpNoF SpInfo

for i=1:length(structlist)
    
    SpF=squeeze(MatSpF(:,i,:));
    SpNoF=squeeze(MatSpNoF(:,i,:));
    SpInfo=squeeze(MatInfo(:,i,:));
    legF=[];legNoF=[];
    for man=1:length(Dir.path)
        try
            if SpInfo(man,3)>th_for_plot           
                subplot(length(structlist),6,6*(i-1)+[1:2]),hold on,
                plot(f,SpF(man,:),'Color',colori(SpInfo(man,2),:));
                %plot(f,SpF(man,:),'Color',colori{SpInfo(man,2)});
                ylabel(structlist{i});xlim([params.fpass]);ylim([cohmin_for_plot 1]);

                legF=[legF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfo(man,3))),'s']}];
            end
        end
        
        try
            if SpInfo(man,4)>th_for_plot     
                subplot(length(structlist),6,6*(i-1)+[3:4]),hold on,
                %plot(f,SpNoF(man,:),'Color',colori{SpInfo(man,2)});
                plot(f,SpNoF(man,:),'Color',colori(SpInfo(man,2),:));
                xlim([params.fpass]);ylim([cohmin_for_plot 1]);
                legNoF=[legNoF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(SpInfo(man,4))),'s']}];
            end
        end
    end
    
    subplot(length(structlist),6,6*(i-1)+[1:2]),
    aa=1;
    while ~exist('confC')
        list=dir([Dir.path{aa} '/CohgramcData']);
        confCtemp=load([Dir.path{aa},'/CohgramcData' suffix '/' list(end).name], 'confC');
        confC=confCtemp.confC;
        aa=aa+1;
    end
    plot([params.fpass], [confC confC], ':', 'Color', [0.7 0.7 0.7])
    if i==1 
           title(namecolmn{1})
           titleF2=struct2comp;titleF2(strfind(struct2comp, '_'))=' ';
           text(-0.5,1.15, titleF2)
    end
    legend(legF,'Location','EastOutside');
    if i==length(structlist), 
    xlabel('Frequency (Hz)');
    Y=ylim;
    text(0,Y(1)-0.5*(Y(2)-Y(1)), ['minimum time to take into account an epoch : ' num2str(th_for_plot) ' sec'])
    end
   
    subplot(length(structlist),6,6*(i-1)+[3:4]),
    plot([params.fpass], [confC confC], ':', 'Color', [0.7 0.7 0.7])
    if i==1
        title(namecolmn{2})
    end
    legend(legNoF,'Location','EastOutside');
    if i==length(structlist), xlabel('Frequency (Hz)');end
    

end


clear SpF SpNoF SpInfo tempSpF temp tempSpNoF 
% %%%%%%%%%%%%%%%%%%%% pool mice before pooling groups %%%%%%%%%%%%%%%%%%%%
for mi=1:length(nameMice)
    for i=1:length(structlist)
        ind=find(strcmp(Dir.name,nameMice{mi}));
        %try
            temp=squeeze(MatSpF(ind,i,:)); if length(ind)==1,temp=temp';end
            tempSpF(mi,i,1:length(f))=nanmean(temp,1);
            temp=squeeze(MatSpNoF(ind,i,:)); if length(ind)==1,temp=temp';end
            tempSpNoF(mi,i,1:length(f))=nanmean(temp,1);
            infoG(mi,i)=unique(Dir.group(ind));
        %end
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%% pool mice in groups %%%%%%%%%%%%%%%%%%%%
for gg=1:length(nameGroups),
    ind=Dir.name(find(strcmp(Dir.group,nameGroups{gg})));
    namecolmn=[namecolmn,{[nameGroups{gg},' (n=',num2str(sum(strcmp(infoG(:,1),nameGroups{gg}))),')']}];
end

colorG={'r', 'b', 'k'};
for i=1:length(structlist)
    NmiceF=nan(1,length(nameGroups));
    NmiceNoF=nan(1,length(nameGroups));
    for gg=1:length(nameGroups)
        ind=find(strcmp(infoG(:,i),nameGroups{gg}));
        SpF=squeeze(tempSpF(ind,i,:)); if length(ind)==1,SpF=SpF';end
        SpNoF=squeeze(tempSpNoF(ind,i,:)); if length(ind)==1,SpNoF=SpNoF';end
        NmiceF(gg)=sum(~isnan(SpF(:,2)),1); % 2 : car 1ere col remplie de Nan
        NmiceNoF(gg)=sum(~isnan(SpNoF(:,1)),1);
        subplot(length(structlist),6,6*(i-1)+5),hold on,
        plot(f,nanmean(SpF,1),'Color',colorG{gg},'Linewidth',2);
        plot(f,nanmedian(SpF,1),'--','Color',colorG{gg},'Linewidth',1);
        xlim([params.fpass]);ylim([cohmin_for_plot 1]);
        subplot(length(structlist),6,6*i),hold on,
        plot(f,nanmean(SpNoF,1),'Color',colorG{gg},'Linewidth',2);
        plot(f,nanmedian(SpNoF,1),'--','Color',colorG{gg},'Linewidth',1);
        ylim([cohmin_for_plot 1]);
        xlim([params.fpass]);
        
    end
    
    if i==length(structlist), legend('OBX', 'OBX med', 'CTRL', 'CTRL med');end
    subplot(length(structlist),6,6*(i-1)+5),hold on,
    plot([params.fpass], [confC confC], ':', 'Color', [0.5 0.5 0.5])
    xlabel([ num2str(NmiceNoF(2)) ' CTRL ' num2str(NmiceNoF(1)) ' OBX '])
    subplot(length(structlist),6,6*i),hold on,
    plot([params.fpass], [confC confC], ':', 'Color', [0.5 0.5 0.5])
    xlabel([ num2str(NmiceF(2)) ' CTRL ' num2str(NmiceF(1)) ' OBX '])
end
for si=5:6,  subplot(length(structlist),6,si), title(namecolmn{si-4});end;
%for si=5:6,  subplot(length(structlist),6,(length(structlist)-1)*6+si), xlabel('Frequency (Hz)');end;
saveas (gcf, [pwd '/Coh' suffix '_' struct2comp '_AllStt.fig'])
saveFigure(gcf,['Coh' suffix '_' struct2comp '_AllStt'],pwd)

