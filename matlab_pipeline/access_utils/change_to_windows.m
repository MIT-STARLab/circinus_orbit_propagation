function [windows,indices] = change_to_windows(times_list,window_spacing_days)
% Author: Kit Kennedy

% This function turns a non-temporally-continuous list of time points into
% a series of windows by searching through the list and finding time gaps
% larger than window_spacing_days

% Inputs
% times_list - Column vector of datestrings in form '15 Mar 2012
% 15:39:00.000' sorted in ascending order
% window_spacing_days - the amount of time that must elapse between two
% consecutive times in times_list in order for them to be considered
% different windows

% Outputs:
% windows - array of windows, where each row is a single window, with start time (mjuliandate), end time (datenum), size of window in seconds

windows = [];
indices = [];

if size(times_list,1) == 0
    return
end

current_time = mjuliandate(parse_iso_datestr(times_list(1,:)));
current_indx = 1;
start_time = current_time;
start_indx = current_indx;
last_time = current_time;
last_indx = current_indx;

for i = 2:size(times_list,1)
    last_time = current_time;
    last_indx = current_indx;
    current_time = mjuliandate(parse_iso_datestr(times_list(i,:)));
    current_indx = i;
    
    % close a window and move on to next
    % note that if trailing point is start of a new window, that new
    % window won't make it into the final list
    if current_time - last_time >= window_spacing_days
        end_time = last_time;
        windows = [windows; start_time end_time (end_time - start_time)*86400]; 
        indices = [indices; start_indx last_indx];
        start_time = current_time;
        start_indx = current_indx;
    end
end

% Handle case where trailing point was in the middle of a window
if current_time - last_time < window_spacing_days
    end_time = current_time;
    windows = [windows; start_time end_time (end_time - start_time)*86400]; 
    indices = [indices; start_indx current_indx];
end

% get rid of first window if it only has a single time point.
if windows(1,3) == 0
    windows = windows(2:end,:);
    indices = indices(2:end,:);
end

end