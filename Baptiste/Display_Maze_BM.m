







figure

eps=0;
a=area([0+eps .35-eps],[.75 .25 ; .75 .25]); a(1).FaceColor=[1 .5 .5]; a(1).LineWidth=1e-6; a(1).EdgeColor=[1 1 1]; a(2).FaceColor=[1 .8 .8];  a(2).LineWidth=1e-6; a(2).EdgeColor=[1 1 1];
hold on
a=area([.35+eps .65-eps],[.75 .25 ; .75 .25]); a(1).FaceColor=[1 1 1]; a(1).LineWidth=1e-6; a(1).EdgeColor=[1 1 1];  a(2).FaceColor=[1 .8 1];  a(2).LineWidth=1e-6; a(2).EdgeColor=[1 1 1];
a=area([.65+eps 1-eps],[.75 .25 ; .75 .25]); a(1).FaceColor=[.5 .5 1]; a(1).LineWidth=1e-6; a(1).EdgeColor=[1 1 1]; a(2).FaceColor=[.8 .8 1];  a(2).LineWidth=1e-6; a(2).EdgeColor=[1 1 1];


x1=0; y1=0;
x2=0.35; y2=0;
x3=0.65; y3=0; 
x4=1; y4=0;
x5=0; y5=1;
x6=1; y6=1;
x7=0.35; y7=0.75;
x8=0.65; y8=0.75; 

line([x1,x5],[y1,y5],'color',[0 0 0],'linewidth',3)
line([x1,x2],[y1,y2],'color',[0 0 0],'linewidth',3)
line([x2,x7],[y2,y7],'color',[0 0 0],'linewidth',3)
line([x5,x6],[y5,y6],'color',[0 0 0],'linewidth',3)
line([x7,x8],[y7,y8],'color',[0 0 0],'linewidth',3)
line([x8,x3],[y8,y3],'color',[0 0 0],'linewidth',3)
line([x3,x4],[y3,y4],'color',[0 0 0],'linewidth',3)
line([x6,x4],[y6,y4],'color',[0 0 0],'linewidth',3)

line([x1 x2],[.6 .6],'color',[0 0 0],'linewidth',2,'linestyle','--')
line([x3 x4],[.6 .6],'color',[0 0 0],'linewidth',2,'linestyle','--')

axis off















