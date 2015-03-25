global THERING;
setradiation on;
setcavity off;


cd(getfamilydata('Directory','DataRoot'));
cd BeamDump

%FileName = 'BeamBump_2014-10-19';
%FileName = 'BeamBump_2014-10-20';
%FileName = 'BeamBump_2014-10-29_04-08-54';
FileName = 'BeamBump_2014-11-03_07-43-07';

load([FileName, '.mat']);
BPMIndex = family2atindex('BPMx',getbpmlist('nonbergoz'));
bpm = 42;
%%%%%%%%% Collect BPM data over 1000 turns
ring_sim = ringpass(THERING,[0,0,0,0,0,0]',1000);
xpos_sim = 0;
for i = 1:find(isnan(ring_sim(1,:))==1,1)-2

	lin_sim = linepass(THERING,ring_sim(:,i),1:length(THERING)+1);
	xpos_sim(i) = lin_sim(1,BPMIndex(bpm));
	
end


X = TBT{1}.X(1:end);
X = X - ones(length(X),1)*mean(X);
% get rid of nan
%X = X(1:find(isnan(X),1)-1);
X = abs(fft(X));
Xt=[1:length(X)/2-1]/length(X);

tunes = 0:0.001:0.5;
for i=1:length(tunes)
	u1(i)=naffcorr(tunes(i), [1:length(X)], X', 1);
end

figure

subplot(211);
y = abs(X(1:length(X)/2-1))
plot(Xt(1:end), y(1:end));
subplot(212);
%semilogy(tunes, 1./u1, 'r');
plot(xpos_sim);
