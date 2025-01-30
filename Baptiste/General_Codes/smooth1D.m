function ys=smooth1D(y,n)
%Moving smoothing filter for 1D data with floating point filter values .
%(The build-in function smooth.m from matlab operates only with odd integer
%nummbers.)
%Input:
%   y is the vector to be smoothed. 
%   n is the filter value with any number.
%     Filter values n below/equal 1 will return the original input.
%     Filter values larger than the number of elements in the y vector are reduced.
%     The filter is symmetric and has therefore an odd number of elements.
%     Filter examples:
%        n=1.5:      0.25, 1, 0.25
%        n=2.5:      0.75, 1, 0.75
%        n=4.0:    0.5, 1, 1, 1, 0.5
%Author: Peter Seibold

    if n<=1;ys=y;return;end;%no filter
    numely=numel(y);
    if n>numely-2 %exact formula: n>floor((numel(y)-1)/2)*2+1, slower
        n=floor((numely-1)/2)*2+1;%closest odd number
        warning('number of filter elements too large.\n%s',...
            ['Filter value reduced to ' num2str(n)]);
    end
    spanL=ceil((n-1)/2);%num filter coeff left or right of filter center
    borderValue=(n-spanL*2+1)/2;%e.g. borderValue=0.25 for n=1.5 
    ys=y;%Unchanged: ys(1)=y(1) and ys(end)=y(end)
    %Filter left and right border of y
    div=2;
     for i=2:spanL
        ys(i)=sum(y(1:div))/div;
        ys(end-i+1)=sum(y(end-div+1:end))/div;
        div=div+2;
     end
     %Filter remaining center part of y
     for i=spanL+1:numely-spanL
         ys(i)=y(i-spanL)*borderValue+sum(y(i-spanL+1:i+spanL-1))+y(i+spanL)*borderValue;
     end
     ys(spanL+1:numely-spanL)=ys(spanL+1:numely-spanL)/n;
     