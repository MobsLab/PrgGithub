%%RipplesDownDeltaDelayDistributionPlot
% 26.08.2019 KJ
%
% Delay between ripples and good/false deltas - down ...
%
%
% see
%   RipplesInDownN2N3Effect FigureExampleFakeSlowWaveRipple1
%   RipplesDownDeltaDelayDistribution
%



%load
clear

load(fullfile(FolderDeltaDataKJ,'RipplesDownDeltaDelayDistribution.mat'))


%params
edges_before = -700:10:0;
edges_after = 0:10:700;
animals = unique(ripples_res.name);


%% distrib

for p=1:length(ripples_res.path)   
    
    
    %sham vs down
    y_data = ripples_res.sham.before{p}/10; y_data = -y_data(y_data<max(abs(edges_before)));
    [sham.before.y{p}, sham.before.x{p}] = histcounts(y_data, edges_before, 'Normalization','probability');
    sham.before.x{p} = sham.before.x{p}(1:end-1);
    
    y_data = ripples_res.sham.after{p}/10; y_data = y_data(y_data<max(edges_after));
    [sham.after.y{p}, sham.after.x{p}] = histcounts(y_data, edges_after, 'Normalization','probability');
    sham.after.x{p} = sham.after.x{p}(1:end-1);
    
    %ripples vs down
    y_data = ripples_res.down.before{p}/10; y_data = -y_data(y_data<max(abs(edges_before)));
    [down.before.y{p}, down.before.x{p}] = histcounts(y_data, edges_before, 'Normalization','probability');
    down.before.x{p} = down.before.x{p}(1:end-1);
    
    y_data = ripples_res.down.after{p}/10; y_data = y_data(y_data<max(edges_after));
    [down.after.y{p}, down.after.x{p}] = histcounts(y_data, edges_after, 'Normalization','probability');
    down.after.x{p} = down.after.x{p}(1:end-1);
    
    %ripples vs all deltas
    y_data = ripples_res.deltas.before{p}/10; y_data = -y_data(y_data<max(abs(edges_before)));
    [deltas.before.y{p}, deltas.before.x{p}] = histcounts(y_data, edges_before, 'Normalization','probability');
    deltas.before.x{p} = deltas.before.x{p}(1:end-1);
    
    y_data = ripples_res.deltas.after{p}/10; y_data = y_data(y_data<max(edges_after));
    [deltas.after.y{p}, deltas.after.x{p}] = histcounts(y_data, edges_after, 'Normalization','probability');
    deltas.after.x{p} = deltas.after.x{p}(1:end-1);
    
    %ripples vs good deltas
    y_data = ripples_res.good.before{p}/10; y_data = -y_data(y_data<max(abs(edges_before)));
    [good.before.y{p}, good.before.x{p}] = histcounts(y_data, edges_before, 'Normalization','probability');
    good.before.x{p} = good.before.x{p}(1:end-1);
    
    y_data = ripples_res.good.after{p}/10; y_data = y_data(y_data<max(edges_after));
    [good.after.y{p}, good.after.x{p}] = histcounts(y_data, edges_after, 'Normalization','probability');
    good.after.x{p} = good.after.x{p}(1:end-1);
    
    %ripples vs false deltas
    y_data = ripples_res.fake.before{p}/10; y_data = -y_data(y_data<max(abs(edges_before)));
    [fake.before.y{p}, fake.before.x{p}] = histcounts(y_data, edges_before, 'Normalization','probability');
    fake.before.x{p} = fake.before.x{p}(1:end-1);
    
    y_data = ripples_res.fake.after{p}/10; y_data = y_data(y_data<max(edges_after));
    [fake.after.y{p}, fake.after.x{p}] = histcounts(y_data, edges_after, 'Normalization','probability');
    fake.after.x{p} = fake.after.x{p}(1:end-1);
    
    %ripples corrected vs false deltas
    y_data = ripples_res.fakecorrected.before{p}/10; y_data = -y_data(y_data<max(abs(edges_before)));
    [fakecorrect.before.y{p}, fakecorrect.before.x{p}] = histcounts(y_data, edges_before, 'Normalization','probability');
    fakecorrect.before.x{p} = fakecorrect.before.x{p}(1:end-1);
    
    y_data = ripples_res.fakecorrected.after{p}/10; y_data = y_data(y_data<max(edges_after));
    [fakecorrect.after.y{p}, fakecorrect.after.x{p}] = histcounts(y_data, edges_after, 'Normalization','probability');
    fakecorrect.after.x{p} = fakecorrect.after.x{p}(1:end-1);
    
    
