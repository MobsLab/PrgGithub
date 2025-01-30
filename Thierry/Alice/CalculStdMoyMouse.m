function [Data_std]=CalculStdMoyMouse(Data)


% -
% [data_std]=CalculStdMoyMouse(Data);
%------------------------------------------------------------------------------------------------
%
% INPUTS
% Data : la moyenne (avec ou sans restriction) du Sp du spectre que l'on
% veut moyenner, tel que Sp(i,:) correspond aux données de la souris i
%       ex : for i=1:number_of_mice
%                Data(i,:)=mean(10*(Data(Restrict(Sp{i},Wake{i}))));
%            end
%
% OUTPUTS
% Data_std : l'écart type de Data sur toutes les souris

for k=1:length(Data)
    Data_std(k)=std(Data(:,k));
end
