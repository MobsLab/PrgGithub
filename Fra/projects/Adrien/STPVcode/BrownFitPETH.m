function A  = BrownFitPETH(A)

A = getResource(A, 'StartTrial');
startTrial = startTrial{1};
A = getResource(A, 'TrialOutcome');
trialOutcome = trialOutcome{1};
A = getResource(A, 'LightRecord');
lightRecord = lightRecord{1};
A = getResource(A, 'CorrectError');
correctError = correctError{1};

A = getResource(A, 'SpikeData');
A = getResource(A, 'CellNames');
A = getResource(A, 'MazeEpoch');

A = registerResource(A, 'BrownThetasRight', 'cell', {1,1}, 'thetasRight', ...
    'the theta coefficients for Brown fit, right trials');
A = registerResource(A, 'BrownThetasLeft', 'cell', {1,1}, 'thetasLeft', ...
    'the theta coefficients for Brown fit, left trials');
A = registerResource(A, 'BrownThetasAll', 'cell', {1,1}, 'thetasLeft', ...
    'the theta coefficients for Brown fit, All trials');

figDir =  [ 'STPV_' strrep(current_dataset(A), '/', '_')]
mkdir(parent_dir(A), figDir)
cd(figDir);
close all

binSize = 50 * 10;
controlPointSpacing = 400* 10;

startIntervalT0 = -3000*10;
startIntervalT1 = 10000*10;
e_time = 2/20; % check value = learning rate de l'algo. Changt d'intensite de la fonction % aux donnees au tps 
% intensite  =composition des pts precedents et de ce qui suit, fait varier le smoothing de la fonction.
%  cf Wirth Science 2003
%  cf supplementary data, % au tps alors que Franck et al seult spatial.

bins = startIntervalT0:binSize:(startIntervalT1-eps);
bins = bins(1:(end-1));
controlPoints = (bins(1)-controlPointSpacing):controlPointSpacing:(bins(end)+controlPointSpacing);
trials = intervalSet(Range(startTrial)+startIntervalT0, Range(startTrial)+startIntervalT1);

% Q : matrix of binned firing rates
% Q is SPARSE

Q = MakeQfromS(S, binSize);

% uniquement les intervalles correspondant aux essais.
QtrialsAll = intervalSplit(Q, trials, 'OffsetStart', startIntervalT0);

% algo cf Franck 2002;

% cardinal splines : splines exprimees par % a leur val dans des points de controle
% poly 3e degre ac pt de control; chaque poly passe par 4 pts; affectes par les vals des 4 pts de controle;
% 1 pt de controle ts les 8 bins; 
%PETH 3

% dldt : 
% prevControlPoint : 

