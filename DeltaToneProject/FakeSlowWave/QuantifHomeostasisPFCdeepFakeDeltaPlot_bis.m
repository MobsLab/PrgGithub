%%QuantifHomeostasisPFCdeepFakeDeltaPlot_bis
% 08.09.2019 KJ
%
% Infos
%   plot quantif on homeostasis for real and fake delta waves
%
% see
%    QuantifHomeostasisPFCdeepFakeDelta QuantifHomeostasisPFCdeepFakeDeltaPlotAll
%    QuantifHomeostasisPFCdeepFakeDeltaPlot2
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifHomeostasisPFCdeepFakeDelta.mat'))

% %animals
animals = unique(homeo_res.name);


%% concatenate
swa.slope0  = []; swa.slope1  = []; swa.slope2  = []; swa.expB = [];
down1.slope0  = []; down1.slope1  = []; down1.slope2  = []; down1.expB = [];
down2.slope0   = []; down2.slope1   = []; down2.slope2   = []; down2.expB = [];
diff.slope0   = []; diff.slope1   = []; diff.slope2   = []; diff.expB = [];
delta1.slope0 = []; delta1.slope1 = []; delta1.slope2 = []; delta1.expB = [];
delta2.slope0  = []; delta2.slope1  = []; delta2.slope2  = []; delta2.expB = [];
fake1.slope0  = []; fake1.slope1  = []; fake1.slope2  = []; fake1.expB = [];
fake2.slope0   = []; fake2.slope1   = []; fake2.slope2   = []; fake2.expB = [];

swa.rmse0  = []; swa.rmse1  = []; swa.rmse2  = []; swa.rmseExp = [];
down1.rmse0  = []; down1.rmse1  = []; down1.rmse2  = []; down1.rmseExp = [];
down2.rmse0   = []; down2.rmse1   = []; down2.rmse2   = []; down2.rmseExp = [];
diff.rmse0   = []; diff.rmse1   = []; diff.rmse2   = []; diff.rmseExp = [];
delta1.rmse0 = []; delta1.rmse1 = []; delta1.rmse2 = []; delta1.rmseExp = [];
delta2.rmse0  = []; delta2.rmse1  = []; delta2.rmse2  = []; delta2.rmseExp = [];
fake1.rmse0  = []; fake1.rmse1  = []; fake1.rmse2  = []; fake1.rmseExp = [];
fake2.rmse0   = []; fake2.rmse1   = []; fake2.rmse2   = []; fake2.rmseExp = [];

swa.pv0  = []; swa.pv1  = []; swa.pv2  = []; swa.pv_b  = [];
down1.pv0  = []; down1.pv1  = []; down1.pv2  = []; down1.pv_b  = [];
down2.pv0   = []; down2.pv1   = []; down2.pv2   = []; down2.pv_b  = [];
diff.pv0   = []; diff.pv1   = []; diff.pv2   = []; diff.pv_b  = [];
delta1.pv0 = []; delta1.pv1 = []; delta1.pv2 = []; delta1.pv_b  = [];
delta2.pv0  = []; delta2.pv1  = []; delta2.pv2  = [];  delta2.pv_b  = [];
fake1.pv0  = []; fake1.pv1  = []; fake1.pv2  = []; fake1.pv_b  = []; 
fake2.pv0   = []; fake2.pv1   = []; fake2.pv2   = []; fake2.pv_b  = [];


