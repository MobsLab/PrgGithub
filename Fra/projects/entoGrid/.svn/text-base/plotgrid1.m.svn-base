figure(1)
clf
thr = 4;
t1 = 10001;
t2 = 20000;
plot(xx(t1:t2), yy(t1:t2), 'color', [0.7 0.7 0.7])
hold on 
Vq2 =Vconf(1,t1:t2);
tt =find(Vq2 > thr);
plot(xx(tt), yy(tt), 'b.')
Vq2 =Vconf(200,t1:t2);
tt =find(Vq2 > thr);
plot(xx(tt), yy(tt), 'r.')
Vq2 =Vconf(310,t1:t2);
tt =find(Vq2 > thr);
plot(xx(tt), yy(tt), 'g.')
axis equal 
axis tight 
set(gca, 'xtick', [] ,'ytick', []);

figure(2)
clf
mo = hist2d(xx(t1:t2), yy(t1:t2), 50, 50);
Vq2 =Vconf(1,:);
tt =find(Vq2 > thr);

tt = tt(find(tt >=t1  & tt <= t2));

mh = hist2d(xx(tt), yy(tt), 50, 50);

imagesc(mh./mo)
axis equal
axis tight 
set(gca, 'xtick', [] ,'ytick', []);
colormap(hot)

figure(3)
clf

Vq2 =Vconf(200,:);
tt =find(Vq2 > thr);

tt = tt(tt >=t1 & tt <= t2);

mh = hist2d(xx(tt), yy(tt), 50, 50);

imagesc(mh./mo)
axis equal
axis tight 
set(gca, 'xtick', [] ,'ytick', []);
colormap(hot)
figure(4)
clf

Vq2 =Vconf(310,:);
tt =find(Vq2 > thr);

tt = tt(tt >=t1 & tt <= t2);

mh = hist2d(xx(tt), yy(tt), 50, 50);

imagesc(mh./mo)
axis equal
axis tight 
set(gca, 'xtick', [] ,'ytick', []);
colormap(hot)