function [skew_ang_vel] = sangvel (w)
% [skew_ang_vel] = sangvel (w)
%   To obtain the skew simetric matrix of the satellite angular
%   velocity
%
% inputs:
%   w              - Satellite angular velocity (rd/s)
%
% outputs:
%   skew_ang_vel   - Angular velocity matrix (4 x 4)
% 

% Valdemir Carrara, Sep, 1998.

skew_ang_vel = [     0,  w(3), -w(2),  w(1);...
                 -w(3),     0,  w(1),  w(2);...
                  w(2), -w(1),     0,  w(3);...
                 -w(1), -w(2), -w(3),     0];
            
      