end





%% average distributions


%sham vs down
d_before.sham = [];
d_after.sham = [];
x_before.sham = sham.before.x{1};
x_after.sham  = sham.after.x{1};
%ripples vs down
d_before.down = [];
d_after.down = [];
x_before.down = down.before.x{1};
x_after.down  = down.after.x{1};
%ripples vs all deltas
d_before.deltas = [];
d_after.deltas = [];
x_before.deltas = deltas.before.x{1};
x_after.deltas  = deltas.after.x{1};
%ripples vs good deltas
d_before.good = [];
d_after.good = [];
x_before.good = good.before.x{1};
x_after.good  = good.after.x{1};
%ripples vs false deltas
d_before.fake = [];
d_after.fake = [];
x_before.fake = fake.before.x{1};
x_after.fake  = fake.after.x{1};
%ripples corrected vs false deltas
d_before.fakecorrect = [];
d_after.fakecorrect = [];
x_before.fakecorrect = fakecorrect.before.x{1};
x_after.fakecorrect  = fakecorrect.after.x{1};


for m=1:length(animals)
    
    %sham vs down
    sham.before_mouse = [];
    sham.after_mouse = [];
    %ripples vs down
    down.before_mouse = [];
    down.after_mouse = [];
    %ripples vs all deltas
    deltas.before_mouse = [];
    deltas.after_mouse = [];
    %ripples vs good deltas
    good.before_mouse = [];
    good.after_mouse = [];
    %ripples vs false deltas
    fake.before_mouse = [];
    fake.after_mouse = [];
    %ripples corrected vs false deltas
    fakecorrect.before_mouse = [];
    fakecorrect.after_mouse = [];
    
    
    %loop over records of animals
    for p=1:length(ripples_res.path)
        if strcmpi(ripples_res.name{p},animals{m})
        
            %sham vs down
            sham.before_mouse = [sham.before_mouse ; sham.before.y{p}];
            sham.after_mouse = [sham.after_mouse ; sham.after.y{p}];
            %ripples vs down
            down.before_mouse = [down.before_mouse ; down.before.y{p}];
            down.after_mouse = [down.after_mouse ; down.after.y{p}];
            %ripples vs all deltas
            deltas.before_mouse = [deltas.before_mouse ; deltas.before.y{p}];
            deltas.after_mouse = [deltas.after_mouse ; deltas.after.y{p}];
            %ripples vs good deltas
            good.before_mouse = [good.before_mouse ; good.before.y{p}];
            good.after_mouse = [good.after_mouse ; good.after.y{p}];
            %ripples vs false deltas
            fake.before_mouse = [fake.before_mouse ; fake.before.y{p}];
            fake.after_mouse = [fake.after_mouse ; fake.after.y{p}];
            %ripples corrected vs false deltas
            fakecorrect.before_mouse = [fakecorrect.before_mouse ; fakecorrect.before.y{p}];
            fakecorrect.after_mouse = [fakecorrect.after_mouse ; fakecorrect.after.y{p}];
            
        end
    end

    
    %concatenate average
    
    %sham vs down
    d_before.sham  = [d_before.sham ; nanmean(sham.before_mouse,1)];
    d_after.sham   = [d_after.sham ; nanmean(sham.after_mouse,1)];
    %ripples vs down
    d_before.down  = [d_before.down ; nanmean(down.before_mouse,1)];
    d_after.down   = [d_after.down ; nanmean(down.after_mouse,1)];
    %ripples vs all deltas
    d_before.deltas  = [d_before.deltas ; nanmean(deltas.before_mouse,1)];
    d_after.deltas   = [d_after.deltas ; nanmean(deltas.after_mouse,1)];
    %ripples vs good deltas
    d_before.good  = [d_before.good ; nanmean(good.before_mouse,1)];
    d_after.good   = [d_after.good ; nanmean(good.after_mouse,1)];
    %ripples vs false deltas
    d_before.fake  = [d_before.fake ; nanmean(fake.before_mouse,1)];
    d_after.fake   = [d_after.fake ; nanmean(fake.after_mouse,1)];
    %ripples corrected vs false deltas
    d_before.fakecorrect  = [d_before.fakecorrect ; nanmean(fakecorrect.before_mouse,1)];
    d_after.fakecorrect   = [d_after.fakecorrect ; nanmean(fakecorrect.after_mouse,1)];