% compute the dlambda/dtheta matrix
dldt = zeros(length(controlPoints), length(bins));
[u0, prevControlPoint] = Restrict(ts(controlPoints'), ts(bins'), 'align', 'prev');
ut = (bins-(Data(u0))')/ controlPointSpacing;
prevControlPoint = prevControlPoint';
i = [];
j = [];
s = [];

%add the matrix elements for the 4 contrl points affected/affecting by each datapoint
% chacun de ces triplets de ligne est une diag de la matrice par bande cree par la fct sparse
% evite de faire une enorme boucle

i = [ i, (prevControlPoint-1)];
j = [ j, (1:length(bins))];
s =[s,  (-0.5 *ut.^3 + ut .^ 2 - 0.5 *ut)];

i = [ i, (prevControlPoint)];
j = [ j, (1:length(bins))];
s =[s,  (1.5 *ut.^3 - 2.5 * ut .^ 2 +1)];

i = [ i, (prevControlPoint+1)];
j = [ j, (1:length(bins))];
s =[s,  (-1.5 *ut .^ 3 + 2 * ut .^ 2 + 0.5 * ut)];

i = [ i, (prevControlPoint+2)];
j = [ j, (1:length(bins))];
s =[s,  (0.5 *ut.^3 - 0.5 * ut .^ 2) ];

ix = find(i > 0 & i <=length(controlPoints));
i = i(ix);
j = j(ix);
s = s(ix);

dldt = full(sparse(i, j, s, length(controlPoints), length(bins)));

% boucle separee pour les essais droite et gauche
sfx = {'Right', 'Left'};

for sf = 1:2

    t = find(Data(trialOutcome) == (sf-1)); %  on selectionne les essais droite/gauche
    Qtrials = QtrialsAll(t); %initialisation
    if length(Qtrials)
    thetas = zeros(length(S), length(Qtrials)+1,length(controlPoints)); % first value for teta is initialization
    % theta(:,i+1,:) refers to i-th trial


%  Initialisation de la premiere val
    q = Data(Qtrials{1});
    for iCell = 1:length(S)
        thetas(iCell, 1,:) = e_time * squeeze(dldt * q(:,iCell));
    end

%  cf Eq 1.1 p 3819 :
%      tic
    for jTrials  = 1:length(Qtrials)
        q = Data(Qtrials{jTrials});
        for iCell = 1:length(S)
            innovation = q(:,iCell) - dldt' * squeeze(thetas(iCell, jTrials,:));
            thetas(iCell,jTrials+1,:) = squeeze(thetas(iCell,jTrials,:)) + e_time * dldt * innovation;
        end
    end
%      toc

    else
        thetas = zeros(length(S), 0,length(controlPoints)); % first value for teta is initialization
    end

%  sauvegarde des 2 thetas
    eval(['thetas' sfx{sf} ' = thetas;']);

end

lc = length(controlPoints);
% mat 2x + gde que Theta left/gauche
thetasAll = zeros(length(S), length(QtrialsAll),2*length(controlPoints)); % first value for teta is initialization

thetasAll(:,1,1:lc) = thetasRight(:,2,:);
thetasAll(:,1,(lc+1):end) = thetasLeft(:,2,:);
to = Data(trialOutcome);
nRight = 2;
nLeft = 2;

if to(1) == 0
    nRight = nRight + 1;
else
    nLeft = nLeft + 1;
end

%on remplie la mat ThetaAlls

for jTrials = 2:length(trialOutcome)
    if to(jTrials) == 0 % trial to the right
        thetasAll(:,jTrials,1:lc) = thetasRight(:,nRight,:); %update
        thetasAll(:,jTrials,(lc+1):end) = thetasAll(:,jTrials-1,(lc+1):end) ; % on prend celle de l'essai precedent
        nRight = nRight + 1;
    else
        thetasAll(:,jTrials,1:lc) =  thetasAll(:,jTrials-1,1:lc); %et ici on fait l'inverse
        thetasAll(:,jTrials,(lc+1):end) = thetasLeft(:,nLeft,:);
        
        nLeft = nLeft + 1;
    end
end

% average firing rate
for i = 1:length(S)
sm = Restrict(S{i}, mazeEpoch{1});
fr(i) = length(Data(sm)) / tot_length(mazeEpoch{1}, 's');
end

% arbitrary selection
okCells = find(fr < 20 & fr > 0.2);
nOkCells = length(okCells);
nCtrl = 2 * length(controlPoints);
ta = thetasAll(okCells, :,:);

% pour chaque essai on veut un binaire
%  ThetaAll 1er D :Cell
%  2D trial #
%  3D point sur le controle point
% on transform en mat 2D
%  1erD : trial#
%  on combine les 2 autres dans la 2emeD
ta = permute(ta, [1 3 2]);
[s1, s2, s3] = size(ta);
ta = reshape(ta, [(s1*s2) s3]);
display('all')
figure(1), clf, imagesc(corrcoef(ta));
saveas(gcf, 'similarityAll', 'png');
saveas(gcf, 'similarityAll', 'eps');


% PCA
thetasAllR = ta;
[coeff, score, latent] = princomp(thetasAllR');
% show PCA, reverse reshaping, on exprime a nouveau en matrice: (cells# x control Points)
pc1 = reshape(coeff(:,1), nOkCells, nCtrl);
pc2 = reshape(coeff(:,2), nOkCells, nCtrl);
figure(6), subplot(121), imagesc(controlPoints/10000, 1:nOkCells,pc1(:,1:length(controlPoints))), caxis([-0.2 .2]), title('PC 1 right ');
ax1 = subplot(122), imagesc(controlPoints/10000, 1:nOkCells,pc1(:,(length(controlPoints)+1):end)),  caxis([-0.2 .2]),title('PC 1 left '); ax1 = gca;
%subplot(133), axis off, colorbar('clim',[-0.2 0.2]);
saveas(gcf, 'pc1', 'png');
saveas(gcf, 'pc1', 'eps');

figure(7), subplot(121), imagesc(controlPoints/10000, 1:nOkCells,pc2(:,1:length(controlPoints))), caxis([-0.2 .2]), title('PC 2 right ');
ax1 =subplot(122), imagesc(controlPoints/10000, 1:nOkCells,pc2(:,(length(controlPoints)+1):end)),  caxis([-0.2 .2]), title('PC 2 left '); ax1 = gca;
%subplot(133), axis off, colorbar('clim',[-0.2 0.2]);
saveas(gcf, 'pc2', 'png');
saveas(gcf, 'pc2', 'eps');

% Calcul de learning curves, algo EM d'A Smith.
% bLight = v
bLight = SmithBrownLearningCurve((to == Data(lightRecord))', 111);
set(111, 'name', 'Light performance');
saveas(gcf, 'LightPerf', 'png');
saveas(gcf, 'LightPerf', 'eps');

bLeft = SmithBrownLearningCurve((to)', 112);
set(112, 'name', 'Left performance');
saveas(gcf, 'LeftPerf', 'png');
saveas(gcf, 'LeftPerf', 'eps');

tAlt = abs(diff(to));
tAlt = [tAlt(1) ; tAlt];
bAlt =SmithBrownLearningCurve(tAlt', 113);
set(113, 'name', 'Alternation Performance');


% score cf princomp above
for i = 1:20
cc = corrcoef(bLeft', score(:,i));
rLeft(i) = cc(1,2);
cc = corrcoef(bLight', score(:,i));
rLight(i) = cc(1,2);
cc = corrcoef(bAlt', score(:,i));
rAlt(i) = cc(1,2);
end

[dummy, iLeft] = sort(rLeft .^ 2);
figure(2), clf, plotColors( bLeft, score(:,iLeft(end)), 1:(length(to)), 30); 
xlabel('bLeft');
ylabel(['PC' num2str(iLeft(end))]);
saveas(gcf, 'LeftPCA', 'png');
saveas(gcf, 'LeftPCA', 'eps');


figure(12), clf, plotColors( bLeft, score(:,iLeft(end-1)), 1:(length(to)), 30); 
xlabel('bLeft');
ylabel(['PC' num2str(iLeft(end-1))]);
saveas(gcf, 'LeftPCA_B', 'png');
saveas(gcf, 'LeftPCA_B', 'eps');





[dummy, iLight] = sort(rLight .^ 2);
figure(3), clf, plotColors( bLight, score(:,iLight(end)), 1:(length(to)), 30); 
xlabel('bLight');
ylabel(['PC' num2str(iLight(end))]);
saveas(gcf, 'LightPCA', 'png');
saveas(gcf, 'LightPCA', 'eps');

figure(13), clf, plotColors( bLight, score(:,iLight(end-1)), 1:(length(to)), 30); 
xlabel('bLight');
ylabel(['PC' num2str(iLight(end-1))]);
saveas(gcf, 'LightPCA_B', 'png');
saveas(gcf, 'LightPCA_B', 'eps');


[dummy, iAlt] = sort(rAlt .^ 2);
figure(8), clf, plotColors( bAlt, score(:,iAlt(end)), 1:(length(to)), 30); 
xlabel('bAlt');
ylabel(['PC' num2str(iAlt(end))]);
saveas(gcf, 'AltPCA', 'png');
saveas(gcf, 'AltPCA', 'eps');

figure(18), clf, plotColors( bAlt, score(:,iAlt(end-1)), 1:(length(to)), 30); 
xlabel('bAlt');
ylabel(['PC' num2str(iAlt(end-1))]);
saveas(gcf, 'AltPCA_B', 'png');
saveas(gcf, 'AltPCA_B', 'eps');





figure(4), clf
plot(rLeft.^2, 'o')
hold on
plot(rLight.^2, 'ro')
plot(rAlt.^2, 'go')
legend({'left', 'light', 'altern'});
saveas(gcf, 'PCAStrategyCorr', 'png');
saveas(gcf, 'PCAStrategyCorr', 'eps');




ta = thetasRight(find(fr < 20 & fr > 0.2), :,:);
ta = permute(ta, [1 3 2]);
[s1, s2, s3] = size(ta);
ta = reshape(ta, [(s1*s2) s3]);
display('right')
figure(1), clf, imagesc(corrcoef(ta));
saveas(gcf, 'similarityRight', 'png');
saveas(gcf, 'similarityRight', 'eps');

thetasRightR = ta;

ta = thetasLeft(find(fr < 20 & fr > 0.2), :,:);
ta = permute(ta, [1 3 2]);
[s1, s2, s3] = size(ta);
ta = reshape(ta, [(s1*s2) s3]);
display('left')
figure(1), clf, imagesc(corrcoef(ta));
saveas(gcf, 'similarityLeft', 'png');
saveas(gcf, 'similarityLeft', 'eps');

thetasLeftR = ta;



% for i = 1:length(S)
%     ta = thetasRight(i, :,:);
%     ta = permute(ta, [1 3 2]);
%     [s1, s2, s3] = size(ta);
%     ta = reshape(ta, [(s1*s2) s3]);
%     figure(1), clf, imagesc(corrcoef(ta));
%     keyboard
% end


cd(parent_dir(A));

A = saveAllResources(A);