%%QuantifFakeSlowWaveNeuronPlot
% 23.08.2019 KJ
%
%   
%   
%
% see
%   QuantifFakeSlowWaveNeuron 
%




% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifFakeSlowWaveNeuron.mat'))
animals = unique(fake_res.name);

%init
mua_min.deep.all  = []; mua_min.deep.good = []; mua_min.deep.fake  = [];
mua_min.sup.all  = []; mua_min.sup.good = []; mua_min.sup.fake  = [];
mua_decrease.deep.all  = []; mua_decrease.deep.good = []; mua_decrease.deep.fake  = [];
mua_decrease.sup.all  = []; mua_decrease.sup.good = []; mua_decrease.sup.fake  = [];
peakCC.deep.all  = []; peakCC.deep.good = []; peakCC.deep.fake  = [];
peakCC.sup.all  = []; peakCC.sup.good = []; peakCC.sup.fake  = [];



for m=1:length(animals)
    
    mouse.mua_min.deep.all  = []; mouse.mua_min.deep.good = []; mouse.mua_min.deep.fake  = [];
    mouse.mua_min.sup.all  = []; mouse.mua_min.sup.good = []; mouse.mua_min.sup.fake  = [];
    mouse.mua_decrease.deep.all  = []; mouse.mua_decrease.deep.good = []; mouse.mua_decrease.deep.fake  = [];
    mouse.mua_decrease.sup.all  = []; mouse.mua_decrease.sup.good = []; mouse.mua_decrease.sup.fake  = [];
    mouse.peakCC.deep.all  = []; mouse.peakCC.deep.good = []; mouse.peakCC.deep.fake  = [];
    mouse.peakCC.sup.all  = []; mouse.peakCC.sup.good = []; mouse.peakCC.sup.fake  = [];

    
    for p=1:length(fake_res.path)
        if strcmpi(animals{m},fake_res.name{p})
            
            %mua min
            mouse.mua_min.deep.all  = [mouse.mua_min.deep.all fake_res.mua_min.deep.all{p}];
            mouse.mua_min.deep.good = [mouse.mua_min.deep.good fake_res.mua_min.deep.good{p}];
            mouse.mua_min.deep.fake = [mouse.mua_min.deep.fake fake_res.mua_min.deep.fake{p}];
            
            mouse.mua_min.sup.all  = [mouse.mua_min.sup.all fake_res.mua_min.sup.all{p}];
            mouse.mua_min.sup.good = [mouse.mua_min.sup.good fake_res.mua_min.sup.good{p}];
            mouse.mua_min.sup.fake = [mouse.mua_min.sup.fake fake_res.mua_min.sup.fake{p}];
            
            
            %mua decrease
            mouse.mua_decrease.deep.all  = [mouse.mua_decrease.deep.all fake_res.mua_decrease.deep.all{p}];
            mouse.mua_decrease.deep.good = [mouse.mua_decrease.deep.good fake_res.mua_decrease.deep.good{p}];
            mouse.mua_decrease.deep.fake = [mouse.mua_decrease.deep.fake fake_res.mua_decrease.deep.fake{p}];
            
            mouse.mua_decrease.sup.all  = [mouse.mua_decrease.sup.all fake_res.mua_decrease.sup.all{p}];
            mouse.mua_decrease.sup.good = [mouse.mua_decrease.sup.good fake_res.mua_decrease.sup.good{p}];
            mouse.mua_decrease.sup.fake = [mouse.mua_decrease.sup.fake fake_res.mua_decrease.sup.fake{p}];
            
            %peakCC
            mouse.peakCC.deep.all  = [mouse.peakCC.deep.all fake_res.peakCC.deep.all{p}];
            mouse.peakCC.deep.good = [mouse.peakCC.deep.good fake_res.peakCC.deep.good{p}];
            mouse.peakCC.deep.fake = [mouse.peakCC.deep.fake fake_res.peakCC.deep.fake{p}];
            
            mouse.peakCC.sup.all  = [mouse.peakCC.sup.all fake_res.peakCC.sup.all{p}];
            mouse.peakCC.sup.good = [mouse.peakCC.sup.good fake_res.peakCC.sup.good{p}];
            mouse.peakCC.sup.fake = [mouse.peakCC.sup.fake fake_res.peakCC.sup.fake{p}];

        end
    end
    
    
    %average mua min
    mua_min.deep.all   = [mua_min.deep.all ; mean(mouse.mua_min.deep.all)];
    mua_min.deep.good  = [mua_min.deep.good ; mean(mouse.mua_min.deep.good)];
    mua_min.deep.fake  = [mua_min.deep.fake ; mean(mouse.mua_min.deep.fake)];
    
    mua_min.sup.all   = [mua_min.sup.all ; mean(mouse.mua_min.sup.all)];
    mua_min.sup.good  = [mua_min.sup.good ; mean(mouse.mua_min.sup.good)];
    mua_min.sup.fake  = [mua_min.sup.fake ; mean(mouse.mua_min.sup.fake)];
    
    %average mua decrease
    mua_decrease.deep.all   = [mua_decrease.deep.all ; mean(mouse.mua_decrease.deep.all)];
    mua_decrease.deep.good  = [mua_decrease.deep.good ; mean(mouse.mua_decrease.deep.good)];
    mua_decrease.deep.fake  = [mua_decrease.deep.fake ; mean(mouse.mua_decrease.deep.fake)];
    
    mua_decrease.sup.all   = [mua_decrease.sup.all ; mean(mouse.mua_decrease.sup.all)];
    mua_decrease.sup.good  = [mua_decrease.sup.good ; mean(mouse.mua_decrease.sup.good)];
    mua_decrease.sup.fake  = [mua_decrease.sup.fake ; mean(mouse.mua_decrease.sup.fake)];
    
    %average peakCC
    peakCC.deep.all   = [peakCC.deep.all ; mean(mouse.peakCC.deep.all)];
    peakCC.deep.good  = [peakCC.deep.good ; mean(mouse.peakCC.deep.good)];
    peakCC.deep.fake  = [peakCC.deep.fake ; mean(mouse.peakCC.deep.fake)];
    
    peakCC.sup.all   = [peakCC.sup.all ; mean(mouse.peakCC.sup.all)];
    peakCC.sup.good  = [peakCC.sup.good ; mean(mouse.peakCC.sup.good)];
    peakCC.sup.fake  = [peakCC.sup.fake ; mean(mouse.peakCC.sup.fake)];
    

