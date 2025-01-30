

function Cont = Contour_BM(X,Y,Inner_perc)

% Prc : percentile to use

X_CenterDist = abs(X - nanmean(X));
Y_CenterDist = abs(Y - nanmean(Y));
XY_CenterDist=(abs(X - nanmean(X)).*(abs(Y - nanmean(Y))));


Prc=prctile(XY_CenterDist,Inner_perc); 
X2=X(XY_CenterDist<Prc); 
Y2=Y(XY_CenterDist<Prc); 

intdat_X=X2;
intdat_Y=Y2;

intdat_X=intdat_X(~ isnan(intdat_Y));
intdat_Y=intdat_Y(~ isnan(intdat_Y));

K=convhull(intdat_X,intdat_Y);
Cont(1,:)=intdat_X(K);
Cont(2,:)=intdat_Y(K);




% 
% X_CenterDist = tsd(Range(X),abs(Data(X) - nanmean(Data(X))));
% Y_CenterDist = tsd(Range(Y),abs(Data(Y) - nanmean(Data(Y))));
% XY_CenterDist=tsd(Range(X),(abs(Data(X) - nanmean(Data(X))).*(abs(Data(Y) - nanmean(Data(Y))))));
% 
% 
% Prc=prctile(Data(XY_CenterDist),Inner_perc); DataCenterXY=Data(XY_CenterDist);
% DataCenterX=Data(X_CenterDist); RangeCenterX=Range(X_CenterDist);
% DataX=Data(X); RangeX=Range(X);
% DataX2=DataX(DataCenterXY<Prc); RangeX2=RangeX(DataCenterXY<Prc);
% 
% DataCenterY=Data(Y_CenterDist); RangeCenterY=Range(Y_CenterDist);
% DataY=Data(Y); RangeY=Range(Y);
% DataY2=DataY(DataCenterXY<Prc); RangeY2=RangeY(DataCenterXY<Prc);
% 
% intdat_X=DataX2;
% intdat_Y=DataY2;
% 
% intdat_X=intdat_X(~ isnan(intdat_Y));
% intdat_Y=intdat_Y(~ isnan(intdat_Y));
% 
% K=convhull(intdat_X,intdat_Y);
% Cont(1,:)=intdat_X(K);
% Cont(2,:)=intdat_Y(K);
%X_CenterDist2=tsd(RangeCenterX,DataCenterX);







