%IntraMouseMultivar

%cd /home/karim/Dropbox/MOBS_workingON/AnalyseMultivarieMarie
clear
load BigMat

MatREM(isnan(MatREM)) = 0;
%good variables - remove 25-26-36-37
goodvar = [2:24 27:35 38:75];
X = MatREM(:,27:35);
durRem = MatREM(:,1);

allpaths = [MatREM(:,76) zeros(length(MatREM(:,76)),1)];
mice_name = unique(Dir.name);
path_mice = zeros(1,length(Dir.path));
for i=1:length(Dir.path)
    path_mice(i) = find(strcmp(Dir.name(i), mice_name));
    allpaths(allpaths(:,1)==i,2) = path_mice(i);
end
xmice = allpaths(:,2);

%tree
% tree = linkage(X,'average');
% figure()
% dendrogram(tree)

%manova
[d,p,stats] = manova1(X, xmice');
manovacluster(stats, 'ward')
