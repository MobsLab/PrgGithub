function d=ComputeIstantaneuousDistance(x,y)

X=diff(x);
Y=diff(y);
d=sqrt(X.*X+Y.*Y);
