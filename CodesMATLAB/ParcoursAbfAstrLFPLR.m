%  ParcoursAbf

try 
freq;
catch
freq=10000;
end


cd H:\Data_Astros_Field

listdir=dir;

for i=1:length(listdir)
%  for mois=1:7

	cd H:\Data_Astros_Field

	if listdir(i).name(1)~='.'

%  	disp('ok step 1')

% 	cd (listdir(i).name)

% 	listsousdir=dir;

% 		for i=1:length(listsousdir)
%  		for i=1:3


			nom=listdir(i).name;
			le=length(listdir(i).name);
			

			try
				if nom(le-2:le)=='abf';
				nom	

%  try
%  eval(['cd ', nom(1:le-4)])
%  cd (listdir(mois).name)
%  catch

%  				disp('ok step 2')
	
				data=abfloadKB(nom);
	
				nbtraces=size(data,2)-1;
				
				mkdir(pwd,nom(1:le-4))
	
				eval(['cd ', nom(1:le-4)])
	%  			keyboard
				save Data data freq nbtraces nom 
				cd ..
%  end

				end
			end



		end

	end




% end
