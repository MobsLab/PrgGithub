function [xyn_type_map]=density_map(xyn_type,n_type,t_end);
%enter the type e.g pbs and n_type e.g n_pbs=57

D=240; %number of pixels

%%%%%%%%%%%%%%%%%%pbs data
xyn_type_map=zeros(D,D,n_type);
for j=1:n_type
    for i=1:t_end
   
    J_cord=round(xyn_type(i,1,j));
    I_cord=round(xyn_type(i,2,j));
    
    if J_cord <= 0
        J_cord = 1;
    end
    
    if I_cord <= 0
        I_cord=1;
    end
    
    xyn_type_map(I_cord,J_cord,j)=xyn_type_map(I_cord,J_cord,j)+1;
end
end


