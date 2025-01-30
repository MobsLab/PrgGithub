function RasterPlotid(S,id,plo)

try
    plo;
catch
    plo=1;
end

for i=1:length(id)
Sid{i}=S{id(i)};
end
Sid=tsdArray(Sid);

if plo
figure('color',[1 1 1]),
end

RasterPlot(Sid)