end


%mean and std

%sham vs down
std_before.sham   = std(d_before.sham,1) / sqrt(size(d_before.sham,1));
std_after.sham    = std(d_after.sham,1) / sqrt(size(d_after.sham,1));
d_before.sham     = nanmean(d_before.sham,1);
d_after.sham      = nanmean(d_after.sham,1);
%ripples vs down
std_before.down   = std(d_before.down,1) / sqrt(size(d_before.down,1));
std_after.down    = std(d_after.down,1) / sqrt(size(d_after.down,1));
d_before.down     = nanmean(d_before.down,1);
d_after.down      = nanmean(d_after.down,1);
%ripples vs all deltas
std_before.deltas   = std(d_before.deltas,1) / sqrt(size(d_before.deltas,1));
std_after.deltas    = std(d_after.deltas,1) / sqrt(size(d_after.deltas,1));
d_before.deltas     = nanmean(d_before.deltas,1);
d_after.deltas      = nanmean(d_after.deltas,1);
%ripples vs good deltas
std_before.good   = std(d_before.good,1) / sqrt(size(d_before.good,1));
std_after.good    = std(d_after.good,1) / sqrt(size(d_after.good,1));
d_before.good     = nanmean(d_before.good,1);
d_after.good      = nanmean(d_after.good,1);
%ripples vs false deltas
std_before.fake   = std(d_before.fake,1) / sqrt(size(d_before.fake,1));
std_after.fake    = std(d_after.fake,1) / sqrt(size(d_after.fake,1));
d_before.fake     = nanmean(d_before.fake,1);
d_after.fake      = nanmean(d_after.fake,1);
%ripples corrected vs false deltas
std_before.fakecorrect   = std(d_before.fakecorrect,1) / sqrt(size(d_before.fakecorrect,1));
std_after.fakecorrect    = std(d_after.fakecorrect,1) / sqrt(size(d_after.fakecorrect,1));
d_before.fakecorrect     = nanmean(d_before.fakecorrect,1);
d_after.fakecorrect      = nanmean(d_after.fakecorrect,1);


