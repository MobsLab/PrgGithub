clear all
tic
cd /media/DataMOBsRAIDN/SophieBToProcess/ProjectOBStim/14112016/FEAR-Mouse-458-14112016-01-Baseline/

load('behavResources.mat')
cd F14112016-0001/
clear RemData
ls=dir;
load(ls(3).name);
a=double(datas.image.*mask);
b=double(floor(a/8));
OrigPic=b;
for k=4:length(ls)
    k
    load(ls(k).name);
    a2=double(datas.image.*mask);
    b2=double(floor(a2/8));
    
    diffb=(b2-b);
    [vals]=find(abs(diffb)>0);
    RemData{k-3,1}=uint32(vals);
    RemData{k-3,2}=int8((diffb(vals)));
    %     bnew=b(:);bnew(RemData{k-3,1})=bnew(RemData{k-3,1})+double(RemData{k-3,2});bnew=reshape(bnew,240,320);
    %     imagesc(bnew)
    %     pause(0.1)
    b=b2;
end
cd ..
toc

cd /media/DataMOBsRAIDN/SophieBToProcess/ProjectOBStim/14112016/FEAR-Mouse-458-14112016-01-Baseline/F14112016-0001
clear RemData
ls=dir;
load(ls(3).name);
a=double(datas.image.*mask);
b=double(floor(a/8));
OrigPic=b;
for k=4:length(ls)
    k
    load(ls(k).name);
    a2=double(datas.image.*mask);
    b2=double(floor(a2/8));
    
    diffb=(b2-b);
    [vals]=find(abs(diffb)>0);
    RemData{k-3,1}=uint32(vals);
    RemData{k-3,2}=int8((diffb(vals)));
    bnew=b(:);bnew(RemData{k-3,1})=bnew(RemData{k-3,1})+double(RemData{k-3,2});bnew=reshape(bnew,240,320);
    imagesc(bnew)
    pause(0.1)
    b=b2;
end
 
figure
b=(OrigPic);
for k=4:length(ls)
    load(ls(k).name);
    subplot(121)
imagesc(datas.image)
    title('original')
bnew=b(:);bnew(RemData{k-3,1})=bnew(RemData{k-3,1})+double(RemData{k-3,2});bnew=reshape(bnew,240,320);
        subplot(122)
imagesc(bnew)
  title('recosntructed compressed')
  pause(0.1)
    b=bnew;
    
end