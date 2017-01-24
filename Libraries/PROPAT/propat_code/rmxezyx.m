function [euler_angles] = rmxezyx (rot_mat)
% [euler_angles] = rmxezyx (rot_mat)
%   To compute the Euler angles of a Z-Y-X rotation, given 
%   the attitude matrix.
% inputs:
%   rot_mat
%       Rotation matrix (3, 3)
% outputs:
%   euler_angles
%       Euler angles from a Z-Y-X rotation, in radians (3)
%           -pi   < euler_angle(1) <= pi
%           -pi/2 < euler_angle(2) <= pi/2
%           -pi   < euler_angle(3) <= pi
%
% Valdemir Carrara, Feb, 2009

stet = -rot_mat(1,3);
ctsf =  rot_mat(1,2);
ctcf =  rot_mat(1,1);
spct =  rot_mat(2,3);
cpct =  rot_mat(3,3);

if abs(stet) <= 1.
	eul2 = asin(stet);
else
	eul2 = pi/2*sign(stet);
end

if abs(eul2) <= pi/2 - 1e-5
    if abs(ctcf) ~= 0
		eul1 = atan2(ctsf, ctcf);
        if (eul1 > pi)
            eul1 = eul1 - 2*pi;
        end
    else
		eul1 = pi/2*sign(ctsf);
    end

    if abs(cpct) ~= 0
		eul3 = atan2(spct, cpct);
        if (eul3 > pi)
            eul3 = eul3 - 2*pi;
        end
	else
		eul3 = pi/2*sign(spct);
    end
else
	capb = rot_mat(2,2);
	sapb = rot_mat(2,1);
	eul1 = 0.;

    if abs(capb) ~= 0 
		eul3 = atan2(sapb, capb);
        if (eul3 > pi)
            eul3 = eul3 - 2*pi;
        end
	else
		eul3 = 0.;
    end
end

euler_angles = [eul1; eul2; eul3];
