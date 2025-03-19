%% dir
DirPre = PathForExperimentsReversalBehav_MC('TestPre');
DirPostPAG = PathForExperimentsReversalBehav_MC('TestPostPAG');
DirPostMFB = PathForExperimentsReversalBehav_MC('TestPostMFB');
DirCondPAG = PathForExperimentsReversalBehav_MC('CondPAG');
DirCondMFB = PathForExperimentsReversalBehav_MC('CondMFB');

DirPreSham = RestrictPathForExperiment(DirPre,'Group','Sham');
DirPostPAGSham = RestrictPathForExperiment(DirPostPAG,'Group','Sham');
DirPostMFBSham = RestrictPathForExperiment(DirPostMFB,'Group','Sham');
DirCondPAGSham = RestrictPathForExperiment(DirCondPAG,'Group','Sham');
DirCondMFBSham = RestrictPathForExperiment(DirCondMFB,'Group','Sham');

DirPreExp = RestrictPathForExperiment(DirPre,'Group','Exp');
DirPostPAGExp = RestrictPathForExperiment(DirPostPAG,'Group','Exp');
DirPostMFBExp = RestrictPathForExperiment(DirPostMFB,'Group','Exp');
DirCondPAGExp = RestrictPathForExperiment(DirCondPAG,'Group','Exp');
DirCondMFBExp = RestrictPathForExperiment(DirCondMFB,'Group','Exp');


%% get data and calculate occupancy

speed_thresh = 6;

