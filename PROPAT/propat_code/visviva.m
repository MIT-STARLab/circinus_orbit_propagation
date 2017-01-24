function vi = visviva(a, r)
% equação da visviva
% entradas:
%    a    Semi-eixo maior da órbita (m).
%    r    Altitude do satélite num dado instante (m)
% saídas:
%    vi   Velocidade do satélite no ponto dado por r.
% Valdemir Carrara (11/2014)

mu = 3.986e14;
vi = sqrt(mu*(2/r - 1/a));
