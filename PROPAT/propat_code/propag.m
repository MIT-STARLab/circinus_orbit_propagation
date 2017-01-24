%
% Este programa visa efetuar uma animação da evolução da
% atitude simulada de um satélite.
% A animação será gerada em POV, enquanto que a atitude
% será propagada em Matlab, e armazenada no arquivo
% attit.txt, cujo formato é o seguinte:
%
% Primeira linha:
% [tstep], [tend],
% Segunda linha:
% <[hx], [hy], [hz]>, 
% terceira e demais linhas:
% [stim], <[bx], [by], [bz]>, <[mx], [my], [mz]>, <[ix], [iy], [iz]>,
% com:
%   tstep : intervalo de tempo entre dois valores consecutivos da atitude
%   em segundos
%   tend  : instante referente ao último valor da atitude em segundos
%   hx, hy e hz : componentes do vetor momento angular do satélite
%   stim = tempo (s)
%   bx, by e bz = ângulos de Euler numa rotação XYZ, em graus,
%                 do sistema fixo ao corpo do satélite
%   mx, my e mz = idem, do sistema de eixos principais de inércia.
%   ix, iy e iz = idem, do sistema de eixos inerciais (fixo).
%

% Arquivo de saida:
% fid = fopen('c:\mydocu~1\valdemir\cursos\semina~1\cursod~1\attit.txt', 'wt');
fid = fopen('propatt.txt', 'wt');

% atitude de referencia
euler_ref = [0; 0; 0]; % em graus
angvec_ref = [0; 0; 0]; % em rpm

% ganhos do controle
propgain = 0.5*1;
dervgain = 0.5*15;

% torque máximo
% torq_max = [0.15; 0.15; 0.15];
% torq_max = [1000, 1000, 1000];
torq_max = 0.15;

% transformação para radianos
euler_ref = euler_ref*pi/180; % em rad
angvec_ref = angvec_ref*pi/30; % em rpm

% tempos de propagação (s):
tini = 0;
tstep = 1/15;
tend = 36.;

% inicialização
angular_velocity = [10; 0; 10]; % em rpm
euler_angles = [0; 0; 0];  % em graus

hamor = [0; 0; 0];
angular_velocity = [0; 0; 10];
dimens = [6; 4; 2];
torqcon = [0; 0; 0];

anima = 15;

if anima==1   			% Movimento puro sem rotação
   angular_velocity = [0; 0; 10];
elseif anima==2		% Nutação num disco
   angular_velocity = [6; 0; 4];
   dimens = [6; 6; 2];
elseif anima==3		% Nutação num corpo com momentos de inércia diferentes
   angular_velocity = [7; 0; 4];
elseif anima==4		% Nutação em torno do eixo de menor (z) momento de inércia
   angular_velocity = [1.5; 0; 11];
   dimens = [2; 4; 6];
elseif anima==5		% Amortecimento de nutação 
   angular_velocity = [16; 0; 8];
   angular_velocity = [2; 0; 8];
	% amortecimento de nutação
   cmat = [1.0, 0, 0; 0, 1.0, 0; 0, 0, 1.0]*.6;
   tinut = [2.0; 2.0; 2.0];
   hamor = tinut.*angular_velocity*pi/30;
elseif anima==6		% Torque constante no inercial
   torqcon = [1; 0; 0];
elseif anima==7		% Torque de precessão (sistema do corpo)
   angular_velocity = [0; 0; 12];
elseif anima==8		% Controle PID
   angular_velocity = [0; 0; 0];
   kp = [.8; 1.6; 3.2];
   kd = [5; 8; 15];
elseif anima==9		% Gradiente de gravidade
   angular_velocity = [0; 0; 0];
   dimens = [1; 1; 20];
elseif anima==10		% Aquisição de atitude com jatos de gás
   angular_velocity = [8; -6; 10];
   dimens = [2; 1.6; 1.8];
elseif anima==11    % Rotação estável sobre o eixo de menor momento de inércia
   angular_velocity = [0; 0; 10];
   dimens = [2; 4; 6];
elseif anima==12    % Rotação sobre o eixo intermediário
   angular_velocity = [.2; 0; 8];
   dimens = [2; 6; 4];
elseif anima==13		% Amortecimento de nutação com rotação no eixo de menor momento
   angular_velocity = [2; 0; 20];
%   angular_velocity = [3; 3; 180]; %rpm *******************8
   dimens = [2; 4; 6];
	% amortecimento de nutação
   cmat = [1.0, 0, 0; 0, 1.0, 0; 0, 0, 1.0]*1.50;
   tinut = [2.0; 2.0; 2.0];
   hamor = tinut.*angular_velocity*pi/30;
