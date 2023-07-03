%% Final Project (Open loop)

%% Signal plots

% u = [zeros(100,1);u];
% y = [zeros(100,1);y];

t=1:1:length(u);
figure(100)
subplot(2,1,1)
plot(t,u)
title('u')
subplot(2,1,2)
plot(t,y)
title('y')

Ts = t(2)-t(1);

%% Open loop SPA


N = length(u);
W=[zeros(1,100) hanning(N-200)' zeros(1,100)];
U=fft(W.*u');
Y=fft(W.*y');
Puu=U.*conj(U)/sum(W.^2);
Pyu=Y.*conj(U)/sum(W.^2);
f=0:1/(N*Ts):1/Ts-1/(N*Ts);
Puu=Puu(1:N/2+1).';
Pyu=Pyu(1:N/2+1).';
f=f(1:N/2+1);

figure(101)
subplot(2,1,1)
loglog(f,abs(Pyu./Puu))
title('Frequency response of real system')
ylabel('Db')
subplot(2,1,2)
semilogx(f,180/pi*angle(Pyu./Puu))
ylabel('Angle (degree)')
xlabel('Frequency (Hz)')

%% High order ARX

THarx=arx([y u],[15 16 0]);
[marx,parx]=bode(tf(THarx.B,THarx.A,Ts),2*pi*f);
ysim=filter(THarx.B,THarx.A,u);

G_hat_arx=tf(THarx.B,THarx.A,Ts);
[a,b,c,d]=tf2ss(THarx.B,THarx.A);
G_hat_arx=ss(a,b,c,d);

figure(2)
subplot(2,1,1)
loglog(f,abs(Pyu./Puu),'g',f,squeeze(marx),'r')
subplot(2,1,2)
semilogx(f,180/pi*angle(Pyu./Puu),'g',f,squeeze(parx),'r')

figure(3)
plot(t,y,'g',t,ysim,'r')

figure(4)
step(tf(THarx.B,THarx.A,Ts))

%% Filter for OE

s=tf('s');
P=c2d(1/(s^2),Ts);

wn=0.6283*0.08;
zeta=0.05;
numf=[0 0 wn^2];
denf=[0.08 (2*zeta*wn)/0.08 wn^2/0.08];
filt=tf(numf,denf);
filt=c2d(filt,Ts)
% figure(105)
% bode((1/filt),2*pi*f)

%% Low order OE

THoe=oe([y u],[5 5 1],'maxiter',100);
[m,p]=bode(tf(THoe.B,THoe.F,Ts),2*pi*f);
ysim=filter(THoe.B,THoe.F,u);

G_hat_oe=tf(THoe.B,THoe.F,Ts)

figure(5)
subplot(2,1,1)
loglog(2*pi*f,abs(Pyu./Puu),2*pi*f,squeeze(m),'r')
subplot(2,1,2)
semilogx(2*pi*f,180/pi*angle(Pyu./Puu),2*pi*f,squeeze(p),'r')

figure(6)
plot(t,y,'g',t,ysim,'r')
title('Figure 1: Measured vs Simulated output')
xlabel('Time(s)')
ylabel('Amplitude')
legend('y','ysim')

figure(7)
%lsim(G_hat_oe,ones(100,1))
step(tf(THoe.B,THoe.F,Ts))
title('Figure 2: Step respose of G_o_l')

fprintf('The closed loop lopes are\n')
pole(feedback(G_hat_oe,C))

%% Controller information

[numc,denc]=ss2tf(Ac,Bc,Cc,Dc);
C=tf(numc,denc,Ts)

isstable(feedback(G_hat_oe,C))
