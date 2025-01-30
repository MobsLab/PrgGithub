%AnalyseKB24042019

a=1;
Dir = PathForExperimentsEmbReact('BaselineSleep')
for mousenum  = 1:length(Dir.path)
for daynum = 1:length(Dir.path{mousenum})
cd(Dir.path{mousenum}{daynum})
try
    [val{a},tps{a}]=SleepHomeostasisSleepCycleFunction; close all
    nam{a}=pwd;
    a=a+1;
end
end
end


Dir2=PathForExperimentsBasalSleepRhythms;
for daynum  = 1:length(Dir2.path)
cd(Dir2.path{daynum})
try
    [val{a},tps{a}]=SleepHomeostasisSleepCycleFunction; close all
    nam{a}=pwd;
a=a+1;
end
end

test=[];test1=[];tes=[];tes1=[];
for i=1:length(tps)
test=[test,tps{i}];
test1=[test1,rescale(tps{i},0,1)];
tes1=[tes1;zscore(val{i})];
tes=[tes;val{i}];
end

[nn1, xx1, yy1] = hist2(test(:), tes1(:), [8 0.05 20], [-4 0.1 4]);
[nn, xx, yy] = hist2(test(:), tes(:), [8 0.05 20], [0 0.02 2]);

[nn1b, xx1b, yy1b] = hist2(test1(:), tes1(:), [0 0.01 1], [-4 0.1 4]);
[nnb, xxb, yyb] = hist2(test1(:), tes(:), [0 0.01 1], [0 0.02 2]);

figure, imagesc(xx1,yy1,SmoothDec(nn1,[2 2])), axis xy
figure, imagesc(xx,yy,SmoothDec(nn,[2 2])), axis xy

for i=1:length(tps)
figure, plot(tps{i},val{i},'ko'), title(nam{i})
end



figure,
subplot(2,2,1), plot(test,tes,'ko')
subplot(2,2,2), plot(test1,tes,'ko')
subplot(2,2,3), plot(test,tes1,'ko')
subplot(2,2,4), plot(test1,tes1,'ko')

figure,
subplot(2,2,1), imagesc(xx,yy,SmoothDec(nn,[2 2])), axis xy
subplot(2,2,2), imagesc(xx1,yy1,SmoothDec(nn1,[2 2])), axis xy
subplot(2,2,3), imagesc(xxb,yyb,SmoothDec(nnb,[2 2])), axis xy
subplot(2,2,4), imagesc(xx1b,yy1b,SmoothDec(nn1b,[2 2])), axis xy




