% Linearize maze
function LinearDist = LinearizeMaze(Params, redo)
%% This function linearizes the maze.


if isstring(Params)
    Params = load([Params '/behavResources.mat']);
end

if isfield(Params, 'LinearDist')

    figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);


    imagesc(Params.mask+Params.Zone{1})
    curvexy=ginput(4);
    clf

    xxx = Data(Params.Ytsd)';
    yyy = Data(Params.Xtsd)';
    mapxy=[Data(Params.Ytsd)'; Data(Params.Xtsd)']';
    [xy,distance,t] = distance2curve(curvexy,mapxy*Params.Ratio_IMAonREAL,'linear');

    t(isnan(xxx))=NaN;

    subplot(211)
    imagesc(Params.mask+Params.Zone{1})
    hold on
    plot(Data(Params.Ytsd)'*Params.Ratio_IMAonREAL,Data(Params.Xtsd)'*Params.Ratio_IMAonREAL)
    subplot(212)
    plot(t), ylim([0 1])

    close(gcf);

    LinearDist=tsd(Range(Params.Xtsd),t);
else
    if redo
        figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);


        imagesc(Params.mask+Params.Zone{1})
        curvexy=ginput(4);
        clf

        xxx = Data(Params.Ytsd)';
        yyy = Data(Params.Xtsd)';
        mapxy=[Data(Params.Ytsd)'; Data(Params.Xtsd)']';
        [xy,distance,t] = distance2curve(curvexy,mapxy*Params.Ratio_IMAonREAL,'linear');

        t(isnan(xxx))=NaN;

        subplot(211)
        imagesc(mask+Zone{1})
        hold on
        plot(Data(Params.Ytsd)'*Params.Ratio_IMAonREAL,Data(Params.Xtsd)'*Params.Ratio_IMAonREAL)
        subplot(212)
        plot(t), ylim([0 1])


        close(gcf);

        LinearDist=tsd(Range(Params.Xtsd),t);

    end
end

end