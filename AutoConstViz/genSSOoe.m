function [oe] = genSSOoe(alt_km, e, epoch_mJD, LTN_hour)
Re = 6378.0088;
J2 = 1.08262668e-3;
tes = 3.155815e7;
mu = 398600.440;
a = alt_km + Re;
ci = -4*pi*((1-e^2)^2 * a^(7/2)) / (3 * J2 * Re^2 * sqrt(mu) * tes);
i = acos(ci);

oe.i_deg = i * 180/pi;
oe.a_km = a;
oe.e = e;

% dv = mJD2date(epoch_mJD);
vemJD = mjuliandate([2016, 3, 20, 4, 30 0]);
dt = epoch_mJD - vemJD;
dangle = dt * 360 / 365.242199;
while(1)
    if dangle > 360
        dangle = dangle - 360;
    elseif dangle < 0
        dangle = dangle + 360;
    else
        break;
    end
end

oe.RAAN = (LTN_hour - 12) * 360 / 24 + dangle;
oe.w = 0;
