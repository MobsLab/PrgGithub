function AlignTsp2Whl_All(processdir,varargin)

% USAGE
%     AlignTsp2Whl_All(processdir,'parameters','values')
%     
% Inputs:
%     - processdir is the name of the folder containing all the data (that
%     is the root folder in which process_multi_start was launched)
%    SIMPLEST THING TO DO: call AlignTsp2Whl_All(pwd)
%
%    WARNING: it is assumed that the root folder name and the final merge name are the same. If not, use
%    the 'mergename' option. Typically the root folder is something like
%    /xxx/yyy/AnimalZZZ-DayA/ and the merged data are in /xxx/yyy/AnimalZZZ-DayA/AnimalZZZ-DayA/
%
% - options:
%     'mergename': if the merged data are not in 'fbasename/fbasename' but in
%     'fbasename/mergename', then indicate with this option the name of the
%     merged data directory
%     'merge': if set to 1 (default 1) the function will merge the whl
%     dat into one single whl file 'fbasename/mergename/mergename.whl'.
%     'colorIx': a 2 value vector [colFront colRear] which defines which
%     color from [R G B] is the front and rear LEDs. Default: [1 3]
%     'folderNames': a cell array of filenames in the order they will be
%     merged. If omitted, the program looks at the merged files in the xml
%     file contained in '/dir1/dir2/.../fbasename/mergename/mergename.xml'
%     'fromMpg': if 1 (default 0) will reconstruct the tracking from the
%     video
% 
% Dependencies: xml_toolbox (easy to find on the web)
% 
% Adrien Peyrache, 2012

if strcmp(processdir,'filesep') && length(processdir)>1
    processdir = processdir(1:end-1);
elseif length(processdir)==1
    error('Are you sure you want to call if from the root folder...?')
end

merge=1;
colorIx=[1 3];
datFiles = {};
frommpg = 0;
[dummy fbasename dummy] = fileparts(processdir);

mergename = fbasename;

for i = 1:2:length(varargin),
  if ~isa(varargin{i},'char'),
    error(['Parameter ' num2str(i+3) ' is not a property (type ''help LoadBinary'' for details).']);
  end
  switch(lower(varargin{i})),
    case 'mergename',
      mergename = varargin{i+1};
      if ~ischar(mergename)
        error('Incorrect value for property ''mergename''. Should be char array.');
      end 
    case 'merge',
      merge = varargin{i+1};
      if merge ~= 1 || merge ~= 0
        error('Incorrect value for property ''merge''. Should be logical.');
      end
    case 'colorix',
      colorIx = varargin{i+1};
      if length(colorIx)~=2
        error('Incorrect value for property ''colorIx''. Should be 3 element vector of logical values.');
      end
    case 'folderNames',
      datFiles = varargin{i+1};
      isachar = 1;
      for fix=1:length(datFiles),isachar=isachar*isa(datFiles{fix},'char');end
      if ~isa(datFiles,'cell') || ~isachar
        error('Incorrect value for property ''datFiles''. Should be a cell array of filenames');
      end
       case 'frommpg'
         frommpg = varargin{i+1};
         if ~isnumeric(frommpg)
            error('Incorrect value for property ''frommpg''. Should be 0 pr 1');
         end
  end
end

if isempty(datFiles)
    xmldata = xml_load([mergedir filesep mergename '.xml']);
    segnames = xmldata.multiFileProcessing.files;
    datFiles = cell(length(segnames),1);
    for ii=1:length(segnames)
        datFiles{ii} = segnames(ii).fileBaseName;
    end
end

fprintf('Creating whl files...\n')
for fix=1:length(datFiles)
    fname = datFiles{fix};
    fprintf('\t%s\n',fname)
    
    AlignTsp2Whl([rootdir filesep fname filesep fname],colorIx,frommpg);    
end

if merge
    fprintf('Merging files...\n')
    whlall = [];
    for fix=1:length(datFiles)
        fname = datFiles{fix};
        whl = load([rootdir filesep fname filesep fname '.whl']);
        whlall = [whlall;whl];
    end
    dlmwrite([mergedir filesep mergename '.whl'],whlall,'delimiter','\t');
end
