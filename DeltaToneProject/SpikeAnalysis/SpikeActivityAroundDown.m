% SpikeActivityAroundDown
% 22.08.2017 KJ
%
% 
% 
% 
%   see 
%


clear

%% load data

%Epochs
load StateEpochSB SWSEpoch Wake REMEpoch
        
%MUA
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number
SpikeAll = PoolNeurons(S,NumNeurons);

%Down states
try
    load newDownState Down
catch
    try
        load DownSpk Down
    catch
        Down = intervalSet([],[]);
    end
end
start_down = Start(Down);
end_down = End(Down);
tdowns = (Start(Down)+End(Down)/2);


%% Raster
figure, [fh,sq,sweeps] = RasterPETH(SpikeAll, ts(start_down(1:100)), -1000, +1500,'BinSize',50);


%% Correlogram SUA/Down

%correlo
for i=1:length(NumNeurons)
    %all down
    [CT(i,:), B] = CrossCorr(start_down,Range(PoolNeurons(S,NumNeurons(i))),1,1000);
    CTm(i,:) = CT(i,:)/max(CT(i,:));
    CTz(i,:) = zscore(CT(i,:));
    
    %first down
    [CT_begin(i,:), B] = CrossCorr(start_down(1:length(start_down)/3),Range(PoolNeurons(S,NumNeurons(i))),1,1000);
    CT_begin_m(i,:) = CT_begin(i,:)/max(CT_begin(i,:));
    CT_begin_z(i,:) = zscore(CT_begin(i,:));
    
    %last down
    [CT_end(i,:), B] = CrossCorr(start_down(2*length(start_down)/3:end),Range(PoolNeurons(S,NumNeurons(i))),1,1000);
    CT_end_m(i,:) = CT_end(i,:)/max(CT_end(i,:));
    CT_end_z(i,:) = zscore(CT_end(i,:));
    
end

%smooth
intv = 550:600;
smoothing = [0.001,1];

%mat1
Mat1 = CT_begin_m;
[~, id] = sort(mean(Mat1(:,intv),2));
Mat1 = SmoothDec(Mat1(id,:), smoothing);
%mat1
Mat2 = CT_end_m;
[~, id] = sort(mean(Mat2(:,intv),2));
Mat2 = SmoothDec(Mat2(id,:), smoothing);


%% PLOT
figure, 
subplot(1,2,1), imagesc(Mat1)
title('Early Down States'),

subplot(1,2,2), imagesc(Mat2)
title('Late Down States'),

suplabel('SUA around down states start','t')

