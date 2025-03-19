function [PosMat,PosMatInit,im_diff,im_diffInit,Vtsd,Xtsd,Ytsd,Imdifftsd]=CommonInterpPosMatImDiff(im_diff,chrono,PosMat, dist_thresh)
% This function takes in the im_diff and PosMat calculated during the code
% and interpolates variables to get rid of nans on the short distances.
% (interpolation on long distances may lead to spurious trajectories)
% There are three layers of output
% - PosMatInit & im_diffInit : the raw data with no interpolation what so
% ever
% - PosMat & im_diff : the interpolated data
% - Vtsd Xtsd Ytsd Imdifftsd : tsd that is ready for analysis

% Changed by Dima Bryzgalov on 19/05/2021

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
                    if 1%dist<dist_thresh
                        
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
   

%%  im_diff
if sum(~isnan(im_diff(:,2)))>2
im_diffint=im_diff;
x=im_diffint(:,2);
nanx = isnan(x);
t    = 1:numel(x);
x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));
x(isnan(x))=nanmean(x);
im_diffint(:,2)=x;

PosMatInit=PosMat;
PosMat=CleanPosMat;
im_diffInit=im_diff;
im_diff=im_diffint;
Imdifftsd=tsd(im_diffint(:,1)*1e4,SmoothDec(im_diffint(:,2)',1));
else
im_diffInit=im_diff;
Imdifftsd=tsd(im_diffInit(:,1)*1e4,NaN*SmoothDec(im_diffInit(:,2)',1));
PosMatInit=PosMat;

end
%% Clean
Vtsd=tsd(CleanPosMat(1:end-1,1)*1e4,(sqrt(diff(CleanPosMat(:,2)).^2+diff(CleanPosMat(:,3)).^2)./(diff(CleanPosMat(:,1)))));
Xtsd=tsd(CleanPosMat(:,1)*1e4,(CleanPosMat(:,3)));
Ytsd=tsd(CleanPosMat(:,1)*1e4,(CleanPosMat(:,2)));

end