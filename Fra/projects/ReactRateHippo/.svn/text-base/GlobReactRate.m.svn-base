cd /home/fpbatta/Data/DIRAC/
load gl_rate_react_complete.mat

X_MS1 = log10(gl_frate_maze./gl_frate_sleep1);
X_MS2 = log10(gl_frate_maze./gl_frate_sleep2);
X_S2S1 = log10(gl_frate_sleep2./gl_frate_sleep1);

subplot(2,1,1)
set(gcf, 'position', [ 360    76   560   830])
plot(X_MS1, X_S2S1, '.');
hold on 
xl = get(gca, 'XLim');
xlabel('X_MS2', 'interpreter', 'none')
ylabel('X_S2S1', 'interpreter', 'none')



display('direct:');
c = nancorrcoef(X_MS1, X_S2S1)
[a, b, r, p] = regression_line(X_MS1, X_S2S1)
title(['X_S2S1 = ' num2str(b) ' * X_MS1  ' num2str(a) '   ;r = ' num2str(r)], ...
      'interpreter', 'none')

plot(xl, b*xl+a, 'r')
axis equal


subplot(2,1,2)
plot(X_MS2, -X_S2S1, '.');
hold on 
xl = get(gca, 'XLim');
xlabel('X_MS2', 'interpreter', 'none')
ylabel('X_S1S2', 'interpreter', 'none')

display('inverse:');
c = nancorrcoef(X_MS2, -X_S2S1)
[a, b, r, p] = regression_line(X_MS2, -X_S2S1)
title(['X_S1S2 = ' num2str(b) ' * X_MS2  ' num2str(a) '   ;r = ' num2str(r)], ...
      'interpreter', 'none')
plot(xl, b*xl+a, 'r')
axis equal


figure(2)


x_S2S1 = X_S2S1(isfinite(X_S2S1));
x_MS1 = X_MS1(isfinite(X_MS1));
x_MS2 = X_MS2(isfinite(X_MS2));


subplot(3,1,1)
hist(x_MS1, linspace(-2, 2, 40))
title(['X_MS1 mean = ' num2str(mean(x_MS1)) ' std = ' num2str(std(x_MS1))], ...
      'interpreter', 'none')

subplot(3,1,2)
hist(x_MS2, linspace(-2, 2, 40))
title(['X_MS2 mean = ' num2str(mean(x_MS2)) ' std = ' num2str(std(x_MS2))], ...
      'interpreter', 'none')


subplot(3,1,3)
hist(x_S2S1, linspace(-2, 2, 40))
title(['X_S2S1 mean = ' num2str(mean(x_S2S1)) ' std = ' num2str(std(x_S2S1))], ...
      'interpreter', 'none')


figure(3)

f_m = log10(gl_frate_maze);
f_m = f_m(isfinite(f_m));

f_s1 = log10(gl_frate_sleep1);
f_s1 = f_s1(isfinite(f_s1));

f_s2 = log10(gl_frate_sleep2);
f_s2 = f_s2(isfinite(f_s2));

subplot(3,1,1)
hist(f_m, linspace(-2, 2, 40))
title(['log(f_maze) mean = ' num2str(mean(f_m)) ' std = ' num2str(std(f_m))], ...
      'interpreter', 'none')
subplot(3,1,2)
hist(f_s1, linspace(-2, 2, 40))
title(['log(f_sleep1) mean = ' num2str(mean(f_s1)) ' std = ' num2str(std(f_s1))], ...
      'interpreter', 'none')
subplot(3,1,3)
hist(f_s2, linspace(-2, 2, 40))
title(['log(f_sleep2) mean = ' num2str(mean(f_s2)) ' std = ' num2str(std(f_s2))], ...
      'interpreter', 'none')


