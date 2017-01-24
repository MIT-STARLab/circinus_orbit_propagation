function [dayf] = time_to_dayf (hours, minutes, seconds)
% [dayf] = time_to_dayf (hours, minutes, seconds)
%    The function time_to_dayf returns with the day elapesed
%    time in seconds
% inputs:
%   hours     
%       day hour (integer).
%   minutes
%       minutes (integer).
%   seconds
%       seconds and fraction of second
% outputs:
%   dayf
%       Day elapsed time in seconds. 
%
% Valdemir Carrara, Feb, 2009
%

dayf = seconds + 60*(minutes + 60*hours);
