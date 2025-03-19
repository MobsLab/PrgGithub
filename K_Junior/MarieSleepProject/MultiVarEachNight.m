%Each night of Bigmat

clear
load BigMat
load BigMat2

%good variables - remove 25-26-36-37
goodvar = [2:24 27:35 38:75];
%path and mice
allpaths = newMatREM(:,76:77);
mice = unique(newMatREM(:,77));
micepath = unique(allpaths, 'rows');
paths = unique(allpaths(:,1));

for i=1:length(paths)
    cd(Dir.path{paths(i)})
    try
       SleepScoreFigure() 
    end
    
end