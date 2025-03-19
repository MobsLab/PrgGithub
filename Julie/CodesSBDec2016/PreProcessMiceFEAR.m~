mm=0;
mm=mm+1;Filename{mm}='/media/DataMOBs55bis/FEAR_souris_Marie/intan_data/Mouse-394/';
TetrodeChans{mm}=[0:7];

m=1;
cd(Filename{m})
GetFolderName=dir;
AmplifierXMLFile=[cd filesep 'amplifier.xml'];
num=0;
clear Folders
for g=1:length(GetFolderName)
   if not(isempty(findstr(GetFolderName(g).name,'FEAR')))
      num=num+1; 
      Folders{num}=GetFolderName(g).name
   end 
end

for f=1:length(Folders)
    cd(Folders{f})
    ChansToKeep=[0:31];   ChansToKeep(ismember(ChansToKeep,TetrodeChans{m}))=[];
    load('LFPData/InfoLFP.mat')
    RefChan= InfoLFP.channel(find(strcmp(InfoLFP.structure,'Ref')));
    RefSubtraction_multi_AverageChans('amplifier.dat',32,1,'SubRefSpk', TetrodeChans{m}(:), TetrodeChans{m}(:), ChansToKeep)
    RefSubtraction_multi('amplifier_original.dat',32,1,'SubNorm', [0:31],RefChan,[]);
    
    movefile('amplifier_original_SubNorm.dat',[Folders{f} '-wideband.dat'])
    movefile('digitalin.dat',[Folders{f} '-digin.dat'])
    movefile('auxiliary.dat',[Folders{f} '-accelero.dat'])
    movefile('amplifier_SubRefSpk.dat',[Folders{f} '_SubRefSpk.dat'])
    
    copyfile(AmplifierXMLFile,[Folders{f} '.xml'])
    copyfile(AmplifierXMLFile,[Folders{f} '_SubRefSpk.xml'])

    system(['ndm_mergedat ' Folders{f}])
    system(['ndm_lfp ' Folders{f}])
    
    system(['ndm_hipass ' Folders{f} '_SubRefSpk'])
    system(['ndm_extractspikes ' Folders{f} '_SubRefSpk'])
    system(['ndm_pca ' Folders{f} '_SubRefSpk'])

for tet=1:10
   system(['KlustaKwiknew ' Folders{f} '_SubRefSpk ' num2str(tet)]) 
end
    cd ..   
end