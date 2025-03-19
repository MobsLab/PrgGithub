%%% PlotPCExamples

load('/home/mobsrick/Dropbox/MOBS_workingON/Dima/Data_temp/SelectedPlaceCells.mat');

%% Durinhg PreExplorations
mazeMap{1} = [10 10; 10 83; 85 83; 85 10; 59 10; 59 65; 38 65; 38 10; 10 10];
mazeMap{2} = [24 15; 24 77; 85 77; 85 15; 63 15;  63 58; 46 58; 46 15; 24 15];
mazeMap{8} = [17 10; 17 85; 86 85; 86 10; 62 10; 62 66; 41 66; 41 10; 17 10];
mazeMap{9} = [10 13; 10 87; 76 87; 76 13; 52 13; 52 64; 34 64; 34 13; 10 13];
mazeMap{10} = [10 12; 10 79; 76 79; 76 12; 52 12; 52 58; 35 58; 35 12; 10 12];

ShockZoneMap{1} = [10 10; 10 42; 38 42; 38 10;10 10];
ShockZoneMap{2} = [24 15; 24 48; 46 48; 46 15; 24 15];
ShockZoneMap{8} = [17 10; 17 43; 41 43; 41 10; 17 10];
ShockZoneMap{9} = [10 13; 10 43; 34 43; 34 13; 10 13];
ShockZoneMap{10} = [10 12; 10 45; 35 45; 35 12; 10 12];

s = 0;
fh = figure('units', 'normalized', 'outerposition', [0 0 1 1]);
for i=1:length(SelectedPlaceCells)
    if ~isempty(SelectedPlaceCells(i).BeforeCond)
        for j = 1:length(SelectedPlaceCells(i).BeforeCond.map)
            s=s+1;
            subplot(4,4,s)
            imagesc(SelectedPlaceCells(i).BeforeCond.map{j}.rate)
            colormap jet
            colorbar
            axis xy
            hold on
            plot(mazeMap{i}(:,1),mazeMap{i}(:,2),'w','LineWidth',3)
            plot(ShockZoneMap{i}(:,1),ShockZoneMap{i}(:,2),'r','LineWidth',3)
            set(gca,'XTickLabel',{},'YTickLabel',{});
            title([SelectedPlaceCells(i).name ' - ' SelectedPlaceCells(i).BeforeCond.idtet{j}])
        end
    end
end

saveas(fh,'/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/AllCells_maps.fig');
saveFigure(fh,'AllCells_maps','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/');

