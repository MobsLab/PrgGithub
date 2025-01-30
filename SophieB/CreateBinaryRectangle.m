function Im = CreateBinaryRectangle(ImSz1,ImSz2,RectSz1,RectSz2,Center1,Center2)

% ImSz1, ImSz2 = siez of total image
% RectSz1,RectSz2:Size of the rectangle you want
% Center1,Center2: Center of the rectangle you want

Im = zeros(ImSz1,ImSz2);

HalfLen1 = floor(RectSz1/2);
HalfLen2 = floor(RectSz2/2);

for ii = Center1 - HalfLen1:Center1 + HalfLen1
    for jj = Center2 - HalfLen2:Center2 + HalfLen2
        
        Im(ii,jj) = 1;
        
    end
end


end