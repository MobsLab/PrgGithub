
%% OB/HR
figure
% Saline Shock
subplot(221); group=5;
for sess=1:length(Session_type)-1

    a=line([Respi.Shock.Figure.(Session_type{sess}){group} Respi.Shock.Figure.(Session_type{sess+1}){group}] , [HR.Shock.Figure.(Session_type{sess}){group} HR.Shock.Figure.(Session_type{sess+1}){group}] , 'Color' , [1 .5 .5]);
    hold on
    if sess==1;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , HR.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , HR.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Shock.Figure.(Session_type{sess+1}){group} , HR.Shock.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , HR.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([Respi.Shock.Figure.(Session_type{4}){group} Respi.Shock.Figure.(Session_type{6}){group}] , [HR.Shock.Figure.(Session_type{4}){group} HR.Shock.Figure.(Session_type{6}){group}] , 'Color' , [1 .5 .5]);
makepretty; xlim([2 7]); ylim([8 13])

% DZP Shock
group=6; subplot(223);
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([Respi.Shock.Figure.(Session_type{sess}){group} Respi.Shock.Figure.(Session_type{sess+1}){group}] , [HR.Shock.Figure.(Session_type{sess}){group} HR.Shock.Figure.(Session_type{sess+1}){group}], 'LineStyle', '--' , 'Color' , 'm');
    else
        a=line([Respi.Shock.Figure.(Session_type{sess}){group} Respi.Shock.Figure.(Session_type{sess+1}){group}] , [HR.Shock.Figure.(Session_type{sess}){group} HR.Shock.Figure.(Session_type{sess+1}){group}] , 'Color' , 'm');
    end
    hold on
    if sess==1;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , HR.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , HR.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Shock.Figure.(Session_type{sess+1}){group} , HR.Shock.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , HR.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
makepretty; xlim([2 7]); ylim([8 13])
ylabel('HR frequency (Hz)'); title('Shock');

% Saline Safe
subplot(222); group=5;
for sess=1:length(Session_type)-1
    
    a=line([Respi.Safe.Figure.(Session_type{sess}){group} Respi.Safe.Figure.(Session_type{sess+1}){group}] , [HR.Safe.Figure.(Session_type{sess}){group} HR.Safe.Figure.(Session_type{sess+1}){group}] , 'Color' , [.5 .5 1]);
    hold on
    if sess==1;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , HR.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , HR.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Safe.Figure.(Session_type{sess+1}){group} , HR.Safe.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , HR.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
makepretty; xlim([2 7]); ylim([8 13])
ylabel('HR frequency (Hz)'); title('Shock');

% DZP Safe
group=6; subplot(224)
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([Respi.Safe.Figure.(Session_type{sess}){group} Respi.Safe.Figure.(Session_type{sess+1}){group}] , [HR.Safe.Figure.(Session_type{sess}){group} HR.Safe.Figure.(Session_type{sess+1}){group}], 'LineStyle', '--' , 'Color' , 'c');
    else
        a=line([Respi.Safe.Figure.(Session_type{sess}){group} Respi.Safe.Figure.(Session_type{sess+1}){group}] , [HR.Safe.Figure.(Session_type{sess}){group} HR.Safe.Figure.(Session_type{sess+1}){group}] , 'Color' , 'c');
    end
    hold on
    if sess==1;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , HR.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , HR.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Safe.Figure.(Session_type{sess+1}){group} , HR.Safe.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , HR.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([Respi.Safe.Figure.(Session_type{5}){6} Respi.Safe.Figure.(Session_type{7}){6}] , [HR.Safe.Figure.(Session_type{5}){6} HR.Safe.Figure.(Session_type{7}){6}] , 'Color' ,'c');
makepretty; xlim([2 7]); ylim([8 13])

