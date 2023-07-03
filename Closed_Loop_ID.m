%% Closed loop

%% Signal plots

t=1:1:length(u);

figure(200)
subplot(3,1,1)
plot(t,r1)
subplot(3,1,2)
plot(t,ucl)
title('u')
subplot(3,1,3)
plot(t,ycl)
title('y')

%% 2 step

THarx = arx([ucl r1],[20 20 0]);
usim = filter(THarx.B,THarx.A,r1);

THoe = oe([ycl usim],[5 5 1],'maxiter',100);
Ghat = tf(THoe.B,THoe.F,Ts);

[m,p] = bode(Ghat,2*pi*f);
ysim = filter(THoe.B,THoe.F,usim);

figure(300)
subplot(2,1,1)
loglog(f,abs(Pyu./Puu),'g',f,squeeze(m),'r')
subplot(2,1,2)
semilogx(f,180/pi*angle(Pyu./Puu),'g',f,squeeze(p),'r')

figure(400)
plot(t,ucl,'g',t,usim,'r')
title('Figure 3: Measured vs simulated noise free input')
xlabel('Time(s)')
ylabel('Amplitude')
legend('u','u_n_f')

figure(401)
plot(t,ycl,'g',t,ysim,'r')
title('Figure 4: Measured vs simulated output')
xlabel('Time(s)')
ylabel('Amplitude')
legend('y_c_l','Y_c_lsim')

figure(402)
step(Ghat)
title('Figure 5: Step response of G_C_l')

fprintf('The closed loop lopes are\n')
pole(feedback(Ghat,C))
