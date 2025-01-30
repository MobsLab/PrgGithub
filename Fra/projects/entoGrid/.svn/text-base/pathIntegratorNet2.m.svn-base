function pathIntegratorNet()



Simulation = 'TriangularPathIntegrator';

switch Simulation
    
    
         
    case 'TriangularPathIntegrator'

        synapticMatrix = 'TriangularPeriodic';

        initialization = 'ToMap';

        outputDisplay = 'Video';
        tVideoInit = 6;
        tVideoEnd = 400;
        
        trajectory = 'Linear';

        externalInput = 'HeadDirection';

        plasticity = 'None';

        output = 'None';

        InhibitionType= 'FixedActivity';

        VideoFeatures = {'RatVideo'};
        %%%% parameters for the simulations

        latticeSpacing = 40; % unit is "centimeters"
        connectionSpan = 13; % the spread of the conncetion matrix
        connectionSpanD = 7;
        N = 1000;  % the number of cells
        nSteps =5000; % the number of random walk steps
        nLaps = nSteps/2000;
        cageSize = 100; % the size of the rat "cage"
        G = 20; % the gain of the threshold-linear function
        threshold = 0.5; % the threshold of the threshold-linear function

        fixAct = 2; % the maximum average activity allowed by the inhibition mechanism
        gamma = 0.3; % the relative importance of the asymmetric component in the synapric matrix
        dT = 1; % time step at each iteration (a bit redundant, in practise we keep it at one)
        tau = 50; % the time constant

        dirStrength = 0.01; % the strength of the directional input
        nonDirInput = 5;


        % neural adaptation is modeled as a subtractive term that
        %depends on the activity in the last Tadapt time steps (linearly decaying) and
        % with a strength Kadapt: A = - (Kadapt/Tadapt) \int_{t-Tadapt}^{t} dt' V(t') (t'-t+Tadapt)
        Tadapt = 500;
        Kadapt = 0.05;

        % we save the activity every monitorStep time steps
        monitorStep = 10;

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if strcmp(externalInput, 'GridPlace') | strcmp(outputDisplay, 'VideoImage')
    load Jcomp
    ix = find(sum(Vtot,1) >80);
    N = length(ix);
    Vtot = Vtot(:,ix);
end







 

switch synapticMatrix
    
    case 'Load'
        
        load SMatrix
        N = size(J, 1);
    case 'LoadJComp'
        load Jcomp
         % get rid of "autapses"
        for i = 1:N
            J(i,i) = 0;
        end
        
        J(find(J < 0)) = 0;
        % normalize J so that the rows sum on average to 1
         Jnorm = abs(mean(sum(J,2)))
         J = J / Jnorm;
         J(find(J > 1e-3)) = 1e-3;
         
    case 'TriangularPeriodic'


        % set up the place on the grid of  each cell, so that
        % they will be uniformly distributed in the triangular lattice




        % first draw points in a equilateral triangle


        %         x = rand(1,N) - 0.5;
        %         y = rand(1, N) * sqrt(3) / 2;
        %
        %         while(nd)
        %             % points falling outside the triangle)
        %             ndix = find(y > sqrt(3) * (x+0.5) | y  > -sqrt(3) * (x - 0.5));
        %             nd = length(ndix);
        %             x(ndix) = rand(1,nd)- 0.5;
        %             y(ndix) = rand(1,nd) * sqrt(3)/2;
        %
        %         end
        %
        %
        %         % move half of the points in the symmetric triangle on the other side
        %         % of the X-axis
        %
        %         y(floor(N/2):N) = -y(floor(N/2):N);
        %         x = x * latticeSpacing;
        %         y = y * latticeSpacing;
        %
        %         axis equal


        v1 = [0.5, sqrt(3)/2];
        v2 = [0.5, -sqrt(3)/2];
        M = [v1;v2];
        sz = (ceil(sqrt(N)));
        N = sz^2;
        vx = linspace(0,sz/(sz+1),sz);


        [x,y] = meshgrid(vx, vx);
        vq = [x(:),y(:)];
        vm = vq * M;
        x = (vm(:,1)-0.5)*latticeSpacing;
        y = (vm(:,2))*latticeSpacing;
          
        % now compute synaptic matrix
        % the preferred direction for each cell, uniformly distributed on [0, 2 \pi]
        phi = rand(1,N)*2*pi;
        
               % The versor for each cell
        dirCell = [cos(phi) ; sin(phi)];
        % to keep into accoutn the periodic conditions we need to sum terms
        % corresponding to several lattice basis vectors, in practice we get two on each
        % side, connections decay with a constant smaller than lattice spacing, so this
        % is
        J = zeros(N, N);

        % lattice basis vectors
        v1 = [1, 0] * latticeSpacing;
        v2 = [0.5, sqrt(3)/2] * latticeSpacing;


        % J_{ij} = (1 + \gamma \cos(phi_j - \atan(\vector{d_i} - \vector{d_j})))
        % exp(- | d_i - d_j | /latticeSpacing) + terms coming from the periodic
        % bondary conditions

        % a few meshgrid tricks to "vectorize" the synaptic matrix generation

        [X, Y] = meshgrid(x,y);
        Y = Y';
        [Phi,phiY] = meshgrid(phi,phi);
        for i = -2:2
            for j = -2:2
                [XC, YC] = meshgrid(x+i*v1(1)+j*v2(1), ...
                    y+i*v1(2)+j*v2(2));
                XC = XC';

                zeta = atan2(YC-Y, XC-X);

                D = sqrt((X-XC).^2 + (Y-YC).^2);
                J = J + exp(-D  /connectionSpan) + gamma * cos(zeta-Phi) .* D.* exp(-D  /connectionSpan)/connectionSpan;
                %J = J + exp(-D * (1 )/connectionSpan);
                %          if i == 0 & j == 0
                %              keyboard
                %          end

            end
        end

        % get rid of "autapses"
        for i = 1:N
            J(i,i) = 0;
        end


        % normalize J so that the rows sum on average to 1
        Jnorm = mean(sum(J,2));
        J = J / Jnorm;
        
        figure
        imagesc(J);
        clear X Y XC YC zeta D Phi phiY M
        save SMatrix J x y phi dirCell
       


