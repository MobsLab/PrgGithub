function [C_c,C_cp]=Crossings(rawdata_c,rawdata_cp,Xp,Yp,Rc);

        [t_end d1 N]=size(rawdata_c);
        C_c=zeros(N,1);
        plat=repmat([Xp,Yp],t_end,1);
        
        for i=1:N
          fz=sqrt(sum((rawdata_c(:,:,i)-plat).^2,2))<=Rc;
          
          dfz=diff(fz);
          C_c(i)=sum(dfz==1);
          
        end
        
        %first=C_c   %Shows Crossings values for each animal in the first
        %dataset; Useful to compare with Actimertrics results
        [t_end d1 N]=size(rawdata_cp);
        
        C_cp=zeros(N,1);
        for i=1:N
          
          fz=sqrt(sum((rawdata_cp(:,:,i)-plat).^2,2))<=Rc;
          dfz=diff(fz);
          C_cp(i)=sum(dfz==1);
        
        end
        %second=C_cp %Shows Crossings values for each animal in the second
        %dataset; Useful to compare with Actimertrics results