end



%% Plot Deep

%params
color_all = [0.3 0.3 0.3];
color_good = 'b';
color_fake = 'r';

show_sig = 'sig';
barcolors={color_all,color_good,color_fake};
labels = {'all deep delta','good delta','fake delta'};

%data
data1 = [mua_min.deep.all mua_min.deep.good mua_min.deep.fake];
data2 = 100*[mua_decrease.deep.all mua_decrease.deep.good mua_decrease.deep.fake];
data3 = [peakCC.deep.all 4*peakCC.deep.good 4*peakCC.deep.fake];

%figure
figure, hold on

%MUA min
subplot(1,3,1), hold on
PlotErrorBarN_KJ(data1, 'x_data',1:3, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'ShowSigstar',show_sig); hold on
set(gca,'XTick',1:3 ,'XTickLabel',labels),
xlim([0 4]), ylabel('Minimum MUA on delta waves')

%MUA decrease
subplot(1,3,2), hold on
PlotErrorBarN_KJ(data2, 'x_data',1:3, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'ShowSigstar',show_sig); hold on
set(gca,'XTick',1:3 ,'XTickLabel',labels),
xlim([0 4]), ylabel('% MUA decrease on delta waves')

%Peak Cc
subplot(1,3,3), hold on
PlotErrorBarN_KJ(data3, 'x_data',1:3, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'ShowSigstar',show_sig); hold on
set(gca,'XTick',1:3 ,'XTickLabel',labels),
xlim([0 4]), ylabel('maximum of Cross-correlogram between down states and delta waves')


%% Plot Sup

%params
color_all = [0.3 0.3 0.3];
color_good = 'b';
color_fake = 'r';

show_sig = 'sig';
barcolors={color_all,color_good,color_fake};
labels = {'all sup delta','good delta','fake delta'};

%data
data1 = [mua_min.sup.all mua_min.sup.good mua_min.sup.fake];
data2 = 100*[mua_decrease.sup.all mua_decrease.sup.good mua_decrease.sup.fake];
data3 = [peakCC.sup.all 4*peakCC.sup.good 4*peakCC.sup.fake];

%figure
figure, hold on

%MUA min
subplot(1,3,1), hold on
PlotErrorBarN_KJ(data1, 'x_data',1:3, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'ShowSigstar',show_sig); hold on
set(gca,'XTick',1:3 ,'XTickLabel',labels),
xlim([0 4]), ylabel('Minimum MUA on delta waves')

%MUA decrease
subplot(1,3,2), hold on
PlotErrorBarN_KJ(data2, 'x_data',1:3, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'ShowSigstar',show_sig); hold on
set(gca,'XTick',1:3 ,'XTickLabel',labels),
xlim([0 4]), ylabel('% MUA decrease on delta waves')

%Peak Cc
subplot(1,3,3), hold on
PlotErrorBarN_KJ(data3, 'x_data',1:3, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'ShowSigstar',show_sig); hold on
set(gca,'XTick',1:3 ,'XTickLabel',labels),
xlim([0 4]), ylabel('maximum of Cross-correlogram between down states and delta waves')





