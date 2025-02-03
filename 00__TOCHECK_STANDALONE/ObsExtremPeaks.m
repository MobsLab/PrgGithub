function [h,Sp,brst]=ObsExtremPeaks(t1,limTime)





brst = burstinfo(Range(t1,'s'), limTime);
%brst = burstinfo(Range(t2,'s'), 1);
%brst = burstinfo(Range(t3,'s'), 1);


%Sp=intervalSet(brst.t_start(brst.n>20)*1E4,brst.t_end(brst.n>20)*1E4);
Sp=intervalSet(brst.t_start*1E4,brst.t_end*1E4);

a=1;
for i=1:length(Start(Sp))
h(a,:)=hist(Data(Restrict(t1,subset(Sp,i))),[1:2:23]);
id(a)=i;
a=a+1;
end

%figure, imagesc([1:2:22],[1:length(Start(Sp))],SmoothDec(h,[2,1]))


if 0
    
    
        try
    
        load behavResources
        st=Start(CPEpoch);
        st1=Start(VEHEpoch);
        st2=Start(CPEpoch);

        tim=Start(Sp);



        idVEH=find(tim>st1(1));
        idVEH=idVEH(1);

        idCP=find(tim>st2(1));
        idCP=idCP(1);

        % figure, plot(tim)
        % hold on, line([0 1200],[st2(1) st2(1)],'color','r')
        % hold on, line([0 1200],[st1(1) st1(1)],'color','r')

        figure, imagesc([1:2:22],[1:length(Start(Sp))],SmoothDec(h,[2,1]))
        hold on, line([0 22],[idVEH idVEH],'color','w','linewidth',2)
        hold on, line([0 22],[idCP idCP],'color','w','linewidth',2)

        figure, plot([1:2:23],sum(h(1:idVEH,:)),'b','linewidth',2)
        hold on, plot([1:2:23],sum(h(idVEH:idCP,:)),'k','linewidth',2)
        hold on, plot([1:2:23],sum(h(idCP:length(Start(Sp)),:)),'r','linewidth',2)

        figure, plot([1:2:23],median(h(1:idVEH,:)),'b','linewidth',2)
        hold on, plot([1:2:23],median(h(idVEH:idCP,:)),'k','linewidth',2)
        hold on, plot([1:2:23],median(h(idCP:length(Start(Sp)),:)),'r','linewidth',2)

        figure, plot([1:2:23],mean(h(1:idVEH,:)),'b','linewidth',2)
        hold on, plot([1:2:23],mean(h(idVEH:idCP,:)),'k','linewidth',2)
        hold on, plot([1:2:23],mean(h(idCP:length(Start(Sp)),:)),'r','linewidth',2)

        end


end

