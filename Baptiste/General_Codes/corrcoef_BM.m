function [r,p,rlo,rup] = corrcoef_BM(x,y,varargin)

% see corrcoef
%
clear lgcl_vect; 

lgcl_vect = ~isnan(x) & ~isnan(y); % logical vector

X_to_use = x(lgcl_vect); 
Y_to_use = y(lgcl_vect);

[r,p,rlo,rup] = corrcoef( X_to_use , Y_to_use );