%% OB/Ripples
figure
subplot(221); group=5;
for sess=1:length(Session_type)-1
    
    a=line([Respi.Shock.Figure.(Session_type{sess}){group} Respi.Shock.Figure.(Session_type{sess+1}){group}] , [Ripples.Shock.Figure.(Session_type{sess}){group} Ripples.Shock.Figure.(Session_type{sess+1}){group}] , 'Color' , [1 .5 .5]);
    hold on
    if sess==3;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , Ripples.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , Ripples.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Shock.Figure.(Session_type{sess+1}){group} , Ripples.Shock.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , Ripples.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([Respi.Shock.Figure.(Session_type{4}){group} Respi.Shock.Figure.(Session_type{6}){group}] , [Ripples.Shock.Figure.(Session_type{4}){group} Ripples.Shock.Figure.(Session_type{6}){group}] , 'Color' , [1 .5 .5]);
makepretty; xlim([2 7]); ylim([0 1])

% DZP Shock
subplot(223)
group=6;
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([Respi.Shock.Figure.(Session_type{sess}){group} Respi.Shock.Figure.(Session_type{sess+1}){group}] , [Ripples.Shock.Figure.(Session_type{sess}){group} Ripples.Shock.Figure.(Session_type{sess+1}){group}], 'LineStyle', '--' , 'Color' , 'm');
    else
        a=line([Respi.Shock.Figure.(Session_type{sess}){group} Respi.Shock.Figure.(Session_type{sess+1}){group}] , [Ripples.Shock.Figure.(Session_type{sess}){group} Ripples.Shock.Figure.(Session_type{sess+1}){group}] , 'Color' , 'm');
    end
    hold on
    if sess==1;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , Ripples.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , Ripples.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Shock.Figure.(Session_type{sess+1}){group} , Ripples.Shock.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , Ripples.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([Respi.Shock.Figure.(Session_type{1}){group} Respi.Shock.Figure.(Session_type{3}){group}] , [Ripples.Shock.Figure.(Session_type{1}){group} Ripples.Shock.Figure.(Session_type{3}){group}], 'LineStyle', '--' , 'Color' , 'm');
a=line([Respi.Shock.Figure.(Session_type{4}){group} Respi.Shock.Figure.(Session_type{6}){group}] , [Ripples.Shock.Figure.(Session_type{4}){group} Ripples.Shock.Figure.(Session_type{6}){group}] , 'Color' , 'm');
makepretty; xlim([2 7]); ylim([0 .5])
ylabel('Density (#/s)'); xlabel('OB frequency (Hz)')

% Saline Safe
subplot(222); group=5;
for sess=1:length(Session_type)-1
    
    a=line([Respi.Safe.Figure.(Session_type{sess}){group} Respi.Safe.Figure.(Session_type{sess+1}){group}] , [Ripples.Safe.Figure.(Session_type{sess}){group} Ripples.Safe.Figure.(Session_type{sess+1}){group}] , 'Color' , [.5 .5 1]);
    hold on
    if sess==1;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , Ripples.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , Ripples.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Safe.Figure.(Session_type{sess+1}){group} , Ripples.Safe.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , Ripples.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
makepretty; xlim([2 7]); ylim([0 1])

% DZP Safe
group=6; subplot(224)
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([Respi.Safe.Figure.(Session_type{sess}){group} Respi.Safe.Figure.(Session_type{sess+1}){group}] , [Ripples.Safe.Figure.(Session_type{sess}){group} Ripples.Safe.Figure.(Session_type{sess+1}){group}], 'LineStyle', '--' , 'Color' , 'c');
    else
        a=line([Respi.Safe.Figure.(Session_type{sess}){group} Respi.Safe.Figure.(Session_type{sess+1}){group}] , [Ripples.Safe.Figure.(Session_type{sess}){group} Ripples.Safe.Figure.(Session_type{sess+1}){group}] , 'Color' , 'c');
    end
    hold on
    if sess==1;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , Ripples.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , Ripples.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Safe.Figure.(Session_type{sess+1}){group} , Ripples.Safe.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , Ripples.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
makepretty; xlim([2 7]); ylim([0 1])
xlabel('OB frequency (Hz)')



%%

