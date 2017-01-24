function [euler_angles] = rmxezxz (rot_mat)
% [euler_angles] = rmxezxz (rot_mat)
%   To compute the Euler angles of a Z-X-Z rotation, given 
%   the attitude matrix.
% inputs:
%   rot_mat
%       matriz de rotação (3, 3)
% outputs:
%   euler_angles
%       Euler angles from a Z-X-Z rotation, in radians (3)
%       such that:
%           -pi   < euler_angle(1) <= pi
%           0    <= euler_angle(2) <=  pi
%           -pi   < euler_angle(3) <= pi
%

% Valdemir Carrara, Sep, 1998

a11    = rot_mat(1,1);
a12    = rot_mat(1,2);
a13    = rot_mat(1,3);
a23    = rot_mat(2,3);
a31    = rot_mat(3,1);
a32    = rot_mat(3,2);
a33    = rot_mat(3,3);
      
if abs(a33) <= 1 
    eul2 = acos(a33);
elseif a33 < 0 
    eul2 = pi;
else
    eul2 = 0;
end

if abs(eul2) >= 0.00001 
    if a32 ~= 0 
        eul1 = atan2(a31, -a32);
    else
        eul1 = pi/2*sign(a31);
        if (eul1 > pi)
            eul1 = eul1 - 2*pi;
        end
    end

    if a23 ~= 0
        eul3 = atan2(a13, a23);
        if (eul3 > pi)
            eul3 = eul3 - 2*pi;
        end
    else
        eul3 = pi/2*sign(a13);
    end
else
    eul1 = 0;
    if a11 ~= 0
        eul3 = atan2(a12, a11);
        if (eul3 > pi)
            eul3 = eul3 - 2*pi;
        end
    else
        eul3 = pi/2*sign(a12);
    end
end

euler_angles = [eul1; eul2; eul3];

       
