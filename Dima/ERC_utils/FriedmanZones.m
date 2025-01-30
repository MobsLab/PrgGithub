%%^ FriedmanZones 

% Stripe is bigger

%% Parameters
dir_out = '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/Behavior/Mouse714/';
fig_post = 'beh_pre_post';

indir = '/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/';
ntest = 4;
Day3 = '31052018';

suf = {'TestPre'; 'TestPost'};

% 0 - ZebraSide is Shock (example:/media/DataMOBsRAIDN/ProjetERC2/Mouse-712/12042018/TestPre/behavResources)
% 1 - StripeSide is Shock (example:/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Hab/behavResources)
% 2 - New Equal UMaze
orientation = 1;


theoreticalOccupEqual = [0.347 0.347 0.066 0.12 0.12...
    0.347 0.347 0.066 0.12 0.12...
    0.347 0.347 0.066 0.12 0.12...
    0.347 0.347 0.066 0.12 0.12];
theoreticalOccupUnequal1 = [0.386 0.309 0.067 0.132 0.106...
    0.386 0.309 0.067 0.132 0.106...
    0.386 0.309 0.067 0.132 0.106...
    0.386 0.309 0.067 0.132 0.106];
theoreticalOccupUnequal2 = [0.309 0.386 .067 0.106 0.132...
    0.309 0.386 .067 0.106 0.132...
    0.309 0.386 .067 0.106 0.132...
    0.309 0.386 .067 0.106 0.132];

%% 
% Get data from all 4 PreTests = Real

for i = 1:1:ntest
    % PreTests
    a = load([indir Day3 '/' suf{1} '/' suf{1} num2str(i) '/behavResources.mat'],'Occup');
	PreReal(i*5-4:i*5) = a.Occup(1:5);
    % PostTests
    b = load([indir Day3 '/' suf{2} '/' suf{2} num2str(i) '/behavResources.mat'],'Occup');
    PostReal(i*5-4:i*5) = b.Occup(1:5);
end

if orientation == 0
    Theory = theoreticalOccupUnequal2;
elseif orientation == 1
    Theory = theoreticalOccupUnequal1;
elseif orientation == 2
    Theory = theoreticalOccupEqual;
end

[PreReal' PostReal']

p_pre_post = friedman([PreReal' PostReal'], 4);

p_theor_pre = friedman([Theory' PreReal'], 4);

p_theor_post = friedman([Theory' PostReal'], 4); 

p_theor_pre_post = friedman([Theory' PreReal' PostReal'], 4); 