for p=1:length(homeo_res.path)
    
    %down states 1
    Hstat = homeo_res.down1.rescaled.Hstat{p};
    down1.slope0(p,1) = Hstat.p0(1);
    down1.rmse0(p,1)  = Hstat.rmse0;
    down1.pv0(p,1)    = mean(Hstat.pv0<0.05);
    down1.slope1(p,1) = Hstat.p1(1);
    down1.rmse1(p,1)  = Hstat.rmse1;
    down1.pv1(p,1)    = mean(Hstat.pv1<0.05);
    down1.slope2(p,1) = Hstat.p2(1);
    down1.rmse2(p,1)  = Hstat.rmse2;
    down1.pv2(p,1)    = mean(Hstat.pv2<0.05);
    down1.expB(p,1)   = Hstat.exp_b;
    down1.rmseExp(p,1)= Hstat.rmseExp;
    down1.pv_b(p,1)   = mean(Hstat.pv_b<0.05);
    %down states 2
    Hstat = homeo_res.down2.rescaled.Hstat{p};
    down2.slope0(p,1) = Hstat.p0(1);
    down2.rmse0(p,1)  = Hstat.rmse0;
    down2.pv0(p,1)    = mean(Hstat.pv0<0.05);
    down2.slope1(p,1) = Hstat.p1(1);
    down2.rmse1(p,1)  = Hstat.rmse1;
    down2.pv1(p,1)    = mean(Hstat.pv1<0.05);
    down2.slope2(p,1) = Hstat.p2(1);
    down2.rmse2(p,1)  = Hstat.rmse2;
    down2.pv2(p,1)    = mean(Hstat.pv2<0.05);
    down2.expB(p,1)   = Hstat.exp_b;
    down2.rmseExp(p,1)= Hstat.rmseExp;
    down2.pv_b(p,1)   = mean(Hstat.pv_b<0.05);
    %delta diff
    Hstat = homeo_res.diff.rescaled.Hstat{p};
    diff.slope0(p,1) = Hstat.p0(1);
    diff.rmse0(p,1)  = Hstat.rmse0;
    diff.pv0(p,1)    = mean(Hstat.pv0<0.05);
    diff.slope1(p,1) = Hstat.p1(1);
    diff.rmse1(p,1)  = Hstat.rmse1;
    diff.pv1(p,1)    = mean(Hstat.pv1<0.05);
    diff.slope2(p,1) = Hstat.p2(1);
    diff.rmse2(p,1)  = Hstat.rmse2;
    diff.pv2(p,1)    = mean(Hstat.pv2<0.05);
    diff.expB(p,1)   = Hstat.exp_b;
    diff.rmseExp(p,1)= Hstat.rmseExp;
    diff.pv_b(p,1)   = mean(Hstat.pv_b<0.05);
    
    %for delta1
    slope0 = []; slope1 = []; slope2 = [];
    rmse0 = []; rmse1 = []; rmse2 = [];
    pv0 = []; pv1 = []; pv2 = [];
    expB = []; rmseExp = []; pv_b = [];
    for ch=1:length(homeo_res.channels{p})
        Hstat = homeo_res.delta1.rescaled.Hstat{p,ch};
        slope0 = [slope0 Hstat.p0(1)];
        rmse0 = [rmse0 Hstat.rmse0];
        pv0 = [pv0 Hstat.pv0];
        slope1 = [slope1 Hstat.p1(1)];
        rmse1 = [rmse1 Hstat.rmse1];
        pv1 = [pv1 Hstat.pv1];
        slope2 = [slope2 Hstat.p2(1)];
        rmse2 = [rmse2 Hstat.rmse2];
        pv2 = [pv2 Hstat.pv2];
        expB = [expB Hstat.exp_b];
        rmseExp = [rmseExp Hstat.rmseExp];
        pv_b = [pv_b Hstat.pv_b];
    end
    delta1.slope0(p,1) = median(slope0);
    delta1.rmse0(p,1)  = mean(rmse0);
    delta1.pv0(p,1)    = mean(pv0<0.5);
    delta1.slope1(p,1) = median(slope1);
    delta1.rmse1(p,1)  = mean(rmse1);
    delta1.pv1(p,1)    = mean(pv1<0.05);
    delta1.slope2(p,1) = median(slope2);
    delta1.rmse2(p,1)  = mean(rmse2);
    delta1.pv2(p,1)    = mean(pv2<0.05);
    delta1.expB(p,1)   = mean(expB);
    delta1.rmseExp(p,1)= mean(rmseExp);
    delta1.pv_b(p,1)   = mean(pv_b<0.05);

    %for delta2
    slope0 = []; slope1 = []; slope2 = [];
    rmse0 = []; rmse1 = []; rmse2 = [];
    pv0 = []; pv1 = []; pv2 = [];
    expB = []; rmseExp = []; pv_b = [];
    for ch=1:length(homeo_res.channels{p})
        Hstat = homeo_res.delta2.rescaled.Hstat{p,ch};
        slope0 = [slope0 Hstat.p0(1)];
        rmse0 = [rmse0 Hstat.rmse0];
        pv0 = [pv0 Hstat.pv0];
        slope1 = [slope1 Hstat.p1(1)];
        rmse1 = [rmse1 Hstat.rmse1];
        pv1 = [pv1 Hstat.pv1];
        slope2 = [slope2 Hstat.p2(1)];
        rmse2 = [rmse2 Hstat.rmse2];
        pv2 = [pv2 Hstat.pv2];
        expB = [expB Hstat.exp_b];
        rmseExp = [rmseExp Hstat.rmseExp];
        pv_b = [pv_b Hstat.pv_b];
    end
    delta2.slope0(p,1) = mean(slope0);
    delta2.rmse0(p,1)     = mean(rmse0);
    delta2.pv0(p,1)    = mean(pv0<0.05);
    delta2.slope1(p,1) = mean(slope1);
    delta2.rmse1(p,1)     = mean(rmse1);
    delta2.pv1(p,1)    = mean(pv1<0.05);
    delta2.slope2(p,1) = mean(slope2);
    delta2.rmse2(p,1)     = mean(rmse2);
    delta2.pv2(p,1)    = mean(pv2<0.05);
    delta2.expB(p,1)   = mean(expB);
    delta2.rmseExp(p,1)   = mean(rmseExp);
    delta2.pv_b(p,1)   = mean(pv_b<0.05);
    
    
    %for other1
    slope0 = []; slope1 = []; slope2 = [];
    rmse0 = []; rmse1 = []; rmse2 = [];
    pv0 = []; pv1 = []; pv2 = [];
    expB = []; rmseExp = []; pv_b = [];
    for ch=1:length(homeo_res.channels{p})
        Hstat = homeo_res.other1.rescaled.Hstat{p,ch};
        slope0 = [slope0 Hstat.p0(1)];
        rmse0 = [rmse0 Hstat.rmse0];
        pv0 = [pv0 Hstat.pv0];
        slope1 = [slope1 Hstat.p1(1)];
        rmse1 = [rmse1 Hstat.rmse1];
        pv1 = [pv1 Hstat.pv1];
        slope2 = [slope2 Hstat.p2(1)];
        rmse2 = [rmse2 Hstat.rmse2];
        pv2 = [pv2 Hstat.pv2];
        expB = [expB Hstat.exp_b];
        rmseExp = [rmseExp Hstat.rmseExp];
        pv_b = [pv_b Hstat.pv_b];
    end
    fake1.slope0(p,1) = mean(slope0);
    fake1.rmse0(p,1)  = mean(rmse0);
    fake1.pv0(p,1)    = mean(pv0<0.05);
    fake1.slope1(p,1) = mean(slope1);
    fake1.rmse1(p,1)  = mean(rmse1);
    fake1.pv1(p,1)    = mean(pv1<0.05);
    fake1.slope2(p,1) = mean(slope2);
    fake1.rmse2(p,1)  = mean(rmse2);
    fake1.pv2(p,1)    = mean(pv2<0.05);
    fake1.expB(p,1)   = mean(expB);
    fake1.rmseExp(p,1)= mean(rmseExp);
    fake1.pv_b(p,1)   = mean(pv_b<0.05);

    %for other2
    slope0 = []; slope1 = []; slope2 = [];
    rmse0 = []; rmse1 = []; rmse2 = [];
    pv0 = []; pv1 = []; pv2 = [];
    expB = []; rmseExp = []; pv_b = [];
    for ch=1:length(homeo_res.channels{p})
        Hstat = homeo_res.other2.rescaled.Hstat{p,ch};
        slope0 = [slope0 Hstat.p0(1)];
        rmse0 = [rmse0 Hstat.rmse0];
        pv0 = [pv0 Hstat.pv0];
        slope1 = [slope1 Hstat.p1(1)];
        rmse1 = [rmse1 Hstat.rmse1];
        pv1 = [pv1 Hstat.pv1];
        slope2 = [slope2 Hstat.p2(1)];
        rmse2 = [rmse2 Hstat.rmse2];
        pv2 = [pv2 Hstat.pv2];
        expB = [expB Hstat.exp_b];
        rmseExp = [rmseExp Hstat.rmseExp];
        pv_b = [pv_b Hstat.pv_b];
    end
    fake2.slope0(p,1) = mean(slope0);
    fake2.rmse0(p,1)  = mean(rmse0);
    fake2.pv0(p,1)    = mean(pv0<0.05);
    fake2.slope1(p,1) = mean(slope1);
    fake2.rmse1(p,1)  = mean(rmse1);
    fake2.pv1(p,1)    = mean(pv1<0.05);
    fake2.slope2(p,1) = mean(slope2);
    fake2.rmse2(p,1)  = mean(rmse2);
    fake2.pv2(p,1)    = mean(pv2<0.05);
    fake2.expB(p,1)   = mean(expB);
    fake2.rmseExp(p,1)= mean(rmseExp);
    fake2.pv_b(p,1)   = mean(pv_b<0.05);
    
