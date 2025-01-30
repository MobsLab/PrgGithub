% Check behaviour
% display ref, mask, tracking colored as zones, imdiff, check for acce;ero
% and do freezing is need be from accelerom, check ZoneEpochsm merge if
% theres are two sets of tracking

FileNames=GetAllMouseTaskSessions(666);
for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});

    disp(SessNames{ss})
    for d=[15,16,17]
        for dd=1:length(Dir.path{d})
            if not(Dir.ExpeInfo{d}{dd}.nmouse==117)
                cd(Dir.path{d}{dd})
                tempvar=who('-file','behavResources.mat');
                if strcmp(tempvar{1},'Behav')==0
                    clearvars -except Dir d dd ss SessNames
                    disp(Dir.path{d}{dd})
                if exist([cd filesep 'behavResources.mat'])>0
                    load([cd filesep 'behavResources.mat'])
                    if exist('PosMat')>0
                        if size(PosMat,2)==4
                            MatlabStimTimes=tsd(PosMat(:,1)*1e4,PosMat(:,4)*1e4);
                        else
                            MatlabStimTimes=[];
                        end
                    else
                        MatlabStimTimes=[];
                    end
                end
            
                if exist([cd filesep 'behavResourcesNewTracking.mat'])>0
                    load([cd filesep 'behavResourcesNewTracking.mat'])
                end
                
                %% BASIC PARAMETERS
                thtps_immob=2;
                try imageRef; ref=imageRef; clear imageRef; end
                try pixratio; catch,
                    try,
                        pixratio=1/Ratio_IMAonREAL; clear Ratio_IMAonREAL;
                    catch
                        disp('give pixratio')
                        keyboard
                    end
                end
                try, smoofact; catch, smoofact=1;end
                try, thtps_immob; catch, thtps_immob=2;end
                clear Ratio_IMAonREAL imageRef
                
                %% POSMAT & IMDIFF
                if sum(isnan(PosMat(:,2)))>0
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
                    Movtsd=tsd(PosMat(1:end-1,1)*1e4,sqrt(diff(PosMat(:,2)).^2+diff(PosMat(:,3)).^2));
                    Xtsd=tsd(PosMat(:,1)*1e4,(PosMat(:,2)));
                    Ytsd=tsd(PosMat(:,1)*1e4,(PosMat(:,3)));
                    
                    clear PosMatInt PosMatOriginal PosMat
                else
                    Movtsd=tsd(PosMat(1:end-1,1)*1e4,sqrt(diff(PosMat(:,2)).^2+diff(PosMat(:,3)).^2));
                    Xtsd=tsd(PosMat(:,1)*1e4,(PosMat(:,2)));
                    Ytsd=tsd(PosMat(:,1)*1e4,(PosMat(:,3)));
                    clear PosMatInt PosMatOriginal PosMat
                end
                
                if sum(isnan(im_diff(:,2)))>0
                    % Sort out im_diff
                    % deal with nans
                    im_diffint=im_diff;
                    x=im_diffint(:,2);
                    nanx = isnan(x);
                    t    = 1:numel(x);
                    x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
                    x(isnan(x))=nanmean(x);
                    im_diffint(:,2)=x;
                    im_diff=im_diffint;
                    ImDiffTsd=tsd(im_diff(:,1)*1e4,SmoothDec(im_diff(:,2)',smoofact));
                    clear im_diffint im_diff
                else
                    ImDiffTsd=tsd(im_diff(:,1)*1e4,SmoothDec(im_diff(:,2)',smoofact));
                    clear im_diffint im_diff
                end
                clear Imdifftsd
                
                %% FREEZING WITH GOOD VARIABLES
                if exist('MovAcctsd')>0
                    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
                    FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
                    FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
                    FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
                end
                FreezeEpoch=thresholdIntervals(ImDiffTsd,th_immob,'Direction','Below');
                FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
                FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
                
                %% BEHAVIOUR
                Xtemp=Data(Xtsd); Ytemp=Data(Ytsd); T1=Range(Ytsd);
                MissingEpochs=intervalSet(0,max(Range(Xtsd)));
                for t=1:min([length(Zone),5])
                    ZoneIndices{t}=find(diag(Zone{t}((floor(Data(Ytsd)./pixratio)),(floor(Data(Xtsd)./pixratio)))));
                    Xtemp2=Xtemp*0;
                    Xtemp2(ZoneIndices{t})=1;
                    ZoneEpoch{t}=CleanUpEpoch(thresholdIntervals(tsd(T1,Xtemp2),0.5,'Direction','Above'));
                    MissingEpochs=MissingEpochs-ZoneEpoch{t};
                end
                MissingEpochs=CleanUpEpoch(mergeCloseIntervals(MissingEpochs,1*1e4));
                for t=1:min([length(Zone),5])
                    [aft_cell,bef_cell]=transEpoch(MissingEpochs,ZoneEpoch{t});
                    ZoneEpoch{t}=or(ZoneEpoch{t},bef_cell{1,2});
                end
                for t=1:min([length(Zone),5])
                    Occup(t)=size(ZoneIndices{t},1)./size(Data(Xtsd),1);
                    FreezeTime(t)=length(Data(Restrict(Xtsd,and(FreezeEpoch,ZoneEpoch{t}))))./length(Data((Restrict(Xtsd,ZoneEpoch{t}))));
                end
                
                %% TTL INFORMATION
                try
                GetStims
                catch
                   disp('TTL problem') 
                   keyboard
                end
                %% ORGANIZE ALL VARIABLES
                Params.pixratio=pixratio;
                Params.ref=ref;
                Params.thtps_immob=thtps_immob;
                Params.th_immob=th_immob;
                Params.smoofact=smoofact;
                Params.mask=mask;
                Params.Zone=Zone;
                try,MovAcctsd
                    Params.th_immob_Acc=th_immob_Acc;
                    Params.smoofact_Acc=smoofact_Acc;
                catch
                    Params.th_immob_Acc=[];
                    Params.smoofact_Acc=[];
                end
                
                Behav.Movtsd=Movtsd;
                Behav.Xtsd=Xtsd;
                Behav.Ytsd=Ytsd;
                Behav.ImDiffTsd=ImDiffTsd;
                Behav.FreezeEpoch=FreezeEpoch;
                try,MovAcctsd
                    Behav.MovAcctsd=MovAcctsd;
                    Behav.FreezeAccEpoch=FreezeAccEpoch;
                catch
                    Behav.MovAcctsd=[];
                    Behav.FreezeAccEpoch=[];
                end
                Behav.ZoneEpoch=ZoneEpoch;
                Behav.ZoneIndices=ZoneIndices;
                Behav.MatlabStimTimes=MatlabStimTimes;
                
                Results.Occup=Occup;
                Results.FreezeTime=FreezeTime;
                
                %% Global figure
                subplot(4,5,k)
                
                if DoPosition
                    cols=lines(5);
                    for t=1:5
                        plot(Data(Restrict(Xtsd,ZoneEpoch{t})),Data(Restrict(Ytsd,ZoneEpoch{t})),'color',cols(t,:)), hold on
                    end
                    xlim([10 100]),ylim([0 80])
                else
                    plot(Range((ImDiffTsd),'s'),Data(ImDiffTsd))
                    hold on
                    plot(Range(Restrict(ImDiffTsd,FreezeEpoch),'s'),Data(Restrict(ImDiffTsd,FreezeEpoch)));
                    line(xlim,[1 1]*th_immob,'color','r')
                    ylim([0 0.1])
                end
                
                %% FIGURE TO CHECK
                clf
                subplot(121)
                imagesc(ref), hold on, colormap gray
                cols=lines(5);
                for z=1:min([length(Zone),5])
                    plot(Data(Restrict(Xtsd,ZoneEpoch{z}))/pixratio,Data(Restrict(Ytsd,ZoneEpoch{z}))/pixratio,'color',cols(z,:))
                end
                legend({'1','2','3','4','5'})
                subplot(222)
                plot(Range(ImDiffTsd),Data(ImDiffTsd)), hold on
                plot(Range(Restrict(ImDiffTsd,FreezeEpoch)),Data(Restrict(ImDiffTsd,FreezeEpoch))), hold on
                try
                    subplot(224)
                    plot(Range(NewMovAcctsd),Data(NewMovAcctsd)), hold on
                    plot(Range(Restrict(NewMovAcctsd,FreezeAccEpoch)),Data(Restrict(NewMovAcctsd,FreezeAccEpoch))), hold on
                end
                
                keyboard
                %% SAVE EVERYTHING
                mkdir('OldBehavFiles')
                try,movefile('behavResources.mat','OldBehavFiles'),end
                try,movefile('Behavior.mat','OldBehavFiles'),end
                try,movefile('behavResourcesNewTracking.mat','OldBehavFiles'),end
                
                save('behavResources_SB.mat','Behav','Params','Results','TTLInfo')
                end
            end
        end
    end
end