%concatenate before and after
%sham vs down
sham.plot.x = [x_before.sham x_after.sham];
sham.plot.y = [d_before.sham d_after.sham];
sham.plot.std = [std_before.sham std_after.sham]; 
%ripples vs down
down.plot.x = [x_before.down x_after.down];
down.plot.y = [d_before.down d_after.down];
down.plot.std = [std_before.down std_after.down]; 
%ripples vs all deltas
deltas.plot.x = [x_before.deltas x_after.deltas];
deltas.plot.y = [d_before.deltas d_after.deltas];
deltas.plot.std = [std_before.deltas std_after.deltas]; 
%ripples vs good deltas
good.plot.x = [x_before.good x_after.good];
good.plot.y = [d_before.good d_after.good];
good.plot.std = [std_before.good std_after.good]; 
%ripples vs fake deltas
fake.plot.x = [x_before.fake x_after.fake];
fake.plot.y = [d_before.fake d_after.fake];
fake.plot.std = [std_before.fake std_after.fake]; 
%ripples corrected vs false deltas
fakecorrect.plot.x = [x_before.fakecorrect x_after.fakecorrect];
fakecorrect.plot.y = [d_before.fakecorrect d_after.fakecorrect];
fakecorrect.plot.std = [std_before.fakecorrect std_after.fakecorrect];


%% PLOT

color_down = 'k';
color_sham = 'b';
color_all = 'm';
color_good = 'b';
color_fake = 'r';


gap = [0.10 0.04];
fontsize = 13;

figure, hold on

%sham/ripples vs down
subplot(2,2,1), hold on
h(1) = plot(down.plot.x, Smooth(down.plot.y, 0), 'color', color_down, 'linewidth',2);
h(2) = plot(sham.plot.x, Smooth(sham.plot.y, 0), 'color', color_sham, 'linewidth',2);
hs(1) = shadedErrorBar(down.plot.x, Smooth(down.plot.y, 0), Smooth(down.plot.std, 0), color_down);
hs(2) = shadedErrorBar(sham.plot.x, Smooth(sham.plot.y, 0), Smooth(sham.plot.std, 0), color_sham);

line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlim([-700 690])
xlabel('time from ripples/sham (ms)'), ylabel('density of down states')
legend(h,'ripples','sham')

%fake
subplot(2,2,2), hold on
h(1) = plot(down.plot.x, Smooth(down.plot.y, 0), 'color', color_down, 'linewidth',2);
h(2) = plot(fake.plot.x, Smooth(fake.plot.y, 0), 'color', color_fake, 'linewidth',2);
hs(1) = shadedErrorBar(down.plot.x, Smooth(down.plot.y, 0), Smooth(down.plot.std, 0), color_down);
hs(2) = shadedErrorBar(fake.plot.x, Smooth(fake.plot.y, 0), Smooth(fake.plot.std, 0), color_fake);
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlim([-700 690])
xlabel('time from ripples (ms)'), ylabel('density of delta waves')
legend(h,'down','fake deltas')

%good
subplot(2,2,3), hold on
h(1) = plot(down.plot.x, Smooth(down.plot.y, 0), 'color', color_down, 'linewidth',2);
h(2) = plot(good.plot.x, Smooth(good.plot.y, 0), 'color', color_good, 'linewidth',2);
hs(1) = shadedErrorBar(down.plot.x, Smooth(down.plot.y, 0), Smooth(down.plot.std, 0), color_down);
hs(2) = shadedErrorBar(good.plot.x, Smooth(good.plot.y, 0), Smooth(good.plot.std, 0), color_good);
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlim([-700 690])
xlabel('time from ripples (ms)'), ylabel('density of delta waves')
legend(h,'down','good deltas')

%ripples corrected vs fake
subplot(2,2,4), hold on
h(1) = plot(down.plot.x, Smooth(down.plot.y, 0), 'color', color_down, 'linewidth',2);
h(2) = plot(fakecorrect.plot.x, Smooth(fakecorrect.plot.y, 0), 'color', color_good, 'linewidth',2);
hs(1) = shadedErrorBar(down.plot.x, Smooth(down.plot.y, 0), Smooth(down.plot.std, 0), color_down);
hs(2) = shadedErrorBar(fakecorrect.plot.x, Smooth(fakecorrect.plot.y, 0), Smooth(fakecorrect.plot.std, 0), color_good);
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlim([-700 690])
xlabel('time from ripples (ms)'), ylabel('density of delta waves')
legend(h,'down','ripples corrected vs fake')


