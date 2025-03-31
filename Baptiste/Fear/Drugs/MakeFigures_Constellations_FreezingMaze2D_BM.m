%% OB/HR
figure
% Saline Freezing_shock
subplot(221); group=5;
plot(X_Freezing_shock,Y_Freezing_shock,'.r','MarkerSize',40); plot(X_Freezing_shock_ext,Y_Freezing_shock_ext,'.m','MarkerSize',40); plot(X_Freezing_safe,Y_Freezing_safe,'.b','MarkerSize',40)
for sess=1:length(Session_type)-1
    
    a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , [1 .5 .5]);
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{6}){group})] , [nanmean(HR.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(HR.Freezing_shock.Figure.(Session_type{6}){group})] , 'Color' , [1 .5 .5]);

% DZP Freezing_shock
group=6;
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_shock.Figure.(Session_type{sess+1}){group})], 'LineStyle', '--' , 'Color' , 'm');
    else
        a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , 'm');
    end
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
makepretty; xlim([3 5.5]); ylim([9 12.5])
ylabel('HR frequency (Hz)'); title('Freezing_shock');

% Saline Freezing_safe
subplot(222); group=5;
plot(X_Freezing_shock,Y_Freezing_shock,'.r','MarkerSize',40); plot(X_Freezing_shock_ext,Y_Freezing_shock_ext,'.m','MarkerSize',40); plot(X_Freezing_safe,Y_Freezing_safe,'.b','MarkerSize',40)
for sess=1:length(Session_type)-1
    
    a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , [.5 .5 1]);
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end

% DZP Freezing_safe
group=6;
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_safe.Figure.(Session_type{sess+1}){group})], 'LineStyle', '--' , 'Color' , 'c');
    else
        a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , 'c');
    end
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{5}){6}) nanmean(Respi.Freezing_safe.Figure.(Session_type{7}){6})] , [nanmean(HR.Freezing_safe.Figure.(Session_type{5}){6}) nanmean(HR.Freezing_safe.Figure.(Session_type{7}){6})] , 'Color' ,'c');
makepretty; xlim([3 5.5]); ylim([9 12.5])
title('Freezing_safe')

%% OB/Ripples
subplot(223); group=5;
plot(X_Freezing_shock,Y2_Freezing_shock,'.r','MarkerSize',40); plot(X_Freezing_shock_ext,Y2_Freezing_shock_ext,'.m','MarkerSize',40); plot(X_Freezing_safe,Y2_Freezing_safe,'.b','MarkerSize',40)
for sess=1:length(Session_type)-1
    
    a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , [1 .5 .5]);
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{6}){group})] , [nanmean(Ripples.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Ripples.Freezing_shock.Figure.(Session_type{6}){group})] , 'Color' , [1 .5 .5]);
a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{1}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{3}){group})] , [nanmean(Ripples.Freezing_shock.Figure.(Session_type{1}){group}) nanmean(Ripples.Freezing_shock.Figure.(Session_type{3}){group})] , 'Color' , [1 .5 .5]);

% DZP Freezing_shock
group=6;
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess+1}){group})], 'LineStyle', '--' , 'Color' , 'm');
    else
        a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , 'm');
    end
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{1}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{3}){group})] , [nanmean(Ripples.Freezing_shock.Figure.(Session_type{1}){group}) nanmean(Ripples.Freezing_shock.Figure.(Session_type{3}){group})], 'LineStyle', '--' , 'Color' , 'm');
a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{6}){group})] , [nanmean(Ripples.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Ripples.Freezing_shock.Figure.(Session_type{6}){group})] , 'Color' , 'm');
makepretty; xlim([3 5.5]); ylim([0 1])
ylabel('Density (#/s)'); xlabel('OB frequency (Hz)')

% Saline Freezing_safe
subplot(224); group=5;
plot(X_Freezing_shock,Y2_Freezing_shock,'.r','MarkerSize',40); plot(X_Freezing_shock_ext,Y2_Freezing_shock_ext,'.m','MarkerSize',40); plot(X_Freezing_safe,Y2_Freezing_safe,'.b','MarkerSize',40)
for sess=1:length(Session_type)-1
    
    a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , [.5 .5 1]);
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end

