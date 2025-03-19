
clear all

Dir1 = PathForExperimentsOB({'Shropshire'}, 'freely-moving','saline');
Dir2 = PathForExperimentsOB({'Shropshire'}, 'freely-moving','none');
Dir = MergePathForExperiment(Dir1,Dir2);

pwd = Dir.path{5};

Frequency_HPC = {[.2 2.8],[2.8 6]};
Frequency_OB = {[.5 4]};

%% raw signals Sleep
load([pwd filesep 'ChannelsToAnalyse/Bulb_deep.mat'])
load([pwd filesep 'LFPData/LFP' num2str(channel) '.mat'])
OB_gamma = FilterLFP(LFP,[20 100],1024);
OB_delta = FilterLFP(LFP,[.1 5],1024);
OB_delta2 = FilterLFP(LFP,[.5 4],1024);

load([pwd filesep 'ChannelsToAnalyse/ThetaREM.mat'])
load([pwd filesep 'LFPData/LFP' num2str(channel) '.mat'])
HPC_theta = FilterLFP(LFP,[1 8],1024);


figure
subplot(131)
plot(Range(OB_gamma,'s') , Data(OB_gamma) , 'k' , 'LineWidth' , .2)
hold on
plot(Range(HPC_theta,'s') , Data(HPC_theta)-5e3 , 'k' , 'LineWidth' , .2)
plot(Range(OB_delta,'s') , Data(OB_delta)-10e3 , 'k' , 'LineWidth' , .2)
xlim([3127 3127+10]), ylim([-1.3e4 4e3]), axis off
text(3127,0,'OB','FontSize',15)
text(3127,-5e3,'HPC','FontSize',15)
text(3127,-1e4,'OB','FontSize',15)
line([3128 3130],[-1.3e4 -1.3e4],'LineStyle','-','Color','k','LineWidth',5)
text(3128.5,-1.1e4,'2s','FontSize',15)
text(3127+4,4e3,'REM','FontSize',20)

subplot(132)
plot(Range(OB_gamma,'s') , Data(OB_gamma) , 'k' , 'LineWidth' , .2)
hold on
plot(Range(HPC_theta,'s') , Data(HPC_theta)-5e3 , 'k' , 'LineWidth' , .2)
plot(Range(OB_delta,'s') , Data(OB_delta)-10e3 , 'k' , 'LineWidth' , .2)
xlim([3329 3329+10]), ylim([-1.3e4 4e3]), axis off
text(3329+4,4e3,'IS','FontSize',20)

subplot(133)
plot(Range(OB_gamma,'s') , Data(OB_gamma) , 'k' , 'LineWidth' , .2)
hold on
plot(Range(HPC_theta,'s') , Data(HPC_theta)-5e3 , 'k' , 'LineWidth' , .2)
plot(Range(OB_delta,'s') , Data(OB_delta)-10e3 , 'k' , 'LineWidth' , .2)
xlim([5474 5474+10]), ylim([-1.3e4 4e3]), axis off
text(5474+4,4e3,'NREM','FontSize',20)



%% trash ?
subplot(131)
plot(Range(OB_gamma,'s') , Data(OB_gamma) , 'k' , 'LineWidth' , .2)
hold on
plot(Range(HPC_theta,'s') , Data(HPC_theta)-5e3 , 'k' , 'LineWidth' , .2)
plot(Range(OB_delta,'s') , Data(OB_delta)-10e3 , 'k' , 'LineWidth' , .2)
xlim([148 148+10]), ylim([-1.3e4 4e3]), %axis off

title('Wake')

subplot(132)
