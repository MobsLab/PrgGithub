function [LinearDist, curvexy] = LinearizeMaze(Params, redo, varargin)
%% This function linearizes the maze.
% It takes the parameters from the behavResources.mat file
% and the data from the tracking file.
% It returns the linearized distance and the curvexy.
% Inputs:
%   Params: the parameters from the behavResources.mat file
%   redo: if set to 1, the function will redo the linearization
%   varargin: optional arguments for the function
%       'curvexy': the curvexy from another "template" session
% Outputs:
%   LinearDist: the linearized distance
%   curvexy: the curvexy to compute LinearDist

% parse the varargin arguments
p = inputParser;
% curvexy can be either empty or a double
addParameter(p, 'redo', 0, @(x) islogical(x) || x==1 || x==0);
addParameter(p, 'curvexy', [], @(x) isempty(x) || (isnumeric(x) && size(x, 2) == 2));
parse(p, varargin{:});
curvexy = p.Results.curvexy;


if isstring(Params)
    try
        Params = load([Params '/behavResources.mat']);
    catch
        Params = load([Params])
    end
end

if ~isfield(Params, 'LinearDist')

    figure('units', 'normalized', 'outerposition', [0 1 0.5 0.8]);
    xxx = Data(Params.Ytsd)';
    yyy = Data(Params.Xtsd)';
    if ~isempty(curvexy)
        curvexy=curvexy;
    else
        imagesc(Params.mask+Params.Zone{1})
        hold on;
        plot(xxx*Params.Ratio_IMAonREAL, yyy*Params.Ratio_IMAonREAL)
        title('Give 4 points: Shk-ext corner, shk-center corner, safe-center corner, safe-ext corner.')
        curvexy=ginput(4);
        clf
    end

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
        xxx = Data(Params.Ytsd)';
        yyy = Data(Params.Xtsd)';

        if ~isempty(curvexy)
            curvexy=curvexy;
        else
            imagesc(Params.mask+Params.Zone{1})
            hold on;
            plot(xxx*Params.Ratio_IMAonREAL, yyy*Params.Ratio_IMAonREAL)
            title('Give 4 points: Shk-ext corner, shk-center corner, safe-center corner, safe-ext corner.')
            curvexy=ginput(4);
            clf
        end

        mapxy=[Data(Params.Ytsd)'; Data(Params.Xtsd)']';
        [xy,distance,t] = distance2curve(curvexy,mapxy*Params.Ratio_IMAonREAL,'linear');

        t(isnan(xxx))=NaN;

        subplot(221)
        imagesc(Params.mask+Params.Zone{1})
        hold on
        plot(Data(Params.Ytsd)'*Params.Ratio_IMAonREAL,Data(Params.Xtsd)'*Params.Ratio_IMAonREAL)
        hold off
        subplot(222)
        hold on
        scatter(Data(Params.Xtsd)*Params.Ratio_IMAonREAL,Data(Params.Ytsd)*Params.Ratio_IMAonREAL, [], t)
        colorbar
        hold off
        subplot(212)
        plot(t), ylim([0 1])


        close(gcf);

        LinearDist=tsd(Range(Params.Xtsd),t);

    end
end
end