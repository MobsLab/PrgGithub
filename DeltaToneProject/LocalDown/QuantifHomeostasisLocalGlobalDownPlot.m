%%QuantifHomeostasisLocalGlobalDownPlot
% 05.09.2019 KJ
%
% Infos
%   script about homeostasis for real and fake delta
%
% see
%    QuantifHomeostasisPFCdeepFakeDelta QuantifHomeostasisLocalGlobalDown QuantifHomeostasieLocalSyncPlot
%   PlotAllHomeostasisCurvesLocalGlobal   
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifHomeostasisLocalGlobalDown.mat'))

% %animals
animals = unique(homeo_res.name);
list_mouse = homeo_res.name;

%exclude
list_mouse{2} = 'NoName';
list_mouse{5} = 'NoName';
list_mouse{12} = 'NoName';
list_mouse{13} = 'NoName';

list_mouse{16} = 'NoName';
list_mouse{17} = 'NoName';
list_mouse{18} = 'NoName';
% list_mouse{19} = 'NoName';



%% concatenate
globalDw.slope0  = []; globalDw.slope1  = []; globalDw.slope2  = []; globalDw.expB = [];
LocalDw.slope0 = []; LocalDw.slope1 = []; LocalDw.slope2 = []; LocalDw.expB = [];

globalDw.rmse0  = []; globalDw.rmse1  = []; globalDw.rmse2  = []; globalDw.rmseExp = [];
LocalDw.rmse0 = []; LocalDw.rmse1 = []; LocalDw.rmse2 = []; LocalDw.rmseExp = [];

globalDw.pv0  = []; globalDw.pv1  = []; globalDw.pv2  = []; globalDw.pv_b  = [];
LocalDw.pv0 = []; LocalDw.pv1 = []; LocalDw.pv2 = []; LocalDw.pv_b  = [];


for p=1:length(homeo_res.path)
    
    %down states 1
    Hstat = homeo_res.global.rescaled.Hstat{p};
    globalDw.slope0(p,1) = Hstat.p0(1);
    globalDw.rmse0(p,1)  = Hstat.rmse0;
    globalDw.pv0(p,1)    = mean(Hstat.pv0<0.05);
    globalDw.slope1(p,1) = Hstat.p1(1);
    globalDw.rmse1(p,1)  = Hstat.rmse1;
    globalDw.pv1(p,1)    = mean(Hstat.pv1<0.05);
    globalDw.slope2(p,1) = Hstat.p2(1);
    globalDw.rmse2(p,1)  = Hstat.rmse2;
    globalDw.pv2(p,1)    = mean(Hstat.pv2<0.05);
    globalDw.expB(p,1)   = Hstat.exp_b;
    globalDw.rmseExp(p,1)= Hstat.rmseExp;
    globalDw.pv_b(p,1)   = mean(Hstat.pv_b<0.05);
    
    %for LocalDw
    slope0 = []; slope1 = []; slope2 = [];
    rmse0 = []; rmse1 = []; rmse2 = [];
    pv0 = []; pv1 = []; pv2 = [];
    expB = []; rmseExp = []; pv_b = [];
    for tt=1:length(homeo_res.tetrodes{p})
        Hstat = homeo_res.local.rescaled.Hstat{p,tt};
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
    LocalDw.slope0(p,1) = median(slope0);
    LocalDw.rmse0(p,1)  = mean(rmse0);
    LocalDw.pv0(p,1)    = mean(pv0<0.5);
    LocalDw.slope1(p,1) = median(slope1);
    LocalDw.rmse1(p,1)  = mean(rmse1);
    LocalDw.pv1(p,1)    = mean(pv1<0.05);
    LocalDw.slope2(p,1) = median(slope2);
    LocalDw.rmse2(p,1)  = mean(rmse2);
    LocalDw.pv2(p,1)    = mean(pv2<0.05);
    LocalDw.expB(p,1)   = mean(expB);
    LocalDw.rmseExp(p,1)= mean(rmseExp);
    LocalDw.pv_b(p,1)   = mean(pv_b<0.05); 

