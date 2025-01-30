%this program uses functions such as "circle" and "find_angle" "density_map"
%"smooth"
%load('../data/data_cn370'); p_xy=data_cn370;
%data1=p_xy;
%rawdata_c=data; %size: Tx2xn

%load('../data/data_cnp388');p_xy=data_cnp388;
%data2=p_xy;
%rawdata_cp=data;

%load('testds');rawdata_c=p_xy;rawdata_cp=p_xy;

function denplot(rawdata_c,rawdata_cp);
%%%
WMinit

num=gcf;


for kk=1:2
%     kk
    figure(num+1);
%uiload; xyn_type=p_xy;
%%%% for henry
if kk==1
   
xyn_type=rawdata_c;

end 
if kk==2
xyn_type=rawdata_cp;
end
%%%%%%
[t_end d2 n_type]=size(xyn_type);
%function [my_map]=denplot(xyn_type,n_type,t_end);




fac=10/n_type; %normalized to the 10 animals


%sel_anim=[1:n_type]; %selected animals
%num_sel=length(sel_anim);
%%%%%%%%%%%%%%%     DENSITY MAP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xymap_n=density_map(xyn_type,n_type,t_end);      %%%

xymap=sum(xymap_n,3);

%%%%%%%%%%%%%%% SMOOTH DENSITIES
scale=10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rplat=5;
Rplat_s=Rplat/scale;
xplat_s=Xp/scale;
yplat_s=Yp/scale;
[xymap_smt,xymap_hist_smt]=smooth(xymap,scale);


%%%%%%%%%%%%%%%%%%%%%
my_map=xymap_smt*fac;
%%%%%%%%%%%%%%%%%%%

vec=[1:length(my_map(:,1))];



%%%%                                 Map for Paul
subplot(1,2,kk)

clim=[0 1];
imagesc(my_map,clim); 
%axis ij;
axis off ;
axis equal

%colorbar('YTickLabel',[0;1;2;3; 4; ; 6; ; 7; 8;9; 10])
hold on; circle([xplat_s/sc yplat_s/sc],Rplat_s/sc,25,'k.');
hold on; circle([Xctr/(scale*sc) Yctr/(scale*sc)],60/(scale*sc),200,'white');
%hold on; rectangle('Position', [Xctr/(scale*sc) Yctr/(scale*sc),2,3]);
%hold on; circle([-22*2+120 120-2*22]/scale,20*1.75/scale,80,'k.');

set(gcf, 'color', 'white');
hold on; pcolor(vec,vec,my_map);
shading interp; axis equal

%%%%%%%%%%%%%%%%%%%%%%
%figure; contourf(vec,vec,my_map); axis ij;
%axis equal tight off
%set(gcf, 'color', 'white');
%hold on; circle([xplat_s yplat_s]/del_x,Rplat_s/del_x,15,'k');

%%%%%%%%%%%%%%%%%   3D plot
% figure;
% set(gcf, 'color', 'white');
% 
% surf(my_map,'FaceColor','interp','EdgeColor','none','FaceLighting','phong');
% axis ij tight off;


end


