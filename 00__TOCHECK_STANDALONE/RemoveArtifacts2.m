function WorkingData = RemoveArtifacts2 (TimeBetween2Measure,...
                                    PlatformCoordinates,...
                                    PlatformDiameter,...
                                    data, ShowFlag, ExperimentName, FileName, DayPath )



WorkingData = data;

% Sauve les données initiales pour les afficher
data1 = WorkingData;

n =length(WorkingData);
Artifacts =zeros(1, length(WorkingData));
Decalage=0;

CalibrationCorrection =0; % (=1)Corrige la calibration (=0 ne corrige pas):facteur=coord. calibrées/coord. non calibrées
if CalibrationCorrection == 1
    XFactor = 1.1223;
    YFactor = 1.1452;
    WorkingData(:,2) = WorkingData(:,2) * XFactor; % X coordinates
    WorkingData(:,3) = WorkingData(:,3) * YFactor; % Y coordinates
end

% get variables X = PosX_cm, Y = PosY_cm, and t = time
X = WorkingData(:,2); 
Y = WorkingData(:,3);
t = WorkingData(:,1);

% compute the matrix of distances between two sampled positions
deltaD = ComputeIstantaneuousDistance(X, Y);

% compute the matrix of time intervals between two sampled positions
deltaT = ComputeTimeIntervals(t);

% compute the matrix of "instantaneuous" speeds
speed = ComputeInstantaneuousSpeed( deltaD, deltaT );

% Speed threshold
threshold = 78; %cm/s

% find all items with speed values >= threshold
index = find(speed >=threshold);

while length(index) > 0
    if index(1)==1
        Artifacts(index(1)+Decalage)=1; 
        WorkingData (index(1),:)=[];
        Decalage=Decalage+1;
    else
        Artifacts(index(1)+Decalage+1)=1;
        WorkingData (index(1)+1,:) =[];
        Decalage=Decalage+1;
    end
    
    X = WorkingData(:,2);
    Y = WorkingData(:,3);
    t = WorkingData(:,1);
    
    % compute the matrix of distances between two smpled positions
    deltaD = ComputeIstantaneuousDistance(X, Y);

    % compute the matrix of time intervals between two sampled positions
    deltaT = ComputeTimeIntervals(t);

    % compute the matrix of "instantaneuous" speeds
    speed = ComputeInstantaneuousSpeed( deltaD, deltaT );
    
    % find all items with speed values >= threshold
    index = find (speed >= threshold);   

end
 
% Remplace les points supprimés par une moyenne avec les points restants
% voisins.
 
WorkingData=data;

if CalibrationCorrection == 1
    WorkingData(:,2) = WorkingData(:,2) * XFactor; % X coordinates
    WorkingData(:,3) = WorkingData(:,3) * YFactor; % Y coordinates
end

%if ShowFlag
    