%% OB/HR
figure
% Saline Shock
subplot(221); group=7;
for sess=1:length(Session_type)-1

    a=line([Respi.Shock.Figure.(Session_type{sess}){group} Respi.Shock.Figure.(Session_type{sess+1}){group}] , [HR.Shock.Figure.(Session_type{sess}){group} HR.Shock.Figure.(Session_type{sess+1}){group}] , 'Color' , [1 .5 .5]);
    hold on
    if sess==1;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , HR.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , HR.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Shock.Figure.(Session_type{sess+1}){group} , HR.Shock.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , HR.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([Respi.Shock.Figure.(Session_type{4}){group} Respi.Shock.Figure.(Session_type{6}){group}] , [HR.Shock.Figure.(Session_type{4}){group} HR.Shock.Figure.(Session_type{6}){group}] , 'Color' , [1 .5 .5]);
makepretty; xlim([2 7]); ylim([8 13])

% DZP Shock
group=8; subplot(223);
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([Respi.Shock.Figure.(Session_type{sess}){group} Respi.Shock.Figure.(Session_type{sess+1}){group}] , [HR.Shock.Figure.(Session_type{sess}){group} HR.Shock.Figure.(Session_type{sess+1}){group}], 'LineStyle', '--' , 'Color' , 'm');
    else
        a=line([Respi.Shock.Figure.(Session_type{sess}){group} Respi.Shock.Figure.(Session_type{sess+1}){group}] , [HR.Shock.Figure.(Session_type{sess}){group} HR.Shock.Figure.(Session_type{sess+1}){group}] , 'Color' , 'm');
    end
    hold on
    if sess==1;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , HR.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , HR.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Shock.Figure.(Session_type{sess+1}){group} , HR.Shock.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , HR.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
makepretty; xlim([2 7]); ylim([8 13])
ylabel('HR frequency (Hz)'); title('Shock');

% Saline Safe
subplot(222); group=7;
for sess=1:length(Session_type)-1
    
    a=line([Respi.Safe.Figure.(Session_type{sess}){group} Respi.Safe.Figure.(Session_type{sess+1}){group}] , [HR.Safe.Figure.(Session_type{sess}){group} HR.Safe.Figure.(Session_type{sess+1}){group}] , 'Color' , [.5 .5 1]);
    hold on
    if sess==1;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , HR.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , HR.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Safe.Figure.(Session_type{sess+1}){group} , HR.Safe.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , HR.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
makepretty; xlim([2 7]); ylim([8 13])
ylabel('HR frequency (Hz)'); title('Shock');

% DZP Safe
group=8; subplot(224)
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([Respi.Safe.Figure.(Session_type{sess}){group} Respi.Safe.Figure.(Session_type{sess+1}){group}] , [HR.Safe.Figure.(Session_type{sess}){group} HR.Safe.Figure.(Session_type{sess+1}){group}], 'LineStyle', '--' , 'Color' , 'c');
    else
        a=line([Respi.Safe.Figure.(Session_type{sess}){group} Respi.Safe.Figure.(Session_type{sess+1}){group}] , [HR.Safe.Figure.(Session_type{sess}){group} HR.Safe.Figure.(Session_type{sess+1}){group}] , 'Color' , 'c');
    end
    hold on
    if sess==1;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , HR.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , HR.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Safe.Figure.(Session_type{sess+1}){group} , HR.Safe.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , HR.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([Respi.Safe.Figure.(Session_type{5}){8} Respi.Safe.Figure.(Session_type{7}){8}] , [HR.Safe.Figure.(Session_type{5}){8} HR.Safe.Figure.(Session_type{7}){8}] , 'Color' ,'c');
makepretty; xlim([2 7]); ylim([8 13])

%% OB/Ripples
figure
subplot(221); group=7;
for sess=1:length(Session_type)-1
    
    a=line([Respi.Shock.Figure.(Session_type{sess}){group} Respi.Shock.Figure.(Session_type{sess+1}){group}] , [Ripples.Shock.Figure.(Session_type{sess}){group} Ripples.Shock.Figure.(Session_type{sess+1}){group}] , 'Color' , [1 .5 .5]);
    hold on
    if sess==3;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , Ripples.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , Ripples.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Shock.Figure.(Session_type{sess+1}){group} , Ripples.Shock.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , Ripples.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([Respi.Shock.Figure.(Session_type{4}){group} Respi.Shock.Figure.(Session_type{6}){group}] , [Ripples.Shock.Figure.(Session_type{4}){group} Ripples.Shock.Figure.(Session_type{6}){group}] , 'Color' , [1 .5 .5]);
