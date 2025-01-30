function [meanint,stint]=mean_trial(All,t_av,nfig)
narg=length(All);
maxtot=[];
mintot=[];

for y=1:narg
for k=1:length(All{y}) 
    int=[];
    for i=1:size(All{y}{k},1)  
        int(i)=All{y}{k}(i);
    end
    if k==1 
        maxtot(y)=max(int);
        mintot(y)=min(int);
    end
maxtot(y)=max([maxtot(y),int]);
mintot(y)=min([mintot(y),int]);
    meanint{y}(k)=mean(int);
    stint{y}(k)=std(int)/sqrt(length(int));
end
end
  
%% Execute to plot
figure(nfig)
clf
for y=1:narg
subplot(1,narg,y)
errorbar(meanint{y},stint{y},'linewidth',3,'color',[0.2 0.2 0.2])
hold on
end

for y=1:narg
        subplot(1,narg,y)
for k=1:length(All{y}) 
     int=[];
   for i=1:size(All{y}{k},1)  
        int(i)=All{y}{k}(i);
    end

        plot(k*ones(1,length(int))+0.5*[0:i-1]/i,int,'color',[0.5 0.5 0.5]);
        hold on
    scatter(k*ones(1,length(int))+0.5*[0:i-1]/i,int,40,(k/length(All{y}))*ones(1,length(int)),'filled')

end
line([t_av t_av],[0.8*mintot(y) 1.1*maxtot(y)],'color','b','linewidth',3,'LineStyle','--')
xlabel('session')
xlim([0 length(All{y})+1])
ylim([0.8*mintot(y) 1.1*maxtot(y)])
colormap summer
end




end
