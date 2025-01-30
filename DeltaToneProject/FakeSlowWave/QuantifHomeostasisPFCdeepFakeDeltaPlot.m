%%QuantifHomeostasisPFCdeepFakeDeltaPlot
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
list_mouse = homeo_res.name;

%exclude
list_mouse{3} = 'NoName';
list_mouse{7} = 'NoName';
list_mouse{12} = 'NoName';
list_mouse{13} = 'NoName';
list_mouse{16} = 'NoName';
list_mouse{17} = 'NoName';


%% concatenate
swa.slope0  = []; swa.slope1  = []; swa.slope2  = []; swa.expB = [];
down.slope0  = []; down.slope1  = []; down.slope2  = []; down.expB = [];
diff.slope0   = []; diff.slope1   = []; diff.slope2   = []; diff.expB = [];
delta.slope0 = []; delta.slope1 = []; delta.slope2 = []; delta.expB = [];
fake.slope0  = []; fake.slope1  = []; fake.slope2  = []; fake.expB = [];

swa.rmse0  = []; swa.rmse1  = []; swa.rmse2  = []; swa.rmseExp = [];
down.rmse0  = []; down.rmse1  = []; down.rmse2  = []; down.rmseExp = [];
diff.rmse0   = []; diff.rmse1   = []; diff.rmse2   = []; diff.rmseExp = [];
delta.rmse0 = []; delta.rmse1 = []; delta.rmse2 = []; delta.rmseExp = [];
fake.rmse0  = []; fake.rmse1  = []; fake.rmse2  = []; fake.rmseExp = [];

swa.pv0  = []; swa.pv1  = []; swa.pv2  = []; swa.pv_b  = [];
down.pv0  = []; down.pv1  = []; down.pv2  = []; down.pv_b  = [];
diff.pv0   = []; diff.pv1   = []; diff.pv2   = []; diff.pv_b  = [];
delta.pv0 = []; delta.pv1 = []; delta.pv2 = []; delta.pv_b  = [];
fake.pv0  = []; fake.pv1  = []; fake.pv2  = []; fake.pv_b  = []; 


for p=1:length(homeo_res.path)
    
    %down states 1
    Hstat = homeo_res.down.rescaled.Hstat{p};
    down.slope0(p,1) = Hstat.p0(1);
    down.rmse0(p,1)  = Hstat.rmse0;
    down.pv0(p,1)    = mean(Hstat.pv0<0.05);
    down.slope1(p,1) = Hstat.p1(1);
    down.rmse1(p,1)  = Hstat.rmse1;
    down.pv1(p,1)    = mean(Hstat.pv1<0.05);
    down.slope2(p,1) = Hstat.p2(1);
    down.rmse2(p,1)  = Hstat.rmse2;
    down.pv2(p,1)    = mean(Hstat.pv2<0.05);
    down.expB(p,1)   = Hstat.exp_b;
    down.rmseExp(p,1)= Hstat.rmseExp;
    down.pv_b(p,1)   = mean(Hstat.pv_b<0.05);

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
        Hstat = homeo_res.delta.rescaled.Hstat{p,ch};
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
    %clean expB
    expB(abs(expB)>10)=nan;
    
    delta.slope0(p,1) = median(slope0);
    delta.rmse0(p,1)  = mean(rmse0);
    delta.pv0(p,1)    = mean(pv0<0.5);
    delta.slope1(p,1) = median(slope1);
    delta.rmse1(p,1)  = mean(rmse1);
    delta.pv1(p,1)    = mean(pv1<0.05);
    delta.slope2(p,1) = median(slope2);
    delta.rmse2(p,1)  = mean(rmse2);
    delta.pv2(p,1)    = mean(pv2<0.05);
    delta.expB(p,1)   = mean(expB);
    delta.rmseExp(p,1)= mean(rmseExp);
    delta.pv_b(p,1)   = mean(pv_b<0.05); 
    
    %for other
    slope0 = []; slope1 = []; slope2 = [];
    rmse0 = []; rmse1 = []; rmse2 = [];
    pv0 = []; pv1 = []; pv2 = [];
    expB = []; rmseExp = []; pv_b = [];
    for ch=1:length(homeo_res.channels{p})
        Hstat = homeo_res.other.rescaled.Hstat{p,ch};
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
    %clean expB
    expB(abs(expB)>10)=nan;
    
    fake.slope0(p,1) = mean(slope0);
    fake.rmse0(p,1)  = mean(rmse0);
    fake.pv0(p,1)    = mean(pv0<0.05);
    fake.slope1(p,1) = mean(slope1);
    fake.rmse1(p,1)  = mean(rmse1);
    fake.pv1(p,1)    = mean(pv1<0.05);
    fake.slope2(p,1) = mean(slope2);
    fake.rmse2(p,1)  = mean(rmse2);
    fake.pv2(p,1)    = mean(pv2<0.05);
    fake.expB(p,1)   = nanmean(expB);
    fake.rmseExp(p,1)= mean(rmseExp);
    fake.pv_b(p,1)   = mean(pv_b<0.05);
    
    
    %for swa
    slope0 = []; slope1 = []; slope2 = [];
    rmse0 = []; rmse1 = []; rmse2 = [];
    pv0 = []; pv1 = []; pv2 = [];
    expB = []; rmseExp = []; pv_b = [];
    for ch=1:length(homeo_res.channels{p})
        Hstat = homeo_res.swa.rescaled.Hstat{p,ch};
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
    %clean expB
    expB(abs(expB)>10)=nan;
    
    swa.slope0(p,1) = mean(slope0);
    swa.rmse0(p,1)  = mean(rmse0);
    swa.pv0(p,1)    = mean(pv0<0.05);
    swa.slope1(p,1) = mean(slope1);
    swa.rmse1(p,1)  = mean(rmse1);
    swa.pv1(p,1)    = mean(pv1<0.05);
    swa.slope2(p,1) = mean(slope2);
    swa.rmse2(p,1)  = mean(rmse2);
    swa.pv2(p,1)    = mean(pv2<0.05);
    swa.expB(p,1)   = nanmean(expB);
    swa.rmseExp(p,1)= mean(rmseExp);
    swa.pv_b(p,1)   = mean(pv_b<0.05);
    
