function [h, m, s, hmsstr] = hrs2hms (hrs)

% convert decimal hours to hours,
% minutes, seconds and equivalent string

% input

%  dd = angle in hours

% output

%  h      = integer hours
%  m      = integer minutes
%  s      = seconds
%  hmsstr = string equivalent of input

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (hrs < 0)
   hrs = hrs + 24;
end

h = abs(hrs);
   
d = fix(h);
   
d1 = (h - d) * 60;
   
m = fix(d1);
   
s = (d1 - m) * 60;
    
hmsstr = sprintf('%+03d%s%02d%s%06.4f%s', d,...
            'h ', m, 'm ', s,'s');

 


