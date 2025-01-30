%TestDownDetectionM403

clear

load('SpikeData.mat')
exclude = [];
for i=1:length(TT)
    if TT{i}(1)==4 || TT{i}(1)==5
        exclude = [exclude i];
    end
end

load('SpikesToAnalyse/PFCx_Neurons.mat')
NumNeurons = number;
NumNeurons(ismember(NumNeurons,exclude)) = [];


%% 

%params
t_start      =  -1e4; %1s
t_end        = 1e4; %1s
binsize_mua  = 2; %2ms
minDuration  = 75;
maxDuration  = 30e4;

%tones
load('DeltaSleepEvent.mat', 'TONEtime2')
tones_tmp = TONEtime2; % + Dir.delay{p}*1E4;
ToneEvent = ts(tones_tmp);

%MUA
MUA  = GetMuaNeurons_KJ(NumNeurons, 'binsize',binsize_mua); 
    
%Down
load('DownState.mat', 'down_PFCx')
down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');


st_down = Start(down_PFCx);
end_down = End(down_PFCx);
%Up
up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
up_PFCx = dropLongIntervals(up_PFCx, maxDuration); %5sec
st_up = Start(up_PFCx);
end_up = End(up_PFCx);


%% Tones in up
ToneIn = Restrict(ToneEvent, up_PFCx);
tonesin_tmp = Range(ToneIn);
    
    
%% Rasters

raster_tsd = RasterMatrixKJ(MUA, ToneIn, t_start, t_end);


%% orders
%tones in up
ibefore = nan(length(tonesin_tmp), 1);
iafter = nan(length(tonesin_tmp), 1);
ipostdown = nan(length(tonesin_tmp), 1);
ipostup = nan(length(tonesin_tmp), 1);


for i=1:length(tonesin_tmp)        
    st_bef = st_up(find(st_up<tonesin_tmp(i),1,'last'));
    ibefore(i) = tonesin_tmp(i) - st_bef;

    end_aft = end_up(find(end_up>tonesin_tmp(i),1));
    iafter(i) = end_aft - tonesin_tmp(i);

    up_post = st_up(find(st_up>tonesin_tmp(i),1));
    ipostup(i) = up_post - tonesin_tmp(i);

    down_post = st_down(find(st_down>tonesin_tmp(i),1));
    ipostdown(i) = down_post - tonesin_tmp(i);

end
    


co=jet;
co(1,:)=[0 0 0]; %silences (M=0) are in black

x_mua = Range(raster_tsd);
MatMUA = Data(raster_tsd)';

[~,idx_order] = sort(ipostdown);

[~,idx_order] = sort(mean(MatMUA(:,x_mua>500&x_mua<1500),2));

MatMUA = MatMUA(idx_order, :);

%% plot
figure, hold on
colormap(co);

imagesc(x_mua/1E4, 1:size(MatMUA,1), MatMUA), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','w'), hold on
line([0.025 0.025], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA,1)], 'XLim',[-0.5 0.5]);
ylabel('# tones'),

yyaxis right
y_mua = mean(MatMUA,1);
y_mua = Smooth(y_mua ,1);
plot(x_mua/1E4, y_mua, 'color', 'w', 'linewidth', 2);
  







    