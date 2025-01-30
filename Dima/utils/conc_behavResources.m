% Concatenate behavResources
clear all

%% Parameters
indir = '/media/mobsrick/DataMOBS101/Mouse-911/';
ntest = 4;
Day3 = '20190508';

suf = {'TestPre'};

%% Concatenate

% Load data
for i = 1:1:ntest
    a{i} = load([indir Day3 '/' suf{1} '/' suf{1} num2str(i) '/behavResources.mat']);
end

% Copy variables, common for each recording
ref = a{1}.ref;
mask = a{1}.mask;
Ratio_IMAonREAL = a{1}.Ratio_IMAonREAL;
frame_limits = a{1}.frame_limits;
BW_threshold = a{1}.BW_threshold;
smaller_object_size = a{1}.smaller_object_size;
sm_fact = a{1}.sm_fact;
strsz = a{1}.strsz;
smaller_object_size = a{1}.smaller_object_size;
SrdZone = a{1}.SrdZone;
Zone = a{1}.Zone;
ZoneLabels = a{1}.ZoneLabels;
DoorChangeMat = a{1}.DoorChangeMat;
th_immob = a{1}.th_immob;
thtps_immob = a{1}.thtps_immob;
delStim = a{1}.delStim;
delStimreturn = a{1}.delStimreturn;
% Save common variables
if exist([indir Day3 '/' suf{1} '/' 'behavResources.mat']) == 2
    save([indir Day3 '/' suf{1} '/behavResources.mat'], 'ref', 'mask', 'Ratio_IMAonREAL', 'frame_limits', 'BW_threshold', 'delStim',...
    'smaller_object_size', 'sm_fact', 'strsz', 'SrdZone', 'Zone', 'DoorChangeMat', 'th_immob', 'thtps_immob', 'delStimreturn',...
    'smaller_object_size', 'ZoneLabels', '-append');
%     save([indir Day3 '/' suf{1} '/behavResources.mat'], 'ref', 'mask', 'Ratio_IMAonREAL', 'frame_limits', 'BW_threshold',...
%     'smaller_object_size', 'sm_fact', 'strsz', 'SrdZone', '-append');
else
    save([indir Day3 '/' suf{1} '/behavResources.mat'], 'ref', 'mask', 'Ratio_IMAonREAL', 'frame_limits', 'BW_threshold', 'delStim',...
    'smaller_object_size', 'sm_fact', 'strsz', 'SrdZone', 'Zone', 'DoorChangeMat', 'th_immob', 'thtps_immob', 'delStimreturn',...
    'smaller_object_size', 'ZoneLabels');
%     save([indir Day3 '/' suf{1} '/behavResources.mat'], 'ref', 'mask', 'Ratio_IMAonREAL', 'frame_limits', 'BW_threshold',...
%     'smaller_object_size', 'sm_fact', 'strsz', 'SrdZone');
end

% Calculate duration, find the first timestamp ('offset') and number of indices for each test
% find also last timestaps for each session ('lasttime')
for i = 1:ntest
    TimeTemp{i} = Range(a{i}.Ytsd);
    duration(i) = TimeTemp{i}(end) - TimeTemp{i}(1);
    offset(i) = TimeTemp{i}(1);
    lind(i) = length(TimeTemp{i});
    lasttime(i) = TimeTemp{i}(end);
end
clear TimeTemp
% Concatenate Ytsd (type single tsd)
for i=1:ntest
    YtsdTimeTemp{i} = Range(a{i}.Ytsd);
    YtsdDataTemp{i} = Data(a{i}.Ytsd);
end
for i = 1:(ntest-1)
    YtsdTimeTemp{i+1} = YtsdTimeTemp{i+1}+sum(duration(1:i)+offset(i+1));
end
YtsdTime = [YtsdTimeTemp{1}; YtsdTimeTemp{2}; YtsdTimeTemp{3}; YtsdTimeTemp{4}];
% YtsdTime = [YtsdTimeTemp{1}; YtsdTimeTemp{2}];
ch = find(diff(YtsdTime) < 0); % check where
YtsdData = [YtsdDataTemp{1}; YtsdDataTemp{2}; YtsdDataTemp{3}; YtsdDataTemp{4}];
% YtsdData = [YtsdDataTemp{1}; YtsdDataTemp{2}];
Ytsd = tsd(YtsdTime, YtsdData);
% Save Ytsd
save([indir Day3 '/' suf{1} '/behavResources.mat'], 'Ytsd', '-append');
% save([indir Day3 '/behavResources.mat'], 'Ytsd', '-append');
clear YtsdTimeTemp YtsdDataTemp YtsdTime YtsdData


