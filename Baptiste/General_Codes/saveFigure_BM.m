function saveFigure_BM(n,title,Dossier)

% pour sauver les figure en png et en epx 
% utilisation saveFigure(n,title,Dossier)
% n : le numero de la figure que tu veux sauver
% title : le nom que tu veux donner a la figure
% Dossier : le dossier dans lequel tu veux sauver la figure
% ex: saveFigure(3,'FigureTitle','/Path/To/Save/Figure')

res=pwd;


set(n,'paperPositionMode','auto')

try
    eval(['print -f',num2str(n),' -dpng ', Dossier filesep title,'.png'])
    saveas(n,[Dossier filesep title '.fig'])
    saveas(n,[Dossier filesep title '.svg'])
    eval(['print -f',num2str(n),' -painters',' -depsc2 ',Dossier filesep title,'.eps'])
catch
    disp('ERROR')
end

end