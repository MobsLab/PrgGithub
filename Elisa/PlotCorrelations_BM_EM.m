
function [R,P,a,b,line_x,line_y]=PlotCorrelations_BM_EM(X_to_use , Y_to_use , varargin)

for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'Marker_Size'
            Marker_Size = varargin{i+1};
        case 'binned'
            binned = varargin{i+1};
        case 'color'
            color = varargin{i+1};
         case 'method'
            method = varargin{i+1};           
        case 'save_data'
        case 'legend'
            legend = varargin{i+1};
    end
end


if ~exist('Marker_Size')
    Marker_Size = 30;
end
if ~exist('binned')
    binned = 0;
end
if ~exist('color')
    color = 'k';
end
if ~exist('method')
    method = 'Pearson';
end 
if ~exist('legend')
    legend=0;
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

plot( X_to_use , Y_to_use ,'Color',color,'Marker','.','LineStyle','none','MarkerSize',Marker_Size); hold on; %makepretty

if size(X_to_use==1)
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
    if legend==0
        f=get(gca,'Children'); legend([f(3)],['R = ' num2str(R(2,1)) '     P = ' num2str(P(2,1))]);
    end
    line_x = (x(1:end-1)+x(2:end))/2;
    line_y = y;
    
else
    plot(x,y,'k','LineWidth',2);
    if legend==0
        f=get(gca,'Children'); legend([f(1)],['R = ' num2str(R) '     P = ' num2str(P)]);
    end
end


end
