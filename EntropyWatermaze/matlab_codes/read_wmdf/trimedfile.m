function [raw_data,N_animal]=trimedfile(p_xy,t_end);

        [dim N_animal]=size(p_xy);
        raw_data=zeros(t_end,2,N_animal);
        xyn=zeros(t_end,2,N_animal);
        xyn=sort_time(t_end,N_animal,p_xy);
        raw_data=xyn(:,:,1:N_animal);
        