end


%% animals average

for m=1:length(animals)
    idm = strcmpi(list_mouse,animals{m}); %list of record of animals m
    
    fn = fieldnames(globalDw);
    for k=1:numel(fn)
        datam = globalDw.(fn{k});
        average.globalDw.(fn{k})(m,1) = mean(datam(idm));
        
        datam = LocalDw.(fn{k});
        average.LocalDw.(fn{k})(m,1) = mean(datam(idm));
    end
end



%% data
%data1
data1_slope{1} = [average.globalDw.slope0 average.LocalDw.slope0];
data1_slope{2} = [average.globalDw.slope1 average.LocalDw.slope1];
data1_slope{3} = [average.globalDw.slope2 average.LocalDw.slope2];
% data1_slope{4} = [average.globalDw.expB average.LocalDw.expB];

data1_rmse2{1} = [average.globalDw.rmse0 average.LocalDw.rmse0];
data1_rmse2{2} = [average.globalDw.rmse1 average.LocalDw.rmse1];
data1_rmse2{3} = [average.globalDw.rmse2 average.LocalDw.rmse2];
% data1_rmse2{4} = [average.globalDw.rmseExp average.LocalDw.rmseExp];

data1_pv{1} = [average.globalDw.pv0 average.LocalDw.pv0]*100;
data1_pv{2} = [average.globalDw.pv1 average.LocalDw.pv1]*100;
data1_pv{3} = [average.globalDw.pv2 average.LocalDw.pv2]*100;
% data1_pv{4} = [average.globalDw.pv_b average.LocalDw.pv_b]*100;



%% Plot bar

titles = {'1fit','2fit 0-3h','2fit end'};
fontsize = 26;
colors_global = {[0 0.5 0],[1 1 0.8]};
colors_local  = {[0 0 1],[0 0.5 1]};
bar_y = [0.07 0.31 0.092];
XL = [0.6 2.3];
Xbar = [1.2 1.8];

figure, hold on 
for i=1:3
    subplot(1,3,i), hold on 
    data_s = data1_slope{i};
    
    line(XL,[0 0], 'Linewidth',1,'color','k','linestyle','--'), hold on
    notBoxPlot(data_s(:,1),Xbar(1), 'patchColors', colors_global),
    notBoxPlot(data_s(:,2),Xbar(2), 'patchColors', colors_local),
    for l=1:size(data_s,1)
        line(Xbar, [data_s(l,1) data_s(l,2)], 'color', [0.7 0.7 0.7]),
    end
    line(Xbar, [bar_y(i) bar_y(i)], 'color', 'k', 'linewidth', 1.5),
    text(1.5,bar_y(i)*1.03, '*', 'HorizontalAlignment','center','fontsize',20)

    set(gca,'xlim',XL,'xtick',Xbar,'XtickLabel',{'Global','Local'},'Fontsize',fontsize),
    
    ylabel('slopes value (%/min/h)');
    title(titles{i}),
    
end

% 
% 
% %% Plot bar
% 
% titles = {'1fit','2fit 0-3h','2fit end'};
% fontsize = 15;
% 
% sigtest = 'ranksum';
% showPoints = 1;
% showsig = 'sig';
% 
% figure, hold on 
% 
% %globalDw delta fake
% for i=1:3
%     subplot(1,3,i), hold on
%     PlotErrorBarN_KJ(data1_slope{i}, 'newfig',0, 'barcolors',{'k','b'}, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
%     set(gca,'xtick',1:2,'XtickLabel',{'Global','Local'},'Fontsize',fontsize),
%     ylabel('slopes value (%/min/h)');
%     title(titles{i}),
%     
%     
% %     subplot(2,3,i+3), hold on
% %     PlotErrorBarN_KJ(data1_pv{i}, 'newfig',0, 'barcolors',{'k','b'}, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
% %     set(gca,'xtick',1:2,'XtickLabel',{'Global','Local'},'Fontsize',fontsize),
% %     ylim([0 120]),
% %     ylabel('% of pvalues <0.05');
% end
% 
% 
% 






