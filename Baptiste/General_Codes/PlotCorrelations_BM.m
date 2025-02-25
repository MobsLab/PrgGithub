

function [R,P,a,b,LINE]=PlotCorrelations_BM(X_to_use , Y_to_use , varargin)

for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'marker_size'
            marker_size = varargin{i+1};
        case 'binned'
            binned = varargin{i+1};
        case 'colortouse'
            colortouse = varargin{i+1};
        case 'method'
            method = varargin{i+1};
        case 'conf_bound'
            conf_bound = varargin{i+1};
    end
end


if ~exist('marker_size')
    marker_size = 30;
end
if ~exist('binned')
    binned = 0;
end
if ~exist('colortouse')
    colortouse = 'k';
end
if ~exist('method')
    method = 'Pearson';
end
if ~exist('conf_bound')
    conf_bound = 1;
end

if size(X_to_use,1)~=size(Y_to_use,1)
    try
        X_to_use=X_to_use';
    catch
        disp('dimensions issues')
    end
end


lgcl_vect = ~isnan(X_to_use)&~isnan(Y_to_use); % logical vector

X_to_use = X_to_use(lgcl_vect); Y_to_use = Y_to_use(lgcl_vect);

plot( X_to_use , Y_to_use ,'color',colortouse,'Marker','.','LineStyle','none','MarkerSize',marker_size); hold on; %makepretty

% if size(X_to_use==1)
if size(X_to_use, 1) == 1  %Temporary modification by Arsenii 03072024
    [R,P] = corr(X_to_use' , Y_to_use' , 'Type', method);
else
    [R,P] = corr(X_to_use , Y_to_use , 'Type', method);
end

p=polyfit( X_to_use , Y_to_use , 1);
x=[min(X_to_use)*1.1 max(X_to_use)*1.1]; y=x.*p(1)+p(2);

a=p(1); b=p(2);

if binned==1
    x = [linspace(min(X_to_use) , max(X_to_use) , 10)];
    for i=1:length(x)-1
        y(i) = nanmean(Y_to_use(and(x(i)<X_to_use , X_to_use<x(i+1))));
        i=i+1;
    end
    
    plot((x(1:end-1)+x(2:end))/2 , y,'.k','MarkerSize',40)
    plot((x(1:end-1)+x(2:end))/2 , y,'k','Linewidth',2)
    f=get(gca,'Children'); legend([f(3)],['R = ' num2str(R(2,1)) '     P = ' num2str(P(2,1))]);
    
    LINE = [(x(1:end-1)+x(2:end))/2 ; y];
    
else
    
    %     plot(x,y,cols2{1},'LineWidth',2);
    l = [xlim ylim];
    %     LINE = [l(1)*.8 l(2)*.8 ; a*l(1)+b a*l(2)+b];
    LINE = [l(1) l(2) ; a*l(1)+b a*l(2)+b]; %Temporary modification by Arsenii 03072024
    
    line([LINE(1,1) LINE(1,2)] , [LINE(2,1) LINE(2,2)] , 'color' , colortouse , 'LineWidth' , 2)
    f=get(gca,'Children'); legend([f(1)],['R = ' num2str(R) '     P = ' num2str(P)]);
    
end

if conf_bound
    S1 = size(X_to_use);
    S2 = size(Y_to_use);
    if S1(2)>S1(1)
        X_to_use = X_to_use';
    end
    if S2(2)>S2(1)
        Y_to_use = Y_to_use';
    end
    
    tbl = table(X_to_use,Y_to_use);
    mdl = fitlm(tbl,'Y_to_use ~ X_to_use');
    figure
    plot(mdl)
    
    f=get(gca,'Children');
    X1=f(1).XData;
    Y1=f(1).YData;
    X2=f(2).XData;
    Y2=f(2).YData;
    close
    
   
    temp1 = plot(X1,Y1,':k' , 'LineWidth',2);
    temp2 = plot(X2,Y2,':k', 'LineWidth',2);
    
    temp1.Color = colortouse;
    temp2.Color = colortouse;
    
    f=get(gca,'Children'); legend([f(3)],['R = ' num2str(R) '     P = ' num2str(P)]);
end
end



