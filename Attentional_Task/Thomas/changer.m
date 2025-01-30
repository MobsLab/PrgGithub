function [y]=changer(str)
str
if(strcmpi('0',str))
    y = '-Contrôle';
elseif(strcmpi('1',str))
    y = '-Post-Privation';
elseif(strcmpi('2',str))
    y = '-Post-Sleep';
else
    y = str;
end
end