elseif anima==14		% Teste do integrador
   angular_velocity = [0; 0.2; 2]*30/pi;  % em rpm
   dimens = sqrt(10)*[1; 1; 10];
   euler_angles = quatezxz([0; 0; 0; 1]);
   tstep = 0.02;
   tend = 20.;
elseif anima==15		% Rotação em torno do eixo intermediário
   angular_velocity = [0.04; 12; 0];
   dimens = [2; 4; 6];
end

% simulação do efeito de uma roda (com uma roda na animação)

% torques externos
ext_torq = [0; 0; 0];
% matriz de inércia (kg*m2) - disco
lx = dimens(1);
ly = dimens(2);
lz = dimens(3);
tensin = [ly*lz, 0.0, 0.0; 0.0, lx*lz, 0.0; 0.0, 0.0, lx*ly];
% tensin = [48, 0.0, 0.0; 0.0, 44, 0.0; 0.0, 0.0, 2]; %**********************

% inversa da matriz de inércia
teninv = inv(tensin);

% momento angular 
ele = tensin*angular_velocity + hamor; 

% calculo da matriz de rotacao inicial, para fazer com que
% o momento angular esteja sobre o eixo z.
lmod = sqrt(ele'*ele);
linh = sqrt(ele(2)*ele(2) + ele(3)*ele(3));
if linh ~= 0
	coal = ele(3)/linh;
   sial = ele(2)/linh;
else
   coal = 1;
   sial = 0;
   if (lmod==0)
      lmod = 1;
   end
end
cobe = linh/lmod;
sibe = ele(1)/lmod;
rmat = [cobe, -sial*sibe, -coal*sibe; 0, coal, -sial; sibe, sial*cobe, coal*cobe];
% a atitude inicial é dada pela inversa da matriz:
euler_angles = -rmxexyz(rmat);

if (anima==6)
	euler_angles = [0; 0; 0];
elseif (anima==7)
   euler_angles = [0; 30; 0]*pi/180;
elseif (anima==8)
   euler_angles = [320; -30; 290]*pi/180;
elseif (anima==9)
   euler_angles = [-60; 0; 0]*pi/180;
elseif (anima==10)
   euler_angles = [-60; -30; 40]*pi/180;
end

% valor inicial
euler_att = euler_angles;
euler_ant = euler_att;

% inicializacao de som
soundw = [];

% vetor de estado
if (anima==5 || anima==13)
	state_vector_in = [exyzquat(euler_angles); angular_velocity*pi/30; hamor; exyzquat(euler_angles)];
else
	state_vector_in = [exyzquat(euler_angles); angular_velocity*pi/30];
end
state_vector = state_vector_in;

% tend = 60.; %**********************
time_att = tini;

% precisão do integrador:
options = odeset('abstol', 1e-8, 'reltol', 1e-8);

torq_att = [0; 0; 0];
torq_dis = [0; 0; 0];

% cabeçalho do arquivo
fprintf(fid, '%15.11f, %12.5f, %12.5f,\n', [tstep, tend, anima]);
fprintf(fid, ' <%8.3f, %8.3f, %8.3f>,\n', [lx, ly, lz]);
%fprintf(fid, '%8.3f, <%8.3f, %8.3f, %8.3f>,\n', [tini, 180/pi*euler_angles']);
if (anima==7)
   rot_mat = exyzrmx(euler_angles);
   ele = rot_mat'*tensin*angular_velocity*pi/30;
   lmod = sqrt(ele'*ele);
   elez = ele/lmod;
   torqcon = cross([0; 0; 0.1], ele);
   elex = torqcon;
   elex = elex/sqrt(elex'*elex);
   eley = cross(elez, elex);
   rmat = [elex'; eley'; elez'];
   ang_vec = -180/pi*rmxexyz(rmat');
   fprintf(fid, '%8.3f, <%8.3f, %8.3f, %8.3f>, <%8.3f, %8.3f, %8.3f>, %8.3f,\n',...
    [tini, 180/pi*euler_angles', ang_vec', lmod]);
elseif (anima==8 || anima==10)
   euler_att = -rmxexyz(exyzrmx(euler_angles)');
   if euler_att(1) > pi
		euler_att(1) = euler_att(1) - 2*pi;
   end
   if euler_att(1) < -pi
      euler_att(1) = euler_att(1) + 2*pi;
   end
	if euler_att(3) > pi
   	euler_att(3) = euler_att(3) - 2*pi;
   end
   if euler_att(3) < -pi
      euler_att(3) = euler_att(3) + 2*pi;
   end
   euler_ant = euler_att;
   fprintf(fid, '%8.3f, <%8.3f, %8.3f, %8.3f>, <%8.3f, %8.3f, %8.3f>, %8.3f,\n',...
    [tini, 180/pi*euler_att', [0, 0, 0], 0]);
    disp ('ola')
elseif (anima==9)
   fprintf(fid, '%8.3f, <%8.3f, %8.3f, %8.3f>, <%8.3f, %8.3f, %8.3f>, %8.3f,\n',...
    [tini, 180/pi*euler_att', [0, 0, 0], 0]);
elseif (anima==5 || anima==13)
   fprintf(fid, '%8.3f, <%8.3f, %8.3f, %8.3f>, <%8.3f, %8.3f, %8.3f>, %8.3f,\n',...
    [tini, 180/pi*euler_angles', 180/pi*euler_angles', lmod]);
else
   fprintf(fid, '%8.3f, <%8.3f, %8.3f, %8.3f>, <%8.3f, %8.3f, %8.3f>, %8.3f,\n',...
    [tini, 180/pi*euler_angles', -180/pi*euler_angles', lmod]);
end

tttt = 1;
ittt = 1;

for time = tini:tstep:tend-tstep
   tspan = [time, time+tstep/2, time+tstep];
   
   if (anima==5 || anima==13)
	   [T, Y] = ode45('pndbody', tspan, state_vector, options, ext_torq, tensin, teninv, tinut, cmat);
   else
	   [T, Y] = ode45('rigbody', tspan, state_vector, options, ext_torq, tensin, teninv);
   end
   
   state_vector = Y(3, :)';
   
   % valor inicial
   %	euler_att = quatexyz(state_vector);
   rot_mat = quatrmx(state_vector);
   euler_att = -rmxexyz(rot_mat');
   
	angvec_att = state_vector(5:7);
   
   for ind = 1: 3
   	if euler_att(ind) > pi
			euler_att(ind) = euler_att(ind) - 2*pi;
	   end
   	if euler_att(ind) < -pi
	      euler_att(ind) = euler_att(ind) + 2*pi;
	   end
   end
   if (anima==8 || anima==10)
      euler_att = proximus(euler_att, euler_ant);
   end
   euler_ant = euler_att;
   euler_deg = 180/pi*euler_ant;
   time_att = cat(2, time_att, T(3));
   
   if (anima == 6)
      ele = rot_mat'*tensin*angvec_att;
      lmod = sqrt(ele'*ele);
      elez = ele/lmod;
      eley = cross(elez, torqcon);
      eley = eley/sqrt(eley'*eley);
      elex = cross(eley, elez);
      rmat = [elex'; eley'; elez'];
      ang_vec = -180/pi*rmxexyz(rmat');
	 	cont_torq = rot_mat*torqcon;
   elseif (anima==7)
      ele = rot_mat'*tensin*angvec_att;
      lmod = sqrt(ele'*ele);
      elez = ele/lmod;
      torqcon = cross([0; 0; 0.1], ele);
      elex = torqcon;
      elex = elex/sqrt(elex'*elex);
      eley = cross(elez, elex);
      rmat = [elex'; eley'; elez'];
      ang_vec = -180/pi*rmxexyz(rmat');
	 	cont_torq = rot_mat*torqcon;
   elseif (anima==8)
      torqcon = -kp.*euler_att - kd.*angvec_att;
      if (time < 2)
         torqcon = [0; 0; 0];
      end
      torqcon = satlins(torqcon);
      cont_torq = torqcon;
      ele = rot_mat'*torqcon;
      lmod = sqrt(ele'*ele);
      if (lmod == 0)
         ang_vec = [0; 0; 0];
      else
	      elez = ele/lmod;
   	   eley = cross(elez, [0; 1; 0]);
      	eley = eley/sqrt(eley'*eley);
	      elex = cross(eley, elez);
   	   rmat = [elex'; eley'; elez'];
         ang_vec = -180/pi*rmxexyz(rmat');
      end
   elseif (anima==9)
      torqcon = gg_torque(1, tensin, rot_mat*[0; 0; 1]) - 3*angvec_att;
      cont_torq = torqcon;
      ele = rot_mat'*torqcon;
      lmod = sqrt(ele'*ele);
      if (lmod == 0)
         ang_vec = [0; 0; 0];
      else
	      elez = ele/lmod;
   	   eley = cross(elez, [0; 1; 0]);
      	eley = eley/sqrt(eley'*eley);
	      elex = cross(eley, elez);
   	   rmat = [elex'; eley'; elez'];
         ang_vec = -180/pi*rmxexyz(rmat');
      end
   elseif (anima==10)
      torqcon = -2*(euler_att + 4*angvec_att);
      for ind = 1:3
         if (abs(torqcon(ind))<1/15)
            torqcon(ind) = 0;
         else
            torqcon(ind) = 0.5*sign(torqcon(ind));
         end
      end
      cont_torq = torqcon;
      ang_vec = torqcon/0.1;
      soundw = cat(2, soundw, sum(abs(ang_vec))/5);
   elseif (anima==5 || anima ==13)
      % momento angular no sistema do corpo:
      hamor = state_vector(8:10);
      ele = tensin*angvec_att + hamor;
      
      % torque externo: 	ele = ext_torq;
		lmod = sqrt(ele'*ele);
		linh = sqrt(ele(2)*ele(2) + ele(3)*ele(3));
		if linh ~= 0
			coal = ele(3)/linh;
		   sial = ele(2)/linh;
		else
	   	coal = 1;
		   sial = 0;
		end
		cobe = linh/lmod;
   	sibe = ele(1)/lmod;
		rmat = [cobe, -sial*sibe, -coal*sibe; 0, coal, -sial; sibe, sial*cobe, coal*cobe];
      
      rot_mat = quatrmx(state_vector(11:14));
	   euler_att = -rmxexyz(rot_mat');
	   for ind = 1: 3
	   	if euler_att(ind) > pi
				euler_att(ind) = euler_att(ind) - 2*pi;
		   end
	   	if euler_att(ind) < -pi
		      euler_att(ind) = euler_att(ind) + 2*pi;
	  		end
	   end
	   ang_vec = 180/pi*euler_att;
      cont_torq = torqcon;
   else
      ele = tensin*angvec_att;
      
      % torque externo: 	ele = ext_torq;
		lmod = sqrt(ele'*ele);
		linh = sqrt(ele(2)*ele(2) + ele(3)*ele(3));
		if linh ~= 0
			coal = ele(3)/linh;
		   sial = ele(2)/linh;
		else
	   	coal = 1;
		   sial = 0;
		end
		cobe = linh/lmod;
   	sibe = ele(1)/lmod;
		rmat = [cobe, -sial*sibe, -coal*sibe; 0, coal, -sial; sibe, sial*cobe, coal*cobe];
      ang_vec = -180/pi*rmxexyz(rmat');
      cont_torq = torqcon;
   
   end
   
   if (time > ittt*tttt)
      time
      lmod;
      ele;
      ittt = ittt + 1;
   end
   
% 	dis_torq = disturb (time, state_vector);
   dis_torq = [0; 0; 0];
   
   ext_torq = cont_torq + dis_torq;
	if (anima==5 || anima==13)   
      torq_att = cat(2, torq_att, (state_vector(8:10)./tinut-angvec_att)*30/pi);
   else
      torq_att = cat(2, torq_att, cont_torq);
   end
   torq_dis = cat(2, torq_dis, dis_torq);
   
%   [sou, emsg] = sprintf('%8.3f, <%8.3f, %8.3f, %8.3f>,\n', [time, euler_deg'])
%   fprintf(fid, '%8.3f, <%8.3f, %8.3f, %8.3f>,\n', [time+tstep, euler_deg']);
	fprintf(fid, '%8.3f, <%8.3f, %8.3f, %8.3f>, <%8.3f, %8.3f, %8.3f>, %8.3f,\n',...
      [time+tstep, euler_deg'], ang_vec, lmod);
     
   euler_angles = cat(2, euler_angles, euler_deg);
   angular_velocity = cat(2, angular_velocity, angvec_att*30/pi);
   
end

close all

subplot (3,1,1), plot (time_att, euler_angles(1,:), 'r', time_att, euler_angles(2,:), 'g', ...
      time_att, euler_angles(3,:), 'b');
%figure
subplot (3,1,2), plot (time_att, angular_velocity(1, :), 'r', time_att, angular_velocity(2, :), 'g', ...
	   time_att, angular_velocity(3, :), 'b');
%figure
subplot (3,1,3), plot (time_att, torq_att(1, :), 'r', time_att, torq_att(2, :), 'g', ...
      time_att, torq_att(3, :), 'b');
%figure
%plot (time_att, torq_dis(1,:), 'r', time_att, torq_dis(2,:), 'g', ...
%      time_att, torq_dis(3,:), 'b');

figure

plot (euler_angles(1, :), angular_velocity(1, :), 'r', euler_angles(2, :), ...
      angular_velocity(2, :), 'g', euler_angles(3, :), angular_velocity(3, :), 'b');
   
figure
   
   plot (time_att, angular_velocity(1, :), 'r')
   figure
   plot (time_att, angular_velocity(2, :), 'g')
   figure
   plot (time_att, angular_velocity(3, :), 'b');

% plot (T, euler_angles);
% plot (euler_angles(1, :), euler_angles(2, :));

st = fclose(fid);

if anima==10
  a = [0, .5, .7, .85];

  [y, fs, bits] = audioread('noise.wav');
  [b, c] = size(y);
  ind = 1;
  delt = b*tstep/(tend-tini);
  icon = 1;

  for time = tini : tstep : tend-tstep
     iend = ind + delt - 1;
     y(ind:iend) = a(soundw(icon)+1)*y(ind:iend);
     ind = ind + delt;
     icon = icon + 1;
  end
  audiowrite(y, fs, 'noise2.wav');
end