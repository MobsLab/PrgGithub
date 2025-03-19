% Number of Mouse
Mouse = 509;
% Date
Date = 20170204;
% XY limits
y = [5 55];
x = [15 75];

dir = pwd;

% Plot Habituation
curdir = [dir '/ProjectEmbReact_M' num2str(Mouse) '_' num2str(Date) '_Habituation'];
cd(curdir);
load('behavResources.mat');
figure, plot(Data(Xtsd), Data(Ytsd));
xlim(x);
ylim(y);
title('Hab');

% Plot TestPre
for i = 1:4
    curdir = [dir '/ProjectEmbReact_M' num2str(Mouse) '_' num2str(Date) '_TestPre/TestPre' num2str(i)];
    cd(curdir);
    load('behavResources.mat');
    figure, plot(Data(Xtsd), Data(Ytsd));
    xlim(x);
    ylim(y);
    title(['Pre' num2str(i)]);
end

% Plot Cond
for i = 1:5
    curdir = [dir '/ProjectEmbReact_M' num2str(Mouse) '_' num2str(Date) '_UMazeCond/Cond' num2str(i)];
    cd(curdir);
    load('behavResources.mat');
    figure, plot(Data(Xtsd), Data(Ytsd));
    xlim(x);
    ylim(y);
    title(['Cond' num2str(i)]);
end

% Plot TestPost
for i = 1:4
    curdir = [dir '/ProjectEmbReact_M' num2str(Mouse) '_' num2str(Date) '_TestPost/TestPost' num2str(i)];
    cd(curdir);
    load('behavResources.mat');
    figure, plot(Data(Xtsd), Data(Ytsd));
    xlim(x);
    ylim(y);
    title(['Post' num2str(i)]);
end

clear