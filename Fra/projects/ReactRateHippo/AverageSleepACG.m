function AverageSleepACG

hm = getenv('HOME');

pdir = [ hm filesep 'Data/DIRAC' ];
dsetList = [ pdir filesep 'dirs_BD1.list'];
datasets = List2Cell(dsetList);

A = Analysis(pdir);

cd(pdir);
load  DIRACSleepACG
ACG_s1 = Sleep1ACG;
ACG_s2 = Sleep2ACG;

AvACG = zeros(35, 1);

ACGtot = [ACG_s1; ACG_s2];

for ag = 1:length(ACGtot)
    acg = ACGtot{ag};
    if length(acg) > 35
        ll = (length(acg) - 35)/2;
        acg = acg((1+ll):(end-ll));
    end
    AvACG = AvACG + acg;
end

AvACG = AvACG / length(ACGtot);

plot(-17:17, log(AvACG));
AvACG_t = -17:17;
save AvACG Av*
    