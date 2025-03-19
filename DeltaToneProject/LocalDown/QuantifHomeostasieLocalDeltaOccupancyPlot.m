%%QuantifHomeostasieLocalDeltaOccupancyPlot
% 08.09.2019 KJ
%
% Infos
%   plot quantif on homeostasis for global, local, fake delta waves
%
% see
%    ParcoursHomeostasieLocalDeltaDensityPlot ParcoursHomeostasieLocalDeltaOccupancy
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'ParcoursHomeostasieLocalDeltaOccupancy.mat'))

rescaleslope = 0;

%% concatenate
down.global.slope0  = []; down.global.slope1  = []; down.global.slope2  = []; down.global.expB = [];
down.local.slope0   = []; down.local.slope1   = []; down.local.slope2   = []; down.local.expB = [];
delta.global.slope0 = []; delta.global.slope1 = []; delta.global.slope2 = []; delta.global.expB = [];
delta.local.slope0  = []; delta.local.slope1  = []; delta.local.slope2  = []; delta.local.expB = [];
delta.fake.slope0   = []; delta.fake.slope1   = []; delta.fake.slope2   = []; delta.fake.expB = [];

down.global.R0  = []; down.global.R1  = []; down.global.R2  = []; down.global.Rexp = [];
down.local.R0   = []; down.local.R1   = []; down.local.R2   = []; down.local.Rexp = [];
delta.global.R0 = []; delta.global.R1 = []; delta.global.R2 = []; delta.global.Rexp = [];
delta.local.R0  = []; delta.local.R1  = []; delta.local.R2  = []; delta.local.Rexp = [];
delta.fake.R0   = []; delta.fake.R1   = []; delta.fake.R2   = []; delta.fake.Rexp = [];


for p=1:length(homeo_res.path)
    
    %slope all night
    down.global.slope0(p,1)  = homeo_res.down.global.p0{p}(1);
    down.global.R0(p,1)  = homeo_res.down.global.R2_0{p}(1);
    
    slope0 = []; R0 = [];
    for tt=1:length(homeo_res.nb.tetrodes{p})
        slope0 = [slope0 homeo_res.down.local.p0{p,tt}(1)];
        R0 = [R0 homeo_res.down.local.R2_0{p,tt}];
    end
    down.local.slope0(p,1) = mean(slope0);
    down.local.R0(p,1) = mean(R0);
 
    
    %slope beginning
    down.global.slope1(p,1)  = homeo_res.down.global.p1{p}(1);
    down.global.R1(p,1)  = homeo_res.down.global.R2_1{p}(1);
    
    slope1 = []; R1 = [];
    for tt=1:length(homeo_res.nb.tetrodes{p})
        slope1 = [slope1 homeo_res.down.local.p1{p,tt}(1)];
        R1 = [R1 homeo_res.down.local.R2_1{p,tt}];
    end
    down.local.slope1(p,1) = mean(slope1);
    down.local.R1(p,1) = mean(R1);
    
    %slope end
    down.global.slope2(p,1)  = homeo_res.down.global.p2{p}(1);
    down.global.R2(p,1)  = homeo_res.down.global.R2_2{p}(1);
    
    slope2 = []; R2 = [];
    for tt=1:length(homeo_res.nb.tetrodes{p})
        slope2 = [slope2 homeo_res.down.local.p2{p,tt}(1)];
        R2 = [R2 homeo_res.down.local.R2_2{p,tt}];
    end
    down.local.slope2(p,1) = mean(slope2);
    down.local.R2(p,1) = mean(R2);
    
    %exponential factor
    down.global.expB(p,1)  = homeo_res.down.global.exp_a{p};
    down.global.Rexp(p,1)  = homeo_res.down.global.exp_R2{p};
    
    expB = []; Rexp = [];
    for tt=1:length(homeo_res.nb.tetrodes{p})
        expB = [expB homeo_res.down.local.exp_a{p,tt}];
        Rexp = [Rexp homeo_res.down.local.exp_R2{p,tt}];
    end
    down.local.expB(p,1) = mean(expB);
    down.local.Rexp(p,1) = mean(Rexp);

end


data_slope{1} = [down.global.slope0 down.local.slope0];
data_slope{2} = [down.global.slope1 down.local.slope1];
data_slope{3} = [down.global.slope2 down.local.slope2];
data_slope{4} = [down.global.expB down.local.expB];

data_r2{1} = [down.global.R0 down.local.R0];
data_r2{2} = [down.global.R1 down.local.R1];
data_r2{3} = [down.global.R2 down.local.R2];
data_r2{4} = [down.global.Rexp down.local.Rexp];

titles = {'1fit','2fit <15h30','2fit >15h30','exp fit'};


%% Plot

figure, hold on 
fontsize = 15;

%down local vs global
for i=1:4
    subplot(2,4,i), hold on
    PlotErrorBarN_KJ(data_slope{i}, 'newfig',0, 'barcolors',{'k','b'}, 'paired',1, 'optiontest','ranksum', 'showPoints',1,'ShowSigstar','sig');
    set(gca,'xtick',1:2,'XtickLabel',{'global','local'},'Fontsize',fontsize),
    ylabel('slopes value (delta/min/h)');
    title(titles{i}),
    
    subplot(2,4,i+4), hold on
    PlotErrorBarN_KJ(data_r2{i}, 'newfig',0, 'barcolors',{'k','b'}, 'paired',1, 'optiontest','ranksum', 'showPoints',1,'ShowSigstar','sig');
    set(gca,'xtick',1:2,'XtickLabel',{'global','local'},'Fontsize',fontsize),
    ylabel('R2');
    
end