% Sauve les valeurs correspondant aux artefacts :
% La première ligne correspond au temps du tracking, les autres lignes
% correspondent au temps pour lesquels des artefacts ont été détectés.
x = find (Artifacts==1);
n=length(x);
if n~=0
    x1(1)=WorkingData(size(WorkingData,1),1);
    x1(2:n+1)= TimeBetween2Measure*(x-1);
     
    % Sauve les artefacts dans un fichier
    name = FileName(1:length(FileName)-4);
    ArtefactFileName = [ DayPath, '\Artefacts\Ascii\', name, '.txt' ];
    Delimiter = {'newline', 'pc'};
    SaveFile ( x1, ArtefactFileName, Delimiter);
end

    k=1;
    while  k <= length(WorkingData)
        if Artifacts(k)==1
            % k est le 1er point contenant un artefact
            if k==1 || k==length(WorkingData)
                % L'artefact est en premiere ou derniere position : on
                % supprime les données correspondantes
                WorkingData (k,:) =[];
                Artifacts (k) = [];
            else
                i=k+1;
                while ( Artifacts(i)==1 && i<length(WorkingData) )
                    i=i+1;
                end
                % i est le 1er point après l'artefact qui est considéré
                % comme correct.
                
                if (i>=length(WorkingData))
                    % Les derniers points sont tous des artefacts : on
                    % supprime tous les points                    
                    WorkingData (k:length(WorkingData),:) = [];
                else                    
                    for j=1:i-k
                        % j est le compteur des points faux.
                        WorkingData(k+j-1,1)=WorkingData(k-1,1)+(j)*TimeBetween2Measure;
                        WorkingData(k+j-1,2)=(1-(j./(i-k+1)))*WorkingData(k-1,2)+(j./(i-k+1))*WorkingData(i,2);
                        WorkingData(k+j-1,3)=(1-(j./(i-k+1)))*WorkingData(k-1,3)+(j./(i-k+1))*WorkingData(i,3);
                        WorkingData(k+j-1,4)=0;
                    end
                end
                k=i;
            end
        else
            k=k+1;
        end
    end
    
    X = WorkingData(:,2);
    Y = WorkingData(:,3);
    t = WorkingData(:,1);
    
    %end
    
% compute the matrix of distances between two sampled positions
deltaD = ComputeIstantaneuousDistance(X, Y);
    
% compute the matrix of time intervals between two sampled positions
deltaT = ComputeTimeIntervals(t);
    
% compute the matrix of "instantaneuous" speeds
speed = ComputeInstantaneuousSpeed( deltaD, deltaT );
    
% Retire les mesures de la fin lorsque l'animal est sur la platforme
% c'est-à-dire lorsque (X,Y) dans le cercle de centre PlatformCoordinates
% et de rayon PlatformDiameter/2. On doit cependant laisser un point sur la
% plateforme.
% Mettre PlatformCorrection à 1 pour une suppression des mesures sur la
% plateforme, mettre PlatformCorrection à 0 pour laisser les données telles
% quelles
PlatformCorrection = 1;

if PlatformCorrection
    LastOnPF=0;
    Continuer=1;
    while Continuer
        % Get parameters
       
        X0 = PlatformCoordinates(1);
        Y0 = PlatformCoordinates(2);
                
        % Compute distance from platform of the last measure
        dx = WorkingData(length(WorkingData),1) - X0;
        dy = WorkingData(length(WorkingData),2) - Y0;
        distance = sqrt ( dx .* dx + dy .* dy );
        
        if distance < PlatformDiameter/2
            if LastOnPF
                WorkingData (index(1)+2,:) =[]
            end
            LastOnPF=1;
        else
            Continuer = 0;
        end
    end
end

if ShowFlag==1
    
    %%%%%%%%%%%
    % show values before and after artifact correction
    %%%%%%%%%%%
    X1 = data1(:,2); 
    Y1 = data1(:,3);
    t1 = data1(:,1);
    deltaD1 = ComputeIstantaneuousDistance(X1, Y1);
    deltaT1 = ComputeTimeIntervals(t1);
    speed1 = ComputeInstantaneuousSpeed( deltaD1, deltaT1 );
    % show animal's trajectory before artifact correction
    fig = figure(1);       
    
    % if screen resolution = 1024 x 768 pixels
    set(fig , 'Position', [10, 400, 300, 245]); 
    % if screen resolution = 1400 x 1050 pixels
    % set(fig , 'Position', [10, 550, 400, 345]); 
    
    set(gcf, 'name', 'Trajectory before artifact correction');
    plot ( X1, Y1, 'r');
    axis square;
    
    % show animal's trajectory after artifact correction
    fig = figure(2);  
    
    % if screen resolution = 1024 x 768 pixels
    set(fig , 'Position', [10, 79, 300, 245]); 
    % if screen resolution = 1400 x 1050 pixels
    % set(fig , 'Position', [10, 110, 400, 345]); 
    
    set(gcf, 'name', 'Trajectory after artifact correction');
    plot ( X, Y );
    axis square;
    
    % show speed before correction
    fig = figure(3);  
    
    % if screen resolution = 1024 x 768 pixels
    set(fig , 'Position', [700, 400, 300, 245]);
    
    % if screen resolution = 1400 x 1050 pixels
    % set(fig , 'Position', [990, 550, 400, 345]);
    
    set(gcf, 'name', 'Speeds before artifact correction');
    plot(speed1, 'r');
    axis square;
     
    % show animal's trajectory after artifact correction
    fig = figure(4);  
     
    % if screen resolution = 1024 x 768 pixels
    set(fig , 'Position', [700, 79, 300, 245]); 
    % if screen resolution = 1400 x 1050 pixels
    % set(fig , 'Position', [990, 110, 400, 345]); 
     
    set(gcf, 'name', 'Speed after artifact correction');
    plot(speed);
    axis square;
end     