% DZP Freezing_safe
group=6;
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess+1}){group})], 'LineStyle', '--' , 'Color' , 'c');
    else
        a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , 'c');
    end
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
makepretty
xlabel('OB frequency (Hz)')
a=suptitle('2D analysis, Freezing, Drugs UMaze'); a.FontSize=20;

%% OB/Gamma_Bulb_Freq
figure
subplot(221); group=5;
for sess=1:length(Session_type)-1
    
    a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , [1 .5 .5]);
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{6}){group})] , [nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{6}){group})] , 'Color' , [1 .5 .5]);

% DZP Freezing_shock
group=6;
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{sess+1}){group})], 'LineStyle', '--' , 'Color' , 'm');
    else
        a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , 'm');
    end
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
makepretty; xlim([3 5.5]); ylim([55 75])
ylabel('OB Gamma frequency (Hz)'); title('Freezing_shock')

% Saline Freezing_safe
subplot(222); group=5;
for sess=1:length(Session_type)-1
    
    a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , [.5 .5 1]);
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end

% DZP Freezing_safe
group=6;
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{sess+1}){group})], 'LineStyle', '--' , 'Color' , 'c');
    else
        a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , 'c');
    end
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{5}){6}) nanmean(Respi.Freezing_safe.Figure.(Session_type{7}){6})] , [nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{5}){6}) nanmean(Gamma_Bulb_Freq.Freezing_safe.Figure.(Session_type{7}){6})] , 'Color' ,'c');
makepretty; ylim([55 75])
title('Freezing_safe')

%% OB/Gamma_Bulb_Power
subplot(223); group=5;
for sess=1:length(Session_type)-1
    
    a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , [1 .5 .5]);
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{6}){group})] , [nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{6}){group})] , 'Color' , [1 .5 .5]);

% DZP Freezing_shock
group=6;
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{sess+1}){group})], 'LineStyle', '--' , 'Color' , 'm');
    else
        a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , 'm');
    end
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Power.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
makepretty; xlim([3 5.5]); ylim([3.4 4])
ylabel('OB gamma power (a.u.)'); xlabel('OB frequency (Hz)')

% Saline Freezing_safe
subplot(224); group=5;
for sess=1:length(Session_type)-1
    
    a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , [.5 .5 1]);
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end

% DZP Freezing_safe
group=6;
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{sess+1}){group})], 'LineStyle', '--' , 'Color' , 'c');
    else
        a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , 'c');
    end
    hold on
    if sess==1;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{5}){6}) nanmean(Respi.Freezing_safe.Figure.(Session_type{7}){6})] , [nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{5}){6}) nanmean(Gamma_Bulb_Power.Freezing_safe.Figure.(Session_type{7}){6})] , 'Color' ,'c');
makepretty;  ylim([3.4 4])
xlabel('OB frequency (Hz)')

a=suptitle('2D analysis, Freezing, Drugs UMaze'); a.FontSize=20;

%% Figures group by group
% 
% figure
% subplot(131); group=8;
% for sess=1:length(Session_type)-1
%     
%     a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , [1 0.5 0.5]);
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
%     
%     a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , [0.5 0.5 1]);
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
%     
%     makepretty
% end
% xlabel('OB frequency (Hz)'); ylabel('HR (Hz)')
% %f=get(gca,'Children'); legend([f(8),f(4)],'Freezing_shock side freezing','Freezing_safe side freezing');
% 
% 
% subplot(132); 
% for sess=1:length(Session_type)-1
%     
%     a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , [1 0.5 0.5]);
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
%     
%     a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , [0.5 0.5 1]);
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
%     
%     makepretty
% end
% xlabel('OB frequency (Hz)'); ylabel('Rip density (#/s)')
% 
% subplot(133); 
% for sess=1:length(Session_type)-1
%     
%     a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , [1 0.5 0.5]);
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
%     
%     a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , [0.5 0.5 1]);
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
%     
%     makepretty
%     
% end
% xlabel('OB frequency (Hz)'); ylabel('Gamma (a.u)')
% 
% a=suptitle(Drug_Group{group}); a.FontSize=20;
% 

%% Gathering Gamma in one variable

