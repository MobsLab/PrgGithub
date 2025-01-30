% ParcoursFluoIntraGLR

cd H:\GFEC-P20_GFP\FluoIntraG

listdir=dir('Cell1');
% listdir=dir('Cell2');
% listdir=dir('Cell3');
% listdir=dir('Cell4');

% a=1;

   Rt=[];
   Rt2=[];

        
        
for Filenum=1:length(listdir)
   
    cd 'H:\GFEC-P20_GFP\FluoIntraG\Cell1'
%     cd 'H:\GFEC-P20_GFP\FluoIntraG\Cell2'
%     cd 'H:\GFEC-P20_GFP\FluoIntraG\Cell3'
%     cd 'H:\GFEC-P20_GFP\FluoIntraG\Cell4'
    
    if listdir(Filenum).isdir==1&listdir(Filenum).name(1)~='.'    %doit être un dossier et sa 1ère lettre différente d un point

        cd (listdir(Filenum).name)

        [R,R2]=FluoIntraGSingleCellLR;
        Rt=[Rt;R];
        Rt2=[Rt2;R2];
        clear R R2
    
    
    end
    
    
    
end

cd 'H:\GFEC-P20_GFP\FluoIntraG\Cell1'
% cd 'H:\GFEC-P20_GFP\FluoIntraG\Cell2'
% cd 'H:\GFEC-P20_GFP\FluoIntraG\Cell3'
% cd 'H:\GFEC-P20_GFP\FluoIntraG\Cell4'

save Results Rt Rt2
    
   