function[dataessais]=CherchefichiersControle(wantessais)
wantessais=sort(wantessais);
titres=[];
base='C:\Users\MOBS\Desktop\Thomas\Data\Etape4\30dB';
subs=subsfind(base);
%subsubs=arrayfun(@subsfind,subs,'UniformOutput',false)
allfiles=[];
fichiers3={};
fichiers2={};
for i=1:length(subs)
    fichiers2={};
    fichiers=dir(num2str(subs{i}));
    fichiers={fichiers.name};
    fichiers(strcmp(fichiers,'.') | strcmp(fichiers,'..'))=[];
    fichiers=transpose(fichiers);
    
    %fichiers={repmat(num2str(subsubs{i}),length(fichiers),1) fichiers}
    for j=1:length(fichiers)
        id=repmat(num2str(subs{i}),length(fichiers),1);
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
    essainumber=strsplit(fichier,{'Essai','.mat'},'CollapseDelimiters',true);
    essainumber=essainumber{2};
    %type=strsplit(fichier,{'(',')'},'CollapseDelimiters',true);
    %type=type{2};
    id=strsplit(fichier,{'dB\','\\Souris'},'CollapseDelimiters',true);
    id=id{2};
    %{
    if(strcmp(type,'controle'))
        type=0;
    end
    
    if(strcmp(type,'post-privation'))
        type=1;
    end
    
    if(strcmp(type,'post-sleep'))
        type=2;
    end
    %}
   
    if(length(essainumber)==1)
        essainumber=cat(2,'0',essainumber);
    end
    
    data=load(fichier);
    data=data(1).A;
    alldata(k).id=id;
    %alldata(k).type=type;
    alldata(k).essai=essainumber;
    alldata(k).data=data;
end
%alldata(find(cat(1,alldata.batch)~=batch))=[];
databatch=[];
%essais=str2num(cat(1,alldata.essai));
dataessais=[];
for l=1:length(wantessais)
    for p=1:length(alldata)
        if (str2double(alldata(p).essai)==wantessais(l))
            dataessais=[dataessais;alldata(p)];
        end
    end 
    %databatch=[databatch,alldata(find(essais==num2str(wantessai(l))))];
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















