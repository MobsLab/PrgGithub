
function map = CleanMapKB(threshold,map,minFieldSize,n)

%minFieldSize=10;

M=size(map,1);
N=size(map,2);

if nargin < 4,
	n = 1;
elseif n >= 50,
	% Maximum 50 recursive calls
	return
else
	n = n + 1;
end



peak = max(max(map));
peakLocation = FindPeakLocation(map);
field = FindFiringField(peakLocation(1),peakLocation(2),M,N,threshold*peak,map);
fieldSize = sum(sum(field));
% disp(['CleanMap: field size = ' int2str(fieldSize)]);

% if fieldSize > 0 & fieldSize < SETTINGS.minFieldSize,



if fieldSize > 0 & fieldSize < minFieldSize,
    
	% Remove this region from rate map for next iteration
	map(logical(field)) = 0;
	map = CleanMapKB(threshold,map,10,99,n);
    %disp(['remove '])
end

% 
% %keyboard
% th=percentile(map(map>0),thpercentile);
% 
% 
% map2=map;
% map2(map2<th)=0;
% 
%  
% peak = max(max(map2));
% peakLocation = FindPeakLocation(map2);
% 
% a=1;
% for i=1:size(map2,1)
%     for j=1:size(map2,2)
% 
%         if map2(i,j)>th;
%           peakLocation2(a,1)=i;
%           peakLocation2(a,2)=j;          
%           a=a+1;
%         end
%         
%         
%     end
% end
% 
% for k=1:a-1
%     
%     field = FindFiringField(peakLocation2(k,1),peakLocation2(k,2),M,N,th/5,map);
%     fieldSize = sum(sum(field))
%     % disp(['CleanMap: field size = ' int2str(fieldSize)]);
% 
%     % if fieldSize > 0 & fieldSize < SETTINGS.minFieldSize,
% 
% 
% 
%     if fieldSize > 0 & fieldSize < minFieldSize,
%     %if fieldSize < minFieldSize,
%     
%         % Remove this region from rate map for next iteration
%         %map(peakLocation2(k,1),peakLocation2(k,2)) = 0;
%         
%         map(logical(field)) = 0;
%         
%         
%         %disp(['remove2 '])
%     end   
% 
% end




function peakLocation = FindPeakLocation(map)

peak = max(max(map));
xy = (map == peak);
x = find(max(xy));
y = find(max(xy,[],2));
peakLocation = [x(1) y(1)];
