function makeBarFig = makeBarFig(barValArray,plotValArray)

nbBar = length(barValArray)
nbPlot = length(plotValArray)
color = {'r','b','c'}
figure(1),clf
hold on;

for i=1:nbBar

	bar(barValArray{i},color{i})	
	
end


for i=1:nbPlot

	plot([1:length(plotValArray{i})],plotValArray{i}) 	
	
end

hold off;