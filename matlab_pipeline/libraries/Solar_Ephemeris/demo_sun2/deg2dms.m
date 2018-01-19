function [d, m, s, dmsstr] = deg2dms (dd)

% convert decimal degrees to degrees,
% minutes, seconds and equivalent string

% input

%  dd = angle in decimal degrees

% output

%  d      = integer degrees
%  m      = integer minutes
%  s      = seconds
%  dmsstr = string equivalent of input

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d1 = abs(dd);
   
d = fix(d1);
   
d1 = (d1 - d) * 60;
   
m = fix(d1);
   
s = (d1 - m) * 60;
    
if (dd < 0)
   if (d ~= 0)
      d = -d;
   elseif (m ~= 0)
      m = -m;
   else
      s = -s;
   end
end

dmsstr = sprintf('%+03d%s%02d%s%05.2f%s', d,...
            'd ', m, 'm ', s,'s');

 


