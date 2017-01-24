% program to test the igrf model in Matlab

date  = 2008.0;
alt   = 500. + 6371.2;
geomag = zeros([181,361]);
for elong = 0:360
    for colat = 0:180
        field = igrf_field (date, alt, colat*pi/180, elong*pi/180);
        magn = sqrt(field*field')/100;
        inten = fix(magn/1600*255);
        if elong > 180
            geomag(colat+1, elong-180) = inten;
        else
            geomag(colat+1, elong+181) = inten;
        end
    end
end
image(geomag)
colormap(gray)
        