% Concatenate Xtsd (type single tsd)
for i=1:ntest
    XtsdTimeTemp{i} = Range(a{i}.Xtsd);
    XtsdDataTemp{i} = Data(a{i}.Xtsd);
end
for i = 1:(ntest-1)
    XtsdTimeTemp{i+1} = XtsdTimeTemp{i+1}+sum(duration(1:i)+offset(i+1));
end
XtsdTime = [XtsdTimeTemp{1}; XtsdTimeTemp{2}; XtsdTimeTemp{3}; XtsdTimeTemp{4}];
% XtsdTime = [XtsdTimeTemp{1}; XtsdTimeTemp{2}];
ch = find(diff(XtsdTime) < 0);
XtsdData = [XtsdDataTemp{1}; XtsdDataTemp{2}; XtsdDataTemp{3}; XtsdDataTemp{4}];
% XtsdData = [XtsdDataTemp{1}; XtsdDataTemp{2}];
Xtsd = tsd(XtsdTime, XtsdData);
% Save Xtsd
save([indir Day3 '/' suf{1} '/behavResources.mat'], 'Xtsd', '-append');
% save([indir Day3 '/behavResources.mat'], 'Xtsd', '-append');
clear XtsdTimeTemp XtsdDataTemp XtsdTime XtsdData

% Concatenate Vtsd (type single tsd); add fake value at the end (-1) to account for (x-1) length
for i=1:ntest
    VtsdTimeTemp{i} = Range(a{i}.Vtsd);
    VtsdDataTemp{i} = Data(a{i}.Vtsd);
end
for i=1:ntest
    if i == ntest
        VtsdTimeTemp{i} = [VtsdTimeTemp{i}];
        VtsdDataTemp{i} = [VtsdDataTemp{i}];
    else
        VtsdTimeTemp{i} = [VtsdTimeTemp{i}; lasttime(i)];
        VtsdDataTemp{i} = [VtsdDataTemp{i}; -1];
    end
end
for i = 1:(ntest-1)
    VtsdTimeTemp{i+1} = VtsdTimeTemp{i+1}+sum(duration(1:i)+offset(i+1));
end
VtsdTime = [VtsdTimeTemp{1}; VtsdTimeTemp{2}; VtsdTimeTemp{3}; VtsdTimeTemp{4}];
% VtsdTime = [VtsdTimeTemp{1}; VtsdTimeTemp{2}];
ch = find(diff(VtsdTime) < 0);
VtsdData = [VtsdDataTemp{1}; VtsdDataTemp{2}; VtsdDataTemp{3}; VtsdDataTemp{4}];
% VtsdData = [VtsdDataTemp{1}; VtsdDataTemp{2}];
Vtsd = tsd(VtsdTime, VtsdData);
% Save Vtsd
save([indir Day3 '/' suf{1} '/behavResources.mat'], 'Vtsd', '-append');
% save([indir Day3 '/behavResources.mat'], 'Vtsd', '-append');
clear VtsdTimeTemp VtsdDataTemp VtsdTime VtsdData

% Concatenate PosMatInit (type - array) 
for i=1:ntest
    PosMatInitTemp{i} = a{i}.PosMatInit; 
end
for i=1:(ntest-1)
    PosMatInitTemp{i+1}(:,1) = PosMatInitTemp{i+1}(:,1) + (sum(duration(1:i)))/1E4 + PosMatInitTemp{i+1}(1,1);
end
PosMatInit = cat(1, PosMatInitTemp{1}, PosMatInitTemp{2}, PosMatInitTemp{3}, PosMatInitTemp{4});
% PosMatInit = cat(1, PosMatInitTemp{1}, PosMatInitTemp{2});
ch = find(diff(PosMatInit(:,1)) <= 0);
% Save PosMatInit
save([indir Day3 '/' suf{1} '/behavResources.mat'], 'PosMatInit', '-append');
% save([indir Day3 '/behavResources.mat'], 'PosMatInit', '-append');
clear PosMatInitTemp

% Concatenate PosMat (type - array) 
for i=1:ntest
    PosMatTemp{i} = a{i}.PosMat; 
end
for i=1:(ntest-1)
    PosMatTemp{i+1}(:,1) = PosMatTemp{i+1}(:,1) + (sum(duration(1:i)))/1E4 + PosMatTemp{i+1}(1,1);
end
PosMat = cat(1, PosMatTemp{1}, PosMatTemp{2}, PosMatTemp{3}, PosMatTemp{4});
% PosMat = cat(1, PosMatTemp{1}, PosMatTemp{2});
ch = find(diff(PosMat(:,1)) <= 0);
% Save PosMat
save([indir Day3 '/' suf{1} '/behavResources.mat'], 'PosMat', '-append');
% save([indir Day3 '/behavResources.mat'], 'PosMat', '-append');
clear PosMatTemp

