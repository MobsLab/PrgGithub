clear all
cd /media/DataMOBS81/MTZL-Exp/SLEEP-Mouse-689&666&739&740-18052018_00
a = VideoReader('F12062018-0000.avi');

Mouse = 1;
load('/media/DataMOBS81/MTZL-Exp/SLEEP-Mouse-689&666&739&740-18052018_00/Mouse739-BaselineSleep/behavResources.mat')
Pos{Mouse}(1,:) = PosMat(:,3)*Ratio_IMAonREAL;
Pos{Mouse}(2,:) = PosMat(:,2)*Ratio_IMAonREAL;
Mask{Mouse} = mask;

Mouse = 2;
load('/media/DataMOBS81/MTZL-Exp/SLEEP-Mouse-689&666&739&740-18052018_00/Mouse740-BaselineSleep/behavResources.mat')
Pos{Mouse}(1,:) = PosMat(:,3)*Ratio_IMAonREAL;
Pos{Mouse}(2,:) = PosMat(:,2)*Ratio_IMAonREAL;
Mask{Mouse} = mask;

load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MTZL-Exp/Mouse666/18052018/behavResources.mat')
Mouse = 3;
Pos{Mouse}(1,:) = PosMat(:,3)*Ratio_IMAonREAL;
Pos{Mouse}(2,:) = PosMat(:,2)*Ratio_IMAonREAL;
Mask{Mouse} = mask;

load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MTZL-Exp/Mouse689/18052018/behavResources.mat')
Mouse = 4;
Pos{Mouse}(1,:) = PosMat(:,3)*Ratio_IMAonREAL;
Pos{Mouse}(2,:) = PosMat(:,2)*Ratio_IMAonREAL;
Mask{Mouse} = mask;


for frame = 10001:10:96521
    fr = read(a,frame);
    fr = fr(:,:,1);
    fr = double(fr)/256;
    fr = (fr*(frame_limits(2)-frame_limits(1)))+frame_limits(1);
    
    for Mouse = 1:4
        MouseTempAll{Mouse}((frame-1)/10+1-1000) = nanmean(nanmean(fr(floor(Pos{Mouse}(1,frame))-4:floor(Pos{Mouse}(1,frame))+4,floor(Pos{Mouse}(2,frame)-4:floor(Pos{Mouse}(2,frame)+4)))));
        MouseTempAll_meth2{Mouse}((frame-1)/10+1-1000) = max(max(fr.*double(Mask{Mouse})));
    end
    
end

TempOutput(isnan(ValuesInput))=[];
ValuesInput(isnan(ValuesInput))=[];
for Mouse = 1:4
    MouseTempAllCorr{Mouse} = (interp1(ValuesInput,TempOutput, MouseTempAll{Mouse}));
    MouseTempAll_meth2Corr{Mouse} = (interp1(ValuesInput,TempOutput, MouseTempAll_meth2{Mouse}));
    MeanTemp(Mouse) = nanmedian( MouseTempAllCorr{Mouse});
end

figure
colormap([0,0,1;0,0,1;1,0,0;1,0,0])
nhist(MouseTempAll_meth2Corr,'binfactor',1,'samebins','proportion','color','colormap')
box off
xlabel('Temperature (°C)')