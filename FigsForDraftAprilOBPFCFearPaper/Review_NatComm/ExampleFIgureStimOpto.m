a=0;
% CHR2 mice
a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse496/20170309-EXT-24-laser13/FEAR-Mouse-496-09032017';

a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse497/20170309-EXT-24-laser13/FEAR-Mouse-497-09032017';

a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse540/20170727-EXT24-laser13';

a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse542/20170727-EXT24-laser13';

a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse543/20170727-EXT24-laser13';

a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse613/20171005-EXT-24';

a=a+1; Dir.path{a}='/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse614/20171005-EXT-24';


cd(Dir.path{1})
load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse496/20170309-EXT-24-laser13/FEAR-Mouse-496-09032017/LFPData/LFP20.mat')
FilLFP = FilterLFP(LFP,[0.1 50],1024);
Ep = intervalSet(697*1E4, 701*1E4);
FilLFP_res = Restrict(FilLFP,Ep);

load('/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse496/20170309-EXT-24-laser13/FEAR-Mouse-496-09032017/LFPData/LFP32.mat')
y = runmean(Data(LFP),10);
y = y<200;
Las_tsd = tsd(Range(LFP),y);
Las_tsd = Restrict(Las_tsd,Ep);


figure


% Create demo plot
X = Range(Las_tsd,'s');
Y = Data(Las_tsd);
X = X(1:20:end);
Y = Y(1:20:end);
figure
sh = stairs(X,Y,'c');
hold on
% Get the (y,x) coordinates from the original inputs or from
% the xdata and ydata properties of the stair object which will
% always be row vectors.
bottom = 0; %identify bottom; or use min(sh.YData)
x = [sh.XData(1),repelem(sh.XData(2:end),2)];
y = [repelem(sh.YData(1:end-1),2),sh.YData(end)];
% plot(x,y,'y:') %should match stair plot
% Fill area
fill([x,fliplr(x)],[y,bottom*ones(size(y))], 'c')
set(gca,'XColor','w','YColor','w')

hold on
yyaxis right
plot(Range(FilLFP_res,'s'),Data(FilLFP_res),'k','linewidth',2)
set(gca,'XColor','w','YColor','w')


%%%
cd(Dir.path{4})
load('LFPData/LFP9.mat')
FilLFP = FilterLFP(LFP,[0.1 80],1024);
Ep = intervalSet(697*1E4, 701*1E4);
FilLFP_res = Restrict(FilLFP,Ep);

load('LFPData/LFP32.mat')
y = runmean(Data(LFP),10);
y = y<200;
Las_tsd = tsd(Range(LFP),y);
Las_tsd = Restrict(Las_tsd,Ep);


figure


% Create demo plot
X = Range(Las_tsd,'s');
Y = Data(Las_tsd);
X = X(1:20:end);
Y = Y(1:20:end);
figure
sh = stairs(X,Y,'c');
hold on
% Get the (y,x) coordinates from the original inputs or from
% the xdata and ydata properties of the stair object which will
% always be row vectors.
bottom = 0; %identify bottom; or use min(sh.YData)
x = [sh.XData(1),repelem(sh.XData(2:end),2)];
y = [repelem(sh.YData(1:end-1),2),sh.YData(end)];
% plot(x,y,'y:') %should match stair plot
% Fill area
fill([x,fliplr(x)],[y,bottom*ones(size(y))], 'c')
set(gca,'XColor','w','YColor','w')

hold on
yyaxis right
plot(Range(FilLFP_res,'s'),Data(FilLFP_res),'k','linewidth',2)
set(gca,'XColor','w','YColor','w')