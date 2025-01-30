

load()
Session_type = {'habituation','sleep_pre','Fear'};
l = linspace(6,8.5,11);
Params = Fear.Params; Params{8} = 'hpc_theta_delta';
Mouse = Fear.Mouse;

for mouse=1:length(Mouse)
    for sess=1:3
        try
            if sess==1
                DATA = Habituation;
                D = Data(DATA.OutPutData.(Session_type{sess}).accelero.tsd{mouse,1}); D(1)=1;
                NewMovAcctsd = tsd(Range(DATA.OutPutData.(Session_type{sess}).accelero.tsd{mouse,1}) , runmean_BM(log10(D),30));
            elseif sess==2
                DATA = Sleep;
                D = Data(DATA.OutPutData.(Session_type{sess}).accelero.tsd{mouse,2}); D(1)=1;
                NewMovAcctsd = tsd(Range(DATA.OutPutData.(Session_type{sess}).accelero.tsd{mouse,2}) , runmean_BM(log10(D),30));
            elseif sess==3
                DATA = Fear;
                D = Data(DATA.OutPutData.(Session_type{sess}).accelero.tsd{mouse,1}); D(1)=1;
                NewMovAcctsd = tsd(Range(DATA.OutPutData.(Session_type{sess}).accelero.tsd{mouse,1}) , runmean_BM(log10(D),30));
            end
            
            for thr=1:10
                FreezeEpoch1 = thresholdIntervals(NewMovAcctsd, l(thr+1) ,'Direction','Below');
                FreezeEpoch2 = thresholdIntervals(NewMovAcctsd, l(thr) ,'Direction','Above');
                FreezeEpoch{mouse,sess,thr} = and(FreezeEpoch1 , FreezeEpoch2);
                for param=1:8
                    MeanVal.(Session_type{sess}){thr}(param,mouse) = nanmean(Data(Restrict(DATA.OutPutData.(Session_type{sess}).(Params{param}).tsd{mouse,1} , FreezeEpoch{mouse,sess,thr})));
                end
            end
        end
    end
    disp(mouse)
end

for sess=1:3
    for thr=1:10
        MeanVal.(Session_type{sess}){thr}(MeanVal.(Session_type{sess}){thr}==0) = NaN;
        MeanVal_zscored.(Session_type{sess}){thr} = ((MeanVal.(Session_type{sess}){thr}-mu')./sigma')';
        for pc=1:size(eigen_vector,2)
            PC.(Session_type{sess}){thr}{pc} = eigen_vector(:,pc)'*MeanVal_zscored.(Session_type{sess}){thr}';
        end
    end
end


    
    
%%
figure
subplot(241)
plot(PC_values_shock{1} , PC_values_shock{2},'.','MarkerSize',10,'Color',[1 .5 .5])
hold on
plot(PC_values_safe{1} , PC_values_safe{2},'.','MarkerSize',10,'Color',[.5 .5 1])
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{1}(mouse)],[Bar_shock(2) PC_values_shock{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{1}(mouse)],[Bar_safe(2) PC_values_safe{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
end
plot(Bar_shock(1),Bar_shock(2),'.','MarkerSize',60,'Color',[1 .5 .5])
plot(Bar_safe(1),Bar_safe(2),'.','MarkerSize',60,'Color',[.5 .5 1])
xlim([-6 4]), ylim([-3 3.5])

subplot(245)
plot(PC_values_shock{3} , PC_values_shock{4},'.','MarkerSize',10,'Color',[1 .5 .5])
hold on
plot(PC_values_safe{3} , PC_values_safe{4},'.','MarkerSize',10,'Color',[.5 .5 1])
axis square
xlabel('PC3 value'), ylabel('PC4 value')
grid on
Bar_shock = [nanmedian(PC_values_shock{3}) nanmedian(PC_values_shock{4})];
Bar_safe = [nanmedian(PC_values_safe{3}) nanmedian(PC_values_safe{4})];
for mouse=1:length(PC_values_shock{1})
    line([Bar_shock(1) PC_values_shock{3}(mouse)],[Bar_shock(2) PC_values_shock{4}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe{3}(mouse)],[Bar_safe(2) PC_values_safe{4}(mouse)],'LineStyle','--','Color',[.5 .5 1])
end
plot(Bar_shock(1),Bar_shock(2),'.','MarkerSize',60,'Color',[1 .5 .5])
plot(Bar_safe(1),Bar_safe(2),'.','MarkerSize',60,'Color',[.5 .5 1])
xlim([-2 10]), ylim([-1 10])

for i=1:10
    Cols{i} = [1-i/10 .5 i/10];
    Legend{11-i} = ['mobility ' num2str(i)];
end
Legend{12} = 'Shock'; Legend{11} = 'Safe';


for sess=1:3
    for mouse=1:length(Mouse)
        for thr=1:10
            try, TotDur{sess,mouse}(thr) = sum(DurationEpoch(FreezeEpoch{mouse,sess,thr})); end
        end
    end
end
for sess=1:3
    for mouse=1:length(Mouse)
        for thr=1:10
            try
                Time_Prop_pre{sess,thr}(mouse) = sum(DurationEpoch(FreezeEpoch{mouse,sess,thr}))./nansum(TotDur{sess,mouse});
                Time_Prop(sess,thr) = nanmean(Time_Prop_pre{sess,thr});
            end
        end
    end
end


Session_type = {'habituation','sleep_pre','Fear'};
for sess=1:3
    subplot(2,4,sess+1)
    Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2})];
    Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2})];
    plot(Bar_shock(1),Bar_shock(2),'.','MarkerSize',60,'Color',[1 .5 .5]), hold on
    plot(Bar_safe(1),Bar_safe(2),'.','MarkerSize',60,'Color',[.5 .5 1])
    for thr=1:10
        Bar = [nanmedian(PC.(Session_type{sess}){thr}{1}) nanmedian(PC.(Session_type{sess}){thr}{2})];
        scatter(Bar(1),Bar(2),'filled','SizeData',sqrt(500*(Time_Prop(sess,thr)+2e-3))*30,'CData',Cols{thr}); alpha(.7), hold on
    end
    xlim([-6 4]), ylim([-3 3.5])
    
    subplot(2,4,sess+5)
    Bar_shock = [nanmedian(PC_values_shock{3}) nanmedian(PC_values_shock{4})];
    Bar_safe = [nanmedian(PC_values_safe{3}) nanmedian(PC_values_safe{4})];
    plot(Bar_shock(1),Bar_shock(2),'.','MarkerSize',60,'Color',[1 .5 .5]), hold on
    plot(Bar_safe(1),Bar_safe(2),'.','MarkerSize',60,'Color',[.5 .5 1])
    for thr=1:10
        Bar = [nanmedian(PC.(Session_type{sess}){thr}{3}) nanmedian(PC.(Session_type{sess}){thr}{4})];
        scatter(Bar(1),Bar(2),'filled','SizeData',sqrt(500*(Time_Prop(sess,thr)+2e-3))*30,'CData',Cols{thr}); alpha(.7), hold on
    end
    xlim([-2 10]), ylim([-1 10])
end

f=get(gca,'Children'); legend([f],Legend);