% Concatenate Freezeepoch (type single tsa)
for i = 1:1:ntest
    FreezeEpochTempStart{i} = Start(a{i}.FreezeEpoch);
    FreezeEpochTempEnd{i} = End(a{i}.FreezeEpoch);
end
for i = 1:(ntest-1)
    FreezeEpochTempStart{i+1} = FreezeEpochTempStart{i+1} + sum(duration(1:i)) + offset(i+1);
    FreezeEpochTempEnd{i+1} = FreezeEpochTempEnd{i+1} + sum(duration(1:i)) + offset(i+1);
end
FreezeEpochStart = [FreezeEpochTempStart{1}; FreezeEpochTempStart{2}; FreezeEpochTempStart{3}; FreezeEpochTempStart{4}];
% FreezeEpochStart = [FreezeEpochTempStart{1}; FreezeEpochTempStart{2}];
FreezeEpochEnd = [FreezeEpochTempEnd{1}; FreezeEpochTempEnd{2}; FreezeEpochTempEnd{3}; FreezeEpochTempEnd{4}];
% FreezeEpochEnd = [FreezeEpochTempEnd{1}; FreezeEpochTempEnd{2}];
FreezeEpoch = intervalSet(FreezeEpochStart, FreezeEpochEnd);
% Save FreezeEpoch
save([indir Day3 '/' suf{1} '/behavResources.mat'], 'FreezeEpoch', '-append');
% save([indir Day3 '/behavResources.mat'], 'FreezeEpoch', '-append');
clear FreezeEpochTempStart FreezeEpochTempEnd FreezeEpochStart FreezeEpochEnd= 

% Concatenate GotFrame (type - array) 
for i = 1:1:ntest
    GotFrameTemp{i} = a{i}.GotFrame;
end
GotFrame = cat(2, GotFrameTemp{1}, GotFrameTemp{2}, GotFrameTemp{3}, GotFrameTemp{4});
% Save PosMat
save([indir Day3 '/' suf{1} '/behavResources.mat'], 'GotFrame', '-append');
clear GotFrameTemp

% Concatenate im_diffInit (type - array) 
for i=1:ntest
    im_diffInitTemp{i} = a{i}.im_diffInit; 
end
for i=1:(ntest-1)
    im_diffInitTemp{i+1}(:,1) = im_diffInitTemp{i+1}(:,1) + (sum(duration(1:i)))/1E4 + im_diffInitTemp{i+1}(1,1);
end
im_diffInit = cat(1, im_diffInitTemp{1}, im_diffInitTemp{2}, im_diffInitTemp{3}, im_diffInitTemp{4});
% im_diffInit = cat(1, im_diffInitTemp{1}, im_diffInitTemp{2});
ch = find(diff(im_diffInit(:,1)) <= 0);
% Save im_diffInit
save([indir Day3 '/' suf{1} '/behavResources.mat'], 'im_diffInit', '-append');
% save([indir Day3 '/behavResources.mat'], 'im_diffInit', '-append');
clear im_diffInitTemp

% Concatenate im_diff (type - array) 
for i=1:ntest
    im_diffTemp{i} = a{i}.im_diff; 
end
for i=1:(ntest-1)
    im_diffTemp{i+1}(:,1) = im_diffTemp{i+1}(:,1) + (sum(duration(1:i)))/1E4 + im_diffTemp{i+1}(1,1);
end
im_diff = cat(1, im_diffTemp{1}, im_diffTemp{2}, im_diffTemp{3}, im_diffTemp{4});
% im_diff = cat(1, im_diffTemp{1}, im_diffTemp{2});
ch = find(diff(im_diff(:,1)) <= 0);
% Save im_diff
save([indir Day3 '/' suf{1} '/behavResources.mat'], 'im_diff', '-append');
% save([indir Day3 '/behavResources.mat'], 'im_diff', '-append');
clear im_diffTemp

% Concatenate Imdifftsd (type single tsd)
for i=1:ntest
    ImdifftsdTimeTemp{i} = Range(a{i}.Imdifftsd);
    ImdifftsdDataTemp{i} = Data(a{i}.Imdifftsd);
end
for i = 1:(ntest-1)
    ImdifftsdTimeTemp{i+1} = ImdifftsdTimeTemp{i+1}+sum(duration(1:i)+offset(i+1));
