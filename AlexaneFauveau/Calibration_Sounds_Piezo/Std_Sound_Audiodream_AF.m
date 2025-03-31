
function [std_table] = Std_Sound_Audiodream_AF(SaveFoldername,valeur_MatLab,add_to_seuil)
% Ouvrir le bon fichier
cd(SaveFoldername)

% Pour l'audio 1
[audio, Fs] = audioread('T0000001.wav');
t = (0:length(audio)-1) / Fs ;

% Définir le seuil : 
periode_calme = audio(1:Fs*1.5); % Sélectionne les 2 premières secondes de l'enregistrement
niveau_bruit_de_fond = max(periode_calme);
seuil = (max(periode_calme) + add_to_seuil)

% Calculer la std pour chaque son 
% Make tsd
tsa = tsd(t*1e4, audio); % t en dizième de ms
figure
plot(Range(tsa,'s'),Data(tsa));
SoundEpoch = thresholdIntervals(tsa,seuil,'Direction','Above'); % above or below for direction
SoundEpoch = mergeCloseIntervals(SoundEpoch,0.15*1e4);
SoundEpoch = dropShortIntervals(SoundEpoch,0.1*1e4);
hold on,plot(Range(Restrict(tsa,SoundEpoch),'s'),Data(Restrict(tsa,SoundEpoch)));

