function [PosMat,PosMatInit,im_diff,im_diffInit,Vtsd,Xtsd,Ytsd,Imdifftsd,CleanPosMat,CleanXtsd,CleanYtsd,CleanVtsd]...
    =CommonInterpPosMatImDiff(im_diff,chrono,PosMat)
% This function takes in the im_diff and PosMat calculated during the code
% and interpolates variables to get rid of nans
% There are three layers of output
% - PosMatInit & im_diffInit : the raw data with no interpolation what so
% ever
% - PosMat & im_diff : the interpolated data
% - Vtsd Xtsd Ytsd Imdifftsd : tsd that si ready for analysis

global dist_thresh;

im_diff=im_diff(1:find(im_diff(:,1)>chrono-1,1,'last'),:);
% im_diff(im_diff(:,2)>50,2)=NaN;

%% Do not interpolate things with distances more than two
% Find indices of timetamps where the mouse was not tracked
idx_nan = isnan(PosMat(:,2));
idx_nan = find(idx_nan);

if ~isempty(idx_nan)
    % Split in sequences
    firsttime = 1;
    DD = diff(idx_nan);
    id=[false (DD==1)' false];
    istart = strfind(id,[0 1]);
    iend = strfind(id,[1 0]);
    k = 0;
    for i=1:length(id)-1
        if id(i)==0 && id(i+1)==0
            seq{i} = idx_nan(i);
            firsttime = 1;
        elseif id(i)==0 && id(i+1) == 1
            if firsttime
                k=k+1;
                start = istart(k);
                stop = iend(k);
                seq{i}=[idx_nan(start):idx_nan(stop)];
                firsttime = 0;
            end
        elseif id(i)==1 && id(i+1)==0
            seq{i} = [];
            firsttime=1;
        end
    end
    seq = seq(~cellfun('isempty',seq));

    
CleanPosMat = PosMat;
    for i=1:length(seq)
        temp = seq{i};
        if temp(1) ~= 1 && temp(1) > 5
            if length(temp)<4 % 4 is arbitrary
                
                if temp(end)+5 < size(CleanPosMat,1) % 5 is arbitrary
                    
                    % Interpolate x
                    x = CleanPosMat(temp(1)-5:temp(end)+5,2);
                    nanx = isnan(x);
                    t = 1:numel(x);
                    x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
                    % Interpolate x
                    y = CleanPosMat(temp(1)-5:temp(end)+5,3);
                    nany = isnan(y);
                    t = 1:numel(y);
                    y(nany) = interp1(t(~nany), y(~nany), t(nany));
                    
                    CleanPosMat(temp(1)-5:temp(end)+5,2:3) = [x y];
                    
                    clear x y nanx nany t
                    
                end
                
                
            else
                
                if temp(end)+5 < size(CleanPosMat,1)
                    
                    twopoints = CleanPosMat([temp(1)-1 temp(end)+1],2:3);
                    dist = pdist(twopoints, 'euclidean');
                    if dist<dist_thresh
                        
                        % Interpolate x
                        x = CleanPosMat(temp(1)-5:temp(end)+5,2);
                        nanx = isnan(x);
                        t = 1:numel(x);
                        x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
                        % Interpolate x
                        y = CleanPosMat(temp(1)-5:temp(end)+5,3);
                        nany = isnan(y);
                        t = 1:numel(y);
                        y(nany) = interp1(t(~nany), y(~nany), t(nany));
                        
                        CleanPosMat(temp(1)-5:temp(end)+5,2:3) = [x y];
                        
                        clear x y nanx nany t
                        
                    end
                end
            end
        end
    end
else
    CleanPosMat = PosMat;
end
    
%% X
PosMatInt=PosMat;
x=PosMatInt(:,2);
nanx = isnan(x);
t    = 1:numel(x);
x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));

% Check if there are still NaNs on the edges taken from Sophie's check all behavior 02.04.2018 Dima
if isnan(x(1))
    x(1:find(not(isnan(x)),1,'first'))=x(find(not(isnan(x)),1,'first'));
end
if isnan(x(end))
    x(find(not(isnan(x)),1,'last'):end)=x(find(not(isnan(x)),1,'last'));
end

PosMatInt(:,2)=x;

%% Y
x=PosMatInt(:,3);
nanx = isnan(x);
t    = 1:numel(x);
x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));

% Check if there are still NaNs on the edges taken from Sophie's check all behavior 02.04.2018 Dima
if isnan(x(1))
    x(1:find(not(isnan(x)),1,'first'))=x(find(not(isnan(x)),1,'first'));
end
if isnan(x(end))
    x(find(not(isnan(x)),1,'last'):end)=x(find(not(isnan(x)),1,'last'));
end

PosMatInt(:,3)=x;

%%  im_diff
im_diffint=im_diff;
x=im_diffint(:,2);
nanx = isnan(x);
t    = 1:numel(x);
x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
x(isnan(x))=nanmean(x);
im_diffint(:,2)=x;

PosMatInit=PosMat;
PosMat=PosMatInt;
CleanPosMat = CleanPosMat;
im_diffInit=im_diff;
im_diff=im_diffint;

% Corrected by DB 10/08/18: the speed in cm/s nowm before it was in cm
Vtsd=tsd(PosMatInt(1:end-1,1)*1e4,(sqrt(diff(PosMatInt(:,2)).^2+diff(PosMatInt(:,3)).^2)./(diff(PosMatInit(:,1)))));
Xtsd=tsd(PosMatInt(:,1)*1e4,(PosMatInt(:,3)));
Ytsd=tsd(PosMatInt(:,1)*1e4,(PosMatInt(:,2)));
Imdifftsd=tsd(im_diffint(:,1)*1e4,SmoothDec(im_diffint(:,2)',1));

%% Clean
CleanVtsd=tsd(CleanPosMat(1:end-1,1)*1e4,(sqrt(diff(CleanPosMat(:,2)).^2+diff(CleanPosMat(:,3)).^2)./(diff(CleanPosMat(:,1)))));
CleanXtsd=tsd(CleanPosMat(:,1)*1e4,(CleanPosMat(:,3)));
CleanYtsd=tsd(CleanPosMat(:,1)*1e4,(CleanPosMat(:,2)));

end