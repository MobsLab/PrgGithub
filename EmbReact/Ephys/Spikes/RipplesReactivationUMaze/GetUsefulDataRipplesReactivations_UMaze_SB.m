MiceNumber=[490,507,508,509,514]; % 510,512 don't have tipples


% 490
mm=1;
Dir{mm}.Hab{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_Habituation/';
for ff = 1:5
    Dir{mm}.Cond{ff} = ['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_UMazeCond/Cond' num2str(ff),'/'];
end
Dir{mm}.SleepPre{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPre';
Dir{mm}.SleepPost{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_SleepPost';
for ff = 1:4
    Dir{mm}.TestPost{ff} = ['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_TestPost/TestPost' num2str(ff),'/'];
end
Dir{mm}.Ext{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_Extinction';
Dir{mm}.Fear = Dir{mm}.Cond; 
Dir{mm}.Fear{6} = Dir{mm}.Ext{1};
for ff=7:10
    Dir{mm}.Fear{ff} = Dir{mm}.TestPost{ff-6};
end

% 507
mm=2;
Dir{mm}.Hab{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_Habituation/';
for ff = 1:5
    Dir{mm}.Cond{ff} = ['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_UMazeCond/Cond' num2str(ff),'/'];
end
Dir{mm}.SleepPre{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_SleepPre';
Dir{mm}.SleepPost{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_SleepPost';
for ff = 1:4
    Dir{mm}.TestPost{ff} = ['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_TestPost/TestPost' num2str(ff),'/'];
end
Dir{mm}.Ext{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170201/ProjectEmbReact_M507_20170201_Extinction';
Dir{mm}.Fear = Dir{mm}.Cond; Dir{mm}.Fear{6} = Dir{mm}.Ext{1};
for ff=7:10
    Dir{mm}.Fear{ff} = Dir{mm}.TestPost{ff-6};
end

% 508
mm=3;
Dir{mm}.Hab{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_Habituation/';
for ff = 1:5
    Dir{mm}.Cond{ff} = ['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_UMazeCond/Cond' num2str(ff),'/'];
end
Dir{mm}.SleepPre{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPre';
Dir{mm}.SleepPost{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_SleepPost';
for ff = 1:4
    Dir{mm}.TestPost{ff} = ['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_TestPost/TestPost' num2str(ff),'/'];
end
Dir{mm}.Ext{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_Extinction';
Dir{mm}.Fear = Dir{mm}.Cond; Dir{mm}.Fear{6} = Dir{mm}.Ext{1};
for ff=7:10
    Dir{mm}.Fear{ff} = Dir{mm}.TestPost{ff-6};
end

% 509
mm=4;
Dir{mm}.Hab{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_Habituation/';
for ff = 1:5
    Dir{mm}.Cond{ff} = ['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_UMazeCond/Cond' num2str(ff),'/'];
end
Dir{mm}.SleepPre{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_SleepPre';
Dir{mm}.SleepPost{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_SleepPost';
for ff = 1:4
    Dir{mm}.TestPost{ff} = ['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_TestPost/TestPost' num2str(ff),'/'];
end
Dir{mm}.Ext{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170204/ProjectEmbReact_M509_20170204_Extinction';
Dir{mm}.Fear = Dir{mm}.Cond; Dir{mm}.Fear{6} = Dir{mm}.Ext{1};
for ff=7:10
    Dir{mm}.Fear{ff} = Dir{mm}.TestPost{ff-6};
end

% 514
mm=5;
Dir{mm}.Hab{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_Habituation/';
for ff = 1:5
    Dir{mm}.Cond{ff} = ['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_UMazeCond/Cond' num2str(ff),'/'];
end
Dir{mm}.SleepPre{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_SleepPre';
Dir{mm}.SleepPost{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_SleepPost';
for ff = 1:4
    Dir{mm}.TestPost{ff} = ['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_TestPost/TestPost' num2str(ff),'/'];
end
Dir{mm}.Ext{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_Extinction';
Dir{mm}.Fear = Dir{mm}.Cond; Dir{mm}.Fear{6} = Dir{mm}.Ext{1};
for ff=7:10
    Dir{mm}.Fear{ff} = Dir{mm}.TestPost{ff-6};
end
