function PlotICSS(x,y,Rst)

[occH, x1, x2] = hist2d(y, x,100, 100);
[xs, OLDMIN, OLDMAX] = rescale(x, 0, 100);
[ys, OLDMIN, OLDMAX] = rescale(y, 0, 100);
occHs=SmoothDec(occH,[3,3]);


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------




figure('Color',[1 1 1])

subplot(1,4,1), hold on
imagesc(occHs)
% plot(xs,ys,'w.')
xlim([0 100])
ylim([0 100])

subplot(1,4,2), 
imagesc(Rst{1}), axis xy
hold on, plot(x,y,'w','linewidth',1)
hold on, plot(x,y,'ko')
hold on, plot(x(1),y(1),'ko','MarkerFaceColor','w')

subplot(1,4,3), 
imagesc(Rst{floor(length(Rst)/2)}), axis xy
hold on, plot(x,y,'w','linewidth',1)
hold on, plot(x,y,'ko')
hold on, plot(x(floor(length(x)/2)),y(floor(length(y)/2)),'ko','MarkerFaceColor','w')

subplot(1,4,4), 
imagesc(Rst{length(Rst)}), axis xy
hold on, plot(x,y,'w','linewidth',1)
hold on, plot(x,y,'ko')
hold on, plot(x(length(x)),y(length(y)),'ko','MarkerFaceColor','w')


