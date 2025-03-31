function [AlignedXtsd,AlignedYtsd, XYOutput] = MorphCageToSingleShape_Align(Xtsd,Ytsd)


satisfied = 0;

f  = figure;
while satisfied ==0
    polygon = GetCageEdgesWithoutVideo(Data(Ytsd),Data(Xtsd));
    x = polygon.Position(:,2);
    y = polygon.Position(:,1);
    if abs(x(1)-x(2))>abs(x(3)-x(2))
        Coord1 = [x(1)-x(2),y(1)-y(2)];
        Coord2 = [x(3)-x(2),y(3)-y(2)];
    else
        Coord2 = [x(1)-x(2),y(1)-y(2)];
        Coord1 = [x(3)-x(2),y(3)-y(2)];
    end
    TranssMat = [Coord1',Coord2'];
    XInit = Data(Xtsd)-x(2);
    YInit = Data(Ytsd)-y(2);

    % The Xtsd and Ytsd in new coordinates
    A = ((pinv(TranssMat)*[XInit,YInit]')');
    AlignedXtsd = tsd(Range(Xtsd),40*A(:,1));
    AlignedYtsd = tsd(Range(Ytsd),20*A(:,2));
    clf
    f.Position = [100 100 900 1800];
    plot(Data(AlignedYtsd),Data(AlignedXtsd))
    xlim([-5 25])
    ylim([-5 45])
    hline(0)
    hline(40)
    vline(0)
    vline(20,'-r')

    satisfied = input('satisfied?');
end
    XYOutput(1,:) = x;
    XYOutput(2,:) = y;
clf;
close
end