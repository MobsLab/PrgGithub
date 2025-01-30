function gridCompLearn()



%%%%%%%%%%%%%%%%%%%% parameters


N = 2500;
nSteps = 100000;

sigmSlope = 4;
sigmOffset = 2.0;

deltaJ = 0.01;










%%%%%%%%%%%%%%%%%%%%%%%%%

load gridTemplate 

Nin = (size(gridTemplate, 1)/2) ^ 2;

J = exprnd(1, N, Nin);

mJ = mean(J, 2);
J = J ./ repmat(mJ, 1, N); % normalize the synapses to that the synapses to each neuron normalize to 1





% simulation loop 

% select a random grid phase for each time step
side = sqrt(Nin);

phaseX = random('discrete uniform', side, 1, nSteps);
phaseY = random('discrete uniform', side, 1, nSteps);


for ns = 1:nSteps
    % select a random grid phase
    px = phaseX(ns);
    py = phaseY(ns);
    
    Vin = gridTemplate(px:(px+side-1),py:(py+side-1));
    Vin = Vin(:);
    Fout = J * Vin;
    % simulate a "soft competitive learning"
    Vout = (Fout-mean(Fout))/std(Fout);
    Vout= (1 ./ (1 + exp(-sigmSlope*(Vout-sigmOffset))));
    J = J + deltaJ * Vout * Vin';
    mJ = mean(J, 2);
    
    J = J ./ repmat(mJ, 1, N); % normalize the synapses to that the synapses to each neuron normalize to 1
    if mod(ns, 50) == 0
        display(ns)
%         if ns == 500
%             keyboard
%         end
    end
    
end

toc 
keyboard

xx = 1:50;
yy = 1:50;
[XX, YY]  = meshgrid(xx, yy);
x = (XX(:))';
y = (YY(:))';

for i = 1:2500

    phaseX = x(i);
    phaseY = y(i);
    
    Vin = gridTemplate(phaseX:(phaseX+side-1),phaseY:(phaseY+side-1));
    Vin = Vin(:);
    Fout = J * Vin;
    % simulate a "soft competitive learning"
    Vout = (Fout-mean(Fout))/std(Fout);
    Vout= (1 ./ (1 + exp(-sigmSlope*(Vout-sigmOffset))));
    Vtot(i,:) = Vout;
end

[m, im] = max(Vtot,[], 1);

Jcomp = J;
save Jcomp Jcomp Vtot x y 
toc
  keyboard
    
