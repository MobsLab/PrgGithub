
function [X,Y,S,stim,limMaz,limM,limMaze]=RemoveFalsePositionML(X,Y,S,stim,TrackingEpoch,posArt,ref_im)

% [X,Y,S,stim,limMaz,limM,limMaze]=RemoveFalsePositionML(X,Y,S,stim,TrackingEpoch,posArt,ref_im)

dt=Data(X);rg=Range(X);
index=find(~isnan(dt));
X=tsd(rg(index),dt(index));
dt=Data(Y); Y=tsd(rg(index),dt(index));

if ismember(posArt,[1,2])
    
    try
        load ParametersAnalyseICSS xMaz yMaz
        xMaz;
    catch
        try load xyMax xMaz yMaz; end
    end
    
    if exist('xMaz','var')
        figure('color',[1 1 1]),
        imagesc(ref_im), axis xy
        hold on, plot(Data(Restrict(X,TrackingEpoch)),Data(Restrict(Y,TrackingEpoch)),'Color',[0.7 0.7 0.7])
        hold on, line([min(xMaz), min(xMaz),max(xMaz), max(xMaz),min(xMaz)],[min(yMaz), max(yMaz), max(yMaz),min(yMaz),min(yMaz)],'Color','k')
        
%         if posArt==1, 
%             ok=input('Changer le contour (o/n)? ','s'); 
%         else
%             ok='n';
%         end
        ok='n';
    else
        ok='y';
    end
    
    
    if strcmp(ok,'y')
        figure('color',[1 1 1]),
        imagesc(ref_im), axis xy
        hold on, plot(Data(Restrict(X,TrackingEpoch)),Data(Restrict(Y,TrackingEpoch)),'Color',[0.7 0.7 0.7])
        title('Delimiter le contour de l''environnement');
        [xMaz,yMaz]=ginput;
        save xyMax xMaz yMaz
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

if 0
    goodInterval1=thresholdIntervals(X,min(xMaz),'Direction','Above');
    goodInterval2=thresholdIntervals(X,max(xMaz),'Direction','Below');
    goodInterval3=thresholdIntervals(Y,min(yMaz),'Direction','Above');
    goodInterval4=thresholdIntervals(Y,max(yMaz),'Direction','Below');
    
    goodIntervalA=intersect(goodInterval1,goodInterval2);
    goodIntervalB=intersect(goodInterval3,goodInterval4);
    
    goodInterval=intersect(goodIntervalA,goodIntervalB);
    
    
else
    goodInterval=intervalSet(min(rg),max(rg));
    goodInterval1=thresholdIntervals(X,max(xMaz),'Direction','Above');
    goodInterval2=thresholdIntervals(X,min(xMaz),'Direction','Below');
    goodInterval3=thresholdIntervals(Y,max(yMaz),'Direction','Above');
    goodInterval4=thresholdIntervals(Y,min(yMaz),'Direction','Below');
    
    goodInterval=goodInterval-goodInterval1-goodInterval2-goodInterval3-goodInterval4;
end

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


