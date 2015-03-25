spacing = 64;


cd(getfamilydata('Directory','DataRoot'));
cd BeamDump

%FileName = 'BeamBump_2014-10-19';
%FileName = 'BeamBump_2014-10-20';
%FileName = 'BeamBump_2014-10-29_04-08-54';
FileName = 'BeamBump_2015-02-10_16-23-45';
%FileName = 'BeamBump_2015-02-11_17-06-01';

load([FileName, '.mat']);

% Find the index of all BPM3s in each Sector (should be 12 bpms)
bpm3index = zeros(12,1);
bpmkey = 1;

for i = 1:43
	if strcmp('BPM2',TBT{i}.Prefix(7:end))
		bpm3index(bpmkey) = i;
		bpmkey = bpmkey+1;
	end		
end

N = 1135;
% create combined bpms data
Tx = zeros(N*length(bpm3index),1);
Ty = zeros(N*length(bpm3index),1);
k=1;
for i = 1:length(bpm3index)
	Tx(N*(i-1)+k:N*i) = TBT{bpm3index(i)}.X(1:N);
	Ty(N*(i-1)+k:N*i) = TBT{bpm3index(i)}.Y(1:N);
end

k=1;
% pre defined cell arrays
tuneX1 = cell(1,floor((N)/spacing));
tuneY1 = cell(1,floor((N)/spacing));

for i = 2:floor(N/spacing)
	space_start = (i-1)*spacing*12+k;
	space_end = i*spacing*12;
	%[tuneX1{i-1}, tuneY1{i-1}] = levon_findtunes(Tx(space_start:space_end),Ty(space_start:space_end));
	tuneX1{i-1} = abs(calcnaff(Tx(space_start:space_end), Tx(space_start-1:space_end-1),1)/(2*pi));
	tuneY1{i-1} = abs(calcnaff(Ty(space_start:space_end), Ty(space_start-1:space_end-1),1)/(2*pi));
	k=0;
	display(strcat(int2str(floor(N/spacing)-i),' turns left'));
end

% pre defined cell arrays
tunex = zeros(1,length(tuneX1));
tuney = zeros(1,length(tuneY1));

%initial tune
currenttunex = 0.1799;
currenttuney = 0.2499;

% take values closest to last recorded measure of the tune
for i = 1:length(tuneX1)-1
	[~,indx] = min(abs(currenttunex - tuneX1{i}));
	[~,indy] = min(abs(currenttuney - tuneY1{i}));
	tunex(i) = tuneX1{i}(indx);
	tuney(i) = tuneY1{i}(indy);
	currenttunex = tunex(i);
	currenttuney = tuney(i);
end

figure;
subplot(211)
hold on
plot([1,length(tunex)*spacing],[0.1799,0.1799],'r');
scatter([1:length(tunex)].*spacing,tunex,'*');
ylabel('Qx')
xlabel('turn #')
subplot(212)
hold on
plot([1,length(tuney)*spacing],[0.2499,0.2499],'r');
scatter([1:length(tuney)].*spacing,tuney,'*');
ylabel('Qy')
xlabel('turn #')

