%%FigISITonesShamOnDownStates
% 18.07.2019 KJ
%
% Look at the effect of tones/sham on the Intervals between down states

%
%   see 
%       IsiTonesOnDownStates IsiShamOnDownStates
%       FigureISIDeltaCurvePlot
%

%load
clear

load(fullfile(FolderDeltaDataKJ,'IsiTonesOnDownStates.mat'))
load(fullfile(FolderDeltaDataKJ,'IsiShamOnDownStates.mat'))

animals = unique(tones_res.name);


%% TONES - Pool by mouse

for i=1:3
    tones.n2_success{i}   = [];
    tones.n3_success{i}   = [];
    tones.nrem_success{i} = [];

    tones.n2_failed{i}    = [];
    tones.n3_failed{i}    = [];
    tones.nrem_failed{i}  = [];
end

for m=1:length(animals)
    
    %N2
    data = tones_res.n2.isi;
    for i=1:3
        mouse_success{i} = [];
        mouse_failed{i}  = [];
        for p=1:length(tones_res.path)
            if strcmpi(animals{m},tones_res.name{p})
                mouse_success{i} = [mouse_success{i} ; data.success{p}(:,i)];
                mouse_failed{i}  = [mouse_failed{i} ; data.failed{p}(:,i)];
            end
        end
        tones.n2_success{i} = [tones.n2_success{i} ; nanmean(mouse_success{i})/10];
        tones.n2_failed{i} = [tones.n2_failed{i} ; nanmean(mouse_failed{i})/10];
    end
    
    %N3
    data = tones_res.n3.isi;
    for i=1:3
        mouse_success{i} = [];
        mouse_failed{i}  = [];
        for p=1:length(tones_res.path)
            if strcmpi(animals{m},tones_res.name{p})
                mouse_success{i} = [mouse_success{i} ; data.success{p}(:,i)];
                mouse_failed{i}  = [mouse_failed{i} ; data.failed{p}(:,i)];
            end
        end
        tones.n3_success{i} = [tones.n3_success{i} ; nanmean(mouse_success{i})/10];
        tones.n3_failed{i} = [tones.n3_failed{i} ; nanmean(mouse_failed{i})/10];
    end
    
    %NREM
    data = tones_res.nrem.isi;
    for i=1:3
        mouse_success{i} = [];
        mouse_failed{i}  = [];
        for p=1:length(tones_res.path)
            if strcmpi(animals{m},tones_res.name{p})
                mouse_success{i} = [mouse_success{i} ; data.success{p}(:,i)];
                mouse_failed{i}  = [mouse_failed{i} ; data.failed{p}(:,i)];
            end
        end
        tones.nrem_success{i} = [tones.nrem_success{i} ; nanmean(mouse_success{i})/10];
        tones.nrem_failed{i} = [tones.nrem_failed{i} ; nanmean(mouse_failed{i})/10];
    end
    
end


%% Sham - Pool by mouse

for i=1:3
    sham.n2_success{i}   = [];
    sham.n3_success{i}   = [];
    sham.nrem_success{i} = [];

    sham.n2_failed{i}    = [];
    sham.n3_failed{i}    = [];
    sham.nrem_failed{i}  = [];
end

for m=1:length(animals)
    
    %N2
    data = sham_res.n2.isi;
    for i=1:3
        mouse_success{i} = [];
        mouse_failed{i}  = [];
        for p=1:length(tones_res.path)
            if strcmpi(animals{m},tones_res.name{p})
                mouse_success{i} = [mouse_success{i} ; data.success{p}(:,i)];
                mouse_failed{i}  = [mouse_failed{i} ; data.failed{p}(:,i)];
            end
        end
        sham.n2_success{i} = [sham.n2_success{i} ; nanmean(mouse_success{i})/10];
        sham.n2_failed{i} = [sham.n2_failed{i} ; nanmean(mouse_failed{i})/10];
    end
    
    %N3
    data = sham_res.n3.isi;
    for i=1:3
        mouse_success{i} = [];
        mouse_failed{i}  = [];
        for p=1:length(tones_res.path)
            if strcmpi(animals{m},tones_res.name{p})
                mouse_success{i} = [mouse_success{i} ; data.success{p}(:,i)];
                mouse_failed{i}  = [mouse_failed{i} ; data.failed{p}(:,i)];
            end
        end
        sham.n3_success{i} = [sham.n3_success{i} ; nanmean(mouse_success{i})/10];
        sham.n3_failed{i} = [sham.n3_failed{i} ; nanmean(mouse_failed{i})/10];
    end
    
    %NREM
    data = sham_res.nrem.isi;
    for i=1:3
        mouse_success{i} = [];
        mouse_failed{i}  = [];
        for p=1:length(tones_res.path)
            if strcmpi(animals{m},tones_res.name{p})
                mouse_success{i} = [mouse_success{i} ; data.success{p}(:,i)];
                mouse_failed{i}  = [mouse_failed{i} ; data.failed{p}(:,i)];
            end
        end
        sham.nrem_success{i} = [sham.nrem_success{i} ; nanmean(mouse_success{i})/10];
        sham.nrem_failed{i} = [sham.nrem_failed{i} ; nanmean(mouse_failed{i})/10];
    end
    
