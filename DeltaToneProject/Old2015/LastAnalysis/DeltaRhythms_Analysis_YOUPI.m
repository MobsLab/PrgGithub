




% Delta Quantity
for i=1:5
    for j=1:5
        M(i,j)=length(Delta_M243_basal{i,j});
        M2(i,j)=length(Delta_M244_basal{i,j});
    end
end
M(2,1)=2000;
for i=1:5
    for j=1:5
        T(i,j)=length(Delta_M243_Tone{i,j});
        T2(i,j)=length(Delta_M244_Tone{i,j});
    end
end



% Delta Quantity
PlotErrorBarN(M)
hold on, plot(1:5,T(1,:),'go-')
hold on, plot(1:5,T(2,:),'co-')
hold on, plot(1:5,T(3,:),'bo-')
hold on, plot(1:5,T(4,:),'mo-')
hold on, plot(1:5,T(5,:),'ro-')

PlotErrorBarN(M2)
hold on, plot(1:5,T2(1,:),'go-')
hold on, plot(1:5,T2(2,:),'co-')
hold on, plot(1:5,T2(3,:),'bo-')
hold on, plot(1:5,T2(4,:),'mo-')
hold on, plot(1:5,T2(5,:),'ro-')


% Delta Quantity (normalized)
PlotErrorBarN(M./(M(:,1)*ones(1,5)))
hold on, plot(1:5,T(1,:)/T(1,1),'go-')
hold on, plot(1:5,T(2,:)/T(2,1),'co-')
hold on, plot(1:5,T(3,:)/T(3,1),'bo-')
hold on, plot(1:5,T(4,:)/T(4,1),'mo-')
hold on, plot(1:5,T(5,:)/T(5,1),'ro-')

PlotErrorBarN(M2./(M2(:,1)*ones(1,5)))
hold on, plot(1:5,T2(1,:)/T2(1,1),'go-')
hold on, plot(1:5,T2(2,:)/T2(2,1),'co-')
hold on, plot(1:5,T2(3,:)/T2(3,1),'bo-')
hold on, plot(1:5,T2(4,:)/T2(4,1),'mo-')
hold on, plot(1:5,T2(5,:)/T2(5,1),'ro-')



% Delta Quantity (mean)
m=(M./(M(:,1)*ones(1,5))+M2./(M2(:,1)*ones(1,5)))/2;
t=(T./(T(:,1)*ones(1,5))+T2./(T2(:,1)*ones(1,5)))/2;

PlotErrorBarN(m)
hold on, plot(1:5,t(1,:),'go-')
hold on, plot(1:5,t(2,:),'co-')
hold on, plot(1:5,t(3,:),'bo-')
hold on, plot(1:5,t(4,:),'mo-')
hold on, plot(1:5,t(5,:),'ro-')



% Delta Quantity (mean & normalized)
figure('color',[1 1 1]), 
subplot(3,2,1)
plot(T(:,1),T(:,2)-T(:,1),'ko','markerfacecolor','k')
hold on, plot(T2(:,1),T2(:,2)-T2(:,1),'ro','markerfacecolor','r')
xlim([1000 5000]), ylim([-2000 2000])

subplot(3,2,2)
plot(M(:,1),M(:,2)-M(:,1),'bo','markerfacecolor','b')
hold on, plot(M2(:,1),M2(:,2)-M2(:,1),'mo','markerfacecolor','m')
xlim([1000 5000]), ylim([-2000 2000])

subplot(3,2,3), plot(T(:,3),T(:,4)-T(:,3),'ko','markerfacecolor','k')
hold on, plot(T2(:,3),T2(:,4)-T2(:,3),'ro','markerfacecolor','r')
xlim([1000 5000]), ylim([-2000 2000])

subplot(3,2,4)
plot(M(:,3),M(:,4)-M(:,3),'bo','markerfacecolor','b')
hold on, plot(M2(:,3),M2(:,4)-M2(:,3),'mo','markerfacecolor','m')
xlim([1000 5000]), ylim([-2000 2000])

subplot(3,2,5), plot(T(:,1),T(:,4)-T(:,3),'ko','markerfacecolor','k')
hold on, plot(T2(:,1),T2(:,4)-T2(:,3),'ro','markerfacecolor','r')
xlim([1000 5000]), ylim([-2000 2000])

subplot(3,2,6)
plot(M(:,1),M(:,4)-M(:,3),'bo','markerfacecolor','b')
hold on, plot(M2(:,1),M2(:,4)-M2(:,3),'mo','markerfacecolor','m')
xlim([1000 5000]), ylim([-2000 2000])
