function Tracking_OnlinePlaceField

%% Declaration des variables globales

% Get global variables that are common to all codes --> code comes from
global TrObj % the video object
global TrObjLocal
if iscell(TrObj)
TrObjLocal = TrObj{1};
else
    TrObjLocal = TrObj;
end

global Stimulator PulsePalSystem nBytesAvailable % Stimulator type


% see Gen_Track_ObjectOrientated
% Tracking parameters
global BW_threshold; BW_threshold=0.5; 
global smaller_object_size; smaller_object_size=30; 
global sm_fact; sm_fact=0; 
global strsz se; strsz=4; se= strel('disk',strsz);
global SrdZone; SrdZone=20;
% see Gen_Track_ObjectOrientated

%% Variables that are specific to this code
global arreter
global occupation
global carte_spike
global cell_map
global RGBoccupation
global RGBcarte_spike
global RGBcell_map
global etat_enregistrement
global color_off
global color_on

global parametres %param�tres interessants de l'exp�rience
global name_folder %nom du fichier dans lequl on sauve les donn�es
global last_experiment

global handles
global hpop
global t0 % limiter la manip � une demi heure
global premier_acq % la manip se lance d�s a premi�re fois qu'on appuie sur start/stop
global numero %boite contenant le numero affich� en bas de l'interface graphique
global num_exp % numero de l'experience en cours au correctif pr�s
global correctif % pour sauver le bon numero de fichier
global prefac0 %prefacteur servant � mettre le bon nombre de 0 dans le numero
global n
global nodetect
global nb_canaux
global nb_ttl
global num_canal;
global redemarre


%% initialisations 
duree_max=Inf; %dur�e de l'enregistrement max
redemarre=0;
num_canal=1;
correctif=0;
num_exp=0;
nb_canaux=8;
nb_ttl=zeros(1,nb_canaux);
premier_acq=0;
etat_enregistrement = 0;
arreter = 0;
nodetect=1;
color_off = [ 0.5 0.5 0.5];
color_on = [ 0 0 0];
for o=1:nb_canaux
    canal{o}=num2str(o);
end

%% Variables that are specific to this code
% General thresholds and display
global guireg_fig
global time_image;time_image = 1/TrObjLocal.frame_rate;
global UpdateImage; UpdateImage=ceil(TrObjLocal.frame_rate/5); % update every n frames the picture shown on screen to show at 10Hz
global writerObj  % allows us to save as .avi
global enableTrack % Controls whether the tracking is on or not
global DoorChangeMat % Matrix of times at which the door was moved
global ShTN; ShTN=1; % Variable that count the shocks

% Variables for plotting
global thimmobline % line that shows current freezing threshold
global PlotFreez % the name of the Plot that shows im_diff
global StartChrono, StartChrono=0; % Variable set to one when the tracking begins
% the handle of the chronometer object
global PlotForVideo % the plot that will be saved to .avi if needed
global GuiForUmaze % slides with specific values for UMaze 
global color_on; color_on=[0 0 0];

global ExpeInfo
% contains
% - nmouse : number of current mouse
% - lengthPhase : duration of current phase
% - nPhase : number of current phase
% - enableTrack 
% - name_folder : current folder for saving
% - Fname : current foldre in which individual frames are saved

global KeepTime 
KeepTime.t1=clock;
KeepTime.t2=clock;
% contains 
% - t1,t2 for tracking time between frames 
% - tDeb for tracking length of session ; ...
% - LastStim to recall when alst stimulation was given
% - chrono to dsplay passing of time


% Freezing detection
global th_immob; th_immob=20; 
global thtps_immob; thtps_immob=2;
global maxyaxis ymax; maxyaxis=500;ymax=50;
global maxfrvis;maxfrvis=800;
global maxth_immob; maxth_immob=200 ;

% Time/date parameters
t=clock;
jour=num2str(t(3));if length(jour)==1, jour=cat(2,'0',jour);end
mois=num2str(t(2));if length(mois)==1, mois=cat(2,'0',mois);end
annee=num2str(t(1));
ExpeInfo.TodayIs=[jour mois annee];clear t jour mois annee

% arduino 
global a % the arduino
global arduinoDictionary % list of numbers to send to arduino for each case
arduinoDictionary.On=1;
arduinoDictionary.Off=3;
arduinoDictionary.SoundStim=5;
arduinoDictionary.Sound=7;
arduinoDictionary.SendStim=9;
arduinoDictionary.ThousandFrames=2;

%% taille carte occupation
nx = 32;
ny = 24;

