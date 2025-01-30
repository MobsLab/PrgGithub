
function [X,Y,S,stim,limMaz,limM,limMaze]=RemoveFalsePosition(X,Y,S,stim,TrackingEpoch,posArt)


if posArt==1 || (~exist('ParametersAnalyseICSS.mat','file') && ~exist('xyMax.mat','file'))
    figure('color',[1 1 1]),
    plot(Data(Restrict(X,TrackingEpoch)),Data(Restrict(Y,TrackingEpoch)))
    title('Delimiter le contour de l''environnement');
    [xMaz,yMaz]=ginput;

    yMaz=sort(yMaz);
    xMaz=sort(xMaz);
    
    save xyMax xMaz yMaz

elseif posArt==2
    try 
        load ParametersAnalyseICSS xMaz yMaz
        xMaz;
    catch
        load xyMax xMaz yMaz
    end
    
else
    
   xMaz=[80 285];
   yMaz=[60 265]; 
   
end

limMaze=[min(min(xMaz),min(yMaz)),max(max(xMaz),max(yMaz))];
limM=[limMaze(1)-0.05*diff(limMaze),limMaze(2)+0.05*diff(limMaze)];

if 0
    
Xx=Data(X);
Yy=Data(Y);
Xx(Xx<=min(xMaz))=min(xMaz);
Xx(Xx>=max(xMaz))=max(xMaz);
Yy(Yy<=min(yMaz))=min(yMaz);
Yy(Yy>=max(yMaz))=max(yMaz);
X=tsd(Range(X),Xx-min(xMaz));
Y=tsd(Range(Y),Yy-min(yMaz));
limMaz=[0 max(max(xMaz)-min(xMaz),max(yMaz)-min(yMaz))];


else
    
Xx=Data(X);
Yy=Data(Y);
rg=Range(X);
goodInterval1=thresholdIntervals(X,min(xMaz),'Direction','Above');
goodInterval2=thresholdIntervals(X,max(xMaz),'Direction','Below');
goodInterval3=thresholdIntervals(Y,min(yMaz),'Direction','Above');
goodInterval4=thresholdIntervals(Y,max(yMaz),'Direction','Below');

goodIntervalA=intersect(goodInterval1,goodInterval2);
goodIntervalB=intersect(goodInterval3,goodInterval4);

goodInterval=intersect(goodIntervalA,goodIntervalB);

X=Restrict(X,goodInterval);
Y=Restrict(Y,goodInterval);
S=Restrict(S,goodInterval);
stim=Restrict(stim,goodInterval);

Xx=Data(X);
Yy=Data(Y);
X=tsd(Range(X),Xx-min(xMaz));
Y=tsd(Range(Y),Yy-min(yMaz));
limMaz=[0 max(max(xMaz)-min(xMaz),max(yMaz)-min(yMaz))];

end


if posArt==1
    plot(Data(Restrict(X,TrackingEpoch)),Data(Restrict(Y,TrackingEpoch)),'r.')  
    axis image
    Axs=axis;
    pause(1)
    close
end






