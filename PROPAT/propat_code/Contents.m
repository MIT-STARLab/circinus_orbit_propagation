% Satellite Attitude & Orbit Control Toolbox
%
% Matrix transformations
%   exyzquat      - Euler angles (X-Y-Z rotation) to quaternions
%   ezxzquat      - Euler angles (Z-X-Z rotation) to quaternions
%   exyzrmx       - Euler angles (X-Y-Z rotation) to attitude matrix
%   ezxzrmx       - Euler angles (Z-X-Z rotation) to attitude matrix
%   ezxyrmx       - Euler angles (Z-X-Y rotation) to attitude matrix
%   ezyxrmx       - Euler angles (Z-Y-X rotation) to attitude matrix
%   eulerrmx      - Euler angle and vector to rotation matrix. 
%   quatexyz      - Quaternions to Euler angles (X-Y-Z)
%   quatezxz      - Quaternions to Euler angles (Z-X-Z)
%   quatrmx       - Quaternions to attitude matrix
%   rmxexyz       - Attitude matrix to Euler angles (X-Y-Z rotation)
%   rmxezxz       - Attitude matrix to Euler angles (Z-X-Z rotation)
%   rmxezxy       - Attitude matrix to Euler angles (Z-X-Y rotation)
%   rmxezyx       - Attitude matrix to Euler angles (Z-Y-X rotation)
%   rmxeuler      - Rotation matrix to Euler angle and vector  
%   rmxquat       - Attitude matrix to quaternions
%   rotmax        - Rotation matrix in the X axis
%   rotmay        - Rotation matrix in the Y axis
%   rotmaz        - Rotation matrix in the Z axis
%   sangvel       - Skew simetric matrix of the angular velocity
%   cross_matrix  - Skew simetric matrix of the cross product
%   quat_prod     - Product of two quaternions
%   quat_unity    - Quaternion normalization based on euclidian 4D norm
%   quat_norm     - Quaternion normalization based on the vector 3D norm
%   quat_matrix   - Quaternion product matrix
%   quat_inv      - Inverse quaternion (conjugate)
%   proximus      - Obtains the nearest angle from a given angle
%
% Date, time and ephemeris
%   djm           - Modified Julian date
%   djm_inv       - Inverse Modified Julian date
%   time_to_dayf  - Convertion from hours, minutes and seconds to seconds
%   dayf_to_time  - Convertion from day elapsed time to hour, minutes and
%                   seconds
%   gst           - Greenwich aparent sideral time
%   sun           - Inertial Sun coordinates
%   sun_dir       - Sun direction in inertial system (simplified model)
%   igrf_field    - Earth's geomagnetic field from latitude and longitude
%   mag_field     - Earth's geomagnetic field from satellite position
%
% Orbit propagation
%   kepler        - Solve the Kepler equation
%   delkep        - Variation of the angular keplerian elements
%   kepel_statvec - Keplerian elements to inertial state vector
%   statvec_kepel - Inertial state vector to keplerian elements
%   inertial_to_terrestrial - Inertial state vector to geocentric 
%                   terrestrial
%   terrestrial_to_inertial - Geocentric terrestrial to inertial state 
%                   vector
%   geocentric_to_sph_geodetic  - Geocentric terrestrial to spherical 
%                   geodetic
%   sph_geodetic_to_geocentric  - Spherical geodetic to geocentric 
%                   terrestrial
%   rectangular_to_spherical  - Geocentric terrestrial to geocentric 
%                   spherical coordinates
%   spherical_to_rectangular  - Geocentric spherical to terrestrial 
%                   geocentric coordinates
%   orbital_to_inertial_matrix - Rotation matrix from orbital to inertial
%                   frame
%   earth_shadow  - Compute the relative satellite-earth-sun position
%   visviva       - Visviva equation (orbital velocity magnitude as
%                   function of the orbit radius)
%
% Attitude determination
%   triad         - Obtains a reference frame from two vectors
%   triad2        - Obtains the matrix transform from a two pair of vectors
%
% Dynamic equations
%   rigbody       - Time derivative of the attitude state vector (to 
%                   integrate numerically)
%   rb_nutation_damper - Rigid body with on-board angular momentum and a
%                   passive nutation damper
%   rb_reaction_wheel  - Rigid body with three orthogonal reaction wheels
%   rb_reaction_wheel_n  - Rigid body with any number of reaction wheels
%   rw_speed      - Reaction wheel's angular velocity (3 orthogonal)
%   rw_speed_n    - Reaction wheel's angular velocity (n reaction wheels)
%
% Disturbances torques
%   gg_torque     - Gravity gradient torque
%
% Demo programs
%   demo_propat   - Complete demonstration program (Type demo_propat from
%                   Matlab console)
%   propov        - Example of how to generate a attitude motion video with
%                   Povray
%
% Valdemir Carrara, Sep 1998
%
% Ver: 1.0.4    March 2015
%
% Ver: 1.0.5
%               Correction of the Ecliptic obliquity in the sun_dir
%               function (7/12/15) and visviva (09/10/16)