end


%% animals average

for m=1:length(animals)
    idm = strcmpi(homeo_res.name,animals{m}); %list of record of animals m
    
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

data1_rmse2{1} = [average.down1.rmse0 average.diff.rmse0 average.delta1.rmse0 average.fake1.rmse0];
data1_rmse2{2} = [average.down1.rmse1 average.diff.rmse1 average.delta1.rmse1 average.fake1.rmse1];
data1_rmse2{3} = [average.down1.rmse2 average.diff.rmse2 average.delta1.rmse2 average.fake1.rmse2];
data1_rmse2{4} = [average.down1.rmseExp average.diff.rmseExp average.delta1.rmseExp average.fake1.rmseExp];

data1_pv{1} = [average.down1.pv0 average.diff.pv0 average.delta1.pv0 average.fake1.pv0]*100;
data1_pv{2} = [average.down1.pv1 average.diff.pv1 average.delta1.pv1 average.fake1.pv1]*100;
data1_pv{3} = [average.down1.pv2 average.diff.pv2 average.delta1.pv2 average.fake1.pv2]*100;
data1_pv{4} = [average.down1.pv_b average.diff.pv_b average.delta1.pv_b average.fake1.pv_b]*100;

%data2
data2_slope{1} = [average.down2.slope0 average.diff.slope0 average.delta2.slope0 average.fake2.slope0];
data2_slope{2} = [average.down2.slope1 average.diff.slope1 average.delta2.slope1 average.fake2.slope1];
data2_slope{3} = [average.down2.slope2 average.diff.slope2 average.delta2.slope2 average.fake2.slope2];
data2_slope{4} = [average.down2.expB average.diff.expB average.delta2.expB average.fake2.expB];

