function [LogE,gal]=Final_measure(xyn,Xp,Yp,lambda); %ent_kl,E_bar; xyn = data, Xp, Yp = platform location, lambda = weighting

     del_x=1;                                        %what is this for?
     [t_end hala n0]=size(xyn);                      %t_end=number of data points per animal (589), hala=# of dimensions (2), n0=number of animals
     gal=zeros(n0,1);                                %generate n*1 matrix for P
     LogE=zeros(n0,1);                               %for H
     platx=repmat(Xp,t_end,n0);                      %fill t_end*n matrix with X loc of platform. this is for later math operations
     platy=repmat(Yp,t_end,n0);                      %same for Y coord of platform
     plat=repmat([Xp,Yp],t_end,1);                   %both X and Y - this is unused in the program
     
     % distance measure
     dist=zeros(t_end,n0);                           %make t_end*n matrix for dist values
     Xraw=permute(xyn(:,1,:),[1 3 2]);               %Xraw will now include just X coords & be rearranged to be X-coord,n,column index(now useless)
     Yraw=permute(xyn(:,2,:),[1 3 2]);               %same for Yraw
     d_x=permute(xyn(:,1,:),[1 3 2])-platx;          %calculates difference between X coord of path and X coord of Platform
     d_y=permute(xyn(:,2,:),[1 3 2])-platy;          %same for Y; Xraw and Yraw vars unnecessary?
     Dx=d_x*del_x;                                   %accomplishes nothing?
     Dy=d_y*del_x;                                  
     dist2=(Dx.^2+Dy.^2)'; %n*T - the ' transposes matrix to make it n by t_end.
     
     dist=sqrt(dist2);                               %Pythagorean theorem to calculate distance between two points.
     %%% Gallagher measure
     dist_ave=mean(dist,2);                          %calculate mean of dist along 2nd dimension of the matrix (by n).
     gal=(dist_ave);
     w=1;                                          %what is w for?
     %%%
     w=w';
     sw=sum(w,1);
     %%%%%%%%%%%%%% Entropy measure
     
     xm=(mean(w.*Dx,1))./sw;ym=(mean(w.*Dy,1))./sw;
     xxm=(mean(w.*Dx.*Dx,1))./sw;
     yym=(mean(w.*Dy.*Dy,1))./sw;
     xym=(mean(w.*Dx.*Dy,1))./sw;
     var_xy2=zeros(n0,1);
     Sig=zeros(2);
     eig_val=zeros(2,1);
     for i=1:n0 
       
       % det_Sig=det([xxm(i)-xm(i).^2,
       % xym(i)-xm(i)*ym(i);xym(i)-xm(i)*ym(i), yym(i)-ym(i)^2]);
       Sig=[xxm(i)-xm(i).^2, xym(i)-xm(i)*ym(i);xym(i)-xm(i)*ym(i), yym(i)-ym(i)^2];
       eig_val=eig(Sig);
       var_xy2(i)=eig_val(1)*eig_val(2);
       
     end

     mdist2=mean(w'.*dist2,2)./sw';%nx1
aa=mdist2;
LogE=2*0.5*log(aa)+2*0.5*(1/2)*log(var_xy2);%log(aa) = error entropy; log(var_xy2) = path entropy);





