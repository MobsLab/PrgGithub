function histogramPP

load Jcomp2

Vs = sum(Vh, 2);
[tmp, ixq] = sort(Vs);

% load gridWaves
% J = Vin';


jj = zeros(size(J));

%for i = (ixq(200:end))'
for i = 1:size(J,1)
    qq = J(i,:);
    sq = sort(qq);
    sq = sq(2500-20);
    jj(i,:) = qq > sq;
end
ss = sum(jj,1);
%keyboard

load gridWaves
Nin = size(Vin, 1);
nStepsIn = size(Vin, 2);

sigmSlope = 4;
sigmOffset = 1.5;
for ns = 1:nStepsIn
    VinNow = Vin(:,(ns));
    Fout = J * VinNow;
    % simulate a "soft competitive learning"
    Vout = (Fout-mean(Fout))/std(Fout);
    Vout= (1 ./ (1 + exp(-sigmSlope*(Vout-sigmOffset))));
    Vmap = diag(Vout) * jj;
    ss = sum(Vmap, 1);
    imagesc(reshape(ss, 50, 50));
    keyboard
    clf
end