% GetEmbReactMiceFolderList_BM
% 
% Session_type={'RealTimeSess1','RealTimeSess2','RealTimeSess3','RealTimeSess4','RealTimeSess5','RealTimeSess6','RealTimeSess7'};
% Mouse2 = Mouse([1:59 61 63:65]); clear Mouse; Mouse=Mouse2;
% 
% for sess=1:length(Session_type) % generate all data required for analyses
%     [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'heartrate','respi_freq_BM','wake_ripples','ob_high');
% end
% 

%
% for mouse=1:length(Mouse)
%     Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
%     for sess=1:length(Session_type)
%         % Respi
%         Respi.Freezing_shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).respi_freq_BM.mean(mouse,5);
%         Respi.Freezing_safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).respi_freq_BM.mean(mouse,6);
%         % HR
%         try
%             HR.Freezing_shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).heartrate.mean(mouse,5);
%             HR.Freezing_safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).heartrate.mean(mouse,6);
%         end
%         % Ripples
%         Ripples.Freezing_shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).wake_ripples.mean(mouse,5);
%         Ripples.Freezing_safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).wake_ripples.mean(mouse,6);
%         % Gamma
%         clear Zscored_Power_Freezing_shock Zscored_Power_Freezing_safe Zscored_Freq_Freezing_shock Zscored_Freq_Freezing_safe
%         if TSD_DATA.(Session_type{sess}).ob_high.max_freq(mouse,5)==41.503906250096730;
%             TSD_DATA.(Session_type{sess}).ob_high.max_freq(mouse,5)=NaN;
%         elseif TSD_DATA.(Session_type{sess}).ob_high.max_freq(mouse,6)==41.503906250096730;
%             TSD_DATA.(Session_type{sess}).ob_high.max_freq(mouse,6)=NaN;
%         end
%         Zscored_Power_Freezing_shock = sum([TSD_DATA.(Session_type{sess}).ob_high.power(mouse,5) -nanmean(TSD_DATA.(Session_type{sess}).ob_high.power(:,3))])/nanstd(TSD_DATA.(Session_type{sess}).ob_high.power(:,3));
%         Zscored_Power_Freezing_safe = sum([TSD_DATA.(Session_type{sess}).ob_high.power(mouse,6) -nanmean(TSD_DATA.(Session_type{sess}).ob_high.power(:,3))])/nanstd(TSD_DATA.(Session_type{sess}).ob_high.power(:,3));
%         Zscored_Freq_Freezing_shock = sum([TSD_DATA.(Session_type{sess}).ob_high.max_freq(mouse,5) -nanmean(TSD_DATA.(Session_type{sess}).ob_high.max_freq(:,3))])/nanstd(TSD_DATA.(Session_type{sess}).ob_high.max_freq(:,3));
%         Zscored_Freq_Freezing_safe = sum([TSD_DATA.(Session_type{sess}).ob_high.max_freq(mouse,6) -nanmean(TSD_DATA.(Session_type{sess}).ob_high.max_freq(:,3))])/nanstd(TSD_DATA.(Session_type{sess}).ob_high.max_freq(:,3));
%         
%         Gamma_Bulb.Freezing_shock.(Session_type{sess}).(Mouse_names{mouse}) = sum([Zscored_Power_Freezing_shock Zscored_Freq_Freezing_shock]);
%         Gamma_Bulb.Freezing_safe.(Session_type{sess}).(Mouse_names{mouse}) = sum([Zscored_Power_Freezing_safe Zscored_Freq_Freezing_safe]);
%     end
%     Mouse_names{mouse}
% end
% 
% Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};
% for group=1:length(Drug_Group)
%     
%     Drugs_Groups_UMaze_BM
%     
%     for sess=1:length(Session_type) % generate all data required for analyses
%         for mouse=1:length(Mouse)
%             Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
%             
%             Respi.Freezing_shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Respi.Freezing_shock.(Session_type{sess}).(Mouse_names{mouse});
%             Respi.Freezing_safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Respi.Freezing_safe.(Session_type{sess}).(Mouse_names{mouse});
%             try
%                 HR.Freezing_shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = HR.Freezing_shock.(Session_type{sess}).(Mouse_names{mouse});
%                 HR.Freezing_safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = HR.Freezing_safe.(Session_type{sess}).(Mouse_names{mouse});
%             end
%             Ripples.Freezing_shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.Freezing_shock.(Session_type{sess}).(Mouse_names{mouse});
%             Ripples.Freezing_safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.Freezing_safe.(Session_type{sess}).(Mouse_names{mouse});
%             
%             Gamma_Bulb.Freezing_shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Gamma_Bulb.Freezing_shock.(Session_type{sess}).(Mouse_names{mouse});
%             Gamma_Bulb.Freezing_safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Gamma_Bulb.Freezing_safe.(Session_type{sess}).(Mouse_names{mouse});
%         end
%     end
% end
% 
% for sess=1:length(Session_type)
%     for group=1:length(Drug_Group)
%         Respi.Freezing_shock.Figure.(Session_type{sess}){group} = Respi.Freezing_shock.(Drug_Group{group}).(Session_type{sess});
%         Respi.Freezing_safe.Figure.(Session_type{sess}){group} = Respi.Freezing_safe.(Drug_Group{group}).(Session_type{sess});
%         
%         HR.Freezing_shock.Figure.(Session_type{sess}){group} = HR.Freezing_shock.(Drug_Group{group}).(Session_type{sess});
%         HR.Freezing_safe.Figure.(Session_type{sess}){group} = HR.Freezing_safe.(Drug_Group{group}).(Session_type{sess});
%         HR.Freezing_shock.Figure.(Session_type{sess}){group}(HR.Freezing_shock.Figure.(Session_type{sess}){group}==0)=NaN;
%         HR.Freezing_safe.Figure.(Session_type{sess}){group}(HR.Freezing_safe.Figure.(Session_type{sess}){group}==0)=NaN;
%         
%         Ripples.Freezing_shock.Figure.(Session_type{sess}){group} = Ripples.Freezing_shock.(Drug_Group{group}).(Session_type{sess});
%         Ripples.Freezing_safe.Figure.(Session_type{sess}){group} = Ripples.Freezing_safe.(Drug_Group{group}).(Session_type{sess});
%         Ripples.Freezing_shock.Figure.(Session_type{sess}){group}(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}==0)=NaN;
%         Ripples.Freezing_safe.Figure.(Session_type{sess}){group}(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}==0)=NaN;
%         
%         Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group} = Gamma_Bulb.Freezing_shock.(Drug_Group{group}).(Session_type{sess});
%         Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group} = Gamma_Bulb.Freezing_safe.(Drug_Group{group}).(Session_type{sess});
%         Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}==0)=NaN;
%         Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}==0)=NaN;
%     end
% end
% Respi.Freezing_shock.Figure.Ext{6}(4) = NaN; Respi.Freezing_safe.Figure.Ext{6}(4) = NaN; 
% 


