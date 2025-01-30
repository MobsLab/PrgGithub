% cd /media/MOBSDataRotation/LabyrintheenU/Mouse404/20160705/ProjetEmbReact_M404_20161705_Cond/Cond3/raw/F05072016-fichier08/F05072016-0001
%close all
a=dir;
figure
clf
colormap gray
for k=6:2:length(a)
   load(a(k).name) 
    if k==6
       t0=datas.time; 
    end
   pause(0.01)
   imagesc(datas.image)
   %title(datas.time)
   title(etime(datas.time,t0))
end