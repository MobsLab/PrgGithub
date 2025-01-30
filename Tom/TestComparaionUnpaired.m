MicePAG = {'M404';'M437';'M439';'M469';'M471';'M483';'M484';'M485';'M490';...
    'M507';'M508';'M509';'M510';'M512';'M514'};
MiceEyelid = {'M561';'M567';'M568';'M569';'M566';'M688';'M739';'M777';...
    'M779';'M849';'M893';'M1096';'M1144';'M1146';'M1171';'M9184';'M1189';...
    'M9205';'M1391';'M1392';'M1393';'M1394';'M1224';'M1225';'M1226'};

MiceEyelidCleared = {'M561';'M567';'M568';'M569';'M688';'M739';'M777';...
    'M849';'M1171';'M1189';...
    'M1391';'M1392';'M1393';'M1394';'M1224';'M1225';'M1226'};


MicePAGCleared = {'M404';'M437';'M439';'M471';'M483';'M484';'M485';'M490';...
    'M507';'M508';'M509';'M510';'M512';'M514'};
MiceEyelidCleared = {'M561';'M567';'M568';'M569';'M566';'M688';'M739';'M777';...
    'M849';'M893';'M1096';'M1144';'M1146';'M1171';'M9184';'M1189';...
    'M1391';'M1392';'M1393';'M1394';'M1224';'M1225';'M1226'};


Gui_ModelsComparisonUnpaired(Models.FinalAnalysis, Models.FinalAnalysis, ...
    "Optim GT PAG", "Optim GT Eyelid", MicePAGCleared, MiceEyelidCleared, coefFinalAnalysis, coefFinalAnalysis)


figure;
ploted = plot(1:10,1:2:20, 'x');
plotedBrushHandles = ploted.BrushHandles;
plotedBrushHandlesChildren = plotedBrushHandles.Children;
plotedBrushHandlesChildren(1).VertexData

figure;
Handle = plot(1:10, 'x');
xd = get(Handle, 'XData');
yd = get(Handle, 'YData');
brush = get(Handle, 'BrushData');
logbrush = logical(brush);
brushed_x = xd(logical(brush));
brushed_y = yd(logbrush);
brushedPoints = [brushed_x(:) brushed_y(:)];
dist = pdist2([xd(:) yd(:)], brushedPoints);
[~,idx] = min(dist);



for i = 1:length(MiceWV) 
    disp([MiceWV{i} ' : ' num2str(size(DATAtable.(MiceWV{i}))) '    ' num2str(size(DATAtableWV.(MiceWV{i})))])
end 

