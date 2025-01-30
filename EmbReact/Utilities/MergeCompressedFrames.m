clear all
load('CompressedFramesbis.mat')
numFr=1;
for i=StartFrames:Options.DownSample:length(ls)
    load([FrameFolder,ls(i).name])
    a2=double(datas.image.*Options.Mask);
    b2=double(floor(a2/8));
    diffb=(b2-b);
    vals=find(abs(diffb)>0);
    CompressionInfo.Location{numFr}=uint32(vals);
    CompressionInfo.Value{numFr}=int8((diffb(vals)));
    CompressionInfo.Time(numFr)=etime(datas.time,CompressionInfo.OrigTime);
    b=b2;
    numFr=numFr+1;
end

clear all
load('CompressedFrames.mat')
CompressionInfo1=CompressionInfo;
load('CompressedFramesbis.mat')
load('behavResources.mat')
FrameSize=size(Params.ref);
b=double(zeros(FrameSize));
for i=1:length(CompressionInfo.Location)
    bnew=b(:);
    bnew(CompressionInfo.Location{i})=bnew(CompressionInfo.Location{i})+double(CompressionInfo.Value{i});
    bnew=reshape(bnew,FrameSize(1),FrameSize(2));
    b=bnew;
end
LastFrame=b;
NumFrames=size(CompressionInfo.Location,2);
tempb=double(zeros(FrameSize));
bnew=tempb(:);
bnew(CompressionInfo1.Location{1})=bnew(CompressionInfo1.Location{1})+double(CompressionInfo1.Value{1});
bnew=reshape(bnew,FrameSize(1),FrameSize(2));
diffb=(bnew-LastFrame);
vals=find(abs(diffb)>0);
CompressionInfo.Location{NumFrames+1}=uint32(vals);
CompressionInfo.Value{NumFrames+1}=int8((diffb(vals)));

for k=2:size(CompressionInfo1.Location,2);
   CompressionInfo.Location{NumFrames+k}=CompressionInfo1.Location{k};
   CompressionInfo.Value{NumFrames+k}=CompressionInfo1.Value{k};
end