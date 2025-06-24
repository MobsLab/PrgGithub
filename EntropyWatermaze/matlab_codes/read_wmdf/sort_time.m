function [xyn_data]=sort_time(t_end,N_data,data);

        xyn_data=zeros(t_end,2,N_data);
        txyn=[];
        c=0;
        for i=1:N_data
          c=c+1;
          txyn{i}=data{i}(1:t_end,:);
          b=txyn{i}(:);
          b=b(t_end+1:3*t_end);
          c_1=b(1:t_end);
          c_2=b(t_end+1:2*t_end);
          d=[c_1; c_2];
          xyn_data(:,:,c)=reshape(d,t_end,2);
        end