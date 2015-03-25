global THERING;

setradiation on;
setcavity on;

cor = 'CorrectorPass';
names = cell(1,length(THERING));
for i = 1:length(THERING)
	names{i} = THERING{i}.PassMethod;
end

locs = find(strcmp(cor,names));

THERINGNEW = [THERING, THERING, THERING];

THERINGNEW{12}.KickAngle = [0.0001,0];

T = ringpass(THERINGNEW,[0,0,0,0,0,0]',1000);

figure
subplot(211);
plot(T(1,:));
grid on
subplot(212);
plot(T(3,:));
grid on

figure
hold on
for i = 2:1000
	plot([T(1,i-1),T(1,i)],[T(2,i-1),T(2,i)])
	%axis([-2e-3,2e-3,-6e-5,6e-5])
	pause(0.05)
end
