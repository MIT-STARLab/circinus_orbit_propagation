function [quaternions] = rmxquat (rot_mat)
% [quaternions] = rmxquat (rot_mat)
%   To obtain the attitude quaternions from the attitude
%   rotation matrix.
% inputs:
%   rot_mat
%       rotation matrix (3, 3)
% outputs:
%   quaternion
%       attitude quaternions.
%

% Valdemir Carrara, Sep, 1998

matra = trace(rot_mat);
auxi = 1 - matra;
selec = [1+matra; auxi+2*rot_mat(1, 1); auxi+2*rot_mat(2, 2); auxi+2*rot_mat(3, 3)];
[auxi, ites] = max(selec);
auxi = 0.5*sqrt(auxi);

if ites == 1
	quaternions = [(rot_mat(2, 3) - rot_mat(3, 2))/4/auxi;
   	            (rot_mat(3, 1) - rot_mat(1, 3))/4/auxi;
      	         (rot_mat(1, 2) - rot_mat(2, 1))/4/auxi;
         	      auxi];
elseif ites == 2
   quaternions = [auxi; 
      				(rot_mat(1, 2) + rot_mat(2, 1))/4/auxi;
   	            (rot_mat(1, 3) + rot_mat(3, 1))/4/auxi;
      	         (rot_mat(2, 3) - rot_mat(3, 2))/4/auxi];
elseif ites == 3
 	quaternions = [(rot_mat(1, 2) + rot_mat(2, 1))/4/auxi;
       				auxi;
						(rot_mat(2, 3) + rot_mat(3, 2))/4/auxi;
      	         (rot_mat(3, 1) - rot_mat(1, 3))/4/auxi;];
else
	quaternions = [(rot_mat(1, 3) + rot_mat(3, 1))/4/auxi;
      				(rot_mat(2, 3) + rot_mat(3, 2))/4/auxi;
      				auxi;
      	         (rot_mat(1, 2) - rot_mat(2, 1))/4/auxi;];
end
                
            
            
% if auxi == 0
%    quaternions = sqrt([-rot_mat(2,2)-rot_mat(3,3); -rot_mat(1,1)-rot_mat(3,3); ...
%          -rot_mat(1,1)-rot_mat(2,2); 0]/2);
% else