end


%% Stat on data

for i=1:3
    %N2 tones
    [R.n2.tones.success(i),~,E.n2.tones.success(i)] = MeanDifNan(tones.n2_success{i});
    [R.n2.tones.failed(i),~,E.n2.tones.failed(i)]   = MeanDifNan(tones.n2_failed{i});
    %N2 sham
    [R.n2.sham.success(i),~,E.n2.sham.success(i)] = MeanDifNan(sham.n2_success{i});
    [R.n2.sham.failed(i),~,E.n2.sham.failed(i)]   = MeanDifNan(sham.n2_failed{i});
    
    
    %N3 tones
    [R.n3.tones.success(i),~,E.n3.tones.success(i)] = MeanDifNan(tones.n3_success{i});
    [R.n3.tones.failed(i),~,E.n3.tones.failed(i)]   = MeanDifNan(tones.n3_failed{i});
    %N3 sham
    [R.n3.sham.success(i),~,E.n3.sham.success(i)] = MeanDifNan(sham.n3_success{i});
    [R.n3.sham.failed(i),~,E.n3.sham.failed(i)]   = MeanDifNan(sham.n3_failed{i});
    
    
    %NREM  tones
    [R.nrem.tones.success(i),~,E.nrem.tones.success(i)] = MeanDifNan(tones.nrem_success{i});
    [R.nrem.tones.failed(i),~,E.nrem.tones.failed(i)]   = MeanDifNan(tones.nrem_failed{i});
    %NREM sham
    [R.nrem.sham.success(i),~,E.nrem.sham.success(i)] = MeanDifNan(sham.nrem_success{i});
    [R.nrem.sham.failed(i),~,E.nrem.sham.failed(i)]   = MeanDifNan(sham.nrem_failed{i});
end


%test
for i=1:3
    %N2
    data_test = {tones.n2_success{i}, tones.n2_failed{i} , sham.n2_success{i} , sham.n2_failed{i}};
    [stats.n2{i}, groups.n2{i}] = TestStatData_KJ(data_test);
    
    %N3
    data_test = {tones.n3_success{i}, tones.n3_failed{i} , sham.n3_success{i} , sham.n3_failed{i}};
    [stats.n3{i}, groups.n3{i}] = TestStatData_KJ(data_test);
    
    %NREM
    data_test = {tones.nrem_success{i}, tones.nrem_failed{i} , sham.nrem_success{i} , sham.nrem_failed{i}};
    [stats.nrem{i}, groups.nrem{i}] = TestStatData_KJ(data_test);
end



%% lines

%N2 
x_line.n2{1} =  R.n2.tones.success; % success tones
x_line.n2{2} =  R.n2.tones.failed;  % failed tones
x_line.n2{3} =  R.n2.sham.success;  % success sham
x_line.n2{4} =  R.n2.sham.failed;   % failed sham

bar_line.n2{1} =  E.n2.tones.success; % success tones
bar_line.n2{2} =  E.n2.tones.failed;  % failed tones
bar_line.n2{3} =  E.n2.sham.success;  % success sham
bar_line.n2{4} =  E.n2.sham.failed;   % failed sham

%N3 
x_line.n3{1} =  R.n3.tones.success; % success tones
x_line.n3{2} =  R.n3.tones.failed;  % failed tones
x_line.n3{3} =  R.n3.sham.success;  % success sham
x_line.n3{4} =  R.n3.sham.failed;   % failed sham

bar_line.n3{1} =  E.n3.tones.success; % success tones
bar_line.n3{2} =  E.n3.tones.failed;  % failed tones
bar_line.n3{3} =  E.n3.sham.success;  % success sham
bar_line.n3{4} =  E.n3.sham.failed;   % failed sham

%NREM
x_line.nrem{1} =  R.nrem.tones.success; % success tones
x_line.nrem{2} =  R.nrem.tones.failed;  % failed tones
x_line.nrem{3} =  R.nrem.sham.success;  % success sham
x_line.nrem{4} =  R.nrem.sham.failed;   % failed sham

bar_line.nrem{1} =  E.nrem.tones.success; % success tones
bar_line.nrem{2} =  E.nrem.tones.failed;  % failed tones
bar_line.nrem{3} =  E.nrem.sham.success;  % success sham
bar_line.nrem{4} =  E.nrem.sham.failed;   % failed sham


%% PLOT

labels = {'Success Tones','Failed Tones','Success Sham','Failed Sham'};
NameISI = {'d(n,n+1)','d(n,n+2)','d(n,n+3)'}; %ISI
lineColors = {'b','r','k',[0.7 0.7 0.7]};


