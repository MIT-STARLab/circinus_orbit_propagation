% Get a datetime from an iso8601 datestring

% inverse of make_iso_datestr

function [dt] = parse_iso_datestr(iso_date_str)

% Input: string in 8601 isoformat, e.g. "2018-01-18T11:39:50.520000Z", or a
% multi row char array of iso strings
% Output: matlab datetime

dt = [];
for i=1:size(iso_date_str,1)

    % Do a lot of gynmastics on input datestring because matlab doesn't like
    % people.
    % for params.scenario_start_utc:
    % start with input format is like "2018-01-18T11:39:50.520000Z"
    % remove T,Z, concatenate -> 2018-01-18 11:39:50.520000

    time_split = strsplit(iso_date_str(i,:),'Z');
    time_split = time_split{1};
    time_split = strsplit(time_split,'T');
    the_date_str = [time_split{1},' ',time_split{2}];

    dt = [dt; datetime(the_date_str,'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS')];
end

