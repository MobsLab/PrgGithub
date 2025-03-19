for k=1:length(SessOfInterest)
    disp('SubSession{k}')
    for l=1:max([length(SubSession{k}),1])
        if not(isempty(findstr(FolderNameAllUMaze{1}{k,l},'/EmbReact/')))
            FolderNameAllUMaze{1}{k,l}=strrep(FolderNameAllUMaze{1}{k,l},'/EmbReact/','/ProjectEmbReac/');
        end
        
        cd(FolderNameAllUMaze{1}{k,l})
        
        clear im_diff PosMat Vtsd Zone pixratio
        %% Get all data for time stamps
        load([cd filesep 'behavResources.mat'],'im_diff','PosMat','pixratio','Zone')
        try im_diff;
        catch
            load([cd filesep 'Behavior.mat'],'im_diff','PosMat','pixratio','Zone')
        end
        
        tps=PosMat(:,1);
        PosMatOriginal=PosMat;
        im_diffOriginal=tps;
        clear im_diff PosMat Vtsd
        
        %% load new data
        if exist('ResultsTrackinfOfflineBis.mat')
            copyfile('ResultsTrackinfOfflineBis.mat','ResultsTrackinfOffline.mat')
            delete('ResultsTrackinfOfflineBis.mat')
        end
        load('ResultsTrackinfOffline.mat')
        
        % Sort out PosMat
        PosMatOriginal(:,2)=PosMat(:,1)*pixratio;
        PosMatOriginal(:,3)=PosMat(:,2)*pixratio;
        PosMat=PosMatOriginal;
        % correct for nans
        PosMatInt=PosMat;
        x=PosMatInt(:,2);
        nanx = isnan(x);
        t    = 1:numel(x);
        x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
        if isnan(x(1))
            x(1:find(not(isnan(x)),1,'first'))=x(find(not(isnan(x)),1,'first'));
        end
        if isnan(x(end))
            x(find(not(isnan(x)),1,'last'):end)=x(find(not(isnan(x)),1,'last'));
        end
        
        PosMatInt(:,2)=x;
        x=PosMatInt(:,3);
        nanx = isnan(x);
        t    = 1:numel(x);
        x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
        if isnan(x(1))
            x(1:find(not(isnan(x)),1,'first'))=x(find(not(isnan(x)),1,'first'));
        end
        if isnan(x(end))
            x(find(not(isnan(x)),1,'last'):end)=x(find(not(isnan(x)),1,'last'));
        end
        PosMatInt(:,3)=x;
        PosMat=PosMatInt;
        % changed in August 2018 - speed was not speed!
        %Vtsd=tsd(PosMat(1:end-1,1)*1e4,sqrt(diff(PosMat(:,2)).^2+diff(PosMat(:,3)).^2));
        Vtsd=tsd(PosMat(1:end-1,1)*1e4,sqrt(diff(PosMat(:,2)).^2+diff(PosMat(:,3)).^2)./diff(PosMat(1:end,1)));
        
        Xtsd=tsd(PosMat(:,1)*1e4,(PosMat(:,2)));
        Ytsd=tsd(PosMat(:,1)*1e4,(PosMat(:,3)));
        clear PosMatInt PosMatOriginal Vtsd
        
        % Sort out im_diff
        im_diffOriginal(:,2)=im_diff;
        im_diff=im_diffOriginal;
        %deal zith nans
        im_diffint=im_diff;
        x=im_diffint(:,2);
        nanx = isnan(x);
        t    = 1:numel(x);
        x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
        x(isnan(x))=nanmean(x);
        im_diffint(:,2)=x;
        im_diff=im_diffint;
        ImDiffTsd=tsd(tps*1e4,runmean(im_diff(:,2),smoofact));
        clear im_diffint im_diffOriginal
        
        % Freezing
        
        FreezeEpoch=thresholdIntervals(ImDiffTsd,th_immob,'Direction','Below');
        FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1e4);
        if DoSave
            % Behav Vars
            Xtemp=Data(Xtsd); Ytemp=Data(Ytsd); T1=Range(Ytsd);
            for t=1:length(Zone)
                ZoneIndices{t}=find(diag(Zone{t}((floor(Data(Ytsd)./pixratio)),(floor(Data(Xtsd)./pixratio)))));
                Xtemp2=Xtemp*0;
                Xtemp2(ZoneIndices{t})=1;
                ZoneEpoch{t}=thresholdIntervals(tsd(T1,Xtemp2),0.5,'Direction','Above');
                Occup(t)=size(ZoneIndices{t},1)./size(Data(Xtsd),1);
                FreezeTime(t)=length(Data(Restrict(Xtsd,and(FreezeEpoch,ZoneEpoch{t}))))./length(Data((Restrict(Xtsd,ZoneEpoch{t}))));
            end
        end
        %GlobalFigure
        subplot(length(SessOfInterest),5,(k-1)*5+l)
        if DoPosition
            plot(Data(Xtsd),Data(Ytsd))
        else
            plot(Range((ImDiffTsd)),Data(ImDiffTsd))
            hold on
            plot(Range(Restrict(ImDiffTsd,FreezeEpoch)),Data(Restrict(ImDiffTsd,FreezeEpoch)));
            line(xlim,[1 1]*th_immob,'color','r')
            ylim([0 0.1])
        end
        if DoSave
            %save
            cd ..
            cd ..
            try
                copyfile('behavResources.mat','behavResourcesNewTracking.mat')
                save('behavResourcesNewTracking.mat','PosMat','im_diff','FreezeTime','smoofact','Occup','ZoneIndices','ZoneEpoch','Ytsd','Xtsd','th_immob','-append')
            catch
                save('behavResourcesNewTracking.mat','PosMat','im_diff','FreezeTime','smoofact','Occup','ZoneIndices','ZoneEpoch','Ytsd','Xtsd','th_immob')
            end
            clear im_diff PosMat Vtsd FreezeTime Occup ZoneIndices ZoneEpoch tps PosMatOriginal im_diffOriginal pixratio Zone
        end
    end
end
if DoSave
    saveas(1,[FolderName,'/BehavUMazeOverall.fig'])
end