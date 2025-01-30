
Session_type = {'Cond','Ext'};
Mouse=[117 404 425 431 436 437 438 439 469 470 471 483 484 485 490 507 508 509 510 512 514 561 567 568 569 566 666 667 668 669 688 739 777 779 849 893 1144 1146 1147 1170 1171 9184 1189 9205 1391 1392 1393 1394 1224 1225 1226];

for sess=1:length(Session_type)
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'heartbeat');
end

bin_size = 100;
for mouse=1:50
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try
        clear D1 D2 RR_n_shock RR_n1_shock RR_n_safe RR_n1_safe
        D1 = Range(OutPutData.Cond.heartbeat.ts{mouse,5})/1e4;
        RR_n_shock = diff(D1(1:end-1));
        RR_n1_shock = diff(D1(2:end));
        
        D2 = Range(OutPutData.Cond.heartbeat.ts{mouse,6})/1e4;
        RR_n_safe = diff(D2(1:end-1));
        RR_n1_safe = diff(D2(2:end));
        
        RR_n_shock(or(RR_n_shock>.18 , RR_n_shock<.07))=NaN; RR_n1_shock(or(RR_n1_shock>.18 , RR_n1_shock<.07))=NaN;
        RR_n_safe(or(RR_n_safe>.18 , RR_n_safe<.07))=NaN; RR_n1_safe(or(RR_n1_safe>.18 , RR_n1_safe<.07))=NaN;
        
        PoincarrePlot_Shock(mouse,:,:) = hist2d([RR_n_shock ; .07 ; .07 ; .18 ; .18] , [RR_n1_shock ; .07 ; .18 ; .07 ; .18] , bin_size , bin_size);
        PoincarrePlot_Safe(mouse,:,:) = hist2d([RR_n_safe ; .07 ; .07 ; .18 ; .18] , [RR_n1_safe ; .07 ; .18 ; .07 ; .18] , bin_size , bin_size);
        
        if sum(sum(PoincarrePlot_Shock(mouse,:,:)==0))==bin_size*bin_size
            PoincarrePlot_Shock(mouse,:,:) = NaN(bin_size,bin_size);
        end
        if sum(sum(PoincarrePlot_Safe(mouse,:,:)==0))==bin_size*bin_size
            PoincarrePlot_Safe(mouse,:,:) = NaN(bin_size,bin_size);
        end
        PoincarrePlot_Shock(mouse,:,:) = PoincarrePlot_Shock(mouse,:,:)./nansum(PoincarrePlot_Shock(mouse,:,:));
        PoincarrePlot_Shock(mouse,:,:) = squeeze(PoincarrePlot_Shock(mouse,:,:))';
        PoincarrePlot_Safe(mouse,:,:) = PoincarrePlot_Safe(mouse,:,:)./nansum(PoincarrePlot_Safe(mouse,:,:));
        PoincarrePlot_Safe(mouse,:,:) = squeeze(PoincarrePlot_Safe(mouse,:,:))';
    end
end
PoincarrePlot_Shock_all = squeeze(nanmean(PoincarrePlot_Shock));
PoincarrePlot_Safe_all = squeeze(nanmean(PoincarrePlot_Safe));


figure
subplot(121)
imagesc(linspace(.07,.18,bin_size) , linspace(.07,.18,bin_size) , PoincarrePlot_Shock_all)
axis xy
axis square
xlabel('RR-interval_n (s)')
ylabel('RR-interval_n+1 (s)')
title('Fz shock')

subplot(122)
imagesc(linspace(.07,.18,bin_size) , linspace(.07,.18,bin_size) , PoincarrePlot_Safe_all)
axis xy
axis square
xlabel('RR-interval_n (s)')
ylabel('RR-interval_n+1 (s)')
title('Fz safe')

figure
plot(RR_n_safe , RR_n1_safe , '.b')
hold on
plot(RR_n_shock , RR_n1_shock , '.r')
box off
axis square
xlabel('RR-interval_n (s)')
ylabel('RR-interval_n+1 (s)')
xlim([.07 .18]), ylim([.07 .18])
legend('Fz safe','Fz shock')