data2_rmse2{1} = [average.down2.rmse0 average.diff.rmse0 average.delta2.rmse0 average.fake2.rmse0];
data2_rmse2{2} = [average.down2.rmse1 average.diff.rmse1 average.delta2.rmse1 average.fake2.rmse1];
data2_rmse2{3} = [average.down2.rmse2 average.diff.rmse2 average.delta2.rmse2 average.fake2.rmse2];
data2_rmse2{4} = [average.down2.rmseExp average.diff.rmseExp average.delta2.rmseExp average.fake2.rmseExp];

data2_pv{1} = [average.down2.pv0 average.diff.pv0 average.delta2.pv0 average.fake2.pv0]*100;
data2_pv{2} = [average.down2.pv1 average.diff.pv1 average.delta2.pv1 average.fake2.pv1]*100;
data2_pv{3} = [average.down2.pv2 average.diff.pv2 average.delta2.pv2 average.fake2.pv2]*100;
data2_pv{4} = [average.down2.pv_b average.diff.pv_b average.delta2.pv_b average.fake2.pv_b]*100;


%% Plot

titles = {'1fit','2fit 0-2h','2fit end','exp fit'};
fontsize = 15;

sigtest = 'ranksum';
showPoints = 1;
showsig = 'sig';

figure, hold on 

%down1 delta fake
for i=1:4
    subplot(2,4,i), hold on
    PlotErrorBarN_KJ(data1_slope{i}, 'newfig',0, 'barcolors',{'k',[0.6 0.6 0.6],'b','r'}, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
    set(gca,'xtick',1:4,'XtickLabel',{'down', 'diff','delta','fake'},'Fontsize',fontsize),
    ylabel('slopes value (%/min/h)');
    title(titles{i}),
    
    
    subplot(2,4,i+4), hold on
    PlotErrorBarN_KJ(data1_pv{i}, 'newfig',0, 'barcolors',{'k',[0.6 0.6 0.6],'b','r'}, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
    set(gca,'xtick',1:4,'XtickLabel',{'down', 'diff','delta','fake'},'Fontsize',fontsize),
    ylabel('% of pvalues <0.05');
end