end


%% animals average

for m=1:length(animals)
    idm = strcmpi(list_mouse,animals{m}); %list of record of animals m
    
    fn = fieldnames(down);
    for k=1:numel(fn)
        datam = down.(fn{k});
        average.down.(fn{k})(m,1) = mean(datam(idm));
        
        datam = diff.(fn{k});
        average.diff.(fn{k})(m,1) = mean(datam(idm));
        
        datam = delta.(fn{k});
        average.delta.(fn{k})(m,1) = mean(datam(idm));
        
        datam = fake.(fn{k});
        average.fake.(fn{k})(m,1) = mean(datam(idm));
        
        datam = swa.(fn{k});
        average.swa.(fn{k})(m,1) = mean(datam(idm));
    end
    
end



%% data
%data1
data_slope{1} = [average.delta.slope0 average.diff.slope0 average.down.slope0 average.swa.slope0 average.fake.slope0];
data_slope{2} = [average.delta.slope1 average.diff.slope1 average.down.slope1 average.swa.slope1 average.fake.slope1];
data_slope{3} = [average.delta.slope2 average.diff.slope2 average.down.slope2 average.swa.slope2 average.fake.slope2];
data_slope{4} = [average.delta.expB average.diff.expB average.down.expB average.swa.expB average.fake.expB];

data_pv{1} = [average.delta.pv0 average.diff.pv0 average.down.pv0 average.swa.pv0 average.fake.pv0]*100;
data_pv{2} = [average.delta.pv1 average.diff.pv1 average.down.pv1 average.swa.pv1 average.fake.pv1]*100;
data_pv{3} = [average.delta.pv2 average.diff.pv2 average.down.pv2 average.swa.pv0 average.fake.pv2]*100;
data_pv{4} = [average.delta.pv_b average.diff.pv_b average.down.pv_b average.swa.pv_b average.fake.pv_b]*100;


%% Plot

titles = {'1fit','2fit 0-3h','2fit end','exp fit'};
fontsize = 15;
barcolors = {'b',[0.6 0.6 0.6],'k',[0.3 0.2 0.3],'r'};

sigtest = 'ranksum';
showPoints = 0;
showsig = 'sig';

figure, hold on 

%down1 delta fake
for i=1:4
    subplot(2,4,i), hold on
    PlotErrorBarN_KJ(data_slope{i}, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
    set(gca,'xtick',1:5,'XtickLabel',{'type-1 SW', 'delta 2-layers', 'down', 'SWA', 'type-2 SW'},'Fontsize',fontsize), xtickangle(30)
    ylabel('slopes value (%/min/h)');
    title(titles{i}),
    
    
    subplot(2,4,i+4), hold on
    PlotErrorBarN_KJ(data_pv{i}, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
    set(gca,'xtick',1:5,'XtickLabel',{'type-1 SW', 'delta 2-layers', 'down', 'SWA', 'type-2 SW'},'Fontsize',fontsize), xtickangle(30)
    set(gca,'ylim', [0 120], 'ytick',0:20:100),
    ylabel('% of pvalues <0.05');
end





