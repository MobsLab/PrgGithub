
Session_type={'Cond','Ext','Fear'};
State1={'Expe','Fz'};
State2={'Fz','ShockFz','SafeFz'};
Mouse=[688,739,777,849,1251,1253,1254];
for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'accelero','ripples');
end


for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
 
        bin_size = 100;
        
        for state=1:length(State1)
            if state==1
                R1 = Range(OutPutData.(Session_type{sess}).accelero.tsd{mouse,1}); % evolution along experience
            else
                R1 = Range(OutPutData.(Session_type{sess}).accelero.tsd{mouse,3}); % evolution along freezing
            end
            
            for st = 1:length(State2)
                if st==1 % Freezing
                    R2 = Range(OutPutData.(Session_type{sess}).ripples.ts{mouse,3});
                    R3 = Range(OutPutData.(Session_type{sess}).accelero.tsd{mouse,3});
                elseif st==2 % Shock Freezing
                    R2 = Range(OutPutData.(Session_type{sess}).ripples.ts{mouse,5});
                    R3 = Range(OutPutData.(Session_type{sess}).accelero.tsd{mouse,5});
                else % Safe freezing
                    R2 = Range(OutPutData.(Session_type{sess}).ripples.ts{mouse,6});
                    R3 = Range(OutPutData.(Session_type{sess}).accelero.tsd{mouse,6});
                end
                
                % State evolution
                if state==1
                    State_Evolution.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st}) = R3/max(R1);
                    try
                        State_Evolution_Norm.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st}) = interp1(linspace(0,1,length(State_Evolution.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st}))) , State_Evolution.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st}) , linspace(0,1,100));
                    catch
                        State_Evolution_Norm.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st}) = NaN(1,100);
                    end
                    State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{st})(mouse,:) = State_Evolution_Norm.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st});
                else
                    [tf,idx] = ismember(R3 , R1);
                    State_Evolution_Pre.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st})(:,1) = R1;
                    if sum(idx)==0
                        State_Evolution_Pre.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st})([1:2],2) = NaN;
                    else
                        State_Evolution_Pre.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st})(idx(idx~=0),2) = 1;
                    end
                    State_Evolution.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st}) = cumsum(State_Evolution_Pre.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st})(:,2))/sum(State_Evolution_Pre.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st})(:,2));
                    
                    State_Evolution_Norm.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st}) = interp1(linspace(0,1,length(State_Evolution.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st}))) , State_Evolution.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st}) , linspace(0,1,100));
                    State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{st})(mouse,:) = State_Evolution_Norm.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st});
                end
                
                % Ripples
                for rip=1:length(R2)
                    [~,b] = find(R1<R2(rip));
                    Ripples_Evolution.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st})(rip) = length(b)/length(R1);
                    clear b
                end
                
                try
                    Ripples_Evolution_Norm.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st}) = interp1(linspace(0,1,length(Ripples_Evolution.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st}))) , Ripples_Evolution.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st}) , linspace(0,1,100));
                catch
                    Ripples_Evolution_Norm.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st}) = NaN(1,100);
                end
                Ripples_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{st})(mouse,:) = Ripples_Evolution_Norm.(Session_type{sess}).(Mouse_names{mouse}).(State1{state}).(State2{st});
                
            end
            clear R1 R2 R3
        end
    end
end
Ripples_Evolution_Norm.Cond.ShockFz(2,:) = NaN;


% plot first states evolution along expe 
figure; state=1;
for sess=1:length(Session_type)
    
    subplot(2,3,sess)
    
    Conf_Inter=nanstd(State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{1}))/sqrt(size(State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{1}),1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{1}));
    shadedErrorBar( Mean_All_Sp , [0.01:0.01:1], Conf_Inter,'-k',1); hold on;
    Conf_Inter=nanstd(State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{2}))/sqrt(size(State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{2}),1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{2}));
    shadedErrorBar( Mean_All_Sp , [0.01:0.01:1], Conf_Inter,'-r',1); hold on;
    Conf_Inter=nanstd(State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{3}))/sqrt(size(State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{3}),1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{3}));
    shadedErrorBar( Mean_All_Sp , [0.01:0.01:1], Conf_Inter,'-b',1); hold on;
    
    plot([0 1] , [0 1],'--r');
    xlim([0 1]); ylim([0 1]);
    makepretty
    title(Session_type{sess});
    if sess==1; ylabel('state proportion'); f=get(gca,'Children'); legend([f(10),f(6),f(2)],'Fz','Shock Fz','Safe Fz'); end
    
end

% than along freezing during expe
state=2;
for sess=1:length(Session_type)
       
    subplot(2,3,sess+3)
    
    Conf_Inter=nanstd(State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{2}))/sqrt(size(State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{2}),1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{2}));
    shadedErrorBar([0.01:0.01:1], Mean_All_Sp ,  Conf_Inter,'-r',1); hold on;
    Conf_Inter=nanstd(State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{3}))/sqrt(size(State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{3}),1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(State_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{3}));
    shadedErrorBar([0.01:0.01:1], Mean_All_Sp ,  Conf_Inter,'-b',1); hold on;
    
    plot([0 1] , [0 1],'--r');
    xlim([0 1]); ylim([0 1]);
    makepretty
    if sess==1; ylabel('state proportion'); f=get(gca,'Children'); legend([f(6),f(2)],'Fz','Shock Fz','Safe Fz'); end
    xlabel('normalized time');
    
end
a=suptitle('State cumulated analysis'); a.FontSize=20;



% plot first ripples evolution along expe than along freezing during expe
figure
for state=1:length(State1)
    for sess=1:length(Session_type)
        
        subplot(2,3,sess+(state-1)*3)
        
        Conf_Inter=nanstd(Ripples_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{1}))/sqrt(size(Ripples_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{1}),1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Ripples_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{1}));
        shadedErrorBar( Mean_All_Sp , [0.01:0.01:1], Conf_Inter,'-k',1); hold on;
        Conf_Inter=nanstd(Ripples_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{2}))/sqrt(size(Ripples_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{2}),1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Ripples_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{2}));
        shadedErrorBar( Mean_All_Sp , [0.01:0.01:1], Conf_Inter,'-r',1); hold on;
        Conf_Inter=nanstd(Ripples_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{2}))/sqrt(size(Ripples_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{3}),1));
        clear Mean_All_Sp; Mean_All_Sp=nanmean(Ripples_Evolution_Norm.(Session_type{sess}).(State1{state}).(State2{3}));
        shadedErrorBar( Mean_All_Sp , [0.01:0.01:1], Conf_Inter,'-b',1); hold on;
        
        plot([0 1] , [0 1],'--r');
        xlim([0 1]); ylim([0 1]);
        makepretty
        title(Session_type{sess});
        if sess==1; ylabel('ripples proportion'); f=get(gca,'Children'); legend([f(10),f(6),f(2)],'Fz','Shock Fz','Safe Fz'); end
        xlabel('normalized time');
        
    end
end
a=suptitle('Ripples cumulated analysis'); a.FontSize=20;

