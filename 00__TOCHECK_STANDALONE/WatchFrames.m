% cd /media/MOBSDataRotation/LabyrintheenU/Mouse404/20160705/ProjetEmbReact_M404_20161705_Cond/Cond3/raw/F05072016-fichier08/F05072016-0001
%close all
a=dir;
figure
clf
colormap gray
for k=3:length(a)
   load(a(k).name) 
    if k==3
       t0=datas.time; 
    end
   pause(0.005)
   imagesc(squeeze(datas.image(:,:,1))'),axis xy
%    hold on
%    plot(PosMat(:,2)*Ratio_IMAonREAL,PosMat(:,3)*Ratio_IMAonREAL,'*')

   title(datas.time)
   title(etime(datas.time,t0))
   hold off
end