function [diju] =  djm (day, month, year)
% [diju] = djm (day, month, year)
%    The function djm furnishes the Modified Julian
%    Date with reference to the day, month and year,
%    at zero hours of the day.
% inputs:
%   day     
%       day of the month.
%   month
%       month of the year.
%   year
%       year
% outputs:
%   diju
%       Modified Julian Date in days, referred to 1950.0. 
%
% Valdemir Carrara, Apr, 2003
%

diju = 367*year + day - 712269 + fix(275*month/9)- fix(7*(year+fix((month+9)/12))/4);


