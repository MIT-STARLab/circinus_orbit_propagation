% Change a datetime into an output string, with fractional seconds all 0

% inverse of parse_iso_datestr

function [iso_date_str] = make_iso_datestr(dt)

% Input: matlab datetime
% Output: string in 8601 isoformat, e.g. "2018-01-18T11:39:50.520000Z"

% Do a lot of gynmastics on input datestring because matlab doesn't like
% people.
% for params.scenario_start_utc:
% start with input format is like "2018-01-18T11:39:50.520000Z"
% remove T,Z, concatenate -> 2018-01-18 11:39:50.520000

the_date_str = char(dt,'yyyy-MM-dd HH:mm:ss.SSSSSS');

time_split = strsplit(the_date_str,' ');

iso_date_str = [time_split{1},'T',time_split{2},'Z'];