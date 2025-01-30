Dir = PathForExperimentsERC('UMazePAG');

mice_PAG_neurons = [905,906,911,994,1161,1162,1168,1182,1186,1230,1239];
 
 for ff = 1:length(Dir.name)
     if ismember(eval(Dir.name{ff}(6:end)),mice_PAG_neurons)%
cd(Dir.path{ff}{1})
         disp(Dir.path{ff}{1})
end
end 