%N2
figure, hold on
%lines
for i=1:length(labels)
    hpl(i)=plot(x_line.n2{i}, 1:length(NameISI),'color',lineColors{i},'Linewidth',2); hold on
end
%error bar
for i=1:length(labels)
    eb=herrorbar(x_line.n2{i},1:length(NameISI),bar_line.n2{i},'.k'); hold on
    set(eb,'Linewidth',2); %bold error bar
end

title('ISI for N2','fontsize',20), xlabel('ms'), hold on,
set(gca, 'YTickLabel',NameISI, 'YTick',1:length(NameISI),'YLim',[0.5 length(NameISI)+0.5],'FontName','Times','fontsize',20), hold on,
set(gca, 'XTick',0:1000:3000,'XLim',[0 3000]);
legend(hpl,labels),
sigstar(groups.n2{1},stats.n2{1}),


%N3
figure, hold on
%lines
for i=1:length(labels)
    hpl(i)=plot(x_line.n3{i}, 1:length(NameISI),'color',lineColors{i},'Linewidth',2); hold on
end
%error bar
for i=1:length(labels)
    eb=herrorbar(x_line.n3{i},1:length(NameISI),bar_line.n3{i},'.k'); hold on
    set(eb,'Linewidth',2); %bold error bar
end

title('ISI for N3','fontsize',20), xlabel('ms'), hold on,
set(gca, 'YTickLabel',NameISI, 'YTick',1:length(NameISI),'YLim',[0.5 length(NameISI)+0.4],'FontName','Times','fontsize',20), hold on,
set(gca, 'XTick',0:1000:6000,'XLim',[0 2000]);

legend(hpl,labels)


%NREM
figure, hold on
%lines
for i=1:length(labels)
    hpl(i)=plot(x_line.nrem{i}, 1:length(NameISI),'color',lineColors{i},'Linewidth',2); hold on
end
%error bar
for i=1:length(labels)
    eb=herrorbar(x_line.nrem{i},1:length(NameISI),bar_line.nrem{i},'.k'); hold on
    set(eb,'Linewidth',2); %bold error bar
end

title('ISI for NREM','fontsize',20), xlabel('ms'), hold on,
set(gca, 'YTickLabel',NameISI, 'YTick',1:length(NameISI),'YLim',[0.5 length(NameISI)+0.7],'FontName','Times','fontsize',20), hold on,
set(gca, 'XTick',0:1000:6000,'XLim',[0 5000]);

legend(hpl,labels)





%% BAR plot

%N2
figure, hold on
for i=1:length(NameISI)
    databar = {tones.n2_success{i}, tones.n2_failed{i} , sham.n2_success{i} , sham.n2_failed{i}};
    subplot(1,3,i), hold on,
    [~,eb] = PlotErrorBarN_KJ(databar,'newfig',0,'horizontal',0,'barcolors',lineColors,'ShowSigstar','sig', 'optiontest','ranksum','paired',1);
    title([NameISI{i} ' N2'],'fontsize',20), hold on,
    set(eb,'Linewidth',2); %bold error bar
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'XTickLabelRotation',30, 'FontName','Times','fontsize',15), hold on,
%     set(gca, 'YTick',0:1000:3000,'YLim',[0 3500]);
    
end

%N3
figure, hold on
for i=1:length(NameISI)
    databar = {tones.n3_success{i}, tones.n3_failed{i} , sham.n3_success{i} , sham.n3_failed{i}};
    subplot(1,3,i), hold on,
    [~,eb] = PlotErrorBarN_KJ(databar,'newfig',0,'horizontal',0,'barcolors',lineColors,'ShowSigstar','sig', 'optiontest','ranksum','paired',1);
    title([NameISI{i} ' N3'],'fontsize',20), hold on,
    set(eb,'Linewidth',2); %bold error bar
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'XTickLabelRotation',30, 'FontName','Times','fontsize',15), hold on,
%     set(gca, 'YTick',0:1000:3000,'YLim',[0 3500]);
    
end

%NREM
figure, hold on
for i=1:length(NameISI)
    databar = {tones.nrem_success{i}, tones.nrem_failed{i} , sham.nrem_success{i} , sham.nrem_failed{i}};
    subplot(1,3,i), hold on,
    [~,eb] = PlotErrorBarN_KJ(databar,'newfig',0,'horizontal',0,'barcolors',lineColors,'ShowSigstar','sig', 'optiontest','ranksum','paired',1);
    title([NameISI{i} ' NREM'],'fontsize',20), hold on,
    set(eb,'Linewidth',2); %bold error bar
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'XTickLabelRotation',30,'FontName','Times','fontsize',15), hold on,
%     set(gca, 'YTick',0:1000:3000,'YLim',[0 3500]);
    
end



