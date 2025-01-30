% LongREManalys

clear
load BigMat
load BigMat2

%params
threshDur = 80;
n_component = 10;
%long REM episode
longREM = newMatREM(newMatREM(:,1)>threshDur,:);

%path and mice
allpaths = longREM(:,76:77);
mice = unique(longREM(:,77));
micepath = unique(allpaths, 'rows');
paths = unique(allpaths(:,1));

%good variables - remove 25-26-36-37
goodvar = [1:24 27:35 38:75];
longREM = longREM(:,goodvar);
X = longREM(:,2:end);

[Lambda, Psi, T, stats, F] = factoran(X, n_component);


