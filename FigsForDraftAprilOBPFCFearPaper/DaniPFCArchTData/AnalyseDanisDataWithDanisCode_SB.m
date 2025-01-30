clear all
cd /home/vador/Downloads/DaniData
load('sophie.mat');

indGFP=[];indArch=[];
for i=1:length(dataOF)
    if dataOF(i).isGFP==0
        indArch=[indArch,i];
    else
        indGFP=[indGFP,i];
    end
end
auxV={indGFP,indArch};

%% Speed analyses (copiado de temp_analysisofT5...)

%params
blocksize=4;windFz=30;PreWinFz=10;
smoothWnd=0.1; %filtering the speed
binFzMat=0.01;  %bin for fz matrix across trials
fzThreshold=2;minFzDur=1;minNonFzMerge=0.1;
% changed minFzDur to agree with paper --> 2s
stepsize = 2;

StimTypeVals = {'JustCSPlStim','JustcCSMnStim','JustCSPlNoStim','JustCSMnNoStim','AllStim','AllNoStim'};
%aux
tmFzMat=-PreWinFz+binFzMat:binFzMat:windFz;
clear fzByTrial fzDyn;
for cond=1:length(auxV)
    for i=1:length(auxV{cond})
        
        %&&&&&&&&&&&&&&&&&&&
        %freezingstuff
        dataOFAux=dataOF(auxV{cond}(i));
        [speed,pos]=getSpeed3(dataOFAux.track); 
        speed.or=speed.val;
        dt=speed.tm(2)-speed.tm(1);
        speed.val=filtfilt(ones(1,floor(smoothWnd./dt))/floor(smoothWnd./dt),1,speed.val);  %smoothing the speed traces
        auxFzTm=speed.tm(1):binFzMat:speed.tm(end);
        [fz,~]=getFZIntervals(speed.tm,speed.or,fzThreshold,minFzDur,minNonFzMerge);
        
        auxFz=zeros(1,length(auxFzTm));
        for j=1:size(fz,1)
            indAux=find(auxFzTm>=fz(j,1) & auxFzTm<=fz(j,2));
            auxFz(indAux)=ones(1,length(indAux));
        end
        
        Freezetsd = tsd(auxFzTm*1e4,auxFz');
        FreezeEpoch = thresholdIntervals(Freezetsd,0.5,'Direction','Above');
        tps = [0:stepsize:1000]*1e4;
        FakeData = tsd((tps),[1:length(tps)]');
        
        
        for StimType=1:6
            
            if StimType==1
                StimEpoc = intervalSet((dataOFAux.csPBeg(5:8)-2)*1e4,(dataOFAux.csPBeg(5:8)+7)*1e4);
            elseif StimType==2
                StimEpoc = intervalSet((dataOFAux.csMBeg(5:8)-2)*1e4,(dataOFAux.csMBeg(5:8)+7)*1e4);
            elseif StimType==3
                StimEpoc = intervalSet((dataOFAux.csPBeg(1:4)-2)*1e4,(dataOFAux.csPBeg(1:4)+7)*1e4);
            elseif StimType==4
                StimEpoc = intervalSet((dataOFAux.csMBeg(1:4)-2)*1e4,(dataOFAux.csMBeg(1:4)+7)*1e4);
            elseif StimType==5
                StimEpoc = intervalSet((dataOFAux.csPBeg(5:8)-2)*1e4,(dataOFAux.csPBeg(5:8)+7)*1e4);
                StimEpoc2 = intervalSet((dataOFAux.csMBeg(5:8)-2)*1e4,(dataOFAux.csMBeg(5:8)+7)*1e4);
                StimEpoc = or(StimEpoc2,StimEpoc);
            elseif StimType==6
                StimEpoc = intervalSet((dataOFAux.csPBeg(1:4)-2)*1e4,(dataOFAux.csPBeg(1:4)+7)*1e4);
                StimEpoc2 = intervalSet((dataOFAux.csMBeg(1:4)-2)*1e4,(dataOFAux.csMBeg(1:4)+7)*1e4);
                StimEpoc = or(StimEpoc2,StimEpoc);
            end
            
            BinData_FZ_ind = Data(Restrict(FakeData,FreezeEpoch));
            BinData_FZ_val = zeros(1,length(tps));
            BinData_FZ_val(BinData_FZ_ind)=1;
            BinData_FZ_val_Change=diff(BinData_FZ_val);
            BinData_FZ_val(end)=[];
            
            BinData_FZ_val_Change = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val_Change'),StimEpoc));
            BinData_FZ_val = Data(Restrict(tsd(tps(1:end-1),BinData_FZ_val'),StimEpoc));
            
            StayAct.(StimTypeVals{StimType}){cond}(i) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==0);
            ChangeAct.(StimTypeVals{StimType}){cond}(i) = sum(BinData_FZ_val==0 & BinData_FZ_val_Change==1)/sum(BinData_FZ_val==0);
            StayFz.(StimTypeVals{StimType}){cond}(i)= sum(BinData_FZ_val==1 & BinData_FZ_val_Change==0)/sum(BinData_FZ_val==1);
            ChangeFz.(StimTypeVals{StimType}){cond}(i) = sum(BinData_FZ_val==1 & BinData_FZ_val_Change==-1)/sum(BinData_FZ_val==1);
            TotFzDur.(StimTypeVals{StimType}){cond}(i) = nansum(Stop(and(FreezeEpoch,StimEpoc),'s')-Start(and(FreezeEpoch,StimEpoc),'s'))./nansum(Stop(StimEpoc,'s')-Start(StimEpoc,'s'));

        end
                
                
        % CSPlus No Stim
        [M,T] = PlotRipRaw(Freezetsd,dataOFAux.csPBeg(1:4),30*1e3,0,0);
        FreezeTriggered.CSPl.NoStim{cond}(i,:) = M(:,2);
        % CSPlus No Stim
        [M,T] = PlotRipRaw(Freezetsd,dataOFAux.csPBeg(5:8),30*1e3,0,0);
        FreezeTriggered.CSPl.Stim{cond}(i,:) = M(:,2);
        % CSPlus No Stim
        [M,T] = PlotRipRaw(Freezetsd,dataOFAux.csMBeg(1:4),30*1e3,0,0);
        FreezeTriggered.CsMn.NoStim{cond}(i,:) = M(:,2);
        % CSPlus No Stim
        [M,T] = PlotRipRaw(Freezetsd,dataOFAux.csMBeg(5:8),30*1e3,0,0);
        FreezeTriggered.CsMn.Stim{cond}(i,:) = M(:,2);

    end
end

% figure
% subplot(221)
% plot(M(:,1),nanmean(FreezeTriggered.CsMn.NoStim{1}),'k')
% hold on
% plot(M(:,1),nanmean(FreezeTriggered.CsMn.NoStim{2}),'r')
% ylim([0 0.8])
% line([0 0],ylim,'linewidth',3,'color','b')
% title('CS- no stim')
% subplot(222)
% plot(M(:,1),nanmean(FreezeTriggered.CsMn.Stim{1}),'k')
% hold on
% plot(M(:,1),nanmean(FreezeTriggered.CsMn.Stim{2}),'r')
% line([-2 7],[0.45 0.45],'linewidth',3,'color','c')
% ylim([0 0.8])
% line([0 0],ylim,'linewidth',3,'color','b')
% title('CS- stim')
% subplot(223)
% plot(M(:,1),nanmean(FreezeTriggered.CSPl.NoStim{1}),'k')
% hold on
% plot(M(:,1),nanmean(FreezeTriggered.CSPl.NoStim{2}),'r')
% ylim([0 0.8])
% line([0 0],ylim,'linewidth',3,'color','b')
% title('CS+ nostim')
% subplot(224)
% plot(M(:,1),nanmean(FreezeTriggered.CSPl.Stim{1}),'k')
% hold on
% plot(M(:,1),nanmean(FreezeTriggered.CSPl.Stim{2}),'r')
% line([-2 7],[0.45 0.45],'linewidth',3,'color','c')
% ylim([0 0.8])
% line([0 0],ylim,'linewidth',3,'color','b')
% title('CS+ stim')

clf
for StimType=1:6
    subplot(3,6,1+(StimType-1))
    PlotErrorBarN_KJ(TotFzDur.(StimTypeVals{StimType}),'paired',0,'newfig',0)
    title(StimTypeVals{StimType})
    if StimType ==1
        ylabel('TotFz%')
    end
    subplot(3,6,7+(StimType-1))
    PlotErrorBarN_KJ(StayAct.(StimTypeVals{StimType}),'paired',0,'newfig',0)
    if StimType ==1
        ylabel('PActAct')
    end
    subplot(3,6,13+(StimType-1))
    PlotErrorBarN_KJ(StayFz.(StimTypeVals{StimType}),'paired',0,'newfig',0)
    if StimType ==1
        ylabel('PFzFz')
    end
    
end



%% Downsample the freezing data differently
clear all
cd /home/vador/Downloads/DaniData
load('sophie.mat');

indGFP=[];indArch=[];
for i=1:length(dataOF)
    if dataOF(i).isGFP==0
        indArch=[indArch,i];
    else
        indGFP=[indGFP,i];
    end
end
auxV={indGFP,indArch};

%% Speed analyses (copiado de temp_analysisofT5...)

%params
blocksize=4;windFz=30;PreWinFz=10;
smoothWnd=0.1; %filtering the speed
binFzMat=0.01;  %bin for fz matrix across trials
fzThreshold=2;minFzDur=2;minNonFzMerge=0.1;
% changed minFzDur to agree with paper --> 2s
stepsize = 3;
figure
StimTypeVals = {'JustCSPlStim','JustcCSMnStim','JustCSPlNoStim','JustCSMnNoStim','AllStim','AllNoStim'};
%aux
tmFzMat=-PreWinFz+binFzMat:binFzMat:windFz;
clear fzByTrial fzDyn;
for stepsize = 0.5:0.5:3
    for cond=1:length(auxV)
        for i=1:length(auxV{cond})
            
            %&&&&&&&&&&&&&&&&&&&
            %freezingstuff
            dataOFAux=dataOF(auxV{cond}(i));
            [speed,pos]=getSpeed3(dataOFAux.track);
            speed.or=speed.val;
            dt=speed.tm(2)-speed.tm(1);
            speed.val=filtfilt(ones(1,floor(smoothWnd./dt))/floor(smoothWnd./dt),1,speed.val);  %smoothing the speed traces
            auxFzTm=speed.tm(1):binFzMat:speed.tm(end);
            [fz,~]=getFZIntervals(speed.tm,speed.or,fzThreshold,minFzDur,minNonFzMerge);
            
            auxFz=zeros(1,length(auxFzTm));
            for j=1:size(fz,1)
                indAux=find(auxFzTm>=fz(j,1) & auxFzTm<=fz(j,2));
                auxFz(indAux)=ones(1,length(indAux));
            end
            
            Freezetsd = tsd(auxFzTm*1e4,auxFz');
            BinData_FZ_val = auxFz(5:floor(stepsize./dt):end);
            BinData_FZ_val_Change=diff(BinData_FZ_val);
            BinData_FZ_val(end)=[];
            tps = auxFzTm(5:floor(stepsize./dt):end);
            tps(end) = [];
            FreezeEpoch = thresholdIntervals(Freezetsd,0.5,'Direction','Above');
            
            
            for StimType=1
                
                if StimType==1
                    StimEpoc = intervalSet((dataOFAux.csPBeg(5:8)-2)*1e4,(dataOFAux.csPBeg(5:8)+7)*1e4);
                elseif StimType==2
                    StimEpoc = intervalSet((dataOFAux.csMBeg(5:8)-2)*1e4,(dataOFAux.csMBeg(5:8)+7)*1e4);
                elseif StimType==3
                    StimEpoc = intervalSet((dataOFAux.csPBeg(1:4)-2)*1e4,(dataOFAux.csPBeg(1:4)+7)*1e4);
                elseif StimType==4
                    StimEpoc = intervalSet((dataOFAux.csMBeg(1:4)-2)*1e4,(dataOFAux.csMBeg(1:4)+7)*1e4);
                elseif StimType==5
                    StimEpoc = intervalSet((dataOFAux.csPBeg(5:8)-2)*1e4,(dataOFAux.csPBeg(5:8)+7)*1e4);
                    StimEpoc2 = intervalSet((dataOFAux.csMBeg(5:8)-2)*1e4,(dataOFAux.csMBeg(5:8)+7)*1e4);
                    StimEpoc = or(StimEpoc2,StimEpoc);
                elseif StimType==6
                    StimEpoc = intervalSet((dataOFAux.csPBeg(1:4)-2)*1e4,(dataOFAux.csPBeg(1:4)+7)*1e4);
                    StimEpoc2 = intervalSet((dataOFAux.csMBeg(1:4)-2)*1e4,(dataOFAux.csMBeg(1:4)+7)*1e4);
                    StimEpoc = or(StimEpoc2,StimEpoc);
                end
                
                
                BinData_FZ_val_Change_temp = Data(Restrict(tsd(tps(1:end)*1e4,BinData_FZ_val_Change'),StimEpoc));
                BinData_FZ_val_temp = Data(Restrict(tsd(tps(1:end)*1e4,BinData_FZ_val'),StimEpoc));
                TotFzDur.(StimTypeVals{StimType}){cond}(i) = nansum(Stop(and(FreezeEpoch,StimEpoc),'s')-Start(and(FreezeEpoch,StimEpoc),'s'))./nansum(Stop(StimEpoc,'s')-Start(StimEpoc,'s'));
                if  TotFzDur.(StimTypeVals{StimType}){cond}(i)>0
                    StayAct.(StimTypeVals{StimType}){cond}(i) = sum(BinData_FZ_val_temp==0 & BinData_FZ_val_Change_temp==0)/sum(BinData_FZ_val_temp==0);
                    ChangeAct.(StimTypeVals{StimType}){cond}(i) = sum(BinData_FZ_val_temp==0 & BinData_FZ_val_Change_temp==1)/sum(BinData_FZ_val_temp==0);
                    StayFz.(StimTypeVals{StimType}){cond}(i)= sum(BinData_FZ_val_temp==1 & BinData_FZ_val_Change_temp==0)/sum(BinData_FZ_val_temp==1);
                    ChangeFz.(StimTypeVals{StimType}){cond}(i) = sum(BinData_FZ_val_temp==1 & BinData_FZ_val_Change_temp==-1)/sum(BinData_FZ_val_temp==1);
                else
                    StayAct.(StimTypeVals{StimType}){cond}(i) = NaN;
                    ChangeAct.(StimTypeVals{StimType}){cond}(i) =  NaN;
                    StayFz.(StimTypeVals{StimType}){cond}(i)=  NaN;
                    ChangeFz.(StimTypeVals{StimType}){cond}(i) =  NaN;
                    
                end
            end
            
            
            %         % CSPlus No Stim
            %         [M,T] = PlotRipRaw(Freezetsd,dataOFAux.csPBeg(1:4),30*1e3,0,0);
            %         FreezeTriggered.CSPl.NoStim{cond}(i,:) = M(:,2);
            %         % CSPlus No Stim
            %         [M,T] = PlotRipRaw(Freezetsd,dataOFAux.csPBeg(5:8),30*1e3,0,0);
            %         FreezeTriggered.CSPl.Stim{cond}(i,:) = M(:,2);
            %         % CSPlus No Stim
            %         [M,T] = PlotRipRaw(Freezetsd,dataOFAux.csMBeg(1:4),30*1e3,0,0);
            %         FreezeTriggered.CsMn.NoStim{cond}(i,:) = M(:,2);
            %         % CSPlus No Stim
            %         [M,T] = PlotRipRaw(Freezetsd,dataOFAux.csMBeg(5:8),30*1e3,0,0);
            %         FreezeTriggered.CsMn.Stim{cond}(i,:) = M(:,2);
            
        end
    end
    StimType=1;
    subplot(3,6,stepsize/0.5)
    PlotErrorBarN_KJ(TotFzDur.(StimTypeVals{StimType}),'paired',0,'newfig',0)
    title(StimTypeVals{StimType})
    if StimType ==1
        ylabel('TotFz%')
    end
    subplot(3,6,6+stepsize/0.5)
    PlotErrorBarN_KJ(StayAct.(StimTypeVals{StimType}),'paired',0,'newfig',0)
    if StimType ==1
        ylabel('PActAct')
    end
    subplot(3,6,12+stepsize/0.5)
    PlotErrorBarN_KJ(StayFz.(StimTypeVals{StimType}),'paired',0,'newfig',0)
    if StimType ==1
        ylabel('PFzFz')
    end
    
end
% figure
% subplot(221)
% plot(M(:,1),nanmean(FreezeTriggered.CsMn.NoStim{1}),'k')
% hold on
% plot(M(:,1),nanmean(FreezeTriggered.CsMn.NoStim{2}),'r')
% ylim([0 0.8])
% line([0 0],ylim,'linewidth',3,'color','b')
% title('CS- no stim')
% subplot(222)
% plot(M(:,1),nanmean(FreezeTriggered.CsMn.Stim{1}),'k')
% hold on
% plot(M(:,1),nanmean(FreezeTriggered.CsMn.Stim{2}),'r')
% line([-2 7],[0.45 0.45],'linewidth',3,'color','c')
% ylim([0 0.8])
% line([0 0],ylim,'linewidth',3,'color','b')
% title('CS- stim')
% subplot(223)
% plot(M(:,1),nanmean(FreezeTriggered.CSPl.NoStim{1}),'k')
% hold on
% plot(M(:,1),nanmean(FreezeTriggered.CSPl.NoStim{2}),'r')
% ylim([0 0.8])
% line([0 0],ylim,'linewidth',3,'color','b')
% title('CS+ nostim')
% subplot(224)
% plot(M(:,1),nanmean(FreezeTriggered.CSPl.Stim{1}),'k')
% hold on
% plot(M(:,1),nanmean(FreezeTriggered.CSPl.Stim{2}),'r')
% line([-2 7],[0.45 0.45],'linewidth',3,'color','c')
% ylim([0 0.8])
% line([0 0],ylim,'linewidth',3,'color','b')
% title('CS+ stim')
% 
% clf
% for StimType=1:6
%     subplot(3,6,1+(StimType-1))
%     PlotErrorBarN_KJ(TotFzDur.(StimTypeVals{StimType}),'paired',0,'newfig',0)
%     title(StimTypeVals{StimType})
%     if StimType ==1
%         ylabel('TotFz%')
%     end
%     subplot(3,6,7+(StimType-1))
%     PlotErrorBarN_KJ(StayAct.(StimTypeVals{StimType}),'paired',0,'newfig',0)
%     if StimType ==1
%         ylabel('PActAct')
%     end
%     subplot(3,6,13+(StimType-1))
%     PlotErrorBarN_KJ(StayFz.(StimTypeVals{StimType}),'paired',0,'newfig',0)
%     if StimType ==1
%         ylabel('PFzFz')
%     end
%     
% end
% 
% 
%         