makepretty; xlim([2 7]); ylim([0 1])

% DZP Shock
subplot(223)
group=8;
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([Respi.Shock.Figure.(Session_type{sess}){group} Respi.Shock.Figure.(Session_type{sess+1}){group}] , [Ripples.Shock.Figure.(Session_type{sess}){group} Ripples.Shock.Figure.(Session_type{sess+1}){group}], 'LineStyle', '--' , 'Color' , 'm');
    else
        a=line([Respi.Shock.Figure.(Session_type{sess}){group} Respi.Shock.Figure.(Session_type{sess+1}){group}] , [Ripples.Shock.Figure.(Session_type{sess}){group} Ripples.Shock.Figure.(Session_type{sess+1}){group}] , 'Color' , 'm');
    end
    hold on
    if sess==1;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , Ripples.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , Ripples.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Shock.Figure.(Session_type{sess+1}){group} , Ripples.Shock.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Shock.Figure.(Session_type{sess}){group} , Ripples.Shock.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
a=line([Respi.Shock.Figure.(Session_type{1}){group} Respi.Shock.Figure.(Session_type{3}){group}] , [Ripples.Shock.Figure.(Session_type{1}){group} Ripples.Shock.Figure.(Session_type{3}){group}], 'LineStyle', '--' , 'Color' , 'm');
a=line([Respi.Shock.Figure.(Session_type{4}){group} Respi.Shock.Figure.(Session_type{6}){group}] , [Ripples.Shock.Figure.(Session_type{4}){group} Ripples.Shock.Figure.(Session_type{6}){group}] , 'Color' , 'm');
makepretty; xlim([2 7]); ylim([0 .5])
ylabel('Density (#/s)'); xlabel('OB frequency (Hz)')

% Saline Safe
subplot(222); group=7;
for sess=1:length(Session_type)-1
    
    a=line([Respi.Safe.Figure.(Session_type{sess}){group} Respi.Safe.Figure.(Session_type{sess+1}){group}] , [Ripples.Safe.Figure.(Session_type{sess}){group} Ripples.Safe.Figure.(Session_type{sess+1}){group}] , 'Color' , [.5 .5 1]);
    hold on
    if sess==1;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , Ripples.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , Ripples.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Safe.Figure.(Session_type{sess+1}){group} , Ripples.Safe.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , Ripples.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
makepretty; xlim([2 7]); ylim([0 1])

% DZP Safe
group=8; subplot(224)
for sess=1:length(Session_type)-1
    
    if sess<5
        a=line([Respi.Safe.Figure.(Session_type{sess}){group} Respi.Safe.Figure.(Session_type{sess+1}){group}] , [Ripples.Safe.Figure.(Session_type{sess}){group} Ripples.Safe.Figure.(Session_type{sess+1}){group}], 'LineStyle', '--' , 'Color' , 'c');
    else
        a=line([Respi.Safe.Figure.(Session_type{sess}){group} Respi.Safe.Figure.(Session_type{sess+1}){group}] , [Ripples.Safe.Figure.(Session_type{sess}){group} Ripples.Safe.Figure.(Session_type{sess+1}){group}] , 'Color' , 'c');
    end
    hold on
    if sess==1;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , Ripples.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'g')
    elseif sess==6;
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , Ripples.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
        plot(Respi.Safe.Figure.(Session_type{sess+1}){group} , Ripples.Safe.Figure.(Session_type{sess+1}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'r')
    else
        plot(Respi.Safe.Figure.(Session_type{sess}){group} , Ripples.Safe.Figure.(Session_type{sess}){group} , 'o' , 'LineWidth' , 4 , 'Color' , 'k')
    end
end
makepretty; xlim([2 7]); ylim([0 1])
xlabel('OB frequency (Hz)')

