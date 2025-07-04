%ImageModifAngleView
    

orig=zeros(100,100);
orig(45:55,:)=1;
orig(:,45:55)=1;

orig(1:10,:)=0;
orig(90:100,:)=0;
orig(:,1:10)=0;
orig(:,90:100)=0;

if 1
    im=orig;
    %traceRect = @(M) plot(M([1 2 4 3 1],1) ,M([1 2 4 3 1],2), 'r-*');
    [m n rgb] = size(im);
    % U = [36 45 ; 263 63 ; 38 436 ; 267 411];
    U = [180 45 ; 263 63 ; 38 436 ; 267 411];
    X = [ 0  0 ;   n  0 ;  0  m  ;   n   m];
    tform = maketform('projective',U,X);
    [orig2,xdata,ydata] = imtransform(im, tform);
%     subplot(1,2,1)
%     imshow(im)
%     hold on
%     traceRect(U)
%     subplot(1,2,2)
%     imshow(xdata,ydata,orig2)
%     hold on
%     traceRect(X)
else
    [x,y]=find(orig==1);
    p_xy=Rotate([x,y],1,[50 50]);
    orig2=zeros(100,100);
    for i=1:length(p_xy)
    orig2(floor(p_xy(i,1)),floor(p_xy(i,2)))=1;
    orig2(round(p_xy(i,1)),round(p_xy(i,2)))=1;
    end
end


% Read in the aerial photo.
unregistered = orig2;
figure, 
set(gcf,'position',[127 378 1335 395])
subplot(1,4,1),imagesc(unregistered), colormap(pink)
[x1,y1]=ginput;

%Read in the orthophoto.
subplot(1,4,2),imagesc(orig), colormap(pink)
%[x2,y2]=ginput;

pause(2)
input_points=[x1,y1];
base_points=[x2,y2];

% Create a transformation structure for a projective 
% transformation.
t_concord = cp2tform(input_points,base_points,'projective');


% Get the width and height of the orthophoto and perform 
% the transformation.
%info = imfinfo(orig);

registered = imtransform(unregistered,t_concord,...
    'XData',[1 100], 'YData',[1 100]);
subplot(1,4,3), imagesc(registered)
subplot(1,4,4), imagesc(SmoothDec(registered,[1,1]))
colormap(pink)




    