end

 %%%% end synaptic matrix
 

 
 if strcmp(externalInput, '2DPlace')
    % input is given by a layer of place cells with p.f.c.s on a 20x20 grid
    % the synapses from this layer to the grid cell layer are random with
    % exponential distribution
    
    l = sqrt(Ninp);

    xx = linspace(0, cageSize, l+1);
    xx = xx(1:end-1);
    yy = xx;
    [XX, YY]  = meshgrid(xx, yy);
    xInp = (XX(:));
    yInp = (YY(:));
    clear xx yy XX YY
    
    Jinp = rand( N, Ninp);
    
     
     
     ;
 end
 



 if strcmp(output, 'CompLearn')
     Jout = rand(Nout, N);
     Jout = reshape((Jout < outputLayerConn), Nout, N);
     Jnorm = mean(sum(Jout,2));
     Jout = Jout / Jnorm;
     Jcomp = zeros(Nout, Nout);
     
     vOutConf = zeros(Nout, floor(nSteps)/monitorStep);
 end
 
     
 
 
 Vi = zeros(N,1);
 Va = zeros(N, 10);
 Vadapt=zeros(N, Tadapt);
 

 switch initialization

     case 'ToMap'
         %initialize the network in a state where only cells in the center of grid
         %cell are active
         % this is still a bit of a problem: the system takes a while to settle on
         % the activity packet-attractor


         Vi = 3* exp(-sqrt((x).^2+(y).^2)/(latticeSpacing/10));
         Vi / mean(Vi) * fixAct;
     
     case 'Random'
         %Vi = 20 * exprnd(1, N, 1);
         Vi = 0.02* rand(N, 1);
 end

% save the history of the activity configurations
Vconf = zeros(N, floor(nSteps)/monitorStep, 'single');

% generate the rat trajectory

switch trajectory
    case 'RandomWalk'
        [xRat, yRat] = randomWalk(nSteps+500, cageSize);
        xRat = xRat(501:end);
        yRat = yRat(501:end);
    case 'Linear'
        yRat = cageSize /2 * ones(1, nSteps);
        xRat = linspace(0, nLaps*2*pi, nSteps);
        xRat = cageSize/2*(1+sin(xRat));
        
end

% instantaneous rat speed 
vRat = [diff(xRat) ; diff(yRat)];

xRat = xRat(2:end);
yRat = yRat(2:end);

% for the adaptation calculation 
adaptScale = (linspace(0, Kadapt/Tadapt, Tadapt))';
mm = 0;

 if strcmp(externalInput, 'GridPlace')
         Jcomp = Jcomp/size(Jcomp, 2);
     Jcomp = Jcomp(ix,:);
     phaseX = ceil(xRat);
     phaseY = ceil(yRat);
 end
tic


