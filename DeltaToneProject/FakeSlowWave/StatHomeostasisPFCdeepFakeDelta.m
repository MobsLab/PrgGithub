%%StatHomeostasisPFCdeepFakeDelta
% 20.10.2019 KJ
%
% Infos
%   stat
%
% see
%    QuantifHomeostasisPFCdeepFakeDelta QuantifHomeostasisPFCdeepFakeDeltaPlot
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

swa.pv0  = []; swa.pv1  = []; swa.pv2  = []; swa.pv_b  = [];
down.pv0  = []; down.pv1  = []; down.pv2  = []; down.pv_b  = [];
diff.pv0   = []; diff.pv1   = []; diff.pv2   = []; diff.pv_b  = [];
delta.pv0 = []; delta.pv1 = []; delta.pv2 = []; delta.pv_b  = [];
fake.pv0  = []; fake.pv1  = []; fake.pv2  = []; fake.pv_b  = []; 


for p=1:length(homeo_res.path)
    
    %down states 1
    Hstat = homeo_res.down.rescaled.Hstat{p};
    down.slope0(p,1) = Hstat.p0(1);
    down.pv0(p,1)    = mean(Hstat.pv0<0.05);
    down.slope1(p,1) = Hstat.p1(1);
    down.pv1(p,1)    = mean(Hstat.pv1<0.05);
    down.slope2(p,1) = Hstat.p2(1);
    down.pv2(p,1)    = mean(Hstat.pv2<0.05);
    down.expB(p,1)   = Hstat.exp_b;
    down.pv_b(p,1)   = mean(Hstat.pv_b<0.05);

    %delta diff
    Hstat = homeo_res.diff.rescaled.Hstat{p};
    diff.slope0(p,1) = Hstat.p0(1);
    diff.pv0(p,1)    = mean(Hstat.pv0<0.05);
    diff.slope1(p,1) = Hstat.p1(1);
    diff.pv1(p,1)    = mean(Hstat.pv1<0.05);
    diff.slope2(p,1) = Hstat.p2(1);
    diff.pv2(p,1)    = mean(Hstat.pv2<0.05);
    diff.expB(p,1)   = Hstat.exp_b;
    diff.pv_b(p,1)   = mean(Hstat.pv_b<0.05);
    
    %for delta1
    slope0 = []; slope1 = []; slope2 = [];
    pv0 = []; pv1 = []; pv2 = [];
    expB = []; rmseExp = []; pv_b = [];
    for ch=1:length(homeo_res.channels{p})
        Hstat = homeo_res.delta.rescaled.Hstat{p,ch};
        slope0 = [slope0 Hstat.p0(1)];
        pv0 = [pv0 Hstat.pv0];
        slope1 = [slope1 Hstat.p1(1)];
        pv1 = [pv1 Hstat.pv1];
        slope2 = [slope2 Hstat.p2(1)];
        pv2 = [pv2 Hstat.pv2];
        expB = [expB Hstat.exp_b];
        pv_b = [pv_b Hstat.pv_b];
    end
    %clean expB
    expB(abs(expB)>10)=nan;
    
    delta.slope0(p,1) = median(slope0);
    delta.pv0(p,1)    = mean(pv0<0.5);
    delta.slope1(p,1) = median(slope1);
    delta.pv1(p,1)    = mean(pv1<0.05);
    delta.slope2(p,1) = median(slope2);
    delta.pv2(p,1)    = mean(pv2<0.05);
    delta.expB(p,1)   = mean(expB);
    delta.pv_b(p,1)   = mean(pv_b<0.05); 
    
    %for other
    slope0 = []; slope1 = []; slope2 = [];
    pv0 = []; pv1 = []; pv2 = [];
    expB = []; rmseExp = []; pv_b = [];
    for ch=1:length(homeo_res.channels{p})
        Hstat = homeo_res.other.rescaled.Hstat{p,ch};
        slope0 = [slope0 Hstat.p0(1)];
        pv0 = [pv0 Hstat.pv0];
        slope1 = [slope1 Hstat.p1(1)];
        pv1 = [pv1 Hstat.pv1];
        slope2 = [slope2 Hstat.p2(1)];
        pv2 = [pv2 Hstat.pv2];
        expB = [expB Hstat.exp_b];
        pv_b = [pv_b Hstat.pv_b];
    end
    %clean expB
    expB(abs(expB)>10)=nan;
    
    fake.slope0(p,1) = mean(slope0);
    fake.pv0(p,1)    = mean(pv0<0.05);
    fake.slope1(p,1) = mean(slope1);
    fake.pv1(p,1)    = mean(pv1<0.05);
    fake.slope2(p,1) = mean(slope2);
    fake.pv2(p,1)    = mean(pv2<0.05);
    fake.expB(p,1)   = nanmean(expB);
    fake.pv_b(p,1)   = mean(pv_b<0.05);
    
    
    %for swa
    slope0 = []; slope1 = []; slope2 = [];
    pv0 = []; pv1 = []; pv2 = [];
    expB = []; rmseExp = []; pv_b = [];
    for ch=1:length(homeo_res.channels{p})
        Hstat = homeo_res.swa.rescaled.Hstat{p,ch};
        slope0 = [slope0 Hstat.p0(1)];
        pv0 = [pv0 Hstat.pv0];
        slope1 = [slope1 Hstat.p1(1)];
        pv1 = [pv1 Hstat.pv1];
        slope2 = [slope2 Hstat.p2(1)];
        pv2 = [pv2 Hstat.pv2];
        expB = [expB Hstat.exp_b];
        pv_b = [pv_b Hstat.pv_b];
    end
    %clean expB
    expB(abs(expB)>10)=nan;
    
    swa.slope0(p,1) = mean(slope0);
    swa.pv0(p,1)    = mean(pv0<0.05);
    swa.slope1(p,1) = mean(slope1);
    swa.pv1(p,1)    = mean(pv1<0.05);
    swa.slope2(p,1) = mean(slope2);
    swa.pv2(p,1)    = mean(pv2<0.05);
    swa.expB(p,1)   = nanmean(expB);
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
for i=1:4
    
    [p_slope{i},Stat_slope{i}] = PlotSigStat_KJ(data_slope{i},'optiontest','ranksum','paired',1);
    
    [p_pv{i},Stat_pv{i}] = PlotSigStat_KJ(data_pv{i},'optiontest','ranksum','paired',1);
    
end





