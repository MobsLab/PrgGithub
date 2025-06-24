h=hist(V,[-90:0.1:-70]);
figure, area([-90:0.1:-70],h)
xlim([-82 -78])
figure, bar([-90:0.1:-70],h)
figure, bar([-90:0.1:-70],h1)
??? Undefined function or variable 'h1'.
figure, bar([-90:0.1:-70],h,1)
figure, bar([-90:0.1:-70],h/sum(h),1)
h=hist(V,[-90:0.05:-70]);
figure, bar([-90:0.05:-70],h/sum(h),1)
xlim([-82 -78])
figure, bar([-90:0.05:-70],smooth(h/sum(h),2),1)
xlim([-82 -78])

figure, area([-90:0.05:-70],smooth(h/sum(h),3))
xlim([-82 -78])

            Num=gcf;

            set(Num,'paperPositionMode','auto')

            eval(['print -f',num2str(Num),' -dpng ','HistVmSmooth','.png'])
%             eval(['print -f',num2str(Num),' -dpng ','HistVmFIG','.png'])
           

            eval(['print -f',num2str(Num),' -painters',' -depsc2 ','HistVmSmooth','.eps'])
%              eval(['print -f',num2str(Num),' -painters',' -depsc2


h=hist(V,[-90:0.05:-70]);
figure, bar([-90:0.05:-70],h/sum(h),1)
xlim([-82 -78])
figure, area([-90:0.05:-70],smooth(h/sum(h),3))
xlim([-81.7 -78.7])
ylim([0 0.18])
Num=gcf;

            set(Num,'paperPositionMode','auto')

            eval(['print -f',num2str(Num),' -dpng ','HistVmSmooth','.png'])
%             eval(['print -f',num2str(Num),' -dpng ','HistVmFIG','.png'])
           

            eval(['print -f',num2str(Num),' -painters',' -depsc2 ','HistVmSmooth','.eps'])
%              eval(['print -f',num2str(Num),' -painters',' -depsc2