function [xyn_type_smt,xyn_hist_smt]=smooth(xyn_type_map,scale);

Dm=240;
num=Dm/scale;
number_animl=length(xyn_type_map(1,1,:));
xyn_type_smt=zeros(num,num);
xyn_hist_smt=zeros(num,num);
xyn_map2=xyn_type_map(1:Dm,1:Dm,:);

j_s=1;
for j=1:num
    jbin=j*scale;
i_s=1;    
for i=1:num
    ibin=i*scale;
   aaa=xyn_map2(i_s:ibin,j_s:jbin);
   xyn_type_smt(i,j)=mean(aaa(:));
xyn_hist_smt(i,j)=sum(aaa(:));
   i_s=ibin+1;
end
j_s=jbin+1;
end

