function [day_time] = dayf_to_time (dayf)
% [day_time] = dayf_to_time (dayf)
%    The function dayf_to_time computes the hour, minutes and seconds 
%    of the day based on the day elapsed time in seconds
% inputs:
%   dayf
%       Day elapsed time in seconds. 
% outputs:
%   day_time = [day_hour, minutes, seconds]
%       hours
%           day hour (integer).
%       minutes
%           minutes (integer).
%       seconds
%           seconds and fraction of second
%
% Valdemir Carrara, Feb, 2009
%

day1 = fix(dayf/3600);
day2 = fix(dayf/60) - 60*day1;
day3 = dayf - 3600*day1 - 60*day2;
day_time = [day1, day2, day3];
