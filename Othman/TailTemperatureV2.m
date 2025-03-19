[filename,pathname]=uigetfile('*.csv','Select the DeepLabCut tracking file')
DLC=csvread(fullfile(pathname,filename),3); %loads the csv from line 3 to the end (to skip the Header)
% Extract the body parts coordinates
Nose_X = DLC(:,2);
Nose_Y = DLC(:,3);
REar_X = DLC(:,5);
REar_Y = DLC(:,6);
LEar_X = DLC(:,8);
LEar_Y = DLC(:,9);
Neck_X = DLC(:,11);
Neck_Y = DLC(:,12);
Body_X = DLC(:,14);
Body_Y = DLC(:,15);
TailBase_X = DLC(:,17);
TailBase_Y = DLC(:,18);
TailCenter_X = DLC(:,20);
TailCenter_Y = DLC(:,21);

[filename pathname]= uigetfile({'*.avi'},'Select The AVI video file');
pathAVI=fullfile(pathname,filename);

movie=importdata(pathAVI);
xbase=ceil(TailBase_X);
ybase=ceil(TailBase_Y);
xcenter=ceil(TailCenter_X);
ycenter=ceil(TailCenter_Y);


Ymin=1;Ymax=size(movie(1).cdata(:,:,1),1);
Xmin=1;Xmax=size(movie(1).cdata(:,:,1),2);
Radius=10; %In pixels
TemperatureCurve=zeros(1,size(movie,2));

v=VideoWriter('TailTemperatureTracking');
v.FrameRate=15;
open(v);
figure;
a=0;
for frame=1:size(movie,2)
    frame
    dx=xcenter(frame)-xbase(frame);dy=ycenter(frame)-ybase(frame);
    alpha=xbase(frame)+dx/2;
    beta=ybase(frame)+dy/2;
    delta=-1*(dx/dy); %The slope of the line perpendicular to the "Base-center" line is equal to -1* the inverse of the slope of the line between the two tail points.
    K=beta-delta*alpha;
    if abs(delta)==inf
        %Vertical line
        YWithinLine=Ymin:Ymax;
        XWithinLine=(0*YWithinLine+alpha);%same size as Y but replaced by alpha
    elseif abs(delta)>0.5
        Yinterval=1:size(movie(frame).cdata(:,:,1),1);
        Xinterval=round((Yinterval-K)/delta);
        WithinImage=logical(Xinterval>=Xmin.*Xinterval<=Xmax);
        YWithinLine=Yinterval(WithinImage);
        XWithinLine=Xinterval(WithinImage);
    else
        Xinterval=1:size(movie(frame).cdata(:,:,1),2);
        Yinterval=round(Xinterval*delta+K);
        WithinImage=logical(Yinterval>=Ymin.*Yinterval<=Ymax);
        YWithinLine=Yinterval(WithinImage);
        XWithinLine=Xinterval(WithinImage);
    end
    WithinRadius=(((YWithinLine-beta).*(YWithinLine-beta))+((XWithinLine-alpha).*(XWithinLine-alpha)))<Radius*Radius;%Pixel distance of all these pixels from the point halfway between TailBase and TailCenter
    XWithinAll=XWithinLine(WithinRadius);
    YWithinAll=YWithinLine(WithinRadius);
    
    % Vector with negative values for index 
    XY=[XWithinAll;YWithinAll];
    k=find(XY<1);
    XYcheck = isempty(k);
    if XYcheck==0
        XWithinAll=[1:1:11];
        YWithinAll=[1:1:11];
 a=a+1
    end     
    
    VideoFrame=movie(frame).cdata(:,:,1);
    VideoFrameCelcius=IR2DEG(cd,VideoFrame);
    clf;subplot(2,1,1);imagesc(VideoFrameCelcius);hold on;
    plot(xbase(frame),ybase(frame),'.','MarkerSize',20,'Color','w');plot(xcenter(frame),ycenter(frame),'.','MarkerSize',20,'Color','w');
    %%plot(XWithinAll,YWithinAll,'.','Color','r','MarkerSize',15);
    plot([XWithinAll(1),XWithinAll(end)],[YWithinAll(1),YWithinAll(end)],'Color','r','LineWidth',1.5);
    legend('Tail base','Tail center','Segment bisector');
    LinearIndices=sub2ind(size(VideoFrameCelcius),YWithinAll,round(XWithinAll));
    LinearTemperature=VideoFrameCelcius(LinearIndices);
    subplot(4,1,3);plot(1:size(LinearIndices,2),LinearTemperature);ylim([0 40]);
    hold on;
    TempGradient=diff(VideoFrameCelcius(LinearIndices));
    subplot(4,1,3);plot(2:size(LinearIndices,2),TempGradient);
    TempExtremum=find(TempGradient==max(TempGradient));
    if TempExtremum+3>size(LinearIndices,2)
        TailTemp=max(LinearTemperature(TempExtremum:size(LinearIndices,2)));
    else
        TailTemp=max(LinearTemperature(TempExtremum:TempExtremum+3));
    end
    subplot(4,1,3);plot(find(LinearTemperature==TailTemp),TailTemp,'o','Color','r','MarkerSize',5);xlim([0 20]);
    legend('Temperature along the red line','Differential of the temperature','Temperature at the detected intersection of the red line and the tail','Location','northoutside');
    subplot(4,1,4);plot(TemperatureCurve(1:frame),'.');xlim([1 size(movie,2)]);ylim([0 40]);
    title('Estimated tail temperature in °C (X axis is frame #)');
    %f=fit((1:size(LinearIndices,2))',VideoFrame(LinearIndices)','gauss2');
    %subplot(2,1,2);plot(f,(1:size(LinearIndices,2)),VideoFrame(LinearIndices));
    TemperatureCurve(1,frame)=TailTemp;
    AnimationFrame=getframe(gcf);
    writeVideo(v,AnimationFrame);
    pause(0.001)
end

close(v)

save('TailTemperatureCurve.mat','TemperatureCurve')

