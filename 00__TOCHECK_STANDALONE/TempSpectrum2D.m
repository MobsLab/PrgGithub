a=1;
for i=1:5
for j=5:12
Fil2=FilterLFP(Restrict(LFPh,ep),[i i+1],2048);
Fil1=FilterLFP(Restrict(LFPh,ep),[j j+1],2048);
hil1=hilbert(Data(Fil1));
hil2=hilbert(Data(Fil2));
[hh{a},bb,bb2]=hist2d(atan2(imag(hil1), real(hil1)),atan2(imag(hil2), real(hil2)),[-pi:0.1:pi],[-pi:0.1:pi]);
freq(a,1)=i;
freq(a,2)=j;
a=a+1;
end
end

smo=0.7;
figure('color',[1 1 1])
for a=1:40
subplot(5,8,a),imagesc(bb,bb2,SmoothDec(hhP{a}(3:end,3:end),[smo smo])), ylabel(num2str(freq(a,1))), xlabel(num2str(freq(a,2)))
end
figure, imagesc(Range(Restrict(Stsd,ep),'s'),fh,10*log10(Data(Restrict(Stsd,ep)))'), axis xy
figure, plot(fh,mean(Data(Restrict(Stsd,ep))))
figure, plot(fh,10*log10(mean(Data(Restrict(Stsd,ep)))))
smo=0.7;
figure('color',[1 1 1])
for a=1:40
subplot(5,8,a),imagesc(bb,bb2,SmoothDec(hhP{a}(3:end,3:end),[smo smo])), ylabel(num2str(freq(a,1))), xlabel(num2str(freq(a,2))), ca=caxis; title([num2str(ca(1)), ' ', num2str(ca(2))])
end
smo=0.7;
figure('color',[1 1 1])
for a=1:40
subplot(5,8,a),imagesc(bb,bb2,SmoothDec(hhP{a}(3:end,3:end),[smo smo])), ylabel(num2str(freq(a,1))), xlabel(num2str(freq(a,2))), ca=caxis; title([num2str(floor(ca(1))), ' ', num2str(floor(ca(2)))])
end
smo=0.7;
figure('color',[1 1 1])
for a=1:40
subplot(5,8,a),imagesc(bb,bb2,SmoothDec(hh{a}(3:end,3:end),[smo smo])), ylabel(num2str(freq(a,1))), xlabel(num2str(freq(a,2))), ca=caxis; title([num2str(floor(ca(1))), ' ', num2str(floor(ca(2)))])
end
F = fftshift( abs( fft2(SmoothDec(hh{a}(3:end,3:end),[smo smo])) ).^2 );
figure, imagesc(F)
figure, imagesc(abs(F))
figure, imagesc(log(abs(F)))
psd=immultiply(log10(abs(fftshift(fft2(SmoothDec(hh{a}(3:end,3:end),[smo smo]))))), 20);
figure, imagesc(abs(psd))
figure('color',[1 1 1])
for a=1:40
psd=immultiply(log10(abs(fftshift(fft2(SmoothDec(hh{a}(3:end,3:end),[smo smo]))))), 20);
subplot(5,8,a),imagesc(abs(psd))
end
figure('color',[1 1 1])
for a=1:40
psd=immultiply(log10(abs(fftshift(fft2(SmoothDec(hh{a}(3:end,3:end),[smo smo]))))), 20);
subplot(5,8,a),imagesc(SmoothDec(abs(psd),[smo smo]))
end
figure('color',[1 1 1])
for a=1:40
psd=immultiply(log10(abs(fftshift(fft2(SmoothDec(hh{a}(3:end,3:end),[smo smo]))))), 20);
subplot(5,8,a),imagesc(SmoothDec(abs(psd),[smo smo])),  ca=caxis; title([num2str(floor(ca(1))), ' ', num2str(floor(ca(2)))])
end
close all
smo=0.7;
figure('color',[1 1 1])
for a=1:40
subplot(5,8,a),imagesc(bb,bb2,SmoothDec(hh{a}(3:end,3:end),[smo smo])), ylabel(num2str(freq(a,1))), xlabel(num2str(freq(a,2))), ca=caxis; title([num2str(floor(ca(1))), ' ', num2str(floor(ca(2)))])
end
figure('color',[1 1 1])
for a=1:40
psd=immultiply(log10(abs(fftshift(fft2(SmoothDec(hh{a}(3:end,3:end),[smo smo]))))), 20);
subplot(5,8,a),imagesc(SmoothDec(abs(psd),[smo smo])),  ca=caxis; title([num2str(floor(ca(1))), ' ', num2str(floor(ca(2)))])
end
figure('color',[1 1 1])
for a=1:40
psd=immultiply(log10(abs(fftshift(fft2(SmoothDec(hh{a}(3:end,3:end),[smo smo]))))), 20);
subplot(5,8,a),imagesc(SmoothDec(abs(psd),[0.1 0.1])),  ca=caxis; title([num2str(floor(ca(1))), ' ', num2str(floor(ca(2)))])
end
smo=0.7;
figure('color',[1 1 1])
for a=1:40
subplot(5,8,a),imagesc(bb,bb2,SmoothDec(hh{a}(3:end,3:end),[smo smo])), ylabel(num2str(freq(a,1))), xlabel(num2str(freq(a,2))), ca=caxis; title([num2str(floor(ca(1))), ' ', num2str(floor(ca(2)))])
end
figure('color',[1 1 1])
for a=1:40
psd=immultiply(log10(abs(fftshift(fft2(SmoothDec(hh{a}(3:end,3:end),[smo smo]))))), 20);
subplot(5,8,a),imagesc(SmoothDec(abs(psd),[0.1 0.1])),  ca=caxis; title([num2str(floor(ca(1))), ' ', num2str(floor(ca(2)))])
end
smo=0.7;
figure('color',[1 1 1])
for a=1:40
subplot(5,8,a),imagesc(bb,bb2,SmoothDec(hhP{a}(3:end,3:end),[smo smo])), ylabel(num2str(freq(a,1))), xlabel(num2str(freq(a,2))), ca=caxis; title([num2str(floor(ca(1))), ' ', num2str(floor(ca(2)))])
end
figure('color',[1 1 1])
for a=1:40
psd=immultiply(log10(abs(fftshift(fft2(SmoothDec(hhP{a}(3:end,3:end),[smo smo]))))), 20);
subplot(5,8,a),imagesc(SmoothDec(abs(psd),[0.1 0.1])),  ca=caxis; title([num2str(floor(ca(1))), ' ', num2str(floor(ca(2)))])
end
figure('color',[1 1 1])
for a=1:40
psd=immultiply(log10(abs(fftshift(fft2(SmoothDec(hhP{a}(3:end,3:end),[smo smo]))))), 20);
subplot(5,8,a),imagesc(SmoothDec(abs(psd),[0.1 0.1])),  ca=caxis; title([num2str(floor(ca(1))), ' ', num2str(floor(ca(2)))])
end
xx = 1:1000;
yy = 1:2000;
[x,y]=meshgrid(xx,yy);
kx0 = 0.01;
ky0 = 0.004;
w = cos(x*2*pi*kx0).*cos(y*2*pi*ky0);
figure(1);clf
imagesc(xx,yy,w);
set(gca,'ydir','no');
xlabel('x [m]');
ylabel('y [m]');
% first k_x = [0:N-1]/\deltax
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
X = fft(w')';
Gx = (1/M/dx)*X(:,2:M/2).* conj(X(:,2:M/2));
k_x = k_x(2:M/2);
figure(2);clf
loglog(k_x,Gx(10,:))
xlabel('k_x [cpm]');
ylabel('G_x(k_x: y=10 m)');
in = find(k_x>kx0);
in = in(1)-1;
figure(3); clf;
plot(y,Gx(:,in));
xlabel('y [m]');
ylabel('G_x(k_x=k_{x0},y)');
figure(4);
pcolor(k_x,yy,real(Gx));shading flat;
set(gca,'xscale','log');
xlabel('k_x [cpm]');
ylabel('y [m]');
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
figure(5);clf
subplot(1,2,1);
pcolor(k_x,k_y,real(GXY));shading flat;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
subplot(1,2,2);
surface(k_x,k_y,real(GXY));shading interp;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
view(30,30);
w0 = w;
wp = randn(N,M);
w = cumsum(cumsum(wp)')';
w = w+wp*50+1000*w0;
figure(10);clf
subplot(2,1,1);
imagesc(xx,yy,wp);
set(gca,'ydir','nor');
title('w''');
ylabel('y [m]');
subplot(2,1,2);
imagesc(xx,yy,w);
title('w');
set(gca,'ydir','nor');
xlabel('x [m]');
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
figure(15);clf
subplot(1,2,1);
pcolor(k_x,k_y,log10(real(GXY)));shading flat;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
subplot(1,2,2);
surface(k_x,k_y,log10(real(GXY)));shading interp;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
view(40,20);
close all
w=hhP{a};
xx=bb;
yy=bb2;
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
figure(15);clf
subplot(1,2,1);
pcolor(k_x,k_y,log10(real(GXY)));shading flat;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
subplot(1,2,2);
surface(k_x,k_y,log10(real(GXY)));shading interp;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
view(40,20);
figure('color',[1 1 1])
for a=1:40
w=hhP{a};
xx=bb;
yy=bb2;
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
subplot(5,8,a),
pcolor(k_x,k_y,log10(real(GXY)));shading flat;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
end
figure('color',[1 1 1])
for a=1:40
w=hhP{a};
xx=bb;
yy=bb2;
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
subplot(5,8,a),
pcolor(k_x,k_y,log10(real(GXY)));shading flat;
set(gca,'xscale','log','yscale','log')
%xlabel('k_x [cpm]');
%ylabel('k_y [cpm]');
end
close all
figure('color',[1 1 1])
for a=1:40
w=hhP{a};
xx=bb;
yy=bb2;
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
subplot(5,8,a),
pcolor(k_x,k_y,log10(real(GXY)));shading flat;
set(gca,'xscale','log','yscale','log')
%xlabel('k_x [cpm]');
%ylabel('k_y [cpm]');
end
smo=0.7;
figure('color',[1 1 1])
for a=1:40
subplot(5,8,a),imagesc(bb,bb2,SmoothDec(hhP{a}(3:end,3:end),[smo smo])), ylabel(num2str(freq(a,1))), xlabel(num2str(freq(a,2))), ca=caxis; title([num2str(floor(ca(1))), ' ', num2str(floor(ca(2)))])
end
figure('color',[1 1 1])
for a=1:40
w=hhP{a};
xx=bb;
yy=bb2;
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
subplot(5,8,a),
pcolor(k_x,k_y,log10(real(GXY)));shading flat;,  ca=caxis; title([num2str(floor(ca(1))), ' ', num2str(floor(ca(2)))])
set(gca,'xscale','log','yscale','log')
%xlabel('k_x [cpm]');
%ylabel('k_y [cpm]');
end
figure('color',[1 1 1])
for a=1:40
w=hhP{a};
xx=bb;
yy=bb2;
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
subplot(5,8,a),
pcolor(k_x,k_y,log10(real(GXY)));shading flat;,  ca=caxis; title([num2str(floor(10*ca(1))/10), ' ', num2str(floor(10*ca(2))/10)])
set(gca,'xscale','log','yscale','log')
%xlabel('k_x [cpm]');
%ylabel('k_y [cpm]');
end
figure('color',[1 1 1])
for a=1:40
w=hhP{a};
xx=bb;
yy=bb2;
M = length(xx);
N = length(yy);
dx = 0.1;
k_x = (0:M-1)/dx/M;
dy = 0.1;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
subplot(5,8,a),
pcolor(k_x,k_y,log10(real(GXY)));shading flat;,  ca=caxis; title([num2str(floor(10*ca(1))/10), ' ', num2str(floor(10*ca(2))/10)])
set(gca,'xscale','log','yscale','log')
%xlabel('k_x [cpm]');
%ylabel('k_y [cpm]');
end
figure('color',[1 1 1])
for a=1:40
w=hhP{a};
xx=bb;
yy=bb2;
M = length(xx);
N = length(yy);
dx = 2;
k_x = (0:M-1)/dx/M;
dy = 2;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
subplot(5,8,a),
pcolor(k_x,k_y,log10(real(GXY)));shading flat;,  ca=caxis; title([num2str(floor(10*ca(1))/10), ' ', num2str(floor(10*ca(2))/10)])
set(gca,'xscale','log','yscale','log')
%xlabel('k_x [cpm]');
%ylabel('k_y [cpm]');
end
figure('color',[1 1 1])
for a=1:40
w=hhP{a};
xx=bb;
yy=bb2;
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
subplot(5,8,a),
%    pcolor(k_x,k_y,log10(real(GXY)));shading flat;  ca=caxis; title([num2str(floor(10*ca(1))/10), ' ', num2str(floor(10*ca(2))/10)])
%   set(gca,'xscale','log','yscale','log')
surface(k_x,k_y,log10(real(GXY)));shading interp;
set(gca,'xscale','log','yscale','log')
view(40,20);
end
figure, contour(k_x,k_y,log10(real(GXY)))
figure, contourp(k_x,k_y,log10(real(GXY)))
help contour
figure, contourf(k_x,k_y,log10(real(GXY)))
help surface
figure, surf(k_x,k_y,log10(real(GXY)))
figure, surface(k_x,k_y,log10(real(GXY)))
figure, surface(k_x,k_y,log10(real(GXY)));shading flat;
figure, surface(k_x,k_y,log10(real(GXY)));shading interp;
figure, surface(k_x,k_y,SmoothDec(log10(real(GXY)),[0.7 0.7]));shading flat;
figure('color',[1 1 1])
for a=1:40
w=hhP{a};
xx=bb;
yy=bb2;
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
subplot(5,8,a),
%    pcolor(k_x,k_y,log10(real(GXY)));shading flat;  ca=caxis; title([num2str(floor(10*ca(1))/10), ' ', num2str(floor(10*ca(2))/10)])
%   set(gca,'xscale','log','yscale','log')
surface(k_x,k_y,SmoothDec(log10(real(GXY)),[0.7 0.7]));shading flat;
%   surface(k_x,k_y,log10(real(GXY)));shading interp;
%  set(gca,'xscale','log','yscale','log')
% view(40,20);
end
smo=0.7;
figure('color',[1 1 1])
for a=1:40
subplot(5,8,a),imagesc(bb,bb2,SmoothDec(hhP{a}(3:end,3:end),[smo smo])), ylabel(num2str(freq(a,1))), xlabel(num2str(freq(a,2))), ca=caxis; title([num2str(floor(ca(1))), ' ', num2str(floor(ca(2)))])
end
figure('color',[1 1 1])
for a=1:40
w=hhP{a};
xx=bb;
yy=bb2;
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
subplot(5,8,a),
%    pcolor(k_x,k_y,log10(real(GXY)));shading flat;  ca=caxis; title([num2str(floor(10*ca(1))/10), ' ', num2str(floor(10*ca(2))/10)])
%   set(gca,'xscale','log','yscale','log')
surface(k_x,k_y,SmoothDec(log10(real(GXY)),[0.7 0.7]));shading flat;
%   surface(k_x,k_y,log10(real(GXY)));shading interp;
%  set(gca,'xscale','log','yscale','log')
% view(40,20);
end
figure('color',[1 1 1])
for a=1:40
w=hhP{a};
xx=bb;
yy=bb2;
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
subplot(5,8,a),
%    pcolor(k_x,k_y,log10(real(GXY)));shading flat;  ca=caxis; title([num2str(floor(10*ca(1))/10), ' ', num2str(floor(10*ca(2))/10)])
%   set(gca,'xscale','log','yscale','log')
surface(k_x,k_y,SmoothDec(log10(real(GXY)),[0.7 0.7]));shading flat; ca=caxis; title([num2str(floor(10*ca(1))/10), ' ', num2str(floor(10*ca(2))/10)])
%   surface(k_x,k_y,log10(real(GXY)));shading interp;
%  set(gca,'xscale','log','yscale','log')
% view(40,20);
end
k8x
k_x
figure('color',[1 1 1])
for a=1:40
w=hhP{a};
xx=bb;
yy=bb2;
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
subplot(5,8,a),
%    pcolor(k_x,k_y,log10(real(GXY)));shading flat;  ca=caxis; title([num2str(floor(10*ca(1))/10), ' ', num2str(floor(10*ca(2))/10)])
%   set(gca,'xscale','log','yscale','log')
surface(k_x,k_y,SmoothDec(log10(real(GXY)),[0.7 0.7]));shading flat; ca=caxis; title([num2str(floor(10*ca(1))/10), ' ', num2str(floor(10*ca(2))/10)])
xlim([k_x(1) k_x(end)])
ylim([k_x(1) k_x(end)])
%   surface(k_x,k_y,log10(real(GXY)));shading interp;
%  set(gca,'xscale','log','yscale','log')
% view(40,20);
end
help rot90
help imrotate
figure('color',[1 1 1])
for j=1:3
w=imrotate(hhP{a},j);
xx=bb;
yy=bb2;
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
subplot(5,8,a),
%    pcolor(k_x,k_y,log10(real(GXY)));shading flat;  ca=caxis; title([num2str(floor(10*ca(1))/10), ' ', num2str(floor(10*ca(2))/10)])
%   set(gca,'xscale','log','yscale','log')
surface(k_x,k_y,SmoothDec(log10(real(GXY)),[0.7 0.7]));shading flat; ca=caxis; title([num2str(floor(10*ca(1))/10), ' ', num2str(floor(10*ca(2))/10)])
xlim([k_x(1) k_x(end)])
ylim([k_x(1) k_x(end)])
%   surface(k_x,k_y,log10(real(GXY)));shading interp;
%  set(gca,'xscale','log','yscale','log')
% view(40,20);
end
%-- 03/12/2015 21:05:07 --%
LoadPATHKB
xx = 1:1000;
yy = 1:2000;
[x,y]=meshgrid(xx,yy);
kx0 = 0.01;
ky0 = 0.004;
w = cos(x*2*pi*kx0).*cos(y*2*pi*ky0);
figure(1);clf
imagesc(xx,yy,w);
set(gca,'ydir','no');
xlabel('x [m]');
ylabel('y [m]');
% first k_x = [0:N-1]/\deltax
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
X = fft(w')';
Gx = (1/M/dx)*X(:,2:M/2).* conj(X(:,2:M/2));
k_x = k_x(2:M/2);
figure(2);clf
loglog(k_x,Gx(10,:))
xlabel('k_x [cpm]');
ylabel('G_x(k_x: y=10 m)');
in = find(k_x>kx0);
in = in(1)-1;
figure(3); clf;
plot(y,Gx(:,in));
xlabel('y [m]');
ylabel('G_x(k_x=k_{x0},y)');
figure(4);
pcolor(k_x,yy,real(Gx));shading flat;
set(gca,'xscale','log');
xlabel('k_x [cpm]');
ylabel('y [m]');
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
figure(5);clf
subplot(1,2,1);
pcolor(k_x,k_y,real(GXY));shading flat;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
subplot(1,2,2);
surface(k_x,k_y,real(GXY));shading interp;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
view(30,30);
w0 = w;
wp = randn(N,M);
w = cumsum(cumsum(wp)')';
w = w+wp*50+1000*w0;
figure(10);clf
subplot(2,1,1);
imagesc(xx,yy,wp);
set(gca,'ydir','nor');
title('w''');
ylabel('y [m]');
subplot(2,1,2);
imagesc(xx,yy,w);
title('w');
set(gca,'ydir','nor');
xlabel('x [m]');
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
figure(15);clf
subplot(1,2,1);
pcolor(k_x,k_y,log10(real(GXY)));shading flat;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
subplot(1,2,2);
surface(k_x,k_y,log10(real(GXY)));shading interp;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
view(40,20);
figure, imagesc(w)
figure, imagesc(imrotate(w,10))
%-- 03/12/2015 21:12:32 --%
LoadPATHKB
xx = 1:1000;
yy = 1:2000;
[x,y]=meshgrid(xx,yy);
kx0 = 0.01;
ky0 = 0.004;
w = cos(x*2*pi*kx0).*cos(y*2*pi*ky0);
figure(1);clf
imagesc(xx,yy,w);
set(gca,'ydir','no');
xlabel('x [m]');
ylabel('y [m]');
% first k_x = [0:N-1]/\deltax
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
X = fft(w')';
Gx = (1/M/dx)*X(:,2:M/2).* conj(X(:,2:M/2));
k_x = k_x(2:M/2);
figure(2);clf
loglog(k_x,Gx(10,:))
xlabel('k_x [cpm]');
ylabel('G_x(k_x: y=10 m)');
in = find(k_x>kx0);
in = in(1)-1;
figure(3); clf;
plot(y,Gx(:,in));
xlabel('y [m]');
ylabel('G_x(k_x=k_{x0},y)');
figure(4);
pcolor(k_x,yy,real(Gx));shading flat;
set(gca,'xscale','log');
xlabel('k_x [cpm]');
ylabel('y [m]');
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
figure(5);clf
subplot(1,2,1);
pcolor(k_x,k_y,real(GXY));shading flat;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
subplot(1,2,2);
surface(k_x,k_y,real(GXY));shading interp;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
view(30,30);
w0 = w;
wp = randn(N,M);
w = cumsum(cumsum(wp)')';
w = w+wp*50+1000*w0;
figure(10);clf
subplot(2,1,1);
imagesc(xx,yy,wp);
set(gca,'ydir','nor');
title('w''');
ylabel('y [m]');
subplot(2,1,2);
imagesc(xx,yy,w);
title('w');
set(gca,'ydir','nor');
xlabel('x [m]');
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
figure(15);clf
subplot(1,2,1);
pcolor(k_x,k_y,log10(real(GXY)));shading flat;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
subplot(1,2,2);
surface(k_x,k_y,log10(real(GXY)));shading interp;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
view(40,20);
figure, imagesc(w)
J=imrotate(w);
J=imrotate(abs(w));
size(w)
figure, iamgesc(w)
figure, imagesc(w)
figure(15);clf
subplot(1,2,1);
pcolor(k_x,k_y,log10(real(GXY)));shading flat;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
subplot(1,2,2);
surface(k_x,k_y,log10(real(GXY)));shading interp;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
view(40,20);
view(0,20);
view(0,20,10);
view(0,0);
view(10,0);
view(10,10);
view(10,20);
view(10,60);
view(10,6);
view(80,6);
view(10,6);
view
A=imread('flower1.jpg');
X = gpuArray(imread('pout.tif'));
I = imread('cameraman.tif');
imshow(I)
figure, imagesc(I)
w=I;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
figure(15);clf
subplot(1,2,1);
pcolor(k_x,k_y,log10(real(GXY)));shading flat;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
subplot(1,2,2);
surface(k_x,k_y,log10(real(GXY)));shading interp;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
view(40,20);
w=I;
M = length(xx);
N = length(yy);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
figure(15);clf
subplot(1,2,1);
pcolor(k_x,k_y,log10(real(GXY)));shading flat;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
subplot(1,2,2);
surface(k_x,k_y,log10(real(GXY)));shading interp;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
view(40,20);
w=I;
M = length(w);
N = length(w);
dx = 1;
k_x = (0:M-1)/dx/M;
dy = 1;
k_y = (0:N-1)/dx/N;
XY = fft(fft(w')');
k_x = (0:M-1)/dx/M;
k_y = (0:N-1)/dx/N;
GXY = (1/M/dx)*(1/N/dy)*XY(2:N/2,2:M/2).* conj(XY(2:N/2,2:M/2));
k_y = k_y(2:N/2);
k_x = k_x(2:M/2);
figure(15);clf
subplot(1,2,1);
pcolor(k_x,k_y,log10(real(GXY)));shading flat;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
subplot(1,2,2);
surface(k_x,k_y,log10(real(GXY)));shading interp;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
view(40,20);
figure(15);clf
subplot(1,2,1);
pcolor(k_x,k_y,log10(real(GXY)));shading flat;
%set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
subplot(1,2,2);
surface(k_x,k_y,log10(real(GXY)));shading interp;
%set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
view(40,20);
figure(15);clf
subplot(1,2,1);
pcolor(k_x,k_y,log10(real(GXY)));shading flat;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
subplot(1,2,2);
surface(k_x,k_y,log10(real(GXY)));shading interp;
set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
view(40,20);
figure(16);clf
subplot(1,2,1);
pcolor(k_x,k_y,log10(real(GXY)));shading flat;
%set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
subplot(1,2,2);
surface(k_x,k_y,log10(real(GXY)));shading interp;
%set(gca,'xscale','log','yscale','log')
xlabel('k_x [cpm]');
ylabel('k_y [cpm]');
view(40,20);