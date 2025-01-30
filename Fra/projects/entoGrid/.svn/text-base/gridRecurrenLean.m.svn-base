
nSteps = 50000;
deltaJCoeff = 1;
load Jcomp2
N = size(J, 1);
Jrec = zeros(N,N);


load gridWaves
Nin = size(Vin, 1);
nStepsIn = size(Vin, 2);
pr = random('discrete uniform', nStepsIn, [1, nSteps]);
sigmSlope = 4;
sigmOffset = 1.5;
for ns = 1:nStepsIn
    VinNow = Vin(:,(ns));
    Fout = J * VinNow;
    % simulate a "soft competitive learning"
    Vout = (Fout-mean(Fout))/std(Fout);
    Vout= (1 ./ (1 + exp(-sigmSlope*(Vout-sigmOffset))));
    z = (Vout-mean(Vout))/std(Vout);

    Jrec  = Jrec + deltaJCoeff * max(z*z', 0);
    if mod(ns,50) ==0 
        ns
    end
end
for i = 1:N
    Jrec(i,i) = 0;
end

save Jrecurr Jrec

keyboard