% pre- postPAG and postMFB tests for sham mice
cnt_pre_sham = 1;
cnt_postPAG_sham = 1;
cnt_postMFB_sham = 1;
for imouse = 1:length(DirPreSham.path)
    for itest = 1:length(DirPreSham.path{imouse})
        % Pre tests
        cd(DirPreSham.path{imouse}{itest});
        if isfile('cleanBehavResources.mat') == 1
            a{imouse} = load('cleanBehavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'CleanAlignedXtsd');
        else
            a{imouse} = load('behavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'CleanAlignedXtsd');
        end
        % prepare variables
        VtsdSmoothed = tsd(Range(a{imouse}.Vtsd),movmedian(Data(a{imouse}.Vtsd),5));
        LocomotionEpoch = thresholdIntervals(VtsdSmoothed,speed_thresh,'Direction','Above');
        MovingX = Restrict(a{imouse}.Xtsd,LocomotionEpoch);
        MovingY = Restrict(a{imouse}.Ytsd,LocomotionEpoch);
        % calculate occupancies
        [~,~,ZoneIndices] = RecalcInOutZones(a{imouse}.mask,MovingX, MovingY, a{imouse}.Ratio_IMAonREAL, 'Ratio', 0.33);
        for izone = 1:length(ZoneIndices)
            pre_occup_sham(cnt_pre_sham,izone) = size(ZoneIndices{izone},1)./size(Data(Restrict(a{imouse}.CleanAlignedXtsd, LocomotionEpoch)), 1);
        end
        cnt_pre_sham=cnt_pre_sham+1;
        
        % Post PAG
        cd(DirPostPAGSham.path{imouse}{itest});
        if isfile('cleanBehavResources.mat') == 1
            b{imouse} = load('cleanBehavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'CleanAlignedXtsd');
        else
            b{imouse} = load('behavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'CleanAlignedXtsd');
        end
        % prepare variables
        VtsdSmoothed = tsd(Range(b{imouse}.Vtsd),movmedian(Data(b{imouse}.Vtsd),5));
        LocomotionEpoch = thresholdIntervals(VtsdSmoothed,speed_thresh,'Direction','Above');
        MovingX = Restrict(b{imouse}.Xtsd,LocomotionEpoch);
        MovingY = Restrict(b{imouse}.Ytsd,LocomotionEpoch);
        % calculate occupancy
        [~,~,ZoneIndices] = RecalcInOutZones(b{imouse}.mask, MovingX, MovingY, b{imouse}.Ratio_IMAonREAL, 'Ratio', 0.33);
        for izone = 1:length(ZoneIndices)
            postPAG_occup_sham(cnt_postPAG_sham,izone) = size(ZoneIndices{izone},1)./size(Data(Restrict(b{imouse}.CleanAlignedXtsd, LocomotionEpoch)), 1);
        end
        cnt_postPAG_sham=cnt_postPAG_sham+1;
        
        % Post MFB
        cd(DirPostMFBSham.path{imouse}{itest});
        if isfile('cleanBehavResources.mat') == 1
            c{imouse} = load('cleanBehavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'ZoneIndices', 'CleanAlignedXtsd');
        else
            c{imouse} = load('behavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'ZoneIndices', 'CleanAlignedXtsd');
        end
        % prepare variables
        VtsdSmoothed = tsd(Range(c{imouse}.Vtsd),movmedian(Data(c{imouse}.Vtsd),5));
        LocomotionEpoch = thresholdIntervals(VtsdSmoothed,speed_thresh,'Direction','Above');
        MovingX = Restrict(c{imouse}.Xtsd,LocomotionEpoch);
        MovingY = Restrict(c{imouse}.Ytsd,LocomotionEpoch);
        [~,~,ZoneIndices] = RecalcInOutZones(c{imouse}.mask, MovingX, MovingY, c{imouse}.Ratio_IMAonREAL, 'Ratio', 0.33);
        for izone = 1:length(ZoneIndices)
            postMFB_occup_sham(cnt_postMFB_sham,izone) = size(ZoneIndices{izone},1)./size(Data(Restrict(c{imouse}.CleanAlignedXtsd, LocomotionEpoch)), 1);
        end
        cnt_postMFB_sham=cnt_postMFB_sham+1;
    end
end

% conditionning sessions for sham mice
cnt_condPAG_sham = 1;
cnt_condMFB_sham = 1;
for imouse = 1:length(DirCondPAGSham.path)
    for itest = 1:length(DirCondPAGSham.path{imouse})
        % Cond PAG
        cd(DirCondPAGSham.path{imouse}{itest});
        if isfile('cleanBehavResources.mat') == 1
            g{imouse} = load('cleanBehavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'CleanAlignedXtsd');
        else
            g{imouse} = load('behavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'CleanAlignedXtsd');
        end
        % prepare variables
        VtsdSmoothed = tsd(Range(g{imouse}.Vtsd),movmedian(Data(g{imouse}.Vtsd),5));
        LocomotionEpoch = thresholdIntervals(VtsdSmoothed,speed_thresh,'Direction','Above');
        MovingX = Restrict(g{imouse}.Xtsd,LocomotionEpoch);
        MovingY = Restrict(g{imouse}.Ytsd,LocomotionEpoch);
        % calculate occupancy
        [~,~,ZoneIndices] = RecalcInOutZones(g{imouse}.mask, MovingX, MovingY, g{imouse}.Ratio_IMAonREAL, 'Ratio', 0.33);
        for izone = 1:length(ZoneIndices)
            condPAG_occup_sham(cnt_condPAG_sham,izone) = size(ZoneIndices{izone},1)./size(Data(Restrict(g{imouse}.CleanAlignedXtsd, LocomotionEpoch)), 1);
        end
        cnt_condPAG_sham=cnt_condPAG_sham+1;
        
        % Cond MFB
        cd(DirCondMFBSham.path{imouse}{itest});
        if isfile('cleanBehavResources.mat') == 1
            h{imouse} = load('cleanBehavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'ZoneIndices', 'CleanAlignedXtsd');
        else
            h{imouse} = load('behavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'ZoneIndices', 'CleanAlignedXtsd');
        end
        % prepare variables
        VtsdSmoothed = tsd(Range(h{imouse}.Vtsd),movmedian(Data(h{imouse}.Vtsd),5));
        LocomotionEpoch = thresholdIntervals(VtsdSmoothed,speed_thresh,'Direction','Above');
        MovingX = Restrict(h{imouse}.Xtsd,LocomotionEpoch);
        MovingY = Restrict(h{imouse}.Ytsd,LocomotionEpoch);
        % calculate occupancy
        [~,~,ZoneIndices] = RecalcInOutZones(h{imouse}.mask, MovingX, MovingY, h{imouse}.Ratio_IMAonREAL, 'Ratio', 0.33);
        for izone = 1:length(ZoneIndices)
            condMFB_occup_sham(cnt_condMFB_sham,izone) = size(ZoneIndices{izone},1)./size(Data(Restrict(h{imouse}.CleanAlignedXtsd, LocomotionEpoch)), 1);
        end
        cnt_condMFB_sham=cnt_condMFB_sham+1;
    end
end

% pre- postPAG and postMFB tests for experimental mice
cnt_pre_exp=1;
cnt_postPAG_exp=1;
cnt_postMFB_exp = 1;
for jmouse = 1:length(DirPreExp.path)
    for jtest = 1:length(DirPreExp.path{jmouse})
        % Pre tests
        cd(DirPreExp.path{jmouse}{jtest});
        if isfile('cleanBehavResources.mat') == 1
            d{jmouse} = load('cleanBehavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'CleanAlignedXtsd');
        else
            d{jmouse} = load('behavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'CleanAlignedXtsd');
        end
        % prepare variables
        VtsdSmoothed = tsd(Range(d{jmouse}.Vtsd),movmedian(Data(d{jmouse}.Vtsd),5));
        LocomotionEpoch = thresholdIntervals(VtsdSmoothed,speed_thresh,'Direction','Above');
        MovingX = Restrict(d{jmouse}.Xtsd,LocomotionEpoch);
        MovingY = Restrict(d{jmouse}.Ytsd,LocomotionEpoch);
        % calculate occupancy
        [~,~,ZoneIndices] = RecalcInOutZones(d{jmouse}.mask, MovingX, MovingY, d{jmouse}.Ratio_IMAonREAL, 'Ratio', 0.33);
        for izone = 1:length(ZoneIndices)
            pre_occup_exp(cnt_pre_exp,izone) = size(ZoneIndices{izone},1)./size(Data(Restrict(d{jmouse}.CleanAlignedXtsd, LocomotionEpoch)), 1);
        end
        cnt_pre_exp=cnt_pre_exp+1;
        
        % Post PAG
        cd(DirPostPAGExp.path{jmouse}{jtest});
        if isfile('cleanBehavResources.mat') == 1
            e{jmouse} = load('cleanBehavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'CleanAlignedXtsd');
        else
            e{jmouse} = load('behavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'CleanAlignedXtsd');
        end
        % prepare variables
        VtsdSmoothed = tsd(Range(e{jmouse}.Vtsd),movmedian(Data(e{jmouse}.Vtsd),5));
        LocomotionEpoch = thresholdIntervals(VtsdSmoothed,speed_thresh,'Direction','Above');
        MovingX = Restrict(e{jmouse}.Xtsd,LocomotionEpoch);
        MovingY = Restrict(e{jmouse}.Ytsd,LocomotionEpoch);
        % calculate occupancy
        [~,~,ZoneIndices] = RecalcInOutZones(e{jmouse}.mask, MovingX, MovingY, e{jmouse}.Ratio_IMAonREAL, 'Ratio', 0.33);
        for izone = 1:length(ZoneIndices)
            postPAG_occup_exp(cnt_postPAG_exp,izone) = size(ZoneIndices{izone},1)./size(Data(Restrict(e{jmouse}.CleanAlignedXtsd, LocomotionEpoch)), 1);
        end
        cnt_postPAG_exp=cnt_postPAG_exp+1;
        
        % Post MFB
        cd(DirPostMFBExp.path{jmouse}{jtest});
        if isfile('cleanBehavResources.mat') == 1
            f{jmouse} = load('cleanBehavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'CleanAlignedXtsd');
        else
            f{jmouse} = load('behavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'CleanAlignedXtsd');
        end
        % prepare variables
        VtsdSmoothed = tsd(Range(f{jmouse}.Vtsd),movmedian(Data(f{jmouse}.Vtsd),5));
        LocomotionEpoch = thresholdIntervals(VtsdSmoothed,speed_thresh,'Direction','Above');
        MovingX = Restrict(f{jmouse}.Xtsd,LocomotionEpoch);
        MovingY = Restrict(f{jmouse}.Ytsd,LocomotionEpoch);
        % calculate occupancy
        [~,~,ZoneIndices] = RecalcInOutZones(f{jmouse}.mask, MovingX, MovingY, f{jmouse}.Ratio_IMAonREAL, 'Ratio', 0.33);
        for izone = 1:length(ZoneIndices)
            postMFB_occup_exp(cnt_postMFB_exp,izone) = size(ZoneIndices{izone},1)./size(Data(Restrict(f{jmouse}.CleanAlignedXtsd, LocomotionEpoch)), 1);
        end
        cnt_postMFB_exp=cnt_postMFB_exp+1;
    end
end

% conditionning sessions for experimental mice
cnt_condPAG_exp = 1;
cnt_condMFB_exp = 1;
for jmouse = 1:length(DirCondPAGExp.path)
    for itest = 1:length(DirCondPAGExp.path{jmouse})
        % Cond PAG
        cd(DirCondPAGExp.path{jmouse}{itest});
        if isfile('cleanBehavResources.mat') == 1
            k{jmouse} = load('cleanBehavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'CleanAlignedXtsd');
        else
            k{jmouse} = load('behavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'CleanAlignedXtsd');
        end
        % prepare variables
        VtsdSmoothed = tsd(Range(k{jmouse}.Vtsd),movmedian(Data(k{jmouse}.Vtsd),5));
        LocomotionEpoch = thresholdIntervals(VtsdSmoothed,speed_thresh,'Direction','Above');
        MovingX = Restrict(k{jmouse}.Xtsd,LocomotionEpoch);
        MovingY = Restrict(k{jmouse}.Ytsd,LocomotionEpoch);
        % calculate occupancy
        [~,~,ZoneIndices] = RecalcInOutZones(k{jmouse}.mask, MovingX, MovingY, k{jmouse}.Ratio_IMAonREAL, 'Ratio', 0.33);
        for izone = 1:length(ZoneIndices)
            condPAG_occup_exp(cnt_condPAG_exp,izone) = size(ZoneIndices{izone},1)./size(Data(Restrict(k{jmouse}.CleanAlignedXtsd, LocomotionEpoch)), 1);
        end
        cnt_condPAG_exp=cnt_condPAG_exp+1;
        
        % Cond MFB
        cd(DirCondMFBExp.path{jmouse}{itest});
        if isfile('cleanBehavResources.mat') == 1
            l{jmouse} = load('cleanBehavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'ZoneIndices', 'CleanAlignedXtsd');
        else
            l{jmouse} = load('behavResources','mask','Xtsd', 'Ytsd', 'Vtsd', 'Ratio_IMAonREAL', 'ZoneIndices', 'CleanAlignedXtsd');
        end
        % prepare variables
        VtsdSmoothed = tsd(Range(l{jmouse}.Vtsd),movmedian(Data(l{jmouse}.Vtsd),5));
        LocomotionEpoch = thresholdIntervals(VtsdSmoothed,speed_thresh,'Direction','Above');
        MovingX = Restrict(l{jmouse}.Xtsd,LocomotionEpoch);
        MovingY = Restrict(l{jmouse}.Ytsd,LocomotionEpoch);
        % calculate occupancy
        [~,~,ZoneIndices] = RecalcInOutZones(l{jmouse}.mask, MovingX, MovingY, l{jmouse}.Ratio_IMAonREAL, 'Ratio', 0.33);
        for izone = 1:length(ZoneIndices)
            condMFB_occup_exp(cnt_condMFB_exp,izone) = size(ZoneIndices{izone},1)./size(Data(Restrict(l{jmouse}.CleanAlignedXtsd, LocomotionEpoch)), 1);
        end
        cnt_condMFB_exp=cnt_condMFB_exp+1;
    end
end

%% Create arrays to plot - Ratio Walls/Center
comp_pre_sham = pre_occup_sham(:,2)./pre_occup_sham(:,1);
comp_pre_exp = pre_occup_exp(:,2)./pre_occup_exp(:,1);

comp_postPAG_sham = postPAG_occup_sham(:,2)./postPAG_occup_sham(:,1);
comp_postPAG_exp = postPAG_occup_exp(:,2)./postPAG_occup_exp(:,1);

comp_postMFB_sham = postMFB_occup_sham(:,2)./postMFB_occup_sham(:,1);
comp_postMFB_exp = postMFB_occup_exp(:,2)./postMFB_occup_exp(:,1);

comp_condPAG_sham = condPAG_occup_sham(:,2)./condPAG_occup_sham(:,1);
comp_condPAG_exp = condPAG_occup_exp(:,2)./condPAG_occup_exp(:,1);

comp_condMFB_sham = condMFB_occup_sham(:,2)./condMFB_occup_sham(:,1);
comp_condMFB_exp = condMFB_occup_exp(:,2)./condMFB_occup_exp(:,1);

%% figure

cols = {[1 1 1], [0.3 0.3 0.3]};

% PreTests
figure,subplot(151)
MakeBoxPlot_DB({comp_pre_sham, comp_pre_exp}, cols, 1:2, {'Sham', 'Experimental'},1);
% Rank sum test
p = ranksum(comp_pre_sham, comp_pre_exp);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
ylabel('Walls/Center ratio');
box off
title('PreTests','FontSize',18,'FontWeight','bold');
ylim([0 25])
makepretty

% CondPAG
subplot(152)
MakeBoxPlot_DB({comp_condPAG_sham, comp_condPAG_exp}, cols, 1:2, {'Sham', 'Experimental'},1);
% Rank sum test
p = ranksum(comp_condPAG_sham, comp_condPAG_exp);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
ylabel('Walls/Center ratio');
box off
title('CondPAG','FontSize',18,'FontWeight','bold');
ylim([0 25])
makepretty

% PostPAG
subplot(153)
MakeBoxPlot_DB({comp_postPAG_sham, comp_postPAG_exp}, cols, 1:2, {'Sham', 'Experimental'},1);
% Rank sum test
p = ranksum(comp_postPAG_sham, comp_postPAG_exp);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end

ylabel('Walls/Center ratio');
box off
title('PostPAG ','FontSize',18,'FontWeight','bold');
ylim([0 25])
makepretty

% CondMFB
subplot(154)
MakeBoxPlot_DB({comp_condMFB_sham, comp_condMFB_exp}, cols, 1:2, {'Sham', 'Experimental'},1);
% Rank sum test
p = ranksum(comp_condMFB_sham, comp_condMFB_exp);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
ylabel('Walls/Center ratio');
box off
title('CondMFB','FontSize',18,'FontWeight','bold');
ylim([0 25])
makepretty

% PostMFB
subplot(155)
MakeBoxPlot_DB({comp_postMFB_sham, comp_postMFB_exp}, cols, 1:2, {'Sham', 'Experimental'},1);
% Rank sum test
p = ranksum(comp_postMFB_sham, comp_postMFB_exp);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',24);
end
ylabel('Walls/Center ratio');
box off
title('PostMFB','FontSize',18,'FontWeight','bold');
ylim([0 25])
makepretty
