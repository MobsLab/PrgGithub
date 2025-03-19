



figure
Bar_shock = [nanmean(PC_values_shock{1}) nanmean(PC_values_shock{2}) nanmean(PC_values_shock{4})];
Bar_safe = [nanmean(PC_values_safe{1}) nanmean(PC_values_safe{2}) nanmean(PC_values_safe{4})];
Bar_act = [nanmean(PC_values_active{1}) nanmean(PC_values_active{2}) nanmean(PC_values_active{4})];
Bar_sleep = [nanmean(PC_values_sleep{1}) nanmean(PC_values_sleep{2}) nanmean(PC_values_sleep{4})];
Bar_quiet = [nanmean(PC_values_quiet{1}) nanmean(PC_values_quiet{2}) nanmean(PC_values_quiet{4})];

Std_shock = [stdError(PC_values_shock{1}) stdError(PC_values_shock{2}) stdError(PC_values_shock{4})];
Std_safe = [stdError(PC_values_safe{1}) stdError(PC_values_safe{2}) stdError(PC_values_safe{4})];
Std_act = [stdError(PC_values_active{1}) stdError(PC_values_active{2}) stdError(PC_values_active{4})];
Std_sleep = [stdError(PC_values_sleep{1}) stdError(PC_values_sleep{2}) stdError(PC_values_sleep{4})];
Std_quiet = [stdError(PC_values_quiet{1}) stdError(PC_values_quiet{2}) stdError(PC_values_quiet{4})];


[~,~,~,h]=ellipsoid_BM(Bar_shock(1),Bar_shock(2),Bar_shock(3),Std_shock(1),Std_shock(2),Std_shock(3),30); h.FaceColor=[1 .5 .5]; h.EdgeColor=[.5 .5 .5]; h.FaceAlpha=.5;
hold on
[~,~,~,h]=ellipsoid_BM(Bar_safe(1),Bar_safe(2),Bar_safe(3),Std_safe(1),Std_safe(2),Std_safe(3),30); h.FaceColor=[.5 .5 1]; h.EdgeColor=[.5 .5 .5]; h.FaceAlpha=.5;
[~,~,~,h]=ellipsoid_BM(Bar_act(1),Bar_act(2),Bar_act(3),Std_act(1),Std_act(2),Std_act(3),30); h.FaceColor=[.8 .3 .1]; h.EdgeColor=[.5 .5 .5]; h.FaceAlpha=.5;
[~,~,~,h]=ellipsoid_BM(Bar_sleep(1),Bar_sleep(2),Bar_sleep(3),Std_sleep(1),Std_sleep(2),Std_sleep(3),30); h.FaceColor=[.8 .5 0]; h.EdgeColor=[.5 .5 .5]; h.FaceAlpha=.5;
[~,~,~,h]=ellipsoid_BM(Bar_quiet(1),Bar_quiet(2),Bar_quiet(3),Std_quiet(1),Std_quiet(2),Std_quiet(3),30); h.FaceColor=[.5 .8 .5]; h.EdgeColor=[.5 .5 .5]; h.FaceAlpha=.5;

xlabel('PC1 value (a.u.)'), ylabel('PC2 value (a.u.)'), zlabel('PC4 value (a.u.)')
makepretty_BM2

xlim([-4 3])
ylim([-3 3])
zlim([-2 .2])

set(gca, 'LineWidth',4)
