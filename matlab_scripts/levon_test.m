cd(getfamilydata('Directory','DataRoot'));
cd BeamDump

%FileName = 'BeamBump_2014-10-19';
%FileName = 'BeamBump_2014-10-20';
%FileName = 'BeamBump_2014-10-29_04-08-54';
FileName = 'BeamBump_2015-02-10_16-23-45';
%FileName = 'BeamBump_2015-02-11_17-06-01';

load([FileName, '.mat']);


figure
f = 1.523294.*linspace(0,1,ADC{1}.N);
plot(f,abs(fft(ADC{1}.A)))

figure
plot(1.523294.*linspace(0,1,64),abs(fft(ADC{1}.A(1:64))-abs(ADC{1}.B(1:64))))
[x,indx] = max(abs(ADC{1}.A(1:256))-abs(ADC{1}.C(1:256)));
f = 1.523294.*linspace(0,1,256);
title('ADC')

figure
f = 10.*linspace(0,1,256);
Y = abs(fft(FA{1}.X(1000:1255)));
plot(f(5:128),Y(5:128))
title('FA')

figure
f = 1.523294.*linspace(0,1,256);
Y = abs(fft(TBT{1}.X(600:856)));
plot(f(40:200),Y(40:200))
title('TBT')
