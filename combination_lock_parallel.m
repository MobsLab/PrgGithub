%combination_lock_parallel

    ValRes=[1 3 5 7];

id{NumMouse}=find(ResPermut(:,14)==NumMouse);

tic 


    c{NumMouse}=nchoosek(1:length(id{NumMouse}),4);


clear A


parfor i=1:length(c{NumMouse})
%for i=1:1E6%length(c)
    
    A(i,:)=mean(ResPermut(id{NumMouse}(c{NumMouse}(i,:)),ValRes));    
    
end

At{NumMouse}=A;

for i=1:4

    figure('color',[1 1 1])

    th=mean(Res(find(Res(:,13)==NumMouse),ValRes(i)));
    thc=mean(ResCtrl(find(ResCtrl(:,13)==NumMouse),ValRes(i)));
    thp1=percentile(ResPermut(id{NumMouse},ValRes(i)),95);
    thp2=percentile(At{NumMouse}(:,i),95);

    subplot(2,1,1), hist(ResPermut(id{NumMouse},ValRes(i)),100)
    yl=ylim;
    hold on, line([th th],yl,'color','r','linewidth',2)
    hold on, line([thc thc],yl,'color','b','linewidth',2)
    hold on, line([thp1 thp1],yl,'color','k','linewidth',2)

    subplot(2,1,2), hist(At{NumMouse}(:,i),100)
    yl=ylim;
    hold on, line([th th],yl,'color','r','linewidth',2)
    hold on, line([thc thc],yl,'color','b','linewidth',2)
    hold on, line([thp2 thp2],yl,'color','k','linewidth',2)

    title(['Mouse:',num2str(NumMouse),', val:',num2str(ValRes(i))])

end



toc

