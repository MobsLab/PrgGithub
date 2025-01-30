function [AmpRespi,AmpLfp,TempMatrix]=correlationRespi_LFPML(lfp,TidalVolume,RespiIntervals,numPoints,epoch,ploPETH,savename)

% correlationRespi_LFPML
%
% inputs:
% -lfp = tsd lfp 
% -TidalVolume = tsd amplitude respi
% -RespiIntervals =
% -numPoints =
% -epoch = intervalSet to restrict analysis on
% -ploPETH = 1 if figure is wanted, 0 otherwise
%
% outputs
% -



%% initialisation

if exist('epoch','var')==0
    RangeTemp=Range(TidalVolume);
    epoch=intervalSet(RangeTemp(1),RangeTemp(end));
end

if exist('RespiIntervals','var')==0
    RespiIntervals=0:0.003:0.03;
end

if sum(Stop(epoch)-Start(epoch))==0
    disp('intervalSet is empty!'); error
end

colori={'k' 'r' 'b' 'm' 'c' 'g' 'y' };



%% restrict to epoch

DataAmp=Data(Restrict(TidalVolume,epoch));
RangeAmp=Range(Restrict(TidalVolume,epoch));
RangeAllAmp=Range(TidalVolume);

%% plot PETH

if exist('ploPETH','var') && ploPETH

    tp=RangeAmp;
    figure('Color',[1 1 1]), FigurePETH=gcf;
    [fh, rasterAx, histAx, matVal] = ImagePETH(lfp,ts(tp(20:end-20)), -10000, +15000,'BinSize',1000);
    title('LFP triggered by Respi')
    caxis([-0.5 0.8]/1E3)
    
%     M=Data(matVal)';
%     [fh, rasterAx, histAx, matVal2] = ImagePETH(Restrict(TidalVolume,epoch),ts(tp(20:end-20)), -10000, +15000,'BinSize',1000);close
%     M2=Data(matVal2)';
%     [BE,id2]=sort(mean(M2(:,1000:1100)'));
%     figure('Color',[1 1 1]), subplot(1,2,1)
%     imagesc(Range(matVal),[1:length(id2)],SmoothDec(M(id2,:),[1 2]))
%     title('LFP BO triggered by incrinsing TidalVolume of respi')
%     
end
% ----------------------
            
%% Correlation LFP BO vs Respi

if isempty(RangeAmp)==0
    
    
    if numPoints>length(DataAmp), 
        disp(['Warning: length(TidalVolume)=',num2str(length(DataAmp)),' < numpoints asked=',num2str(numPoints)]);
        index=1:length(DataAmp);
    else
        index=sort(ceil(1:length(DataAmp)/numPoints:length(DataAmp)));
        while length(unique(index))~=length(index)
            index=sort(ceil(rand(1,numPoints)*(length(DataAmp)-1)));
        end
    end
    
    
    % --- mean LFP BO trigged by respi ---
    a=0;
    YlimTemp=[];
    figure('Color',[1 1 1]), FigureTrig=gcf; hold on
    for i=3:2:length(RespiIntervals)
        a=a+1;
        TimeEpoch1=thresholdIntervals(TidalVolume,RespiIntervals(i-2),'Direction','Above');
        TimeEpoch2=thresholdIntervals(TidalVolume,RespiIntervals(i),'Direction','Below');
        TimeEpoch=and(and(TimeEpoch1,TimeEpoch2),epoch);
        TimeEpoch=mergeCloseIntervals(TimeEpoch,5*1E4);
        
        B=Range(Restrict(TidalVolume,TimeEpoch));
        TempMatrix=[];
        for ii=1:length(B)
            if B(ii)-1E4>0, I=intervalSet(B(ii)-1E4,B(ii)+1E4); end
            if B(ii)-1E4>0 && (ii==1 || length((Data(Restrict(lfp,I))))==size(TempMatrix,2)), TempMatrix=[TempMatrix; Data(Restrict(lfp,I))'];end
        end
        if isempty(TempMatrix)==0
            subplot(3,ceil(length(3:2:length(RespiIntervals))/3),a), hold on
            plot([1:size(TempMatrix,2)]/size(TempMatrix,2)*1E3,mean(TempMatrix,1),colori{a})
            if size(TempMatrix,1)>3,
                hold on, plot([1:size(TempMatrix,2)]/size(TempMatrix,2)*1E3,mean(TempMatrix,1)+stdError(TempMatrix),colori{a})
                hold on, plot([1:size(TempMatrix,2)]/size(TempMatrix,2)*1E3,mean(TempMatrix,1)+stdError(TempMatrix),colori{a});
            end
            yyy=ylim; YlimTemp=[YlimTemp yyy];
            
            xlabel(['respi volume in [',num2str(RespiIntervals(i-2)),';',num2str(RespiIntervals(i)),']']);
            ylabel('LFP amplitude')
        end
    end
    % ------------------------------------
    for a=1:length(3:2:length(RespiIntervals))
        subplot(3,ceil(length(3:2:length(RespiIntervals))/3),a)
        %ylim([min(YlimTemp) max(YlimTemp)])
        ylim([-5 10]/1E4)
    end
        
    for i=1:length(index)
        try
            I=intervalSet(RangeAmp(index(i)),RangeAllAmp(find(RangeAllAmp==RangeAmp(index(i)))+1));
            AmpRespi(i)=DataAmp(i);
            %AmpLfp(i)=max(Data(Restrict(lfp,I)))-min(Data(Restrict(lfp,I)));
            AmpLfp(i)=max(Data(Restrict(lfp,I)));
        end
    end
    
end

if exist('savename','var')
    res=pwd;
    if ploPETH
        saveFigure(FigurePETH,['PETH_RespiTrigLFP_',savename],res)
    end
    saveFigure(FigureTrig,['IntervalsAmplitude_meanRespiTrigLFP_',savename],res)
end
