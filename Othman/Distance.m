%input 1D arrays of X,Y coodinates of first object and X,Y coordinates of second object. Returns euclydean distance between objects.
function [Distance]=Distance(X1,Y1,X2,Y2)
    Distance=sqrt((X1-X2).*(X1-X2)+(Y1-Y2).*(Y1-Y2));
end