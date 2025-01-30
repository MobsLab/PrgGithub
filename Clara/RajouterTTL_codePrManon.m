
% loader le file de référence
load('Behavior.mat', 'TTL')

% se mettre dans dossier dossier files à modifier

list=dir;
    for i=1:length(list)
        if list(i).name(1)~='.' & list(i).name(1:4)=='FEAR' % condition sur nom de dossier
            cd(list(i).name)
            copyfile(['Behavior.mat'],['Behavior_sauvegarde.mat'])
            save('Behavior.mat', 'TTL', '-Append')
            
        end
        
    end
    