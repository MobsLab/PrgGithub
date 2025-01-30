imagesc(linspace(-250,250,size(MeanFR_AroundRip_all,2)) , [1:size(MeanFR_AroundRip_all,1)] ,...
    MeanFR_AroundRip_all(d{4},190:207))
xlabel('time around ripple (ms)'), yticklabels({''}), caxis([-.15 1]), xticks([-250 0 250])
makepretty_BM
hline(20,'--w'), hline(size(MeanFR_AroundRip_all,1)-40,'--w'), 
colormap viridis
freezeColors


dat = zscore(MeanFR_AroundRip_all(d{4},[190:207])');

[c,e]=max(dat);
for ii = 1:130
    plot(dat(:,ii)+1*ii)
    hold on
    plot(e(ii),1*ii,'*')
    %     pause
    %     clf
end


% Compare with / without the extreme safe cells
figure
[f,g]=max(HistData_FR{sess}(d{4},:)');
[c,e]=max(zscore(MeanFR_AroundRip_all(d{4},[190:207])'));
for i=[1:20 90:130]%size(MeanFR_AroundRip_all,1)
    plot((e(i)/18-.5)*100 ,1-g(i)/100 , '.' , 'MarkerSize' , 50 , 'Color' , [col(i,:)]), hold on
end
for i=[21:89]%size(MeanFR_AroundRip_all,1)
    plot((e(i)/18-.5)*100 ,1-g(i)/100 , '.' , 'MarkerSize' , 50 , 'Color' , [.5 .5 .5]), hold on
end

figure, [R,P,a,b,LINE]=PlotCorrelations_BM((e/18-.5)*100 ,g/100, 'method' , 'pearson'); close
line([LINE(1,1) LINE(1,2)] , [LINE(2,2) LINE(2,1)] , 'Color' , [0 0 0] , 'LineWidth' , 5)
f=get(gca,'Children'); legend([f(1)],['R = ' num2str(R) '     P = ' num2str(P)]);
yticks([0:.1:1]), yticklabels({'1','0.9','0.8','0.7','0.6','0.5','0.4','0.3','0.2','0.1','0'}

figure
dnew = d{4}(1:110);
[f,g]=max(HistData_FR{sess}(dnew,:)');
[c,e]=max(zscore(MeanFR_AroundRip_all(dnew,[190:207])'));
for i=[1:20 90:110]%size(MeanFR_AroundRip_all,1)
    plot((e(i)/18-.5)*100 ,1-g(i)/100 , '.' , 'MarkerSize' , 50 , 'Color' , [col(i,:)]), hold on
end
for i=[21:89]%size(MeanFR_AroundRip_all,1)
    plot((e(i)/18-.5)*100 ,1-g(i)/100 , '.' , 'MarkerSize' , 50 , 'Color' , [.5 .5 .5]), hold on
end

figure, [R,P,a,b,LINE]=PlotCorrelations_BM((e/18-.5)*100 ,g/100, 'method' , 'pearson'); close
line([LINE(1,1) LINE(1,2)] , [LINE(2,2) LINE(2,1)] , 'Color' , [0 0 0] , 'LineWidth' , 5)
f=get(gca,'Children'); legend([f(1)],['R = ' num2str(R) '     P = ' num2str(P)]);
yticks([0:.1:1]), yticklabels({'1','0.9','0.8','0.7','0.6','0.5','0.4','0.3','0.2','0.1','0'}


% Have a look at the cells that are driving this
[c,e]=max(dat);
for ii = 110:130
    subplot(211)
    plot(HistData_FR{4}(d{4}(ii),:))
    subplot(212)
    plot(dat(:,ii)+3*ii)
    hold on
    plot(e(ii),3*ii,'*')
    pause
    clf
end




figure
[c,e]=max(zscore(MeanFR_AroundRip_all(d{4},[190:210])'));
MakeSpreadAndBoxPlot3_SB({e(1:20),e(90:130)},Cols2,X2,Legends2,'showpoints',1,'paired',0)