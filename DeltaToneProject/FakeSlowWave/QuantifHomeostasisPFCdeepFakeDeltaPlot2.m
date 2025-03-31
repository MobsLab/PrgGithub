%%QuantifHomeostasisPFCdeepFakeDeltaPlot2
% 08.09.2019 KJ
%
% Infos
%   plot quantif on homeostasis for real and fake delta waves RESCALED
%
% see
%    QuantifHomeostasisPFCdeepFakeDelta
%    QuantifHomeostasisPFCdeepFakeDeltaPlot
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifHomeostasisPFCdeepFakeDelta.mat'))

%animals
Dir = PathForExperimentsLocalDeltaDown('hemisphere');
homeo_res.hemisphere = Dir.hemisphere;
for p=1:length(homeo_res.path)
    list_names{p,1} = [homeo_res.name{p}];
end
animals = unique(list_names);


%% concatenate
down1.slope0  = []; down1.slope1  = []; down1.slope2  = []; down1.expB = [];
down2.slope0   = []; down2.slope1   = []; down2.slope2   = []; down2.expB = [];
diff.slope0   = []; diff.slope1   = []; diff.slope2   = []; diff.expB = [];
delta1.slope0 = []; delta1.slope1 = []; delta1.slope2 = []; delta1.expB = [];
delta2.slope0  = []; delta2.slope1  = []; delta2.slope2  = []; delta2.expB = [];
fake1.slope0  = []; fake1.slope1  = []; fake1.slope2  = []; fake1.expB = [];
fake2.slope0   = []; fake2.slope1   = []; fake2.slope2   = []; fake2.expB = [];

down1.R0  = []; down1.R1  = []; down1.R2  = []; down1.Rexp = [];
down2.R0   = []; down2.R1   = []; down2.R2   = []; down2.Rexp = [];
diff.R0   = []; diff.R1   = []; diff.R2   = []; diff.Rexp = [];
delta1.R0 = []; delta1.R1 = []; delta1.R2 = []; delta1.Rexp = [];
delta2.R0  = []; delta2.R1  = []; delta2.R2  = []; delta2.Rexp = [];
fake1.R0  = []; fake1.R1  = []; fake1.R2  = []; fake1.Rexp = [];
fake2.R0   = []; fake2.R1   = []; fake2.R2   = []; fake2.Rexp = [];

down1.pv0  = []; down1.pv1  = []; down1.pv2  = [];
down2.pv0   = []; down2.pv1   = []; down2.pv2   = []; 
diff.pv0   = []; diff.pv1   = []; diff.pv2   = []; 
delta1.pv0 = []; delta1.pv1 = []; delta1.pv2 = []; 
delta2.pv0  = []; delta2.pv1  = []; delta2.pv2  = []; 
fake1.pv0  = []; fake1.pv1  = []; fake1.pv2  = []; 
fake2.pv0   = []; fake2.pv1   = []; fake2.pv2   = [];


