function [gamma_thresh , mu1 , mu2 , std1 , std2 , AshD] = GetGammaThresh_BM(sm_ghi, user_confirmation, newPlo)

if nargin<3
    newPlo=1;
end
if nargin<2
    user_confirmation=1;
end

sm_ghi(sm_ghi<=0)=[];
[Y,X]=hist(log(sm_ghi),1000);
Y=Y/sum(Y);
% st_ = [1.07e-2 0 0.101 3.49e-3 1.5 0.21];
[cf2,goodness2]=createFit2gauss(X,Y,[]);
a= coeffvalues(cf2);
b=intersect_gaussians(a(2), a(5), a(3), a(6));
% modified by SB March 2018 to generalise to situations with more wake
% than slee
%     [~,ind]=max(Y);
%     gamma_thresh=b(b>X(ind));
if newPlo, figure ; end
plot(X,Y)
hold on
h_ = plot(cf2,'fit',0.95);
set(h_(1),'Color',[1 0 0],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
try
    if user_confirmation
        disp('place threshold please');
        [gamma_thresh,~]=(ginput(1));
    else
        in=1;
    end
catch
    in=0;
end
close
end