Ci = exp(-dT/tau);
CiM = 1 - Ci;
% main simulation loop
 for ns = 1:(nSteps-1)

     mm = mod(ns, Tadapt);
     if(mm == Tadapt)
         mm = 0;
     end

     % adaptation: Vadapt is a "ring buffer" so that we optimize away 
     as = [adaptScale(end-mm:end) ; adaptScale(1:(end-mm-1))];
     A = Vadapt * as;
    
    % save previous configuration
    Viold = Vi;
    
    
    switch externalInput
        case 'HeadDirection'
            % the directional input is proportional to the scalar product of the
            % speed and the directional versor of each cell 
            extInp = nonDirInput + dirStrength * ((vRat(:,ns))'*dirCell)';
            extInp(extInp < 0) = 0; % rectfy inputs
            
        case 'Ramp'
            extInp = ones(size(N)) *  (ns/nSteps) * rampInputStrength;
           
        case 'Constant'
            extInp = ones(size(N)) * constInputStrength;
            
        case '2DPlace'
            d = sqrt((xInp - xRat(ns)) .^ 2 +  (yInp - yRat(ns)).^2);
            extInp = constInputStrength + placeInputStrength * Jinp * exp(-d/inputActivationSpread);
            
        case 'GridPlace'
            load gridTemplate
            % we move to a different input phase every monitorStep steps
            if mod(ns, monitorStep) == 1
                px = phaseX(ceil(ns/monitorStep));
                py = phaseY(ceil(ns/monitorStep));
                Vin = gridTemplate(px:(px+side-1),py:(py+side-1));
                extInp = placeInputStrength * Jcomp * Vin(:);
            end
    end
    
    % compute input to each neuron: recurrent synaptic + directional input - adaptation 
    F = J * Vi + extInp - A;
    
    Vfield = max(G.*(F-threshold), 0);
    % compute activation without inhibition 
    Vi = CiM * Vfield + Ci * Viold;

    if(ns > 20)
        2;
    end
    
    
    switch InhibitionType
        case 'FixedActivity'
            
            % compute the global inhibition that will take the totla activity to
            % fixAct * N, the "sort" trick gets around the threshold-linear
            % nonlinearity
            VfieldThr= N * fixAct- Ci*sum(Viold);
            
            Vs = sort(Vfield);
            Vs = Vs(end:-1:1);
            Q = cumsum(Vs) - ((1:N)') .* Vs;

            Qix = min(find(Q > N*fixAct));
            
%             if isempty(Qix)
%                 Qix = 600;
%             end
            
           
            if isempty(Qix) & sum(Vi) > N * fixAct
                Qix = N;
            end
            Qix = min(Qix, 300);
            if isempty(Qix)
                inhib = 0;
            else
                inhib = Vs(Qix)/ (mean(G));
            end


            % now compute the "inhibited" activation
            F = F - inhib;
            Vi = CiM * max(G.*(F-threshold), 0) + Ci * Viold;
        case 'Noglobal'
            inhib = 0;
    end
    
    % save activity
    mm = mod(ns, monitorStep);
    if mm == 0
        mm = monitorStep;
    end
    Va(:,mm) = Vi;

    %every monitorStep steps average activtiy and store the result in Vconf
    if mm == monitorStep
        Vconf(:,ns/monitorStep) = mean(Va, 2);
             
 
    end

   
    
    if mod(ns, 50) == 0
        disp(ns);
        disp(sum(Vi)/N);
    end

    
    % save buffer for adaptation

    ma = mod(ns, Tadapt);
    if ma == 0
        ma = Tadapt;
    end
    Vadapt(:,ma) = Vi;


        
 end
 

 toc
 
dx = dirCell(1,:);
dy = dirCell(2,:);

vr = vRat(:,1:monitorStep:end);
xx = xRat(1:monitorStep:end);
yy = yRat(1:monitorStep:end);



 if strcmp(Simulation, 'HexLearn')
     save SMatrix J
 end
 
 save Vconf Vconf x  y monitorStep xRat yRat xx yy
 
 
 switch outputDisplay

         
  
     case 'Video'
          np = 1;
           tInit = tVideoInit;
           tEnd = tVideoEnd;
         %video generation
         for i = tInit:tEnd
             
             
             plotColors(x, y, Vconf(:,i), 10), axis equal % activation as a function of position on the grid
             hold on;
             axis([-40 40 -30 30]);
             if ismember('RatVideo', VideoFeatures)
                 plot(-30 + 10*cos(0:0.1:2*pi), 20 + 10* sin(0:0.1:2*pi)); % Rat inst. speed
                 plot([-30, -30+50*vr(1,i)], [20, 20+50*vr(2,i)])
                 plotColors(-30+10*dx, -20+10*dy, Vconf(:,i), 10); % activation as a fucntion of directional preference
                 
                 % rat position
                 plot([20 40], [-10 -10 ]);
                 plot([20 20], [-10 -30]);
                 mi = max(i-50, tInit);
                 plot(xx(mi:i)/5+20, yy(mi:i)/5-30);
                 plot(xx(i)/5+20, yy(i)/5-30, 'r.');
             end
             text(20, 25, num2str(i));
             hold off
             M(np) = getframe;
             np = np+1;
         end
        
        save simOutput Vconf dirCell 
         movie2avi(M, 'Packet.avi', 'FPS', 6, 'COMPRESSION', 'None');
     case 'None'
         ;
 end

 
 if strcmp(output, 'CompLearn')
     save Jcomp Jcomp
     keyboard
 end
 
% shamelessly copied  from Ole 
function y = mexhat(x, sig)

y = (1 -  x.^2/sig^2).*exp(-x.^2 / (2*sig^2));
