%CreateDatasetForNN

clear
%Load data
load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP
load ChannelsToAnalyse/PFCx_sup
eval(['load LFPData/LFP',num2str(channel)])
LFPsup=LFP;
clear LFP
clear channel
load StateEpochSB SWSEpoch
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number

% params
frequency_sampling = 1000;
mua_binsize=10;
window_size = 5; %in s
size_dataset = 50000;

%get lfp
EEGdeep = ResampleTSD(LFPdeep,frequency_sampling);
EEGsup = ResampleTSD(LFPsup,frequency_sampling);


%% get mua
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q = MakeQfromS(ST,mua_binsize*10); %binsize*10 to be in E-4s

%Restrict and Create Data Set
data_starts = datasample(Range(Restrict(EEGdeep, SWSEpoch)), size_dataset);
data_starts = sort(data_starts);

training = cell(0);
mua = cell(0);
smooth_mua = cell(0);

for i=1:length(data_starts)
    if mod(i,1000)==0
        disp(i)
    end
    subEpoch = intervalSet(data_starts(i), data_starts(i) + window_size * 1E4);
    
    sub_deep = Restrict(EEGdeep, subEpoch);
    sub_sup = Restrict(EEGsup, subEpoch);
    training{i} = [Data(sub_sup)' ; Data(sub_deep)'];
    
    sub_mua = Restrict(Q, subEpoch);
    mua{i} = full(Data(sub_mua))';
    smooth_mua{i} = smooth(full(Data(sub_mua)),6)';

end

%Format data set for hdf5
training_sup = zeros(length(training),length(training{1}));
training_deep = zeros(length(training),length(training{1}));
test_mua = zeros(length(mua),length(mua{1}));
test_smua = zeros(length(smooth_mua),length(smooth_mua{1}));
bad_rows = [];
for i=1:length(training)
    if mod(i,1000)==0
        disp(i)
    end
    if length(training{i})==5000
        training_sup(i,:) = training{i}(1,:);
        training_deep(i,:) = training{i}(2,:);
        test_mua(i,:) = mua{i};
        test_smua(i,:) = smooth_mua{i};
    else
        bad_rows = [bad_rows i];
    end
end
%remove bad rows
training_sup(bad_rows,:) = [];
training_deep(bad_rows,:) = [];
test_mua(bad_rows,:) = [];
test_smua(bad_rows,:) = [];


%Write
hdf5write('ds_mouse244_2.h5', '/training_sup', s);
hdf5write('ds_mouse244_2.h5', '/training_deep', training_deep, 'WriteMode', 'append');
hdf5write('ds_mouse244_2.h5', '/test_mua', test_mua, 'WriteMode', 'append');
hdf5write('ds_mouse244_2.h5', '/test_smooth_mua', test_smua, 'WriteMode', 'append');




