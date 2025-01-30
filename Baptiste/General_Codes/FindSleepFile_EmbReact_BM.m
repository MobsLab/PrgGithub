
function Path = FindSleepFile_EmbReact_BM(Mouse,Sess)

Mouse_names{1}=['M' num2str(Mouse(1))];
load('/media/nas6/ProjetEmbReact/transfer/Sess.mat')
SleepSess = Sess.(Mouse_names{1})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{1}) ,'Sleep')))));

Path = SleepSess{1};

end