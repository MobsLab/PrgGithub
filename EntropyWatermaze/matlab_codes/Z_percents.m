function [perz_c,perz_cp]=Z_percents(scale_data_g1,scale_data_g2,Xp,Yp,Rz);

        [t_end d1 N1]=size(scale_data_g1);
        percent_z=zeros(N1,1);
        
        plat=repmat([Xp,Yp],t_end,1);
        
        for i=1:N1
          
          fz=sqrt(sum((scale_data_g1(:,:,i)-plat).^2,2))<=Rz;
          percent_z(i)=(sum(fz)/t_end)*100;
          
        end
        perz_c=percent_z;
        
        [t_end d1 N2]=size(scale_data_g2);
        percent_zd2=zeros(N2,1);
        for i=1:N2
          
          fz=sqrt(sum((scale_data_g2(:,:,i)-plat).^2,2))<=Rz;
          percent_zd2(i)=(sum(fz)/t_end)*100;
          
        end
        perz_cp=percent_zd2;
        