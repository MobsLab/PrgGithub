cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')
close all
figure
figure

for sess = 1:length(Sess.(Mouse_names{1}))
    cd(Sess.(Mouse_names{1}){sess})
    disp(Sess.(Mouse_names{1}){sess})
    clearvars -except sess n AllDat th_immob thtps_immob smoofact_Acc smoofact th_immob_Acc DoSave GlobalFigure DoPosition FolderName Mouse_names Sess MouseToDo
    load('ExpeInfo.mat')
    
    tempvar=who('-file','behavResources.mat');
    if exist([cd filesep 'behavResources.mat'])>0
        clear PosMat
        load([cd filesep 'behavResources.mat'])
        try,PosMat = PosMatInit;end
        if exist('PosMat')>0
            if size(PosMat,2)==4
                MatlabStimTimes=tsd(PosMat(:,1)*1e4,PosMat(:,4)*1e4);
            else
                MatlabStimTimes=[];
            end
        else
            [FileToLoad,PathToLoad] = uigetfile;
            load([PathToLoad,FileToLoad]);
            if size(PosMat,2)==4
                MatlabStimTimes=tsd(PosMat(:,1)*1e4,PosMat(:,4)*1e4);
            else
                MatlabStimTimes=[];
            end
            movefile('behavResources.mat','behavResources_old.mat')
            copyfile([PathToLoad,FileToLoad],'behavResources.mat')
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
        % correct by SB on 05/09/2018 to put in cm/s
        Vtsd=tsd(PosMat(1:end-1,1)*1e4,sqrt(diff(PosMat(:,2)).^2+diff(PosMat(:,3)).^2)./diff(PosMat(:,1)));
        Xtsd=tsd(PosMat(:,1)*1e4,(PosMat(:,2)));
        Ytsd=tsd(PosMat(:,1)*1e4,(PosMat(:,3)));
        
        clear PosMatInt PosMatOriginal PosMat
    else
        % correct by SB on 05/09/2018 to put in cm/s
        Vtsd=tsd(PosMat(1:end-1,1)*1e4,sqrt(diff(PosMat(:,2)).^2+diff(PosMat(:,3)).^2)./diff(PosMat(:,1)));
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
    try % add by BM on 25/01/2021 because for some sessions, ImDiff is not well registered
        FreezeEpoch=thresholdIntervals(ImDiffTsd,th_immob,'Direction','Below');
        FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
        FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);
    end
    %% BEHAVIOUR
    if ExpeInfo.SleepSession==0
        
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
    end
    %% TTL INFORMATION
    if convertCharsToStrings(ExpeInfo.PreProcessingInfo.TypeOfSystem) == 'Intan'
        try
            GetStims
        catch
            disp('TTL problem')
            load('behavResources.mat', 'TTLInfo')
            %keyboard
        end
    else
        % already done
    end
    
    
    %% ORGANIZE ALL VARIABLES
    Params.pixratio=pixratio;
    Params.ref=ref;
    Params.thtps_immob=thtps_immob;
    Params.th_immob=th_immob;
    Params.smoofact=smoofact;
    Params.mask=mask;
    try
        Params.Zone=Zone;
    end
    try,MovAcctsd;
        Params.th_immob_Acc=th_immob_Acc;
        Params.smoofact_Acc=smoofact_Acc;
    catch
        Params.th_immob_Acc=[];
        Params.smoofact_Acc=[];
    end
    
    Behav.Vtsd=Vtsd;
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
    if ExpeInfo.SleepSession==0
        
        Behav.ZoneEpoch=ZoneEpoch;
        Behav.ZoneIndices=ZoneIndices;
        Behav.MatlabStimTimes=MatlabStimTimes;
        
        Results.Occup=Occup;
        Results.FreezeTime=FreezeTime;
    end
    
    %% Global figure
    
    figure(1)
    subplot(6,8,sess)
    cols=lines(5);
    if ExpeInfo.SleepSession==0
        
        for t=1:min([length(ZoneEpoch),5])
            plot(Data(Restrict(Xtsd,ZoneEpoch{t})),Data(Restrict(Ytsd,ZoneEpoch{t})),'color',cols(t,:)), hold on
        end
        xlim([0 100]),ylim([0 80])
    else
        plot(Data(Xtsd),Data(Ytsd))
    end
    title(ExpeInfo.SessionType)
    
    figure(2)
    subplot(6,8,sess)
    plot(Range((Behav.MovAcctsd),'s'),Data(Behav.MovAcctsd))
    hold on
    plot(Range(Restrict(Behav.MovAcctsd,Behav.FreezeAccEpoch),'s'),Data(Restrict(Behav.MovAcctsd,Behav.FreezeAccEpoch)),'r');
    for k=1:length(Start(Behav.FreezeAccEpoch))
        plot(Range(Restrict(MovAcctsd,subset(Behav.FreezeAccEpoch,k)),'s'),Data(Restrict(MovAcctsd,subset(Behav.FreezeAccEpoch,k)))*0+max(ylim)*0.8,'r','linewidth',2)
    end
    line(xlim,[1 1]*th_immob_Acc,'color','r')
    ylim([0 2000000000])
    %         end
    title(ExpeInfo.SessionType)
%     
    %% FIGURE TO CHECK
    
    %         figure
    %         subplot(121)
    %         imagesc(ref), hold on, colormap gray
    %             cols=lines(5);
    %             if ExpeInfo.SleepSession==0
    %                 for z=1:min([length(Zone),5])
    %                     plot(Data(Restrict(Xtsd,ZoneEpoch{z}))/pixratio,Data(Restrict(Ytsd,ZoneEpoch{z}))/pixratio,'color',cols(z,:))
    %                 end
    %                 legend({'Shk','NoShk','Cntr','CtrShk','CtrShk'})
    %             else
    %                 plot(Data(Xtsd)/pixratio,Data(Ytsd)/pixratio)
    %             end
    %
    %             subplot(222)
    %             plot(Range(ImDiffTsd),Data(ImDiffTsd)), hold on
    %             plot(Range(Restrict(ImDiffTsd,FreezeEpoch)),Data(Restrict(ImDiffTsd,FreezeEpoch))), hold on
    %             title('imdiff')
    %             line(xlim,[1 1]*th_immob,'color','c')
    %             ylim([0 1]*percentile(Data(ImDiffTsd),99.5)*1.2)
    %             try
    %                 subplot(224)
    %                 plot(Range(NewMovAcctsd),Data(NewMovAcctsd)), hold on
    %                 plot(Range(Restrict(NewMovAcctsd,FreezeAccEpoch)),Data(Restrict(NewMovAcctsd,FreezeAccEpoch))), hold on
    %                 ylim([0 1]*percentile(Data(NewMovAcctsd),99.5)*1.2)
    %                 line(xlim,[1 1]*th_immob_Acc,'color','c')
    %                 title('acceleration')
    %             end
    
    %% SAVE EVERYTHING
    
    mkdir('OldBehavFiles')
    try,copyfile('behavResources.mat','OldBehavFiles'),end
    try movefile('Behavior.mat','OldBehavFiles'),end
    try,movefile('behavResourcesNewTracking.mat','OldBehavFiles'),end
    % correct by SB on 05/09/2018 to put in cm/s
    SpeedCorrected=1;
    save('SpeedCorrected.mat','SpeedCorrected')
    save('behavResources_SB.mat','Behav','Params')
    
    if ExpeInfo.SleepSession==0
        save('behavResources_SB.mat','Results','TTLInfo','-append')
    end
end

