Is = 0.01e-12;
Ib = 0.1e-12;
Vb = 1.3;
Gp = 0.1;

V = linspace(-1.95,0.7,200);

I1 = Is*(exp(1.2*V/0.025) - 1) + Gp*V -Ib*exp(-(1.2/0.025)*(V+Vb));

r = -0.2*I1 + 0.4*I1.*rand(1,200);
I2 = I1 + r;

p4 = polyfit(V,I2,4);
p8 = polyfit(V,I2,8);
I4 = polyval(p4,V);
I8 = polyval(p8,V);

fo = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C.*(exp(1.2*(-(x+D))/25e-3)-1)');
ff = fit(V',I2',fo);
If = ff(V);
fo = fittype('A.*(exp(1.2*x/25e-3)-1) + 0.1*x - C.*(exp(1.2*(-(x+1.3))/25e-3)-1)');
ff = fit(V',I2',fo);
IfAC = ff(V);
fo = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C.*(exp(1.2*(-(x+1.3))/25e-3)-1)');
ff = fit(V',I2',fo);
IfABC = ff(V);

inputs = V.';
targets = I2.';
hiddenlayersize = 10;
net = fitnet(hiddenlayersize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs)
view(net)
Inn = outputs

figure(1)
plot(V,I1,V,I2,V,I4,V,I8);
legend('original data','Noisy Data','4th Order Polynomial','8th order Polynomial')
figure(2)
semilogy(V,abs(I1),V,abs(I2),V,abs(I4),V,abs(I8));
legend('original data','Noisy Data','4th Order Polynomial','8th order Polynomial')

figure(3)
plot(V,I2,V,If,V,IfAC,V,IfABC)
legend('noisy data','nonlinear fit','only A and C','only ABC')
ylim([-5 5])

figure(4)
plot(V,I2,V,outputs)
legend('noisy data','neural net fit')