for p=1:length(homeo_res.path)
    
    %down states 1
    down1.slope0(p,1) = homeo_res.down1.rescaled.p0{p}(1);
    down1.R0(p,1)     = homeo_res.down1.rescaled.R2_0{p};
    down1.pv0(p,1)    = mean(homeo_res.down1.rescaled.pv0{p}<0.05);
    down1.slope1(p,1) = homeo_res.down1.rescaled.p1{p}(1);
    down1.R1(p,1)     = homeo_res.down1.rescaled.R2_1{p};
    down1.pv1(p,1)    = mean(homeo_res.down1.rescaled.pv1{p}<0.05);
    down1.slope2(p,1) = homeo_res.down1.rescaled.p2{p}(1);
    down1.R2(p,1)     = homeo_res.down1.rescaled.R2_2{p};
    down1.pv2(p,1)    = mean(homeo_res.down1.rescaled.pv2{p}<0.05);
    down1.expB(p,1)   = homeo_res.down1.rescaled.exp_b{p};
    down1.Rexp(p,1)   = homeo_res.down1.rescaled.exp_R2{p};
    %down states 2
    down2.slope0(p,1) = homeo_res.down2.rescaled.p0{p}(1);
    down2.R0(p,1)     = homeo_res.down2.rescaled.R2_0{p};
    down2.pv0(p,1)    = mean(homeo_res.down2.rescaled.pv0{p}<0.05);
    down2.slope1(p,1) = homeo_res.down2.rescaled.p1{p}(1);
    down2.R1(p,1)     = homeo_res.down2.rescaled.R2_1{p};
    down2.pv1(p,1)    = mean(homeo_res.down2.rescaled.pv1{p}<0.05);
    down2.slope2(p,1) = homeo_res.down2.rescaled.p2{p}(1);
    down2.R2(p,1)     = homeo_res.down2.rescaled.R2_2{p};
    down2.pv2(p,1)    = mean(homeo_res.down2.rescaled.pv2{p}<0.05);
    down2.expB(p,1)   = homeo_res.down2.rescaled.exp_b{p};
    down2.Rexp(p,1)   = homeo_res.down2.rescaled.exp_R2{p};
    %delta diff
    diff.slope0(p,1) = homeo_res.down2.rescaled.p0{p}(1);
    diff.R0(p,1)     = homeo_res.down2.rescaled.R2_0{p};
    diff.pv0(p,1)    = mean(homeo_res.down2.rescaled.pv0{p}<0.05);
    diff.slope1(p,1) = homeo_res.down2.rescaled.p1{p}(1);
    diff.R1(p,1)     = homeo_res.down2.rescaled.R2_1{p};
    diff.pv1(p,1)    = mean(homeo_res.down2.rescaled.pv1{p}<0.05);
    diff.slope2(p,1) = homeo_res.down2.rescaled.p2{p}(1);
    diff.R2(p,1)     = homeo_res.down2.rescaled.R2_2{p};
    diff.pv2(p,1)    = mean(homeo_res.down2.rescaled.pv2{p}<0.05);
    diff.expB(p,1)   = homeo_res.down2.rescaled.exp_b{p};
    diff.Rexp(p,1)   = homeo_res.down2.rescaled.exp_R2{p};
    
    
    %for delta1
    slope0 = []; slope1 = []; slope2 = [];
    R0 = []; R1 = []; R2 = [];
    pv0 = []; pv1 = []; pv2 = [];
    expB = []; Rexp = [];
    for ch=1:length(homeo_res.channels{p})
        slope0 = [slope0 homeo_res.delta1.rescaled.p0{p,ch}(1)];
        R0 = [R0 homeo_res.delta1.rescaled.R2_0{p,ch}];
        pv0 = [pv0 homeo_res.delta1.rescaled.pv0{p,ch}];
        slope1 = [slope1 homeo_res.delta1.rescaled.p1{p,ch}(1)];
        R1 = [R1 homeo_res.delta1.rescaled.R2_1{p,ch}];
        pv1 = [pv1 homeo_res.delta1.rescaled.pv1{p,ch}];
        slope2 = [slope2 homeo_res.delta1.rescaled.p2{p,ch}(1)];
        R2 = [R2 homeo_res.delta1.rescaled.R2_2{p,ch}];
        pv2 = [pv2 homeo_res.delta1.rescaled.pv2{p,ch}];
        expB = [expB homeo_res.delta1.rescaled.exp_b{p,ch}];
        Rexp = [Rexp homeo_res.delta1.rescaled.exp_R2{p,ch}];
    end
    delta1.slope0(p,1) = mean(slope0);
    delta1.R0(p,1)     = mean(R0);
    delta1.pv0(p,1)    = mean(pv0<0.5);
    delta1.slope1(p,1) = mean(slope1);
    delta1.R1(p,1)     = mean(R1);
    delta1.pv1(p,1)    = mean(pv1<0.05);
    delta1.slope2(p,1) = mean(slope2);
    delta1.R2(p,1)     = mean(R2);
    delta1.pv2(p,1)    = mean(pv2<0.05);
    delta1.expB(p,1)   = mean(expB);
    delta1.Rexp(p,1)   = mean(Rexp);

    %for delta2
    slope0 = []; slope1 = []; slope2 = [];
    R0 = []; R1 = []; R2 = [];
    pv0 = []; pv1 = []; pv2 = [];
    expB = []; Rexp = [];
    for ch=1:length(homeo_res.channels{p})
        slope0 = [slope0 homeo_res.delta2.rescaled.p0{p,ch}(1)];
        R0 = [R0 homeo_res.delta2.rescaled.R2_0{p,ch}];
        pv0 = [pv0 homeo_res.delta2.rescaled.pv0{p,ch}];
        slope1 = [slope1 homeo_res.delta2.rescaled.p1{p,ch}(1)];
        R1 = [R1 homeo_res.delta2.rescaled.R2_1{p,ch}];
        pv1 = [pv1 homeo_res.delta2.rescaled.pv1{p,ch}];
        slope2 = [slope2 homeo_res.delta2.rescaled.p2{p,ch}(1)];
        R2 = [R2 homeo_res.delta2.rescaled.R2_2{p,ch}];
        pv2 = [pv2 homeo_res.delta2.rescaled.pv2{p,ch}];
        expB = [expB homeo_res.delta2.rescaled.exp_b{p,ch}];
        Rexp = [Rexp homeo_res.delta2.rescaled.exp_R2{p,ch}];
    end
    delta2.slope0(p,1) = mean(slope0);
    delta2.R0(p,1)     = mean(R0);
    delta2.pv0(p,1)    = mean(pv0<0.05);
    delta2.slope1(p,1) = mean(slope1);
    delta2.R1(p,1)     = mean(R1);
    delta2.pv1(p,1)    = mean(pv1<0.05);
    delta2.slope2(p,1) = mean(slope2);
    delta2.R2(p,1)     = mean(R2);
    delta2.pv2(p,1)    = mean(pv2<0.05);
    delta2.expB(p,1)   = mean(expB);
    delta2.Rexp(p,1)   = mean(Rexp);
    
    
    %for other1
    slope0 = []; slope1 = []; slope2 = [];
    R0 = []; R1 = []; R2 = [];
    pv0 = []; pv1 = []; pv2 = [];
    expB = []; Rexp = [];
    for ch=1:length(homeo_res.channels{p})
        slope0 = [slope0 homeo_res.other1.rescaled.p0{p,ch}(1)];
        R0 = [R0 homeo_res.other1.rescaled.R2_0{p,ch}];
        pv0 = [pv0 homeo_res.other1.rescaled.pv0{p,ch}];
        slope1 = [slope1 homeo_res.other1.rescaled.p1{p,ch}(1)];
        R1 = [R1 homeo_res.other1.rescaled.R2_1{p,ch}];
        pv1 = [pv1 homeo_res.other1.rescaled.pv1{p,ch}];
        slope2 = [slope2 homeo_res.other1.rescaled.p2{p,ch}(1)];
        R2 = [R2 homeo_res.other1.rescaled.R2_2{p,ch}];
        pv2 = [pv2 homeo_res.other1.rescaled.pv2{p,ch}];
        expB = [expB homeo_res.other1.rescaled.exp_b{p,ch}];
        Rexp = [Rexp homeo_res.other1.rescaled.exp_R2{p,ch}];
    end
    fake1.slope0(p,1) = mean(slope0);
    fake1.R0(p,1)     = mean(R0);
    fake1.pv0(p,1)    = mean(pv0<0.05);
    fake1.slope1(p,1) = mean(slope1);
    fake1.R1(p,1)     = mean(R1);
    fake1.pv1(p,1)    = mean(pv1<0.05);
    fake1.slope2(p,1) = mean(slope2);
    fake1.R2(p,1)     = mean(R2);
    fake1.pv2(p,1)    = mean(pv2<0.05);
    fake1.expB(p,1)   = mean(expB);
    fake1.Rexp(p,1)   = mean(Rexp);

    %for other2
    slope0 = []; slope1 = []; slope2 = [];
    R0 = []; R1 = []; R2 = [];
    pv0 = []; pv1 = []; pv2 = [];
    expB = []; Rexp = [];
    for ch=1:length(homeo_res.channels{p})
        slope0 = [slope0 homeo_res.other2.rescaled.p0{p,ch}(1)];
        R0 = [R0 homeo_res.other2.rescaled.R2_0{p,ch}];
        pv0 = [pv0 homeo_res.other2.rescaled.pv0{p,ch}];
        slope1 = [slope1 homeo_res.other2.rescaled.p1{p,ch}(1)];
        R1 = [R1 homeo_res.other2.rescaled.R2_1{p,ch}];
        pv1 = [pv1 homeo_res.other2.rescaled.pv1{p,ch}];
        slope2 = [slope2 homeo_res.other2.rescaled.p2{p,ch}(1)];
        R2 = [R2 homeo_res.other2.rescaled.R2_2{p,ch}];
        pv2 = [pv2 homeo_res.other2.rescaled.pv2{p,ch}];
        expB = [expB homeo_res.other2.rescaled.exp_b{p,ch}];
        Rexp = [Rexp homeo_res.other2.rescaled.exp_R2{p,ch}];
    end
    fake2.slope0(p,1) = mean(slope0);
    fake2.R0(p,1)     = mean(R0);
    fake2.pv0(p,1)    = mean(pv0<0.05);
    fake2.slope1(p,1) = mean(slope1);
    fake2.R1(p,1)     = mean(R1);
    fake2.pv1(p,1)    = mean(pv1<0.05);
    fake2.slope2(p,1) = mean(slope2);
    fake2.R2(p,1)     = mean(R2);
    fake2.pv2(p,1)    = mean(pv2<0.05);
    fake2.expB(p,1)   = mean(expB);
    fake2.Rexp(p,1)   = mean(Rexp);
    
