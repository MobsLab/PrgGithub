clear all
load('CompressedFrames.mat')
load('behavResources_SB.mat')
tps=Range(Behav.Ytsd,'s');
FrameSize=size(Params.ref);
figure;
b=double(zeros(FrameSize));
    XDat=Data(Behav.Xtsd)/Params.pixratio;
    YDat=Data(Behav.Ytsd)/Params.pixratio;

for i=1:length(CompressionInfo.Location)
    bnew=b(:);
    bnew(CompressionInfo.Location{i})=bnew(CompressionInfo.Location{i})+double(CompressionInfo.Value{i});
    bnew=reshape(bnew,FrameSize(1),FrameSize(2));
    imagesc(bnew)
    hold on
    plot(XDat(i),YDat(i),'r*')
    title(num2str(tps(i)))
    pause(0.001)
    hold off
    b=bnew;
end
