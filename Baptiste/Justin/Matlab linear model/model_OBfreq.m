
 


%% GLM : linear model 


X=[TotalArray(:,1) TotalArray(:,4)/(1e3)];
Y=[TotalArray(:,2)];
mdlquad = fitglm(X,Y,'quadratic')
mdllin = fitglm(X,Y,'linear')


f = @(x1,x2) 4.509-0.97374*x1+0.23064*x2
x = 0:0.01:1;  % define range and mesh of x and y which will be shown in figure
y = 0:0.1:6;
[A, B] = meshgrid(x, y);
surf(A, B, f(A,B));
figure;
contourf(A, B, f(A,B));
xlabel('linear position')
ylabel('time since last shock')
zlabel('linear model for OB frequency')
zlim([0 8])
title('Linear model for OB frequency while freezing')







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% New model taking learning degree in count 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% All these parameters will need to be fitetd to model
MaxFreqSk = 7;
MinFreqSk = 4;
Tau = 3; % s

MaxFreqPos = 6;
MinFreqPos = 2;

LearnPoint = 600; %s
LearnSlope = 0.01;

%% Make a simulation of 10s freezing period at different positions and learning rates depending on time since shock
tpsManip = [0:1500];
AllTpsLearn = [ 1:300:max(tpsManip)];

Learning = 1./(1+exp(-LearnSlope*([0:1500]-LearnPoint)));
AllTimeToShock = [0,2,5,10,20];   % Times since last shock

% sample different learning stages
cols = jet(10);
for t = 1:length(AllTpsLearn)
    
    AlphaLearn = Learning(AllTpsLearn(t));     % definition of the learning degree
    
    for sk = 1:length(AllTimeToShock)         
        TimeToShock = AllTimeToShock(sk);      % definition of the time since the last shock
        for Pos = 0:0.1:0.9
            OBFreq_Shock = (1-AlphaLearn) .* ((MaxFreqSk - MinFreqSk) *exp([(-[0:10] -TimeToShock)]/Tau) + MinFreqSk);
            OBFreq_Pos = (AlphaLearn) .* ((MaxFreqPos*Pos - MinFreqPos) *Pos + MinFreqPos);
            OBFreq_Tot = OBFreq_Shock + OBFreq_Pos;
            subplot(5,5,t+(sk-1)*5)
            plot(OBFreq_Tot,'color',cols(round(Pos*10+1),:),'linewidth',2)
            hold on
            ylim([0 8])
            xlabel('Time freezing (s)')
        end
    end
end

figure
plot(tpsManip,Learning,'linewidth',3)
hold on
for t = 1:length(AllTpsLearn)
    line([AllTpsLearn(t) AllTpsLearn(t)],ylim)
end



% Fitting the 7 parameters with data from a mouse

OB_frequencies_data = TotalArray(:,1);
positions = TotalArray(:,2);
times_manip = TotalArray(:,3);
times_since_last_shock = TotalArray(:,4);
time_freezing = TotalArray(:,5);

x0 = [7 4 3 6 2 3000 0.01]';
InputInfo.x0=x0;

options = optimoptions('fmincon');

global InputInfo
global options
global TotalArray


[x,fval,exitflag,output,grad,hessian] = Find_Optimum_BM(@cost2)
[x,fval,exitflag,output,lambda,grad,hessian] = FindOptimum2_BM(@cost2)

% Pour avoir le plot de OB_freq avec le modèle et comparer aux data : 

for t=1:length(times_manip)
    time = times_manip(t);
    time2(t) = times_manip(t);
    Learning = 1./(1+exp(-x(7)*(time - x(6))));
    Learning2(t) = 1./(1+exp(-x(7)*(time - x(6))));
    OBFreq_Shock(t) = (1-Learning) * ((x(1) - x(2)) *exp((-time_freezing(t) -times_since_last_shock(t))/x(3)) + x(2));
    OBFreq_Pos(t) = Learning * ((x(4) - x(5)) *positions(t) + x(5));
    OBFreq_Tot(t) = OBFreq_Shock(t) + OBFreq_Pos(t);
    Cost_MC (t) = (OB_frequencies_data(t) - OBFreq_Tot(t))^2;
    Cost_tot = nansum(Cost_MC);
end




figure
plot(smooth(OB_frequencies_data))
hold on
plot(OBFreq_Tot)
hold off
title('Comparison between OB frequencies with the model and raw data')
xlabel('time')
ylabel('OB frequency')


% This model fits the general baheviour of the OB frequency but it seems
% that parameters are missing to fit precise variations.




%% Model without ls and lp

x1 = [7 4 3 6 2]'
InputInfo.x1=x1;

options = optimoptions('fmincon');

global InputInfo
global options
global TotalArray

[x,fval,exitflag,output,lambda,grad,hessian] = FindOptimum2_nolslp(@cost2)


for t=1:length(times_manip)
    time = times_manip(t);
    time2(t) = times_manip(t);
    Learning = 1./(1+exp(-0.01*(time - 3000)));
    Learning2(t) = 1./(1+exp(-0.01*(time - 3000)));
    OBFreq_Shock(t) = (1-Learning) * ((x(1) - x(2)) *exp((-time_freezing(t) -times_since_last_shock(t))/x(3)) + x(2));
    OBFreq_Pos(t) = Learning * ((x(4) - x(5)) *positions(t) + x(5));
    OBFreq_Tot(t) = OBFreq_Shock(t) + OBFreq_Pos(t);
    Cost_MC (t) = (OB_frequencies_data(t) - OBFreq_Tot(t))^2;
    Cost_tot2 = nansum(Cost_MC);
end



figure
plot(smooth(OB_frequencies_data))
hold on
plot(OBFreq_Tot)
hold off
title('Comparison between OB frequencies with the model and raw data (ls and lp are fixed here)')
xlabel('time')
ylabel('OB frequency')














