load('test_in.mat')

% assuming this script is being executed in its directory
addpath('..')

[obs,obsaer,gslink,gsaer,sunecl,xlink,xrange] = accesses_wrapper(...
        all_sats_t_r_eci,...
        params)

% should execute successfully given these inputs...