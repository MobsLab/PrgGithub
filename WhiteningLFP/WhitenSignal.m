%function [y, ARmodel] = WhitenSignal(x, window,CommonAR,ARmodel, ARorder)
% whitens the signal 
% if window specified will recompute the model in each window of that size
% if CommonAR is set to 1, then will use model from first channel for all
% if ARmodel is specified - use it, not compute fromthe data
% output optionaly the ARmodel for use on the other data to be on the same scale
% seems that phase is shifted by Filter0 - check .. otherwise reprogram to
% filter with filtfilt , instead.
function [y, A] = WhitenSignal(x,varargin)

%artype =2; %Signal processing toolbox
artype =1 ; %arfit toolbox, (crushes sometimes with old version and single data type)

[window,CommonAR, ARmodel,ArOrder] = DefaultArgs(varargin,{[],0,[],1});
ArOrder = ArOrder+1;
Trans = 0;
if size(x,1)<size(x,2)
    x = x';
    Transf =1;
end
[nT nCh]  = size(x);
y = zeros(nT,nCh);
if isempty(window)
    seg = [1 nT];
    nwin=1;
else
    nwin = floor(nT/window)+1;
    seg = repmat([1 window],nwin,1)+repmat([0:nwin-1]'*window,1,2);
    if nwin*window>nT
        seg(end,2) =nT;
    end   
end

for j=1:nwin
    if ~isempty(ARmodel)
        A = ARmodel;
        for i=1:nCh
            y(seg(j,1):seg(j,2),i) = Filter0([1 -A], x(seg(j,1):seg(j,2),i));
        end
    else
        if CommonAR
            for i=1:nCh
                if  j==1
                    switch artype
                        case 1
                            [w A] = arfit(x(seg(j,1):seg(j,2),i),ArOrder,ArOrder);
                        case 2
                            A = arburg(x(seg(j,1):seg(j,2),i),ArOrder);
                    end
                end
                y(seg(j,1):seg(j,2),i) = Filter0([1 -A], x(seg(j,1):seg(j,2),i));
            end
        else
            for i=1:nCh
                switch artype
                    case 1
                        [w A] = arfit(x(seg(j,1):seg(j,2),i),ArOrder,ArOrder);
                    case 2
                        A = arburg(x(seg(j,1):seg(j,2),i),ArOrder);
                end
                y(seg(j,1):seg(j,2),i) = Filter0([1 -A], x(seg(j,1):seg(j,2),i));
            end
        end
    end
end

if Trans
    y =y';
end
