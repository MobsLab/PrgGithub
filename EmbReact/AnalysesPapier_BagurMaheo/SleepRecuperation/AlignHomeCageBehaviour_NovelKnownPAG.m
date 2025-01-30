clear all
Folder.Cond = PathForExperimentsERC('UMazePAG');
Folder.Known = PathForExperimentsERC('Known');
Folder.Novel = PathForExperimentsERC('Novel');
MouseGroup = fieldnames(Folder);
NumGroups = length(MouseGroup);
Session_type={'sleep_pre','sleep_post'};
MergeForLatencyCalculation = [1,5,10,15,20:10:60];
Cols = {'k','r','m'};
clear Prop_time MeanDur_time EpNum_time Prop MeanDur EpNum
for group=3:length(MouseGroup)
    disp(MouseGroup{group})
    for mouse=1:length(Folder.(MouseGroup{group}).path)
        cd(Folder.(MouseGroup{group}).path{mouse}{1})
        if ~exist('AlignedCagePos.mat')
        % Get sleep info
        clear Wake REMEpoch SWSEpoch Tot
        load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','tsdMovement')
        Wake_All = Wake - TotalNoiseEpoch;
        REMEpoch_All = REMEpoch - TotalNoiseEpoch;
        SWSEpoch_All = SWSEpoch - TotalNoiseEpoch;
        Tot_All = or(Wake,or(SWSEpoch,REMEpoch));
        % Get pre and post periods
        clear ExpeInfo TTLInfo
        load('ExpeInfo.mat')
        load('behavResources.mat','TTLInfo','Xtsd','Ytsd')
             load('behavResources.mat','TTLInfo','SessionEpoch')
        
        Epoch.sleep_pre  = SessionEpoch.PreSleep;
        Epoch.sleep_post= SessionEpoch.PostSleep;
        subplot(121)
        plot(Data(Restrict(Xtsd,Epoch.sleep_pre)),Data(Restrict(Ytsd,Epoch.sleep_pre)))
        xlim([0 60])
        ylim([0 60])
        axis square
        subplot(122)
        plot(Data(Restrict(Xtsd,Epoch.sleep_post)),Data(Restrict(Ytsd,Epoch.sleep_post)))
        xlim([0 60])
        ylim([0 60])
        axis square
        keyboard
        end
    end
end


%%% Do realignement
%% WIth reference frame

clf
clear AlignedYtsd AlignedXtsd
load('behavResources-01.mat')
sess = 1;
imagesc(ref)
hold on
Xtemp = Ytsd;
Ytsd = Xtsd;
Xtsd = Xtemp;

plot(Data((Xtsd))*Ratio_IMAonREAL,Data((Ytsd))*Ratio_IMAonREAL)
caxis([-0.1 0.4])
colormap gray
[x,y]  = ginput(3);

Coord1 = [x(2)-x(1),y(2)-y(1)];
Coord2 = [x(3)-x(1),y(3)-y(1)];
TranssMat = [Coord1',Coord2'];

XInit = Data((Xtsd)).*Ratio_IMAonREAL-x(1);
YInit = Data((Ytsd)).*Ratio_IMAonREAL-y(1);


% The Xtsd and Ytsd in new coordinates
A = ((pinv(TranssMat)*[XInit,YInit]')');
AlignedXtsd.(Session_type{sess}) = tsd(Range(Xtsd),40*A(:,1));
AlignedYtsd.(Session_type{sess}) = tsd(Range(Ytsd),20*A(:,2));
clf
%
%             subplot(2,10,(group-1)*10+mouse)
plot(Data((AlignedYtsd.(Session_type{sess}))),Data((AlignedXtsd.(Session_type{sess}))))
xlim([0 20])
ylim([0 40])

load('behavResources-11.mat')
sess = 2;
imagesc(ref)
hold on
Xtemp = Ytsd;
Ytsd = Xtsd;
Xtsd = Xtemp;

plot(Data((Xtsd))*Ratio_IMAonREAL,Data((Ytsd))*Ratio_IMAonREAL)
caxis([-0.3 0.3])
colormap gray
[x,y]  = ginput(3);

Coord1 = [x(2)-x(1),y(2)-y(1)];
Coord2 = [x(3)-x(1),y(3)-y(1)];
TranssMat = [Coord1',Coord2'];

XInit = Data((Xtsd)).*Ratio_IMAonREAL-x(1);
YInit = Data((Ytsd)).*Ratio_IMAonREAL-y(1);


% The Xtsd and Ytsd in new coordinates
A = ((pinv(TranssMat)*[XInit,YInit]')');
AlignedXtsd.(Session_type{sess}) = tsd(Range(Xtsd),40*A(:,1));
AlignedYtsd.(Session_type{sess}) = tsd(Range(Ytsd),20*A(:,2));
clf
%
%             subplot(2,10,(group-1)*10+mouse)
plot(Data((AlignedYtsd.(Session_type{sess}))),Data((AlignedXtsd.(Session_type{sess}))))
xlim([0 20])
ylim([0 40])






save('AlignedCagePos.mat', 'AlignedYtsd','AlignedXtsd')



%% No reference frame
clf
clear AlignedYtsd AlignedXtsd
for sess = 1:2
    satisfied = 0;
    while satisfied==0
        plot(Data(Restrict(Xtsd,Epoch.(Session_type{sess}))),Data(Restrict(Ytsd,Epoch.(Session_type{sess}))))
        xlim([0 80])
        ylim([0 80])
        [x,y]  = ginput(3);
        
        Coord1 = [x(2)-x(1),y(2)-y(1)];
        Coord2 = [x(3)-x(1),y(3)-y(1)];
        TranssMat = [Coord1',Coord2'];
        XInit = Data(Restrict(Xtsd,Epoch.(Session_type{sess})))-x(1);
        YInit = Data(Restrict(Ytsd,Epoch.(Session_type{sess})))-y(1);
        
        % The Xtsd and Ytsd in new coordinates
        A = ((pinv(TranssMat)*[XInit,YInit]')');
        AlignedXtsd.(Session_type{sess}) = tsd(Range(Restrict(Xtsd,Epoch.(Session_type{sess}))),40*A(:,1));
        AlignedYtsd.(Session_type{sess}) = tsd(Range(Restrict(Xtsd,Epoch.(Session_type{sess}))),20*A(:,2));
        clf
        %
        %             subplot(2,10,(group-1)*10+mouse)
        plot(Data(Restrict(AlignedYtsd.(Session_type{sess}),Epoch.(Session_type{sess}))),Data(Restrict(AlignedXtsd.(Session_type{sess}),Epoch.(Session_type{sess}))))
        xlim([0 20])
        ylim([0 40])
        
        satisfied = input('happy?')
        
    end
end

save('AlignedCagePos.mat', 'AlignedYtsd','AlignedXtsd')
