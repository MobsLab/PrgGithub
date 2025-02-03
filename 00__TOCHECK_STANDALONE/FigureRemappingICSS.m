
%FigureRemappingICSS

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';


cd([filename,'Mouse029/20120209'])

a=2; MAP=StabilityPlaceField(a);
a=4; MAP=StabilityPlaceField(a);
a=5; MAP=StabilityPlaceField(a);
a=7; MAP=StabilityPlaceField(a);
a=8; MAP=StabilityPlaceField(a);
a=10; MAP=StabilityPlaceField(a);
a=12; MAP=StabilityPlaceField(a);

figure('color',[1 1 1]), imagesc(MAP{1}), axis xy
figure('color',[1 1 1]), imagesc(MAP{2}), axis xy
figure('color',[1 1 1]), imagesc(MAP{4}), axis xy


MAPtest=(MAP{1}+MAP{2})/2;
[r,p]=corrcoef(MAPtest,MAP{4}(:));

[r,p]=corrcoef(MAP{5}(:),MAP{4}(:));





for i=1:length(S)
    
   MAP=StabilityPlaceField(i); close all
   
   MAPtest=(MAP{1}+MAP{2})/2;
   [r,p]=corrcoef(MAPtest(:),MAP{4}(:)); R(i,1)=r(1,2);
   [r,p]=corrcoef(MAP{5}(:),MAP{4}(:)); R(i,2)=r(1,2);
   [r,p]=corrcoef(MAP{1}(:),MAP{2}(:)); R(i,3)=r(1,2);
   
end



cd([filename,'Mouse026/20120109'])

a=6; MAP=StabilityPlaceField(a);
a=13; MAP=StabilityPlaceField(a);
a=19; MAP=StabilityPlaceField(a);
a=22; MAP=StabilityPlaceField(a);

figure('color',[1 1 1]), imagesc(MAP{11}), axis xy
figure('color',[1 1 1]), imagesc(MAP{9}), axis xy
[r,p]=corrcoef(MAP{9}(:),MAP{11}(:));





