function [date] =  djm_inv (mjd)
% [date] = djm_inv (mjd)
%    The function djm_inv gives the date corresponding to
%    a given mjd (Modified Julian Date) date
% inputs:
%   mjd
%       Modified Julian Date in days, referred to 1950.0. 
% outputs:
%   date = [day, month, year]
%
% Valdemir Carrara, Feb, 2009
%

d1 = [0, 31, 61, 92, 122, 153, 184, 214, 245, 275, 306, 337, 366];

y4   = 0;
y1   = 0;
d    = fix(mjd + 127775);
y400 = fix(d/146097);
d    = d - y400*146097;
y100 = fix(d/36524);
d    = d - y100*36524;

if y100 > 3
	dat1 = 29;
	dat2 = 2;
	dat3 = 1600 + y400*400 + y100*100 + y4*4 + y1;
else
	y4   = fix(d/1461);
	d    = d - y4*1461;
	y1   = fix(d/365);
	if y1 > 3
		dat1 = 29;
		dat2 = 2;
		dat3 = 1600 + y400*400 + y100*100 + y4*4 + y1;
    else
		d    = d - y1*365;
		i    = fix(d/32 + 2);
		d    = d + 1;
%		while d1(i) < d
%    		dat2 = i + 2;
%      		dat1 = d - d1(i-1);
%           	dat3 = 1600 + y400*400 + y100*100 + y4*4 + y1;
%            if dat2 > 12
%    			dat2 = dat2 - 12;
%       			dat3 = dat3 + 1;
%            end
%            i = i + 1;
%        end
		while d1(i) < d
            i = i + 1;
        end
   		dat2 = i + 1;
   		dat1 = d - d1(i-1);
       	dat3 = 1600 + y400*400 + y100*100 + y4*4 + y1;
        if dat2 > 12
   			dat2 = dat2 - 12;
   			dat3 = dat3 + 1;
        end
    end
end
date = [dat1, dat2, dat3];



