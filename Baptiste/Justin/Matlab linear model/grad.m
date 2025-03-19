function dw = grad(C,x,y,w,w0)

dw0 = -(C-y);
dw =  -(C-y) .* x;
dw0 = sum(dw0);
dw = sum(dw,2)';
end 