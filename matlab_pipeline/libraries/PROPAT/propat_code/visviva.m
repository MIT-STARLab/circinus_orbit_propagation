function vi = visviva(a, r)
% equa��o da visviva
% entradas:
%    a    Semi-eixo maior da �rbita (m).
%    r    Altitude do sat�lite num dado instante (m)
% sa�das:
%    vi   Velocidade do sat�lite no ponto dado por r.
% Valdemir Carrara (11/2014)

mu = 3.986e14;
vi = sqrt(mu*(2/r - 1/a));
