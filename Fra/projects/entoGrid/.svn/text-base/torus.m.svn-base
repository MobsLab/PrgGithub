function torus()


r1 = 100;
r2 = 20;
X = cos(U) .* (r1+r2*cos(V));
Y = sin(U) .* (r1+r2*cos(V));
Z = r2*(sin(V));
surf(X,Y,Z,'FaceColor','red','EdgeColor','none')
camlight left
lighting phong
axis equal
alpha(0.4)

xo = pi;
yo = pi;




function d = mdist(x,y, xo, yo)

    d = exp(cos(x-xo)+cos(x-xo));
    
    d = ceil(64*(d-min(d)) /(max(d)-min(d)))