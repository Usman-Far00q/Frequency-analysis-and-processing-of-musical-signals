clear all;
clc;

alpha = input('enter the value of alpha: ');
K = input('enter the value of K for Shelving Filter: ');

alpha_E = input('enter the value of alpha for Equilizer: ');
beta = input('enter the value of beta for Equilizer: ');
K_E = input('enter the value of K for Equilizer: ');

[y,Fs] = audioread('samplesound.mp3');
load handel.mat;

%-------------------Low Pass Filter------------------------

L_scale = (1-alpha)/2;
L_b = [1 1];
b_L = L_scale*L_b;
a = [1 -alpha];
output_L = filter(b_L,a,y);
figure(1)
plot(1:length(y),y)
title('Original Signal');
figure(2)
plot(1:length(output_L),output_L)
title('Low Pass Signal');
sound(y,Fs)
pause(15)
sound(output_L,Fs);
[hL wL] = freqz(b_L,a,'whole');



%-----------------High Pass Filter----------------------------
H_scale = (1+alpha)/2;
H_b = [1 -1];
b_H = H_scale*H_b;
output_H = filter(b_H,a,y);
[hH wH] = freqz(b_H,a,'whole');
figure(3)
plot(1:length(output_H),output_H)
title('High Pass Signal');
sound(y,Fs)
pause(15)
sound(output_H,Fs);


%---------------------Shelving Low Frequency Filter---------------------
g_L = K*hL + hH;
u_L = conv(y,abs(g_L));
figure(4)
plot(1:length(u_L),u_L);
title('Shelving Low Frequency Filter');
pause(10);
sound(u_L,Fs);

%---------------------- Shelving High Frequency Filter------------------------------------
g_H = hL + K*hH;
u_H = conv(y,abs(g_H));
figure(5)
plot(1:length(u_H),u_H);
title('Shelving High Frequency Filter');
pause(10);
sound(u_H,Fs);


%----------------------------Band Pass Filter------------------


scale_P = (1 - alpha_E)/2;
P_b = [1 0 -1];
b_P = scale_P * P_b;
a_E = [1 (-beta*(alpha_E+1)) alpha_E];

output_P = filter(b_P, a_E, y);

[h_P w_P] = freqz(b_P, a_E, 'whole');

%----------------------------Band Pass Filter------------------
scale_S = (1 + alpha_E)/2;
S_b = [1 -2*beta 1];
b_S = scale_S * S_b;

output_S = filter(b_S, a_E, y);

[h_S w_s] = freqz(b_S, a_E, 'whole');

%----------------------------Equilizer-------------------------

g_E = K_E*h_P + h_S
u_E = conv(y,abs(g_E));
figure(6)
plot(1:length(u_E),u_E);
title('Equilizer');
pause(10);
sound(u_E,Fs);
