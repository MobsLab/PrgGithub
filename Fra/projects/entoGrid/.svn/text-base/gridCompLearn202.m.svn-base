function gridCompLearn2



%%%%%%%%%%%%%%%%%%%% parameters


N = 576;
nSteps = 50000;

sigmSlope = 4;
sigmOffset = 1.5;

deltaJ = 2e-6;










%%%%%%%%%%%%%%%%%%%%%%%%%

load gridWaves

Nin = size(Vin, 1);
nStepsIn = size(Vin, 2);


J = exprnd(1, N, Nin);

mJ = sum(J, 2);
J = J ./ repmat(mJ, 1, Nin); % normalize the synapses to that the synapses to each neuron normalize to 1


 


% simulation loop 

% select a random grid phase for each time step
side = sqrt(Nin);

Vh = zeros(N,nSteps, 'single');


tic

pr = random('discrete uniform', nStepsIn, [1, nSteps]);

for ns = 1:nSteps
   
%     % cycle through the Vin configurations
%     nz = mod(ns, nStepsIn);
%     if nz == 0
%         nz = nStepsIn;
%     end
%     VinNow = Vin(:,nz);
    % select a random grid phase
    VinNow = Vin(:,pr(ns));
    
    Fout = J * VinNow;
    % simulate a "soft competitive learning"
    Vout = (Fout-mean(Fout))/std(Fout);
    Vout= (1 ./ (1 + exp(-sigmSlope*(Vout-sigmOffset))));
    Vh(:,ns) = Vout;
    J = J + deltaJ * Vout * VinNow';
    mJ = sum(J, 2);
    
    J = J ./ repmat(mJ, 1, Nin); % normalize the synapses to that the synapses to each neuron normalize to 1
    if mod(ns, 50) == 0
        display(ns)
%         if ns == 500
%             keyboard
%         end
    end
    
end

toc 

save Jcomp2 J Vh
keyboard
    
