function [ethr, etmin, etsec] = gettime

% interactive request and input of ephemeris time

% output

%  ethr  = ephemeris time (hours)
%  etmin = ephemeris time (minutes)
%  etsec = ephemeris time (seconds)

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for itry = 1:1:5
    
    fprintf('\nplease input the ephemeris time');

    fprintf('\n(0 <= hours <= 24, 0 <= minutes <= 60, 0 <= seconds <= 60)\n');

    etstr = input('? ', 's');

    tl = size(etstr);

    ci = findstr(etstr, ',');

    % extract hours, minutes and seconds

    ethr = str2double(etstr(1:ci(1)-1));

    etmin = str2double(etstr(ci(1)+1:ci(2)-1));

    etsec = str2double(etstr(ci(2)+1:tl(2)));

    % check for valid inputs

    if (ethr >= 0 && ethr <= 24 && etmin >= 0 && etmin <= 60 ...
            && etsec >= 0 && etsec <= 60)
        break;
    end
    
end
