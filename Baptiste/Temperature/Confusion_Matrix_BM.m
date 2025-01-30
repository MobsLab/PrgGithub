


function N =Confusion_Matrix_BM(X,Y,thr_x,thr_y,varargin)

% X and Y should be matrix with first row abscisse coordinate, second
% ordinate coordinate
 switch(varargin{1})
        case '1'
        
N(1,1) = (sum(and(X(:,1)<thr_x , X(:,2)>thr_y))) / ((sum(and(Y(:,1)<thr_x , Y(:,2)>thr_y)))+(sum(and(X(:,1)<thr_x , X(:,2)>thr_y))));
N(1,2) = (sum(and(X(:,1)>thr_x , X(:,2)>thr_y))) / ((sum(and(Y(:,1)>thr_x , Y(:,2)>thr_y)))+(sum(and(X(:,1)>thr_x , X(:,2)>thr_y))));
N(2,1) = (sum(and(X(:,1)<thr_x , X(:,2)<thr_y))) / ((sum(and(Y(:,1)<thr_x , Y(:,2)<thr_y)))+(sum(and(X(:,1)<thr_x , X(:,2)<thr_y))));
N(2,2) = (sum(and(X(:,1)>thr_x , X(:,2)<thr_y))) / ((sum(and(Y(:,1)>thr_x , Y(:,2)<thr_y)))+(sum(and(X(:,1)>thr_x , X(:,2)<thr_y))));


        case '2'

N(1,1) = (sum(and(X(:,1)<thr_x , X(:,2)>thr_y))) / length(X);
N(1,2) = (sum(and(X(:,1)>thr_x , X(:,2)>thr_y))) / length(X);
N(2,1) = (sum(and(X(:,1)<thr_x , X(:,2)<thr_y))) / length(X);
N(2,2) = (sum(and(X(:,1)>thr_x , X(:,2)<thr_y))) / length(X);


 end











