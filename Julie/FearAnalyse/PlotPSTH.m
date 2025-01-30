function PlotPSTH(lim, bi, smo, m2,s2,t2,m3,s3,t3,m1,s1,t1,cd, subplotnb,ColorPSTH)
%PlotPSTH(lim, bi, smo, m2,s2,t2,m3,s3,t3,m1,s1,t1,cd,1)
% PSTH
% 26.11.2014 aims at giving an overview of the behavioral results of Fear Conditionning( oct-nov2014
%  m2,s2,t2,m3,s3,t3,m1,s1,t1 : variables given in the script  FigBILANObsFreezManipBulbectomie
% (1) CS-  (2) first CS+   (3) last CS+
lim=100; % nb bins
bi=1000; % bin size
smo=1;


list=dir; %list of mouse folders

load Behavior.mat
csp=StimInfo(StimInfo(:,2)==7,1);
csm=StimInfo(StimInfo(:,2)==5,1);

[m1,s1,t1]=mETAverage(csm*1E4,Range(Movtsd),Data(Movtsd),bi,lim); % CS-
[m2,s2,t2]=mETAverage(csp(1:4)*1E4,Range(Movtsd),Data(Movtsd),bi,lim); % 4 first CS+
[m3,s3,t3]=mETAverage(csp(5:end)*1E4,Range(Movtsd),Data(Movtsd),bi,lim); % last CS+

%ColorPSTH={ 'k','r',[1 0.5 0]}; % first CS+, last CS+, CS-
%figure('color',[1 1 1]),
hold on, 
plot(t1/1E3,SmoothDec(m1,smo),ColorPSTH{1},'linewidth',2), % CS-
plot(t2/1E3,SmoothDec(m2,smo),ColorPSTH{2},'linewidth',2) % 4 first CS+
plot(t3/1E3,SmoothDec(m3,smo),'Color',ColorPSTH{3},'linewidth',2), % last CS+

% with sem 
% CS-
plot(t1/1E3,SmoothDec(m1+s1/sqrt(length(csm)),smo),ColorPSTH{1},'linewidth',1),
plot(t1/1E3,SmoothDec(m1-s1/sqrt(length(csm)),smo),ColorPSTH{1},'linewidth',1),
% first CS+
plot(t2/1E3,SmoothDec(m2+s2/sqrt(4),smo),ColorPSTH{2},'linewidth',1)
plot(t2/1E3,SmoothDec(m2-s2/sqrt(4),smo),ColorPSTH{2},'linewidth',1)
% last CS+
plot(t3/1E3,SmoothDec(m3+s3/sqrt(length(csp(5:end))),smo),'Color', ColorPSTH{3},'linewidth',1),
plot(t3/1E3,SmoothDec(m3-s3/sqrt(length(csp(5:end))),smo),'Color',ColorPSTH{3},'linewidth',1),

if subplotnb==1
    hleg=legend( 'CS-','CS+ (1-4)', 'CS+ (5-end)');
    set(hleg, 'Location', 'NorthWest')
end
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])

fullpath=pwd;
mark=fullpath(1);
n=strfind (fullpath, mark);
titlefig=fullpath((n(end)+1):end);
title(titlefig);
%set(gcf,'position',[284   558   956   420])


