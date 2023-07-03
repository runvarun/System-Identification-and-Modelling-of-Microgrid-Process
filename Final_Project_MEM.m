%% Model Error Modelling

% Additive error overbound
% x=u
% z=y-Gcl*unf

z=ycl-lsim(Ghat,usim);

THADD_ERR=arx([z,usim],[20,20,0]);

[me,pe,w,sdmag,sdphase] = bode(THADD_ERR,2*pi*f);

figure(600)
loglog(f,squeeze(me),'r',f,squeeze(me)+3*abs(squeeze(sdmag)),'r--')
legend('Delta_a','Delta_a + 3*sigma')
xlabel('Frequency(hz)')
ylabel('Db')
title('Figure 6 : Upper bound on additive error ')

figure(601)
loglog(f,squeeze(m),'r',f,squeeze(m)+(squeeze(me)+3*abs(squeeze(sdmag))),'g-',f,squeeze(m)-(squeeze(me)+3*abs(squeeze(sdmag))),'b-')
legend('G_hat','Ghat+error','Ghat-error')
title('model error modelling')

figure(602)
loglog(f,abs(Pyu./Puu),'g',f,squeeze(m),'r',f,squeeze(m)+(squeeze(me)+3*abs(squeeze(sdmag))),'b-',f,squeeze(m)-(squeeze(me)+3*abs(squeeze(sdmag))),'b--')
legend('G_0','G_hat','Ghat+error','Ghat-error')
title('model error modelling')

%% Robust Stability Test

M=feedback(C,Ghat);
delta_a=tf(THADD_ERR.B,THADD_ERR.A,Ts);

robustness=delta_a*M;

figure(603)
[mr,pr]=bode(robustness,2*pi*f);
subplot(2,1,1)
loglog(f,squeeze(mr))
title('Figure 7 : Bode plot of Delta_a * M')
xlabel('Frequency(hz)')
ylabel('Db')
subplot(2,1,2)
semilogx(f,squeeze(pr))
xlabel('Frequency(hz)')
ylabel('Angle(Degree)')


