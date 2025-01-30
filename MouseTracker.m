
function [x y Rst]=MouseTracker(filename,lim,deb)


cd /Users/karimbenchenane/Documents/Data/MiceSetUp/ICSS

% filename='Mouse02-08112010-exploConnected.avi';

lim=lim*30;

try
    deb;
    deb=deb*30;
catch
    deb=1;
end

mov=aviread(filename,deb:30:lim+deb);

test1=squeeze(mov(1).cdata(:,:,1));
test1=double(test1);
test1=1./test1;
test1(test1>0.05)=0.05;
rst1 = im_rst(test1*255, 1, 47, 0, 0);
Im=rst1(120:380,250:490);

test2=mov(1).cdata;   
rst2 = im_rst(test2, 1, 47, 0, 0);
Im2=rst2(120:380,250:490);
 

h = waitbar(0,'Please wait...');
tic

for b=1:length(mov)

    test=squeeze(mov(b).cdata(:,:,1));
    test=double(test);
    test=1./test;
    test(test>0.05)=0.05;
    test=SmoothDec(test,2);
    rst = im_rst(test*255, 1, 47, 0, 0);
    Rst{b}=rst(120:380,250:490);

    [X,Y, bodyline, sqr]=FindFly(Rst{b},0.03);
    x(b)=X;
    y(b)=Y;
    
    waitbar(b/length(mov),h)

end

toc
close(h)

[occH, x1, x2] = hist2d(x, y,100, 100);
[xs, OLDMIN, OLDMAX] = rescale(x, 0, 100);
[ys, OLDMIN, OLDMAX] = rescale(y, 0, 100);
occHs=SmoothDec(occH,[3,3]);


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------




figure('Color',[1 1 1])

subplot(1,4,1), hold on
imagesc(occHs)
plot(ys,xs,'w.')
xlim([0 100])
ylim([0 100])

subplot(1,4,2), 
imagesc(Rst{1}), axis xy
hold on, plot(x,y,'w','linewidth',2)
hold on, plot(x,y,'ko')
hold on, plot(x(1),y(1),'ko','MarkerFaceColor','w')

subplot(1,4,3), 
imagesc(Rst{floor(length(Rst)/2)}), axis xy
hold on, plot(x,y,'w','linewidth',2)
hold on, plot(x,y,'ko')
hold on, plot(x(floor(length(Rst)/2)),y(floor(length(Rst)/2)),'ko','MarkerFaceColor','w')

subplot(1,4,4), 
imagesc(Rst{length(Rst)}), axis xy
hold on, plot(x,y,'w','linewidth',2)
hold on, plot(x,y,'ko')
hold on, plot(x(length(Rst)),y(length(Rst)),'ko','MarkerFaceColor','w')





