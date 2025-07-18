

clear all

%% input dir
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_for_SB/DZP_Sess.mat', 'SleepSession')

%% GET DATA - ctrl group (mCherry saline injection 10h without stress)
clear SFI LatencyToState
time_start = 0*3600*1e4; % first hour
time_end = 1*3600*1e4; % first hour
for i=1:length(SleepSession(1,:,2))
    cd(SleepSession{1,i,2}{1});
    disp(SleepSession{1,i,2}{1})
    clear AlignedXtsd AlignedYtsd
    load('behavResources.mat')
    if 1%exist('AlignedCagePos.mat')==0
        
        % Sleep states
        try
            load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','tsdMovement')
        catch
            load('StateEpochSB.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','tsdMovement')
        end
        Wake = or(Wake,TotalNoiseEpoch);
        REMEpoch = REMEpoch - TotalNoiseEpoch;
        SWSEpoch = SWSEpoch - TotalNoiseEpoch;
        Tot = or(Wake,or(SWSEpoch,REMEpoch));
        %         FirstSleep = min(Start(dropShortIntervals(SWSEpoch,1*1e4)));
        %         PreSleep = intervalSet(0,FirstSleep);
        
        satisfied = 0;
        
        while satisfied ==0
            % Behaviour
            %             a=dir('*.avi');
            %             v = VideoReader(a.name);
            %             firstFrame = read(v,1);
            clear Behav AlignedXtsd AlignedYtsd Ratio_IMAonREAL mask
            load('behavResources_SB.mat', 'Behav')
            load('behavResources.mat', 'Ratio_IMAonREAL')
            load('behavResources.mat', 'mask')
            %             clf
            %             imagesc((squeeze(firstFrame(:,:,1)).*mask)')
            %             hold on
            %             plot(Data(Behav.Xtsd)*Ratio_IMAonREAL,Data(Behav.Ytsd)*Ratio_IMAonREAL)
            % %             plot(Data(Restrict(Behav.Xtsd,SWSEpoch))*Ratio_IMAonREAL,Data(Restrict(Behav.Ytsd,SWSEpoch))*Ratio_IMAonREAL,'r')            % Transformation of coordinates
            %             colormap gray
            %             [x,y]  = ginput(3);
            
            polygon = GetCageEdgesWithVideo;
            x = polygon.Position(:,2);
            y = polygon.Position(:,1);
            if abs(x(1)-x(2))<abs(x(3)-x(2))
                Coord1 = [x(1)-x(2),y(1)-y(2)];
                Coord2 = [x(3)-x(2),y(3)-y(2)];
            else
                Coord2 = [x(1)-x(2),y(1)-y(2)];
                Coord1 = [x(3)-x(2),y(3)-y(2)];
            end
            TranssMat = [Coord1',Coord2'];
            XInit = Data(Behav.Xtsd).*Ratio_IMAonREAL-x(2);
            YInit = Data(Behav.Ytsd).*Ratio_IMAonREAL-y(2);
            
            % The Xtsd and Ytsd in new coordinates
            A = ((pinv(TranssMat)*[XInit,YInit]')');
            AlignedXtsd = tsd(Range(Behav.Xtsd),40*A(:,1));
            AlignedYtsd = tsd(Range(Behav.Ytsd),20*A(:,2));
            clf
            %
            %             subplot(2,10,(group-1)*10+mouse)
            plot(Data(AlignedYtsd),Data(AlignedXtsd))
            %             hold on
            %             plot(Data(Restrict(AlignedYtsd,SWSEpoch)),Data(Restrict(AlignedXtsd,SWSEpoch)),'r')
            xlim([0 20])
            ylim([0 40])
            
            satisfied = input('happy?')
            
        end
        save('AlignedCagePos_BM2.mat', 'AlignedYtsd','AlignedXtsd')
    end
end


%%
GetAllSalineSessions_BM
Mouse = Drugs_Groups_UMaze_BM(22);
clear Mouse_names

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try % are you sure ?
        UMazeSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
        SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
        if length(UMazeSleepSess.(Mouse_names{mouse}))==3
            SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            SleepPostPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
            SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(3);
        else
            try
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
            catch % for 11203... grrr
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            end
        end
    end
end


clear SFI LatencyToState
time_start = 0*3600*1e4; % first hour
time_end = 1*3600*1e4; % first hour
for i=9:length(Mouse)
    cd(SleepPostSess.(Mouse_names{i}){1});
    disp(SleepPostSess.(Mouse_names{i}){1})
    clear AlignedXtsd AlignedYtsd
    load('behavResources.mat')
    if 1%exist('AlignedCagePos.mat')==0
        
        % Sleep states
        try
            load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','tsdMovement')
        catch
            load('StateEpochSB.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','tsdMovement')            
        end
        Wake = or(Wake,TotalNoiseEpoch);
        REMEpoch = REMEpoch - TotalNoiseEpoch;
        SWSEpoch = SWSEpoch - TotalNoiseEpoch;
        Tot = or(Wake,or(SWSEpoch,REMEpoch));
%         FirstSleep = min(Start(dropShortIntervals(SWSEpoch,1*1e4)));
%         PreSleep = intervalSet(0,FirstSleep);
        
        satisfied = 0;
        
        while satisfied ==0
            % Behaviour
            clear Behav AlignedXtsd AlignedYtsd Ratio_IMAonREAL mask
            load('behavResources_SB.mat', 'Behav')
            load('behavResources.mat', 'Ratio_IMAonREAL')
            load('behavResources.mat', 'mask')
            clf
%             try
%                 a=dir('*.avi');
%                 v = VideoReader(a.name);
%                 firstFrame = read(v,1);
%                 imagesc((squeeze(firstFrame(:,:,1)).*mask)')
%             end
%             
%             hold on
%             plot(Data(Behav.Xtsd)*Ratio_IMAonREAL,Data(Behav.Ytsd)*Ratio_IMAonREAL)
% %             plot(Data(Restrict(Behav.Xtsd,SWSEpoch))*Ratio_IMAonREAL,Data(Restrict(Behav.Ytsd,SWSEpoch))*Ratio_IMAonREAL,'r')            % Transformation of coordinates
%             colormap gray
%             [x,y]  = ginput(3);
            
              polygon = GetCageEdgesWithVideo;
            x = polygon.Position(:,2);
            y = polygon.Position(:,1);
            if abs(x(1)-x(2))<abs(x(3)-x(2))
                Coord1 = [x(1)-x(2),y(1)-y(2)];
                Coord2 = [x(3)-x(2),y(3)-y(2)];
            else
                Coord2 = [x(1)-x(2),y(1)-y(2)];
                Coord1 = [x(3)-x(2),y(3)-y(2)];
            end
            TranssMat = [Coord1',Coord2'];
            XInit = Data(Behav.Xtsd).*Ratio_IMAonREAL-x(2);
            YInit = Data(Behav.Ytsd).*Ratio_IMAonREAL-y(2);
            
            % The Xtsd and Ytsd in new coordinates
            A = ((pinv(TranssMat)*[XInit,YInit]')');
            AlignedXtsd = tsd(Range(Behav.Xtsd),40*A(:,1));
            AlignedYtsd = tsd(Range(Behav.Ytsd),20*A(:,2));
            clf
            %
            %             subplot(2,10,(group-1)*10+mouse)
            plot(Data(AlignedYtsd),Data(AlignedXtsd))
%             hold on
%             plot(Data(Restrict(AlignedYtsd,SWSEpoch)),Data(Restrict(AlignedXtsd,SWSEpoch)),'r')
            xlim([0 20])
            ylim([0 40])
            
            satisfied = input('happy?')
            
        end
        save('AlignedCagePos_BM2.mat', 'AlignedYtsd','AlignedXtsd')
    end
end






