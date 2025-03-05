function [gamma_thresh , mu1 , mu2 , std1 , std2 , AshD] = GetGammaThresh_BM(sm_ghi, user_confirmation, PlotFig)

if nargin<3
    PlotFig=1;
end
if nargin<2
    user_confirmation=1;
end

sm_ghi(sm_ghi<=0)=[];
[Y,X]=hist(log(sm_ghi),1000);
Y=runmean(Y,5)/sum(Y);

[cf2,~]=createFit2gauss(X,Y,[]);
a = coeffvalues(cf2);
b = intersect_gaussians(a(2), a(5), a(3), a(6));

gamma_thresh=b(b<a(2)&b>a(5));
if isempty(gamma_thresh)
    gamma_thresh=b(b>a(2)&b<a(5));
end
mu1 = a(2);
mu2 = a(5);
std1 = a(3);
std2 = a(6);
AshD = sqrt(2)*(abs(mu2-mu1)/abs(std1+std2));

if or(PlotFig , isempty(gamma_thresh))
    plot(X,runmean(Y,5))
    hold on
    h_ = plot(cf2,'fit',0.95);
    set(h_(1),'Color',[1 0 0],...
        'LineStyle','-', 'LineWidth',2,...
        'Marker','none', 'MarkerSize',6);
    leg = legend('example');
    set(leg,'visible','off');
    
    try
        line([(gamma_thresh) (gamma_thresh)],[0 max(Y)],'linewidth',4,'color','R')
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
        [cf2,~]=createFit2gauss(X,Y,[peaksY(1) peaksX(1) abs(peaksX(1)-peaksX(2))/2 peaksY(2) peaksX(2) abs(peaksX(1)-peaksX(2))/2]);
        h_ = plot(cf2,'fit',0.95);
        set(h_(1),'color',[0 1 0],...
            'LineStyle','-', 'LineWidth',2,...
            'Marker','none', 'MarkerSize',6);
        a= coeffvalues(cf2);
        b=intersect_gaussians(a(2), a(5), a(3), a(6));
        
        mu1 = a(2);
        mu2 = a(5);
        std1 = a(3);
        std2 = a(6);
        AshD = sqrt(2)*(abs(mu2-mu1)/abs(std1+std2));
        
        gamma_thresh=b(b>a(2)&b<a(5));
        
        try
            line([(gamma_thresh) (gamma_thresh)],[0 max(Y)],'linewidth',4,'color','g')
            in=1;
        catch
            in=0;
        end
        
        if in==0
            if in==0
                disp('Select desired cut off threshold')
                
                [gamma_thresh,~]=(ginput(1));
            end
            
        end
        
    end
end

end