%% Figures with Gamma in one variable

% figure
% %% OB/HR
% % Saline Freezing_shock
% subplot(231); group=5;
% for sess=1:length(Session_type)-1
%     
%     a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , [1 .5 .5]);
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
% end
% a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{6}){group})] , [nanmean(HR.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(HR.Freezing_shock.Figure.(Session_type{6}){group})] , 'Color' , [1 .5 .5]);
% 
% % DZP Freezing_shock
% group=6;
% for sess=1:length(Session_type)-1
%     
%     if sess<5
%         a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_shock.Figure.(Session_type{sess+1}){group})], 'LineStyle', '--' , 'Color' , 'm');
%     else
%         a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , 'm');
%     end
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
% end
% makepretty; xlim([3 5.5]); ylim([9 12.5])
% ylabel('Frequency (Hz)'); title('HR = f(OBfreq)');
% 
% % Saline Freezing_safe
% subplot(234); group=5;
% for sess=1:length(Session_type)-1
%     
%     a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , [.5 .5 1]);
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
% end
% 
% % DZP Freezing_safe
% group=6;
% for sess=1:length(Session_type)-1
%     
%     if sess<5
%         a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_safe.Figure.(Session_type{sess+1}){group})], 'LineStyle', '--' , 'Color' , 'c');
%     else
%         a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(HR.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , 'c');
%     end
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(HR.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
% end
% a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{5}){6}) nanmean(Respi.Freezing_safe.Figure.(Session_type{7}){6})] , [nanmean(HR.Freezing_safe.Figure.(Session_type{5}){6}) nanmean(HR.Freezing_safe.Figure.(Session_type{7}){6})] , 'Color' ,'c');
% makepretty; xlim([3 5.5]); ylim([9 12.5])
% ylabel('Frequency (Hz)'); xlabel('Frequency (Hz)')
% 
% 
% %% OB/Ripples
% subplot(232); group=5;
% for sess=3:length(Session_type)-1
%     
%     a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , [1 .5 .5]);
%     hold on
%     if sess==3;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
% end
% a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{6}){group})] , [nanmean(Ripples.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Ripples.Freezing_shock.Figure.(Session_type{6}){group})] , 'Color' , [1 .5 .5]);
% 
% % DZP Freezing_shock
% group=6;
% for sess=1:length(Session_type)-1
%     
%     if sess<5
%         a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess+1}){group})], 'LineStyle', '--' , 'Color' , 'm');
%     else
%         a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , 'm');
%     end
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
% end
% a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{1}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{3}){group})] , [nanmean(Ripples.Freezing_shock.Figure.(Session_type{1}){group}) nanmean(Ripples.Freezing_shock.Figure.(Session_type{3}){group})], 'LineStyle', '--' , 'Color' , 'm');
% a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{6}){group})] , [nanmean(Ripples.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Ripples.Freezing_shock.Figure.(Session_type{6}){group})] , 'Color' , 'm');
% makepretty; xlim([3 5.5]); ylim([0 1])
% ylabel('Density (#/s)'); title('Ripples density = f(OBfreq)')
% 
% % Saline Freezing_safe
% subplot(235); group=5;
% for sess=1:length(Session_type)-1
%     
%     a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , [.5 .5 1]);
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
% end
% 
% % DZP Freezing_safe
% group=6;
% for sess=1:length(Session_type)-1
%     
%     if sess<5
%         a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess+1}){group})], 'LineStyle', '--' , 'Color' , 'c');
%     else
%         a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , 'c');
%     end
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Ripples.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
% end
% makepretty
% ylabel('Density (#/s)');  xlabel('Frequency (Hz)')
% 
% 
% %% OB/Gamma_Bulb
% subplot(233); group=5;
% for sess=1:length(Session_type)-1
%     
%     a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , [1 .5 .5]);
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
% end
% a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{6}){group})] , [nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{4}){group}) nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{6}){group})] , 'Color' , [1 .5 .5]);
% 
% % DZP Freezing_shock
% group=6;
% for sess=1:length(Session_type)-1
%     
%     if sess<5
%         a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess+1}){group})], 'LineStyle', '--' , 'Color' , 'm');
%     else
%         a=line([nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess+1}){group})] , 'Color' , 'm');
%     end
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_shock.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_shock.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
% end
% makepretty; xlim([3 5.5]); ylim([-1 2])
% ylabel('(a.u.)'); title('Gamma_Bulb = f(OBfreq)')
% 
% % Saline Freezing_safe
% subplot(236); group=5;
% for sess=1:length(Session_type)-1
%     
%     a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , [.5 .5 1]);
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
% end
% 
% % DZP Freezing_safe
% group=6;
% for sess=1:length(Session_type)-1
%     
%     if sess<5
%         a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess+1}){group})], 'LineStyle', '--' , 'Color' , 'c');
%     else
%         a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group})] , [nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess+1}){group})] , 'Color' , 'c');
%     end
%     hold on
%     if sess==1;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
%     elseif sess==6;
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess+1}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess+1}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
%     else
%         plot(nanmean(Respi.Freezing_safe.Figure.(Session_type{sess}){group}) , nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{sess}){group}) , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
%     end
% end
% a=line([nanmean(Respi.Freezing_safe.Figure.(Session_type{5}){6}) nanmean(Respi.Freezing_safe.Figure.(Session_type{7}){6})] , [nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{5}){6}) nanmean(Gamma_Bulb.Freezing_safe.Figure.(Session_type{7}){6})] , 'Color' ,'c');
% makepretty
% ylabel('(a.u.)');  xlabel('Frequency (Hz)')
% 
% 