%%  Cr�ation de l'interface graphique

% Cr�ation de l'objet Figure
handles(1)=figure('units','normalized',...
    'position',[0.1 0.1 0.8 0.8],...
    'numbertitle','off',...
    'name','Online Mouse Tracking',...
    'menubar','none',...
    'tag','interface');
set(handles(1),'Color',color_off);
set(handles(1),'CloseRequestFcn',@fermeture)


% BOUTON Start/Stop
handles(4)=uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.65 0.08 0.05],...
    'string','Start/Stop',...
    'tag','allumage',...
    'callback', @on_off);

% BOUTON Fermeture
handles(5)=uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[0.01 0.5 0.08 0.05],...
    'string','Fermeture',...
    'tag','fermeture',...
    'callback', @fermeture);

% BOUTON Reset Occupation
handles(6)=uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[0.8 0.52 0.1 0.05],...
    'string','Reset Occupation',...
    'tag','reset_occupation',...
    'callback', @reset_occupation);

% BOUTON Reset Spike Global
handles(7)=uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[0.89 0.04 0.1 0.05],...
    'string','Reset Spike Global',...
    'tag','reset_occupation2',...
    'callback', @reset_occupation2);

% BOUTON Reset Spike Local
handles(8)=uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[0.78 0.04 0.1 0.05],...
    'string','Reset Spike Local',...
    'tag','reset_occupation3',...
    'callback', @reset_occupation3);

% BOUTON Reset Total
handles(9)=uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[0.3 0.04 0.1 0.05],...
    'string','Reset Total',...
    'tag','reset_total',...
    'callback', @reset_occupation4);


%TEXTES
handles(10)=uicontrol('style','text', ...
    'units','normalized',...
    'position',[0.67 0.52 0.1 0.05],...
    'string','Carte Occupation');

handles(11)=uicontrol('style','text', ...
    'units','normalized',...
    'position',[0.67 0.04 0.1 0.05],...
    'string','Carte Spike');

handles(12)=uicontrol('style','text', ...
    'units','normalized',...
    'position',[0.47 0.07 0.1 0.03],...
    'string','Canal N�');

handles(13)=uicontrol('style','text', ...
    'units','normalized',...
    'position',[0.18 0.04 0.1 0.05],...
    'string','Cell Field');

handles(14)=uicontrol('style','text', ...
    'units','normalized',...
    'position',[0.24 0.52 0.1 0.05],...
    'string', 'Video');
%FIN TEXTES


% Menu choix du canal
hpop=uicontrol('style', 'popupmenu',...
    'units','normalized',...
    'string', canal,...
    'Position', [0.47 0.02 0.1 0.03],...
    'callback', @choix_canal);

%choix du num�ro de l'exp�rience
numero.edit=uicontrol('style','edit', ...
    'units','normalized',...
    'position',[0.01 0.84 0.08 0.05],...
    'string',num2str(num_exp));

%bouton N�exp
uicontrol('style','pushbutton', ...
    'units','normalized',...
    'position',[0.01 0.9 0.08 0.05],...
    'string', ' N�exp',...
    'callback',@numexp);


%% Cr�ation du fichier de sauvegarde
KeepTime.t1=clock;
KeepTime.t2=clock;
enableTrack=1;
StartChrono=0;
ExpeInfo.nPhase=ExpeInfo.nPhase+1;
ExpeInfo.name_folder=['ERC-Mouse-' num2str(ExpeInfo.nmouse) '-' ExpeInfo.TodayIs '-' ExpeInfo.namePhase];

%recherche le dernier dossier d'exp�rience et cr�ation du dossier de
%sauvegarde
mkdir(ExpeInfo.name_folder);
disp(ExpeInfo.name_folder)

%% param�tres importants
%Frame_rate and time between images;
time_image = 1/frame_rate;

%% Initialisation des diff�rentes cartes (spike, occupation...)

occupation = zeros(ny,nx); %carte d'occupation 
carte_spike=zeros(size(occupation,1),size(occupation,2),nb_canaux); %carte spike
cell_map=zeros(size(carte_spike)); %carte cellules (normalis�es)
RGBoccupation=zeros(size(occupation,1),size(occupation,2),3); %matrice couleur
RGBcarte_spike=zeros(size(carte_spike,1),size(carte_spike,2),size(carte_spike,3),3);%matrice couleur
RGBcell_map=zeros(size(RGBcarte_spike));%matrice couleur

