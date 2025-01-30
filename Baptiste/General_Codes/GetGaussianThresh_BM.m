
function thresh=GetGaussianThresh_BM(Data_to_use, user_confirmation, newPlo)

if nargin<3
    newPlo=1;
end
if nargin<2
    user_confirmation=1;
end

Data_to_use(Data_to_use<=0)=[];
[Y,X]=hist(log10(Data_to_use),1000);
Y=Y/sum(Y);
% st_ = [1.07e-2 0 0.101 3.49e-3 1.5 0.21];
[cf2,goodness2]=createFit2gauss(X,Y,[]);
a= coeffvalues(cf2);
b=intersect_gaussians(a(2), a(5), a(3), a(6));
% modified by SB March 2018 to generalise to situations with more wake
% than slee
thresh=b(find(b>a(2)&b<a(5)));
%     [~,ind]=max(Y);
%     thresh=b(b>X(ind));
if newPlo, figure ; end
plot(X,Y)
hold on
h_ = plot(cf2,'fit',0.95);
set(h_(1),'Color',[1 0 0],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
try
    line([(thresh) (thresh)],[0 max(Y)],'linewidth',4,'color','R')
    if user_confirmation
        in=input('happy? 1/0 ');
    else
        in=1;
    end
catch
    in=0;
end


if in==0
    disp('Please show me where the two peaks are')
    [peaksX,peaksY]=(ginput(2));
    [cf2,goodness2]=createFit2gauss(X,Y,[peaksY(1) peaksX(1) abs(peaksX(1)-peaksX(2))/2 peaksY(2) peaksX(2) abs(peaksX(1)-peaksX(2))/2]);
    h_ = plot(cf2,'fit',0.95);
    set(h_(1),'color',[0 1 0],...
        'LineStyle','-', 'LineWidth',2,...
        'Marker','none', 'MarkerSize',6);
    a= coeffvalues(cf2);
    b=intersect_gaussians(a(2), a(5), a(3), a(6));
    % modified by SB March 2018 to generalise to situations with more wake
    % than slee
    thresh=b(find(b>a(2)&b<a(5)));
    %     [~,ind]=max(Y);
    %     thresh=b(b>X(ind));
    
    try
        line([(thresh) (thresh)],[0 max(Y)],'linewidth',4,'color','g')
        in=input('happy? 1/0 ');
    catch
        in=0;
    end
    
    if in==0
        if in==0
            disp('Select desired cut off threshold')
            
            [thresh,~]=(ginput(1));
        end
        
    end
    
end


end