end
ImdifftsdTime = [ImdifftsdTimeTemp{1}; ImdifftsdTimeTemp{2}; ImdifftsdTimeTemp{3}; ImdifftsdTimeTemp{4}];
% ImdifftsdTime = [ImdifftsdTimeTemp{1}; ImdifftsdTimeTemp{2}];
ch = find(diff(ImdifftsdTime) < 0);
ImdifftsdData = [ImdifftsdDataTemp{1}; ImdifftsdDataTemp{2}; ImdifftsdDataTemp{3}; ImdifftsdDataTemp{4}];
% ImdifftsdData = [ImdifftsdDataTemp{1}; ImdifftsdDataTemp{2}];
Imdifftsd = tsd(ImdifftsdTime, ImdifftsdData);
% Save Imdifftsd
save([indir Day3 '/' suf{1} '/behavResources.mat'], 'Imdifftsd', '-append');
% save([indir Day3 '/behavResources.mat'], 'Imdifftsd', '-append');
clear ImdifftsdTimeTemp ImdifftsdDataTemp ImdifftsdTime ImdifftsdData

% Concatenate MouseTemp (type - array)
for i = 1:1:ntest
    MouseTempTemp{i} = a{i}.MouseTemp;
end
MouseTemp = cat(1, MouseTempTemp{1}, MouseTempTemp{2}, MouseTempTemp{3}, MouseTempTemp{4});
% MouseTemp = cat(1, MouseTempTemp{1}, MouseTempTemp{2});
% Save MouseTemp
save([indir Day3 '/' suf{1} '/behavResources.mat'], 'MouseTemp', '-append');
clear MouseTempTemp

% Concatenate Occup (type double vector 1* 7 - number of Zones)
for i = 1:1:ntest
    OccupTemp(i, 1:7) = a{i}.Occup;
end
Occup = mean(OccupTemp, 1);
Occupstd = std(OccupTemp, 1);
% Save Occup
save([indir Day3 '/' suf{1} '/behavResources.mat'], 'Occup', 'Occupstd', '-append');
clear OccupTemp

% Concatenate ZoneEpoch (type tsa * 7 - number of Zones)
for i = 1:1:ntest
    for k = 1:7
        ZoneEpochTempStart{i}{k} = Start(a{i}.ZoneEpoch{k});
        ZoneEpochTempEnd{i}{k} = End(a{i}.ZoneEpoch{k});
    end
end
for i = 1:(ntest-1)
    for k=1:7
        ZoneEpochTempStart{i+1}{k} = ZoneEpochTempStart{i+1}{k} + sum(duration(1:i)) + offset(i+1);
        ZoneEpochTempEnd{i+1}{k} = ZoneEpochTempEnd{i+1}{k} + sum(duration(1:i)) + offset(i+1);
    end
end
for k=1:7
    ZoneEpochStart{k} = [ZoneEpochTempStart{1}{k}; ZoneEpochTempStart{2}{k}; ZoneEpochTempStart{3}{k}; ZoneEpochTempStart{4}{k}];
    ZoneEpochEnd{k} = [ZoneEpochTempEnd{1}{k}; ZoneEpochTempEnd{2}{k}; ZoneEpochTempEnd{3}{k}; ZoneEpochTempEnd{4}{k}];
end
for k=1:7
    ZoneEpoch{k} = intervalSet(ZoneEpochStart{k}, ZoneEpochEnd{k});
end
% Save ZoneEpoch
save([indir Day3 '/' suf{1} '/behavResources.mat'], 'ZoneEpoch', '-append');
clear ZoneEpochTempStart ZoneEpochTempEnd ZoneEpochStart ZoneEpochEnd

% Concatenate ZoneIndices (type array of indices * 7 - number of Zones)
for i = 1:1:ntest
    for k = 1:7
        ZoneIndicesTemp{i}{k} = a{i}.ZoneIndices{k};
    end
end
for i = 1:(ntest-1)
    for k=1:7
        ZoneIndicesTemp{i+1}{k} = ZoneIndicesTemp{i+1}{k} + sum(lind(1:i));
    end
end
for k=1:7
    ZoneIndices{k} = [ZoneIndicesTemp{1}{k}; ZoneIndicesTemp{2}{k}; ZoneIndicesTemp{3}{k}; ZoneIndicesTemp{4}{k}];
end
% Save ZoneIndices
save([indir Day3 '/' suf{1} '/behavResources.mat'], 'ZoneIndices', '-append');
clear ZoneIndicesTemp


% Concatenate FreezeTime (type double vector 1* 7 - number of Zones)
for k = 1:7
	FreezeTime(k) = length(Data(Restrict(Xtsd,and(FreezeEpoch,ZoneEpoch{k}))))./length(Data((Restrict(Xtsd,ZoneEpoch{k}))));
end
% Save FreezeTime
save([indir Day3 '/' suf{1} '/behavResources.mat'], 'FreezeTime', '-append');

%% Clear bullshit
clear a dir_out ch Day3 duration i k lind indir ntest offset suf 
disp('All good')