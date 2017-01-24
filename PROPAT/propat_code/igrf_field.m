function [field] = igrf_field (date, alt, colat, elong)
%
%     This is a program for synthesising geomagnetic field values from the
%     International Geomagnetic Reference Field series of models as agreed
%     in Decmember 2004 by IAGA Working Group V-MOD.
%     It is the 10th generation IGRF, ie the 9th revision.
%     The main-field models for 1900.0, 1905.0,..1940.0 and 2005.0 are
%     non-definitive, those for 1945.0, 1950.0,...2000.0 are definitive and
%     the secular-variation model for 2005.0 to 2010.0 is non-definitive.
%
%     Main-field models are to degree and order 10 (ie 120 coefficients)
%     for 1900.0-1995.0 and to 13 (ie 195 coefficients) for 2000.0 onwards.
%     The predictive secular-variation model is to degree and order 8 (ie 80
%     coefficients).
%
%     Options include values at different locations at different
%     times (spot), values at same location at one year intervals
%     (time series), grid of values at one time (grid); geodetic or
%     geocentric coordinates, latitude & longitude entered as decimal
%     degrees or degrees & minutes (not in grid), choice of main field
%     or secular variation or both (grid only).
%
%     Adapted from 8th generation version to include new maximum degree for
%     main-field models for 2000.0 and onwards and use WGS84 spheroid instead
%     of International Astronomical Union 1966 spheroid as recommended by IAGA
%     in July 2003. Reference radius remains as 6371.2 km - it is NOT the mean
%     radius (= 6371.0 km) but 6371.2 km is what is used in determining the
%     coefficients. Adaptation by Susan Macmillan, August 2003 (for
%     9th generation) and December 2004.
%
%     This is a synthesis routine for the 10th generation IGRF as agreed
%     in December 2004 by IAGA Working Group V-MOD. It is valid 1900.0 to
%     2010.0 inclusive. Values for dates from 1945.0 to 2000.0 inclusive are
%     definitve, otherwise they are non-definitive.
%   INPUT
%     date  = year A.D. Must be greater than or equal to 1900.0 and
%             less than or equal to 2020.0. Warning message is given
%             for dates greater than 2015.0. Must be double precision.
%     alt   = distance from centre of Earth in km (>3485 km)
%     colat = colatitude in radians (0-2pi)
%     elong = east-longitude in radians (0-2pi)
%   OUTPUT
%     field = magnetic field:
%     field[0]  = north component (nT)
%     field[1]  = east component (nT)
%     field[2]  = vertical component (nT) (positive down)
%
%     To get the other geomagnetic elements (D, I, H and secular
%     variations dD, dH, dI and dF) use routines ptoc and ptocsv.
%
%     Adapted from 8th generation version to include new maximum degree for
%     main-field models for 2000.0 and onwards and use WGS84 spheroid instead
%     of International Astronomical Union 1966 spheroid as recommended by IAGA
%     in July 2003. Reference radius remains as 6371.2 km - it is NOT the mean
%     radius (= 6371.0 km) but 6371.2 km is what is used in determining the
%     coefficients. Adaptation by Susan Macmillan, August 2003 (for
%     9th generation) and December 2004.
%
% Obs:
%   The Matlab version of igrf_field reads the igrf.dat file with the field
%   coefficients.
%
%	 C Version by Valdemir Carrara jun 2005
%    Matlab version by Valdemir Carrara, May 2009
%
persistent n_data n_year order stll gh
    
    if isempty(n_data)
        [n_data, n_year, order, stll, gh] = ...
            igrf_read_data('igrf11.dat');
    end

%  Starting point of the field coefficients
%		stll(i) = stll(i-1) + order(i-1)*(order(i-1)+2)

    cl = zeros([1, 14]);
    sl = cl;            % maximum model order (mmo) + 1

    p = zeros([1, 106]);
    q = p;              % (mmo + 1)*(mmo + 2) / 2 + 1

%    set initial values
    x     = [0, 0, 0];

    if date < n_year(1) || date > n_year(n_data) + 5 
%
%	    Date must be in the valid range.
%		Otherwise field returns null
%
        disp('igrf_field error');
        disp('  Date must be in the range:')
        disp(n_year(1));
        disp(n_year(n_data) + 5);
        field = [0.0, 0.0, 0.0];
        return
    end

	t     = 0.2*(date - 1900.0);
	i     = fix(t);
	t     = t - i;

    if date < n_year(n_data - 1) 
		tc    = 1.0 - t;
    else
		t     = date - n_year(n_data - 1);	% 0 < t < 9.99
      	tc    = 1.0;
    end

    ll    = stll(i + 1);
	nmx   = order(i);
    if order(i+1) < nmx 
        nmx = order(i+1);	% correção para prevenir erros de interpolação
    end
	nc    = nmx*(nmx+2);
	kmx   = (nmx+1)*(nmx+2)/2;

	r     = alt;
	ct    = cos(colat);
	st    = sin(colat);

    cl(1) = cos(elong);
	sl(1) = sin(elong);
	l     = 0;
	m     = 1;
	n     = 0;

	ratio = 6371.2/r;
	rr    = ratio*ratio;
%
%    computation of Schmidt quasi-normal coefficients p and x(=q)
%
	p(1)  = 1.0;
	p(3)  = st;
	q(1)  = 0.0;
	q(3)  =  ct;

	% m   n  fn  gn  fm
	% 1   0
	% 0   1   1   0   0
	% 1

    for k=2:kmx
        if n < m
			m     = 0;
			n     = n + 1;
			rr    = rr*ratio;
			fn    = n;
			gn    = n - 1;
        end
		fm    = m;
        if m ~= n
			gmm    = m*m;
			one   = sqrt(fn*fn - gmm);
			two   = sqrt(gn*gn - gmm)/one;
			three = (fn + gn)/one;
			i     = k - n;
			j     = i - n + 1;
			p(k)  = three*ct*p(i) - two*p(j);
			q(k)  = three*(ct*q(i) - st*p(i)) - two*q(j);
        else
            if k ~= 3
				one   = sqrt(1.0 - 0.5/fm);
				j     = k - n - 1;
				p(k)  = one*st*p(j);
				q(k)  = one*(st*q(j) + ct*p(j));
				cl(m) = cl(m-1)*cl(1) - sl(m-1)*sl(1);
				sl(m) = sl(m-1)*cl(1) + cl(m-1)*sl(1);
            end
        end
    %
    % synthesis of x, y and z in geocentric coordinates
    %
		lm = ll + l + 1;
		one   = (tc*gh(lm) + t*gh(lm+nc))*rr;
    %    a = gh(lm);   % ************************
    %    a = gh(lm+nc);   % ************************
        if m ~= 0
			two   = (tc*gh(lm+1) + t*gh(lm+nc+1))*rr;
			three = one*cl(m) + two*sl(m);
            if st ~= 0.0
				y     = (one*sl(m) - two*cl(m))*fm*p(k)/st;
            else
				y     = (one*sl(m) - two*cl(m))*q(k)*ct;
            end
			x     = x + [three*q(k), y, -(fn + 1.0)*three*p(k)];
		    l     = l + 2;
        else
			x     = x + [one*q(k), 0, -(fn + 1.0)*one*p(k)];
			l     = l + 1;
        end
		m     = m + 1;
%        disp(x);
    end
    %
    %     conversion to coordinate system specified by itype
    %
    %   f     = sqrt(x*x + y*y + z*z);
	field = x;
