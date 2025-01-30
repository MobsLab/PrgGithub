function theta_thresh=Get1015Thresh(rat_theta)
[Y,X]=hist(rat_theta,100);
Y=Y/sum(Y);
[cf2,goodness2,output]=createFit1gauss(X,Y);
a=coeffvalues(cf2);
theta_thresh=((find(abs(output.residuals)'./Y>0.5)));
lim=find(X<a(2),1,'last');
theta_thresh=X(theta_thresh(find(theta_thresh<lim,1,'last')));

figure
plot(X,Y)
hold on
h_ = plot(cf2,'fit');
set(h_(1),'Color',[1 0 0],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
try
    line([(theta_thresh) (theta_thresh)],[0 max(Y)],'linewidth',4,'color','b')
end

%in=input('happy? 1/0');
in=1;


if in==0
                    disp('Select desired cut off threshold')
    [theta_thresh,~]=(ginput(1));
end
% 
% in=input('happy? 1/0 ');
% if in==0
%     disp('Please show me where the two peaks are')
%     [peaksX,peaksY]=(ginput(2));
%     [cf2,goodness2]=createFit2gauss(X,Y,[peaksY(1) peaksX(1) abs(peaksX(1)-peaksX(2))/2 peaksY(2) peaksX(2) abs(peaksX(1)-peaksX(2))/2]);
%     h_ = plot(cf2,'fit',0.95);
%     set(h_(1),'color',[0 1 0],...
%         'LineStyle','-', 'LineWidth',2,...
%         'Marker','none', 'MarkerSize',6);
%     a= coeffvalues(cf2);
%     b=intersect_gaussians(a(2), a(5), a(3), a(6));
%     [~,ind]=max(Y);
%     theta_thresh=b(b>X(ind));
%     try
%         line([(theta_thresh) (theta_thresh)],[0 max(Y)],'linewidth',4,'color','g')
%         in=input('happy? 1/0 ');
%     catch
%         in=0;
%     end
%     
%     if in==0
%         if in==0
%             disp('Select desired cut off threshold')
%             
%             [theta_thresh,~]=(ginput(1));
%         end
%         
%     end
%     
% end

end