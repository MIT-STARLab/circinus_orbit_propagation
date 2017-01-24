function [cross_mat] = cross_matrix (w)
% [cross_mat] = cross_matrix (w)
%   To obtain the skew simetric matrix of the cross product, ie:
%   cross(w, v) = cross_matrix(w)*v
%
% inputs:
%   w
%       Input vector (3)
%
% outputs:
%   cross_mat
%       Cross product matrix (3x3), defined by:
%         |    0,  -w(3),  w(2)|
%         | w(3),      0, -w(1)|
%         |-w(2),   w(1),     0|
%   and 
%       cross(w, v) = cross_matrix(w)*v
% 
% Valdemir Carrara, Feb, 2008.

cross_mat = [     0,  -w(3),  w(2); ...
               w(3),      0, -w(1); ...
              -w(2),   w(1),    0];
            
      