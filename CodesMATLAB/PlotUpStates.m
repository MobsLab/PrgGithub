

function PlotUpStates(data,dEeg,tps,DebutUp,FinUp)


figure('Color',[1,1,1]),
num=gcf;
set(num,'Position',[20 -300 1200 800])

colorUp=[207 35 35]/255;
colorDown=[32 215 28]/255;
colorBox=[205 225 255]/255; %[197 246 255]/255;
boxbottom = min(data(:,2));
boxhight = max(data(:,2)) - boxbottom+10;

for i=1:length(DebutUp)
rectangle('Position', [DebutUp(i) boxbottom FinUp(i)-DebutUp(i) boxhight], 'LineStyle', 'none', 'FaceColor', colorBox);
end
hold on, plot(data(:,1),data(:,2),'Color',[0.6 0.6 0.6])
hold on, plot(tps,dEeg,'r','linewidth',2)
ylim([boxbottom boxhight+boxbottom])

                    
                    
                    
                    