end


%% animals average

for m=1:length(animals)
    idm = strcmpi(list_names,animals{m}); %list of record of animals m
    
    fn = fieldnames(down1);
    for k=1:numel(fn)
        datam = down1.(fn{k});
        average.down1.(fn{k})(m,1) = mean(datam(idm));
        
        datam = down2.(fn{k});
        average.down2.(fn{k})(m,1) = mean(datam(idm));
        
        datam = diff.(fn{k});
        average.diff.(fn{k})(m,1) = mean(datam(idm));
        
        datam = delta1.(fn{k});
        average.delta1.(fn{k})(m,1) = mean(datam(idm));
        
        datam = delta2.(fn{k});
        average.delta2.(fn{k})(m,1) = mean(datam(idm));
        
        datam = fake1.(fn{k});
        average.fake1.(fn{k})(m,1) = mean(datam(idm));
        
        datam = fake2.(fn{k});
        average.fake2.(fn{k})(m,1) = mean(datam(idm));
    end
    
end




%% data
%data1
data1_slope{1} = [average.down1.slope0 average.diff.slope0 average.delta1.slope0 average.fake1.slope0];
data1_slope{2} = [average.down1.slope1 average.diff.slope1 average.delta1.slope1 average.fake1.slope1];
data1_slope{3} = [average.down1.slope2 average.diff.slope2 average.delta1.slope2 average.fake1.slope2];
data1_slope{4} = [average.down1.expB average.diff.expB average.delta1.expB average.fake1.expB];