%%%%
mazeSpikes = [0 0; 0 1; 1 1; 1 0; 0.65 0; 0.65 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZoneSpikes = [0 0; 0 0.35; 0.35 0.35; 0.35 0; 0 0]; 

s=0;
fh1 =  figure('units', 'normalized', 'outerposition', [0 0 1 1]);
for i=1:length(SelectedPlaceCells)
    if ~isempty(SelectedPlaceCells(i).BeforeCond)
        for j = 1:length(SelectedPlaceCells(i).BeforeCond.map)
            if i== 1
                a = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd');
            elseif i==2
                a = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd');
            elseif i==8
                a = load('/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd');
            elseif i==9
                a = load('/media/nas5/ProjetERC2/Mouse-911/20190508/_Concatenated/behavResources.mat','AlignedXtsd',...
                    'AlignedYtsd','SessionEpoch','Vtsd');
            elseif i==10
                a = load('/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd');
            end
            UMazeEpoch = or(a.SessionEpoch.Hab,a.SessionEpoch.TestPre1);
            UMazeEpoch = or(UMazeEpoch,a.SessionEpoch.TestPre2);
            UMazeEpoch = or(UMazeEpoch,a.SessionEpoch.TestPre3);
            UMazeEpoch = or(UMazeEpoch,a.SessionEpoch.TestPre4);
            LocomotionEpoch = thresholdIntervals(tsd(Range(a.Vtsd),movmedian(Data(a.Vtsd),5)),3,'Direction','Above');
            UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
            s=s+1;
            subplot(4,4,s)
            plot(Data(Restrict(a.AlignedXtsd, UMazeMovingEpoch)),Data(Restrict(a.AlignedYtsd, UMazeMovingEpoch)),...
                '.','Color',[0.8 0.8 0.8])
            hold on
            plot(SelectedPlaceCells(i).BeforeCond.px{j},SelectedPlaceCells(i).BeforeCond.py{j},'r.', 'MarkerSize', 12)
            plot(mazeSpikes(:,1),mazeSpikes(:,2),'k','LineWidth',3)
            plot(shockZoneSpikes(:,1),shockZoneSpikes(:,2),'r','LineWidth',3)
            %     title('PreExplorations');
            axis xy
            set(gca, 'FontSize', 14, 'FontWeight',  'bold');
            set(gca, 'LineWidth', 3);
            % set(gca,'XtickLabel',{},'YTickLabel',{});
            xlim([-0.1 1.1])
            ylim([-0.1 1.1])
            title([SelectedPlaceCells(i).name ' - ' SelectedPlaceCells(i).BeforeCond.idtet{j}])
            clear a
        end
    end
end

saveas(fh1,'/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/AllCells_spikes.fig');
saveFigure(fh1,'AllCells_spikes','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PlaceFields_Examples/');

close all

%% During freezing of conditioning

%%%% Spikes
mazeSpikes = [0 0; 0 1; 1 1; 1 0; 0.65 0; 0.65 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZoneSpikes = [0 0; 0 0.35; 0.35 0.35; 0.35 0; 0 0]; 

s=0;
fh1 =  figure('units', 'normalized', 'outerposition', [0 0 1 1]);
for i=1:length(SelectedPlaceCells)
    if ~isempty(SelectedPlaceCells(i).CondFreeze)
        for j = 1:length(SelectedPlaceCells(i).CondFreeze.map)
            if i== 1
                a = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd','FreezeAccEpoch');
            elseif i==2
                a = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd','FreezeAccEpoch');
            elseif i==8
                a = load('/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd','FreezeAccEpoch');
            elseif i==9
                a = load('/media/nas5/ProjetERC2/Mouse-911/20190508/_Concatenated/behavResources.mat','AlignedXtsd',...
                    'AlignedYtsd','SessionEpoch','Vtsd','FreezeAccEpoch');
            elseif i==10
                a = load('/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd','FreezeAccEpoch');
            end
            % Conditioning
            ConditioningEpoch = or(a.SessionEpoch.Cond1,a.SessionEpoch.Cond2);
            ConditioningEpoch = or(ConditioningEpoch,a.SessionEpoch.Cond3);
            ConditioningEpoch = or(ConditioningEpoch,a.SessionEpoch.Cond4);
            LocomotionEpoch = thresholdIntervals(tsd(Range(a.Vtsd),movmedian(Data(a.Vtsd),5)),3,'Direction','Above');
            CoonditioningFreezingEpoch = and(a.FreezeAccEpoch, ConditioningEpoch);
            s=s+1;
            subplot(4,4,s)
            plot(Data(Restrict(a.AlignedXtsd, CoonditioningFreezingEpoch)),...
                Data(Restrict(a.AlignedYtsd, CoonditioningFreezingEpoch)),'.','Color',[0.8 0.8 0.8])
            hold on
            plot(SelectedPlaceCells(i).CondFreeze.px{j},SelectedPlaceCells(i).CondFreeze.py{j},'r.', 'MarkerSize', 12)
            plot(mazeSpikes(:,1),mazeSpikes(:,2),'k','LineWidth',3)
            plot(shockZoneSpikes(:,1),shockZoneSpikes(:,2),'r','LineWidth',3)
            %     title('PreExplorations');
            axis xy
            set(gca, 'FontSize', 14, 'FontWeight',  'bold');
            set(gca, 'LineWidth', 3);
            % set(gca,'XtickLabel',{},'YTickLabel',{});
            xlim([-0.1 1.1])
            ylim([-0.1 1.1])
            title([SelectedPlaceCells(i).name ' - ' SelectedPlaceCells(i).BeforeCond.idtet{j}])
            clear a
        end
    end
end

%% During movement of conditioning

%%%% Spikes
mazeSpikes = [0 0; 0 1; 1 1; 1 0; 0.65 0; 0.65 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZoneSpikes = [0 0; 0 0.35; 0.35 0.35; 0.35 0; 0 0]; 

s=0;
fh1 =  figure('units', 'normalized', 'outerposition', [0 0 1 1]);
for i=1:length(SelectedPlaceCells)
    if ~isempty(SelectedPlaceCells(i).CondMov)
        for j = 1:length(SelectedPlaceCells(i).CondMov.map)
            if i== 1
                a = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd','FreezeAccEpoch');
            elseif i==2
                a = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd','FreezeAccEpoch');
            elseif i==8
                a = load('/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd','FreezeAccEpoch');
            elseif i==9
                a = load('/media/nas5/ProjetERC2/Mouse-911/20190508/_Concatenated/behavResources.mat','AlignedXtsd',...
                    'AlignedYtsd','SessionEpoch','Vtsd','FreezeAccEpoch');
            elseif i==10
                a = load('/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd','FreezeAccEpoch');
            end
            % Conditioning
            ConditioningEpoch = or(a.SessionEpoch.Cond1,a.SessionEpoch.Cond2);
            ConditioningEpoch = or(ConditioningEpoch,a.SessionEpoch.Cond3);
            ConditioningEpoch = or(ConditioningEpoch,a.SessionEpoch.Cond4);
            LocomotionEpoch = thresholdIntervals(tsd(Range(a.Vtsd),movmedian(Data(a.Vtsd),5)),3,'Direction','Above');
            CoonditioningMovingEpoch = and(LocomotionEpoch, ConditioningEpoch);
            s=s+1;
            subplot(4,4,s)
            plot(Data(Restrict(a.AlignedXtsd, CoonditioningMovingEpoch)),...
                Data(Restrict(a.AlignedYtsd, CoonditioningMovingEpoch)),'.','Color',[0.8 0.8 0.8])
            hold on
            plot(SelectedPlaceCells(i).CondMov.px{j},SelectedPlaceCells(i).CondMov.py{j},'r.', 'MarkerSize', 12)
            plot(mazeSpikes(:,1),mazeSpikes(:,2),'k','LineWidth',3)
            plot(shockZoneSpikes(:,1),shockZoneSpikes(:,2),'r','LineWidth',3)
            %     title('PreExplorations');
            axis xy
            set(gca, 'FontSize', 14, 'FontWeight',  'bold');
            set(gca, 'LineWidth', 3);
            % set(gca,'XtickLabel',{},'YTickLabel',{});
            xlim([-0.1 1.1])
            ylim([-0.1 1.1])
            title([SelectedPlaceCells(i).name ' - ' SelectedPlaceCells(i).BeforeCond.idtet{j}])
            clear a
        end
    end
end

%% Baseline - CondSpikes - CondRipples

mazeSpikes = [0 0; 0 1; 1 1; 1 0; 0.65 0; 0.65 0.75; 0.35 0.75; 0.35 0; 0 0];
shockZoneSpikes = [0 0; 0 0.35; 0.35 0.35; 0.35 0; 0 0]; 

% % M912
% mazeSpikes = [0.02 0; 0.02 1; 1.02 1; 1.02 0; 0.67 0; 0.67 0.75; 0.37 0.75; 0.37 0; 0.02 0];
% shockZoneSpikes = [0.02 0; 0.02 0.35; 0.37 0.35; 0.37 0; 0.02 0]; 

for i=1:length(SelectedPlaceCells)
    if ~isempty(SelectedPlaceCells(i).BeforeCond)
        f = figure;
        for j = 1:length(SelectedPlaceCells(i).BeforeCond.map)
            if i== 1
                a = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd','FreezeAccEpoch');
            elseif i==2
                a = load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-797/11112018/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd','FreezeAccEpoch');
            elseif i==8
                a = load('/media/nas5/ProjetERC2/Mouse-906/20190418/PAGExp/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd','FreezeAccEpoch');
            elseif i==9
                a = load('/media/nas5/ProjetERC2/Mouse-911/20190508/_Concatenated/behavResources.mat','AlignedXtsd',...
                    'AlignedYtsd','SessionEpoch','Vtsd','FreezeAccEpoch');
            elseif i==10
                a = load('/media/nas5/ProjetERC2/Mouse-912/20190515/PAGexp/_Concatenated/behavResources.mat',...
                    'AlignedXtsd','AlignedYtsd','SessionEpoch','Vtsd','FreezeAccEpoch');
            end
            % BaselineExplo Epoch
            UMazeEpoch = or(a.SessionEpoch.Hab,a.SessionEpoch.TestPre1);
            UMazeEpoch = or(UMazeEpoch,a.SessionEpoch.TestPre2);
            UMazeEpoch = or(UMazeEpoch,a.SessionEpoch.TestPre3);
            UMazeEpoch = or(UMazeEpoch,a.SessionEpoch.TestPre4);
            % Conditioning
            ConditioningEpoch = or(a.SessionEpoch.Cond1,a.SessionEpoch.Cond2);
            ConditioningEpoch = or(ConditioningEpoch,a.SessionEpoch.Cond3);
            ConditioningEpoch = or(ConditioningEpoch,a.SessionEpoch.Cond4);
            % After Conditioning
            AfterConditioningEpoch = or(a.SessionEpoch.TestPost1,a.SessionEpoch.TestPost2);
            AfterConditioningEpoch = or(AfterConditioningEpoch,a.SessionEpoch.TestPost3);
            AfterConditioningEpoch = or(AfterConditioningEpoch,a.SessionEpoch.TestPost4);
            % Locomotion threshold
            LocomotionEpoch = thresholdIntervals(tsd(Range(a.Vtsd),movmedian(Data(a.Vtsd),5)),2.5,'Direction','Above');
            % Get resulting epochs
            UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
            AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);
            ConditioningMovingEpoch = and(LocomotionEpoch, ConditioningEpoch);
            CoonditioningFreezingEpoch = and(a.FreezeAccEpoch, ConditioningEpoch);
            
            subplot(length(SelectedPlaceCells(i).BeforeCond.map),4,j*4-3)
            
            plot(Data(Restrict(a.AlignedXtsd, UMazeMovingEpoch)),...
                Data(Restrict(a.AlignedYtsd, UMazeMovingEpoch)),'.','Color',[0.8 0.8 0.8])
            hold on
            plot(SelectedPlaceCells(i).BeforeCond.px{j},SelectedPlaceCells(i).BeforeCond.py{j},'r.', 'MarkerSize', 12)
            plot(mazeSpikes(:,1),mazeSpikes(:,2),'k','LineWidth',3)
            plot(shockZoneSpikes(:,1),shockZoneSpikes(:,2),'r','LineWidth',3)
            title('PreExplorations');
            axis xy
            set(gca, 'FontSize', 14, 'FontWeight',  'bold');
            set(gca, 'LineWidth', 3);
            set(gca,'XtickLabel',{},'YTickLabel',{});
            xlim([-0.1 1.1])
            ylim([-0.1 1.1])
            
            subplot(length(SelectedPlaceCells(i).BeforeCond.map),4,j*4-2)
            
            plot(Data(Restrict(a.AlignedXtsd, ConditioningEpoch)),...
                Data(Restrict(a.AlignedYtsd, ConditioningEpoch)),'.','Color',[0.8 0.8 0.8])
            hold on
            plot(SelectedPlaceCells(i).CondMov.px{j},SelectedPlaceCells(i).CondMov.py{j},'r.', 'MarkerSize', 12)
            hold on
            plot(SelectedPlaceCells(i).CondFreeze.px{j},SelectedPlaceCells(i).CondFreeze.py{j},'b.', 'MarkerSize', 12)
            plot(mazeSpikes(:,1),mazeSpikes(:,2),'k','LineWidth',3)
            plot(shockZoneSpikes(:,1),shockZoneSpikes(:,2),'r','LineWidth',3)
            title('Conditioning - Spikes');
            axis xy
            set(gca, 'FontSize', 14, 'FontWeight',  'bold');
            set(gca, 'LineWidth', 3);
            set(gca,'XtickLabel',{},'YTickLabel',{});
            xlim([-0.1 1.1])
            ylim([-0.1 1.1])
            
            subplot(length(SelectedPlaceCells(i).BeforeCond.map),4,j*4-1)
            
            plot(Data(Restrict(a.AlignedXtsd, ConditioningEpoch)),...
                Data(Restrict(a.AlignedYtsd, ConditioningEpoch)),'.','Color',[0.8 0.8 0.8])
            hold on
            plot(SelectedPlaceCells(i).CondFreezeRipples.px,SelectedPlaceCells(i).CondFreezeRipples.py,...
                '.', 'Color',[0 0.4 0.4], 'MarkerSize', 12)
            plot(mazeSpikes(:,1),mazeSpikes(:,2),'k','LineWidth',3)
            plot(shockZoneSpikes(:,1),shockZoneSpikes(:,2),'r','LineWidth',3)
            title('Conditioning - Ripples');
            axis xy
            set(gca, 'FontSize', 14, 'FontWeight',  'bold');
            set(gca, 'LineWidth', 3);
            set(gca,'XtickLabel',{},'YTickLabel',{});
            xlim([-0.1 1.1])
            ylim([-0.1 1.1])
            
            subplot(length(SelectedPlaceCells(i).BeforeCond.map),4,j*4)
            
            plot(Data(Restrict(a.AlignedXtsd, AfterConditioningMovingEpoch)),...
                Data(Restrict(a.AlignedYtsd, AfterConditioningMovingEpoch)),'.','Color',[0.8 0.8 0.8])
            hold on
            plot(SelectedPlaceCells(i).AfterCond.px{j},SelectedPlaceCells(i).AfterCond.py{j},'r.', 'MarkerSize', 12)
            plot(mazeSpikes(:,1),mazeSpikes(:,2),'k','LineWidth',3)
            plot(shockZoneSpikes(:,1),shockZoneSpikes(:,2),'r','LineWidth',3)
            title('PostTests');
            axis xy
            set(gca, 'FontSize', 14, 'FontWeight',  'bold');
            set(gca, 'LineWidth', 3);
            set(gca,'XtickLabel',{},'YTickLabel',{});
            xlim([-0.1 1.1])
            ylim([-0.1 1.1])
            
        end
    end
end

            