%% lanc� au d�but du programme
IM=TrObjLocal.GetAFrame;
[length_line,length_column] = size(IM);

t1 = clock;
t2 = clock;
parametres.begin_recording = [];
parametres.end_recording = [];
% sauvegarde des param�tres
save([ name_folder '/information_experiment'],'parametres');

n = 1; % ce qui s'incr�mente dans le while

%% Boucle correspondant � l'enregistrement

%% enregistrement partie 1 : r�cup�ration des coordonn�es de la souris
while(arreter == 0) %tant qu'on ne clique pas sur fermeture
 
 
    if etime(t2,t1) > time_image % on rentre dans la boucle si le temps entre deux images est sup�rieur � 1/frame_rate
       
        t1 = clock; %t1 en m�moire
        
        %Active la cam�ra et prend une image
        trigger(vid);
        %Envoie l'image dans le workspace
        IM=getdata(vid,1,'uint8');
        %Soustrait l'image de r�f�rence
        subimage = abs(ref-IM);
        % Convert the resulting grayscale image into a binary image.
        diff_im = im2bw(subimage,BW_threshold);
        % Remove all the objects less large than smaller_object_size
        diff_im = bwareaopen(diff_im,smaller_object_size);
        
        % Label all the connected components in the image.
        bw = bwlabel(diff_im, 8);
        
        % We get a set of properties for each labeled region.
        stats = regionprops( bw, 'Centroid','Area');
        centroids = cat(1, stats.Centroid);
        
        %display video, mouse position
        subplot(20,20,[5:10 25:30 45:50 65:70 85:90 105:110 125:130 145:150])
        imagesc(IM)
        axis image
        colormap gray
        hold on
        if size(centroids) == [1 2] %si on ne detecte qu'un objet
            nodetect=0;
            plot(centroids(1),centroids(2), '-m+')
            %calcul de la position sur la carte d'occupation
            x_oc = max(round(centroids(1)/length_column*nx),1);
            y_oc = max(round(centroids(2)/length_line*ny),1);
            occupation(y_oc,x_oc) = occupation(y_oc,x_oc) + 1;
        else
            centroids = 'undefined';
            nodetect=1;
        end
        hold off
        %% enregistrement partie 2 : affichage de la carte d'occupation
        occupation_norm=occupation/n;
        log_occupation_norm=log(1+occupation_norm); % echelle log
        max_log_oc=max(max(log_occupation_norm));
        if max_log_oc>0
        log_occupation_norm=log_occupation_norm/max_log_oc;
        else
        log_occupation_norm=0;
        end
        nopath=(occupation==0); % endroit o� la souris n'est jamais pass�e
        RGBoccupation(:,:,3)=nopath;
        RGBoccupation(:,:,2)=nopath;
        RGBoccupation(:,:,1)= log_occupation_norm+nopath; %en blanc l� o� elle n'est jamais pass�e ; en rouge ailleurs ;
        
        subplot(2,2,2)
        
        imagesc(RGBoccupation); %carte d'occupation
        axis image
        
        
        % Save datas of current frame
        
        
        datas.image = IM;
        datas.time = t1;
        datas.centroid = centroids;
        
        % manipulations sur le prefacteur pour sauver le bon fichier
        % (assure le bon nombre de 0)
        prefac0=char;
        for i=1:4-length(num2str(num_exp-correctif))
            prefac0=cat(2,prefac0,'0');
        end
        t=clock;
        jour=num2str(t(3));
        mois=num2str(t(2));
        annee=num2str(t(1));
        if length(jour)==1
            jour=cat(2,'0',jour);
        end
        if length(mois)==1
            mois=cat(2,'0',mois);
        end
        prefac1=char;
        for i=1:6-length(num2str(n))
            prefac1=cat(2,prefac1,'0');
        end
        %sauver l'image et les datas
        save([ name_folder '/' 'F' jour mois annee '-' prefac0 num2str(num_exp-correctif) '/frame' prefac1 sprintf('%0.5g',n)],'datas');
        n = n+1;
  
        % End Save datas of current frame
      
        %% enregistrement partie 3 : bouton start stop : on plot les cartes
        %% spikes et cell field
        % on est toujours dans la boucle while
       
        if etat_enregistrement==1 % si on a appuy� sur start (et que le temps entre deux images est suffisant : on est toujours dans la boucle if
            
            fwrite(a,2); %d�marrer la lecture du buffer
            
            for j=1:nb_canaux
                data_temp=fscanf(a);
                data_temp2=str2double(data_temp);
                nb_ttl(j)=data_temp2; % on r�cup�re le nombre de spikes par canaux entre deux images
            end
            
            if nodetect==0 % on a d�tect� la position de la souris
                for l=1:nb_canaux
                    carte_spike(y_oc,x_oc,l)=carte_spike(y_oc,x_oc,l)+nb_ttl(l); 
                end
            end
            
            carte_spike_norm=carte_spike/n;
            log_carte_spike_norm=log(1+carte_spike_norm); % echelle log
            max_log_carte_spike=squeeze(max(max(log_carte_spike_norm,[],1),[],2));
            
            for ll=1:nb_canaux
                if max_log_carte_spike(ll)>0
                    log_carte_spike_norm(:,:,ll)=log_carte_spike_norm(:,:,ll)/max_log_carte_spike(ll);
                end
                
                carte0= carte_spike(:,:,ll);
                nopath_spike=(carte0==0); % endroit o� la souris n'a pas d�charg�
                RGBcarte_spike(:,:,ll,3)=nopath_spike;
                RGBcarte_spike(:,:,ll,2)=nopath_spike;
                RGBcarte_spike(:,:,ll,1)= squeeze(log_carte_spike_norm(:,:,ll))+nopath; %en blanc l� o� elle n'a pas d�charg� ; en rouge ailleurs ;
                
                cell_map(:,:,ll)=carte_spike(:,:,ll)./occupation;
                abberation= (occupation<3);
                cell_temp=cell_map(:,:,ll);
               % cell_temp_norm=cell_temp/n;
                cell_temp(abberation)=0;
               % log_cell_temp_norm=log(1+cell_temp_norm);
                %max_log_cell_temp_norm=max(max(log_cell_temp_norm));
                max_cell_temp=max(max(cell_temp));
                if max_cell_temp>0
                    cell_temp_plot=cell_temp/max_cell_temp;
                else
                    cell_temp_plot=cell_temp;
                end
                RGBcell_map(:,:,ll,3)=nopath_spike;
                RGBcell_map(:,:,ll,2)=nopath_spike;
                RGBcell_map(:,:,ll,1)=cell_temp_plot+nopath;
                
            end
            subplot(2,2,4)
            imagesc(squeeze(RGBcarte_spike(:,:,num_canal,:)))
            axis image
            
            
            subplot(2,2,3)
            imagesc(squeeze(RGBcell_map(:,:,num_canal,:)))
            axis image
        end
   end %end if 
        if etat_enregistrement == 0 % si on a appuy� sur stop ou rien fait
           
            uiwait(gcf) %bloque l'execution jusqu'au uiresume 
            %note importante : au d�marrage du programme, t2=t1 et
            %arreter=0 => on arrive directement ici : rien ne se passe
            %avant le premier start
            
        end
        
        t2 = clock;
        
        if etime(t2,t0)>duree_max % on limite � une demi-heure : apr�s �a le tracking s'arr�te automatiquement
            on_off;
            
            warndlg('Temps expir� : veuillez relancer une acquisition','!! CHRONO !!')
            t0=clock;
            redemarre=1;
            pause(1)
            on_off
            
            
            
        end
        
end

disp('Acquisition stopped');
fwrite(a,3); %envoie le signal d'arret � l'arduino

close

%Callback du bouton start/stop, permet d'arreter et de relancer
%l'acquisition
%% fonctions appel�es

%fonction associ�e � Start/Stop
function on_off(obj,event)
global etat_enregistrement
global color_on
global color_off
global parametres
global name_folder
global a
%global last_experiment
%global num_sequence
global t0
global premier_acq
global numero
global num_exp
global correctif
global prefac0
global handles
global n
global redemarre

%toujours ces manips sur les prefacteurs
prefac0=char;
for i=1:4-length(num2str(num_exp))
    prefac0=cat(2,prefac0,'0');
end
t=clock;
jour=num2str(t(3));
mois=num2str(t(2));
annee=num2str(t(1));
if length(jour)==1
    jour=cat(2,'0',jour);
end
if length(mois)==1
    mois=cat(2,'0',mois);
end
existence=exist([ name_folder '/' 'F' jour mois annee '-' prefac0 num2str(num_exp)],'dir');
confirm=1;
%s�curit� pour ne pas �craser les donn�es
if existence ~=0 && correctif==1
    confirm=0;
    choice = questdlg(['Le dossier' name_folder '/' 'F' jour mois annee '-' prefac0 num2str(num_exp) 'existe d�j�. Voulez vous l �craser'], ...
        'Confirmation', ...
        'Oui','Non','Non');
    switch choice
        case 'Oui'
            confirm=1;
            rmdir([name_folder '/' 'F' jour mois annee '-' prefac0 num2str(num_exp)],'s')
    end
end

if confirm==1 %cas habituel
    
    if premier_acq==0 % cas particulier de la premi�re fois qu'on appuie sur start (initialise t0)
       % t0=clock;
        premier_acq=1;
    end
    
    if etat_enregistrement == 1 %si on stoppe
        etat_enregistrement = 0;
        t0=clock;
        fwrite(a,3); % ordre d'arret � l'arduino
        set(handles(1),'Color',color_off);
        parametres.end_recording = [ parametres.end_recording ;clock num_exp-correctif];
        save([ name_folder '/information_experiment'],'parametres');
        
        num_exp=num_exp+1;
        delete(numero.edit)
        numero.edit=uicontrol('style','edit', ...
            'units','normalized',...
            'position',[0.01 0.84 0.08 0.05],...
            'string',num2str(num_exp));
        correctif=1;
        record.edit=uicontrol('style','text', ...
            'units','normalized',...
            'position',[0.01 0.78 0.08 0.05],...
            'string',(['fichier n�' num2str(num_exp-correctif) '   etat arrete']));
        
        
    else t0=clock;%si on allume
        correctif=0;
        etat_enregistrement = 1;
        fwrite(a,1)
        if redemarre==0
        uiresume(gcbf) % on red�marre la boucle
        else
            redemarre=0;
        end
        
        %encore les pr�facteurs
        prefac0=char;
        for i=1:4-length(num2str(num_exp))
            prefac0=cat(2,prefac0,'0');
        end
        mkdir([ name_folder '/' 'F' jour mois annee '-' prefac0 num2str(num_exp)]); %cr�ation du dossier correspondant � l'exp�rience
        parametres.begin_recording = [ parametres.begin_recording ;clock num_exp-correctif];
        save([ name_folder '/information_experiment'],'parametres');
        set(handle(1),'Color',color_on);
        
        record.edit=uicontrol('style','text', ...
            'units','normalized',...
            'position',[0.01 0.78 0.08 0.05],...
            'string',(['fichier n�' num2str(num_exp-correctif) '  en cours d enregistrement']));
        n=1;
        
    end
else % si on refuse d'�craser les donn�es
    warndlg('Operation cancelled','!! Warning !!')
end

%Fonction associe � Fermeture
function fermeture(obj,event)
global arreter
global etat_enregistrement
global t0
t0=clock;

if etat_enregistrement == 0
    arreter = 1;
    uiresume(gcbf)%on continue la boucle pour pouvoir sortir du while
    delete(obj)
else
  warndlg('Stop recording first','!! Warning !!')  
end


%R�initialise la carte d'occupation
function reset_occupation(obj,event)
global occupation
occupation = zeros(size(occupation));

%R�initialise la carte d'occupation des spikes (global)
function reset_occupation2(obj,event)
global carte_spike
carte_spike = zeros(size(carte_spike));

%R�initialise la carte d'occupation des spikes (local)
function reset_occupation3(obj,event)
global carte_spike
global num_canal
carte_spike(:,:,num_canal) = 0;

%R�initialise la carte d'occupation des spikes (global) et la carte
%d'occupation
function reset_occupation4(obj,event)
global carte_spike
global occupation
carte_spike = zeros(size(carte_spike));
occupation = zeros(size(occupation));

%numero exp (pour sauvegarder le bon fichier)
function numexp(obj,event)
global num_exp
global numero

global correctif

global premier_acq

if correctif==1 || premier_acq==0 % le bouton ne marche que si une exp�rience n'est pas en cours
    num_exp=get(numero.edit,'string');
    num_exp=str2double(num_exp);
    
    uicontrol('style','text', ...
        'units','normalized',...
        'position',[0.01 0.78 0.08 0.05],...
        'string',(['fichier n�' num2str(num_exp) ' etat arrete']));
    
else
    warndlg('Stop the recording first','!! Warning !!')
end

%li� au canal qu'on souhaite regarder
function choix_canal(obj,event)

global num_canal
global hpop
global RGBcarte_spike
global RGBcell_map
num_canal = get(hpop,'Value');
subplot(2,2,4)
imagesc(squeeze(RGBcarte_spike(:,:,num_canal,:)))
axis image

subplot(2,2,3)
imagesc(squeeze(RGBcell_map(:,:,num_canal,:)))
axis image

