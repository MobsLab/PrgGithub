disp('Chargement des fichiers de donn�es');
load('data/spikes.mat')
load('data/positions.mat')

positions = [posX(:,2), posY(:,2)];

if size(spikes,2) > 167
    spikesA = spikes([10, 12, 22, 26, 36, 37, 38, 39, 49, 58, 63, 66, 68, 70, 122, 135, 136, 144, 146, 167]); %uniquement un �chantillon des "meilleures" CL s�lectionn�es visuellement, grossi�rement
    spikesBR = spikes([7, 10, 12, 12, 14, 15, 16, 20, 21, 22, 23, 26, 33, 36, 37, 38, 39, 49, 58, 60, 63, 66, 64, 68,...
    70, 78, 106, 115, 116, 118, 122, 123, 125, 130, 131, 134, 135, 136, 144, 145, 146, 148, 156, 157, 167]); %uniquement un �chantillon des "bonnes" CL s�lectionn�es visuellement, grossi�rement
spikesC = spikes; %toutes les CL

spikes = spikesA; %donn�es par d�faut
end
