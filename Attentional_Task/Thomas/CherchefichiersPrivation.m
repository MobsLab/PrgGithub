function[databatch]=CherchefichiersPrivation(wantbatch)
titres=[];
base='C:\Users\MOBS\Desktop\Thomas\Data\Privations';
subs=subsfind(base);
subsubs=[];
for i=1:length(subs)
    subsubs=cat(1,subsubs,subsfind(subs(i)));
end
%subsubs=arrayfun(@subsfind,subs,'UniformOutput',false)
allfiles=[];
fichiers3={};
fichiers2={};
for i=1:length(subsubs)
    fichiers2={};
    fichiers=dir(num2str(subsubs{i}));
    fichiers={fichiers.name};
    fichiers(strcmp(fichiers,'.') | strcmp(fichiers,'..'))=[];
    fichiers=transpose(fichiers);
    
    %fichiers={repmat(num2str(subsubs{i}),length(fichiers),1) fichiers}
    for j=1:length(fichiers)
        id=repmat(num2str(subsubs{i}),length(fichiers),1);
        fichiers2{j,1}=fusing1(id(j,:),fichiers{j,1});
    end
    
    %fichier3=fusing2(fichiers3,fichiers2)
    
    fichiers3=[fichiers3;fichiers2];
    %fichiers2=fusing(repmat(fichiers(:,1)),fichiers{:,2})
    %fichiers2={cat(2,fichiers{:,1},fichiers{:,2})}
    %fichiers2=cat(2,mat2cell(fichiers{:,1}),cell2mat(fichiers{:,2}))
    %allfiles=cat(1,allfiles,fichiers)
end

alldata=struct;
for k=1:length(fichiers3)
    fichier=fichiers3{k,1};
    batchnumber=strsplit(fichier,{'Essai','('},'CollapseDelimiters',true);
    batchnumber=batchnumber{2};
    type=strsplit(fichier,{'(',')'},'CollapseDelimiters',true);
    type=type{2};
    id=strsplit(fichier,{'dB\','\\Souris'},'CollapseDelimiters',true);
    id=id{2};
    
    if(strcmp(type,'controle'))
        type=0;
    end
    
    if(strcmp(type,'post-privation'))
        type=1;
    end
    
    if(strcmp(type,'post-sleep'))
        type=2;
    end
    data=load(fichier);
    data=data(1).A;
    alldata(k).id=id;
    alldata(k).type=type;
    alldata(k).batch=batchnumber;
    alldata(k).data=data;
end
%alldata(find(cat(1,alldata.batch)~=batch))=[];
databatch=[];
for l=1:length(wantbatch)
    databatch=[databatch,alldata(find(cat(1,alldata.batch)==num2str(wantbatch(l))))];
end
end


function[subs]=subsfind(main)
if (iscell(main))
    main=main{1};
end
dirinfo= dir(main);
dirinfo(~[dirinfo.isdir])=[];
names={dirinfo.name};
dirinfo(strcmp(names,'.') | strcmp(names,'..'))=[];
subs=cell(length(dirinfo),1);
for k=1:length(dirinfo)
    dirname=dirinfo(k).name;
    subs{k}=fullfile(main,dirname);
end
end

function [fusedcell]=fusing1(cell1,cell2)
        fusedcell=cat(2,cell1,'\',cell2);
end

function [fusedcell]=fusing2(cell1,cell2)
        fusedcell=cat(1,cell1,cell2);
end















