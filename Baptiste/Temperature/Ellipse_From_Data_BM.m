

function Ellipse = Ellipse_From_Data_BM(X,Y)

x_c=nanmean(X);
y_c=nanmean(Y);

a=nanstd(X);
b=nanstd(Y);
theta_r  = linspace(0,2*pi);

Ellipse(:,1)    = x_c +a*cos( theta_r );
Ellipse(:,2)    = y_c + b*sin( theta_r );



