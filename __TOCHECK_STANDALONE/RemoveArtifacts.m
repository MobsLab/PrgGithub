function [WorkingData,speed]=RemoveArtifacts(Pos,threshold)


% try
    
    
TimeBetween2Measure=median(diff(Pos(:,1)));

WorkingData = Pos;

% Sauve les donn�es initiales pour les afficher
data1 = WorkingData;

n =length(WorkingData);
Artifacts =zeros(1, length(WorkingData));
Decalage=0;

% get variables X = PosX_cm, Y = PosY_cm, and t = time
    X = WorkingData(:,2); 
    Y = WorkingData(:,3);
    t = WorkingData(:,1);

% compute the matrix of distances between two sampled positions
deltaD = ComputeIstantaneuousDistance(X, Y);

% compute the matrix of time intervals between two sampled positions
deltaT = ComputeTimeIntervals(t);

% compute the matrix of "instantaneuous" speeds
speed = ComputeInstantaneuousSpeed(deltaD,deltaT);


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


% Remplace les points supprim�s par une moyenne avec les points restants
% voisins.
 
WorkingData=Pos;

%if ShowFlag
    
% Sauve les valeurs correspondant aux artefacts :
% La premi�re ligne correspond au temps du tracking, les autres lignes
% correspondent au temps pour lesquels des artefacts ont �t� d�tect�s.
x = find (Artifacts==1);
n=length(x);
if n~=0
    x1(1)=WorkingData(size(WorkingData,1),1);
    x1(2:n+1)= TimeBetween2Measure*(x-1);
     
end

    k=1;

    while  k <= length(WorkingData)
   % try
   
        if Artifacts(k)==1
            % k est le 1er point contenant un artefact
            if k==1 || k==length(WorkingData)
                % L'artefact est en premiere ou derniere position : on
                % supprime les donn�es correspondantes
                WorkingData (k,:) =[];
                Artifacts (k) = [];
            else
                i=k+1;
                while ( Artifacts(i)==1 && i<length(WorkingData) )
                    i=i+1;
                end
                % i est le 1er point apr�s l'artefact qui est consid�r�
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
        
%         catch 
%             keyboard
    %     end
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

speed=SmoothDec(speed,1);
% 
% catch
%     
% 
% WorkingData = Pos;
% X = WorkingData(:,2); 
% Y = WorkingData(:,3);
% t = WorkingData(:,1);
% 
% % compute the matrix of distances between two sampled positions
% deltaD = ComputeIstantaneuousDistance(X, Y);
% 
% % compute the matrix of time intervals between two sampled positions
% deltaT = ComputeTimeIntervals(t);
% 
% % compute the matrix of "instantaneuous" speeds
% speed = ComputeInstantaneuousSpeed(deltaD,deltaT);
% speed=SmoothDec(speed,1);
% 
% 
% end