for sd = 1:length(Start(SoundEpoch))
    if length(Start(SoundEpoch)) == length(valeur_MatLab)
    std_table(1,sd) = std(Data(Restrict(tsa,subset(SoundEpoch,sd))));
    else
        if length(Start(SoundEpoch)) == length(valeur_MatLab)-1
        std_table(1,1) = NaN;
      std_table(1,(sd+1)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd))));
        else
            if length(Start(SoundEpoch)) == length(valeur_MatLab)-2
         std_table(1,1) = NaN;
         std_table(1,2) = NaN;
      std_table(1,(sd+2)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
            else
                if length(Start(SoundEpoch)) == length(valeur_MatLab)-3
                    std_table(1,1) = NaN;
                    std_table(1,2) = NaN;
                    std_table(1,3) = NaN;
      std_table(1,(sd+3)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
                else
                    if length(Start(SoundEpoch)) == length(valeur_MatLab)-4
                    std_table(1,1) = NaN;
                    std_table(1,2) = NaN;
                    std_table(1,3) = NaN;
                    std_table(1,4) = NaN;
      std_table(1,(sd+4)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
                    else
                       if length(Start(SoundEpoch)) == length(valeur_MatLab)-5
                            std_table(1,1) = NaN;
                            std_table(1,2) = NaN;
                            std_table(1,3) = NaN;
                            std_table(1,4) = NaN;
                            std_table(1,5) = NaN;
      std_table(1,(sd+5)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
                       else
                           if length(Start(SoundEpoch)) == length(valeur_MatLab)-6
                            std_table(1,1) = NaN;
                            std_table(1,2) = NaN;
                            std_table(1,3) = NaN;
                            std_table(1,4) = NaN;
                            std_table(1,5) = NaN;
                            std_table(1,6) = NaN;
      std_table(1,(sd+6)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
                           else
                           if length(Start(SoundEpoch)) == length(valeur_MatLab)-7
                            std_table(1,1) = NaN;
                            std_table(1,2) = NaN;
                            std_table(1,3) = NaN;
                            std_table(1,4) = NaN;
                            std_table(1,5) = NaN;
                            std_table(1,6) = NaN;
                            std_table(1,7) = NaN;
      std_table(1,(sd+7)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
                       else
                            disp('Error') 
                           end
                           end
                       end
                    end
                end
            end
        end
    end
end

% Pour l'audio 2
[audio, Fs] = audioread('T0000002.wav');
t = (0:length(audio)-1) / Fs ;

% Définir le seuil : 
periode_calme = audio(1:Fs*1.5); % Sélectionne les 2 premières secondes de l'enregistrement
niveau_bruit_de_fond = max(periode_calme);
seuil = (max(periode_calme) + add_to_seuil)

% Calculer la std pour chaque son 
% Make tsd
tsa = tsd(t*1e4, audio); % t en dizième de ms
% figure
% plot(Range(tsa,'min'),Data(tsa));
SoundEpoch = thresholdIntervals(tsa,seuil,'Direction','Above'); % above or below for direction
SoundEpoch = mergeCloseIntervals(SoundEpoch,0.1*1e4);
SoundEpoch = dropShortIntervals(SoundEpoch,0.1*1e4);
% hold on,plot(Range(Restrict(tsa,SoundEpoch),'min'),Data(Restrict(tsa,SoundEpoch)));

for sd = 1:length(Start(SoundEpoch))
    if length(Start(SoundEpoch)) == length(valeur_MatLab)
    std_table(2,sd) = std(Data(Restrict(tsa,subset(SoundEpoch,sd))));
    else
        if length(Start(SoundEpoch)) == length(valeur_MatLab)-1
        std_table(2,1) = NaN;
      std_table(2,(sd+1)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd))));
        else
            if length(Start(SoundEpoch)) == length(valeur_MatLab)-2
         std_table(2,1) = NaN;
         std_table(2,2) = NaN;
         std_table(2,(sd+2)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
            else
                if length(Start(SoundEpoch)) == length(valeur_MatLab)-3
                  std_table(2,1) = NaN;
               std_table(2,2) = NaN;
            std_table(2,3) = NaN;
                std_table(2,(sd+3)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
                else
                    if length(Start(SoundEpoch)) == length(valeur_MatLab)-4
                    std_table(2,1) = NaN;
                    std_table(2,2) = NaN;
                    std_table(2,3) = NaN;
                    std_table(2,4) = NaN;
      std_table(2,(sd+4)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
                    else
                       if length(Start(SoundEpoch)) == length(valeur_MatLab)-5
                            std_table(2,1) = NaN;
                            std_table(2,2) = NaN;
                            std_table(2,3) = NaN;
                            std_table(2,4) = NaN;
                            std_table(2,5) = NaN;
      std_table(2,(sd+5)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
                       else
                           if length(Start(SoundEpoch)) == length(valeur_MatLab)-6
                            std_table(2,1) = NaN;
                            std_table(2,2) = NaN;
                            std_table(2,3) = NaN;
                            std_table(2,4) = NaN;
                            std_table(2,5) = NaN;
                            std_table(2,6) = NaN;
      std_table(2,(sd+6)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
                            else
                                if length(Start(SoundEpoch)) == length(valeur_MatLab)-7
                            std_table(2,1) = NaN;
                            std_table(2,2) = NaN;
                            std_table(2,3) = NaN;
                            std_table(2,4) = NaN;
                            std_table(2,5) = NaN;
                            std_table(2,6) = NaN;
                            std_table(2,7) = NaN;
      std_table(2,(sd+7)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
                       else
            disp('Error')
                                end
                           end
                       end
                    end 
                end
            end
        end
    end
end

% Pour l'audio 3
[audio, Fs] = audioread('T0000003.wav');
t = (0:length(audio)-1) / Fs ;

% Définir le seuil : 
periode_calme = audio(1:Fs*1.5); % Sélectionne les 2 premières secondes de l'enregistrement
niveau_bruit_de_fond = max(periode_calme);
seuil = (max(periode_calme) + add_to_seuil)
% Calculer la std pour chaque son 
% Make tsd
tsa = tsd(t*1e4, audio); % t en dizième de ms
% figure
% plot(Range(tsa,'min'),Data(tsa));
SoundEpoch = thresholdIntervals(tsa,seuil,'Direction','Above'); % above or below for direction
SoundEpoch = mergeCloseIntervals(SoundEpoch,0.1*1e4);
SoundEpoch = dropShortIntervals(SoundEpoch,0.1*1e4);
% hold on,plot(Range(Restrict(tsa,SoundEpoch),'min'),Data(Restrict(tsa,SoundEpoch)));

for sd = 1:length(Start(SoundEpoch))
    if length(Start(SoundEpoch)) == length(valeur_MatLab)
    std_table(3,sd) = std(Data(Restrict(tsa,subset(SoundEpoch,sd))));
    else
        if length(Start(SoundEpoch)) == length(valeur_MatLab)-1
        std_table(3,1) = NaN;
      std_table(3,(sd+1)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd))));
        else
            if length(Start(SoundEpoch)) == length(valeur_MatLab)-2
         std_table(3,1) = NaN;
                std_table(3,2) = NaN;
      std_table(3,(sd+2)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
            else
                if length(Start(SoundEpoch)) == length(valeur_MatLab)-3
                  std_table(3,1) = NaN;
                std_table(3,2) = NaN;
                std_table(3,3) = NaN;
      std_table(3,(sd+3)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
                else
                    if length(Start(SoundEpoch)) == length(valeur_MatLab)-4
                    std_table(3,1) = NaN;
                    std_table(3,2) = NaN;
                    std_table(3,3) = NaN;
                    std_table(3,4) = NaN;
      std_table(3,(sd+4)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
                    else
                       if length(Start(SoundEpoch)) == length(valeur_MatLab)-5
                            std_table(3,1) = NaN;
                            std_table(3,2) = NaN;
                            std_table(3,3) = NaN;
                            std_table(3,4) = NaN;
                            std_table(3,5) = NaN;
      std_table(3,(sd+5)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
                       else
                           if length(Start(SoundEpoch)) == length(valeur_MatLab)-6
                            std_table(3,1) = NaN;
                            std_table(3,2) = NaN;
                            std_table(3,3) = NaN;
                            std_table(3,4) = NaN;
                            std_table(3,5) = NaN;
                            std_table(3,6) = NaN;
      std_table(3,(sd+6)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
                           else
                           if length(Start(SoundEpoch)) == length(valeur_MatLab)-7
                            std_table(3,1) = NaN;
                            std_table(3,2) = NaN;
                            std_table(3,3) = NaN;
                            std_table(3,4) = NaN;
                            std_table(3,5) = NaN;
                            std_table(3,6) = NaN;
                            std_table(3,7) = NaN;
      std_table(3,(sd+7)) = std(Data(Restrict(tsa,subset(SoundEpoch,sd)))); 
                           else
                               disp('Error')
                           end
                           end
                       end
                    end
                end
            end
        end
    end
end

% Faire la moyenne pour la chambre :
for sd = 1:32
    std_table(4,sd) = mean(std_table(1:3,sd),1);
end


for sd = 1:length(std_table)
    std_table(6,sd) = valeur_MatLab(5,sd);
end
for colonne = 1:length(std_table)
    std_table(5, colonne) = 8.736 * log(std_table(4, colonne)) + 110.7;
end
for colonne = 1:length(std_table)
    std_table(7, colonne) = 8.736 * log(std_table(1, colonne)) + 110.7;
end
for colonne = 1:length(std_table)
    std_table(8, colonne) = 8.736 * log(std_table(2, colonne)) + 110.7;
end
for colonne = 1:length(std_table)
    std_table(9, colonne) = 8.736 * log(std_table(3, colonne)) + 110.7;
end