data1_r2{1} = [average.down1.R0 average.diff.R0 average.delta1.R0 average.fake1.R0];
data1_r2{2} = [average.down1.R1 average.diff.R1 average.delta1.R1 average.fake1.R1];
data1_r2{3} = [average.down1.R2 average.diff.R2 average.delta1.R2 average.fake1.R2];
data1_r2{4} = [average.down1.Rexp average.diff.Rexp average.delta1.Rexp average.fake1.Rexp];

data1_pv{1} = [average.down1.pv0 average.diff.pv0 average.delta1.pv0 average.fake1.pv0]*100;
data1_pv{2} = [average.down1.pv1 average.diff.pv1 average.delta1.pv1 average.fake1.pv1]*100;
data1_pv{3} = [average.down1.pv2 average.diff.pv2 average.delta1.pv2 average.fake1.pv2]*100;

%data2
data2_slope{1} = [average.down2.slope0 average.diff.slope0 average.delta2.slope0 average.fake2.slope0];
data2_slope{2} = [average.down2.slope1 average.diff.slope1 average.delta2.slope1 average.fake2.slope1];
data2_slope{3} = [average.down2.slope2 average.diff.slope2 average.delta2.slope2 average.fake2.slope2];
data2_slope{4} = [average.down2.expB average.diff.expB average.delta2.expB average.fake2.expB];

data2_r2{1} = [average.down2.R0 average.diff.R0 average.delta2.R0 average.fake2.R0];
data2_r2{2} = [average.down2.R1 average.diff.R1 average.delta2.R1 average.fake2.R1];
data2_r2{3} = [average.down2.R2 average.diff.R2 average.delta2.R2 average.fake2.R2];
data2_r2{4} = [average.down2.Rexp average.diff.Rexp average.delta2.Rexp average.fake2.Rexp];

data2_pv{1} = [average.down2.pv0 average.diff.pv0 average.delta2.pv0 average.fake2.pv0]*100;
data2_pv{2} = [average.down2.pv1 average.diff.pv1 average.delta2.pv1 average.fake2.pv1]*100;
data2_pv{3} = [average.down2.pv2 average.diff.pv2 average.delta2.pv2 average.fake2.pv2]*100;


titles = {'1fit','2fit 0-2h','2fit end','exp fit'};


%% Plot

figure, hold on 
fontsize = 10;

sigtest = 'ranksum';
showPoints = 1;

%down1 delta fake
for i=1:4
    subplot(3,4,i), hold on
    PlotErrorBarN_KJ(data1_slope{i}, 'newfig',0, 'barcolors',{'k',[0.6 0.6 0.6],'b','r'}, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar','sig');
    set(gca,'xtick',1:4,'XtickLabel',{'down', 'diff','delta','fake'},'Fontsize',fontsize),
    ylabel('slopes value (delta/min/h)');
    title(titles{i}),
    
    subplot(3,4,i+4), hold on
    PlotErrorBarN_KJ(data1_r2{i}, 'newfig',0, 'barcolors',{'k',[0.6 0.6 0.6],'b','r'}, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar','sig');
    set(gca,'xtick',1:4,'XtickLabel',{'down', 'diff','delta','fake'},'Fontsize',fontsize),
    ylabel('R2');
    
    if i<4
        subplot(3,4,i+8), hold on
        PlotErrorBarN_KJ(data1_pv{i}, 'newfig',0, 'barcolors',{'k',[0.6 0.6 0.6],'b','r'}, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar','sig');
        set(gca,'xtick',1:4,'XtickLabel',{'down', 'diff','delta','fake'},'Fontsize',fontsize),
        ylabel('% of pvalues <0.05');
    end
end


figure, hold on 

%down2 local vs global
for i=1:4
    subplot(3,4,i), hold on
    PlotErrorBarN_KJ(data2_slope{i}, 'newfig',0, 'barcolors',{'k',[0.6 0.6 0.6],'b','r'}, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar','sig');
    set(gca,'xtick',1:4,'XtickLabel',{'down', 'diff','delta','fake'},'Fontsize',fontsize),
    ylabel('slopes value (delta/min/h)');
    title(titles{i}),
    
    subplot(3,4,i+4), hold on
    PlotErrorBarN_KJ(data2_r2{i}, 'newfig',0, 'barcolors',{'k',[0.6 0.6 0.6],'b','r'}, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar','sig');
    set(gca,'xtick',1:4,'XtickLabel',{'down', 'diff','delta','fake'},'Fontsize',fontsize),
    ylabel('R2');
    
    if i<4
        subplot(3,4,i+8), hold on
        PlotErrorBarN_KJ(data2_pv{i}, 'newfig',0, 'barcolors',{'k',[0.6 0.6 0.6],'b','r'}, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar','sig');
        set(gca,'xtick',1:4,'XtickLabel',{'down', 'diff','delta','fake'},'Fontsize',fontsize),
        ylabel('% of pvalues <0.05');
    end
    
end


