spacing = 40;
ax = 1e-3;
ay = 1e-3;


% Choose bpm to be used for tune measurement
bpm = 1;

cd(getfamilydata('Directory','DataRoot'));
cd BeamDump

%FileName = 'BeamBump_2014-10-19';
%FileName = 'BeamBump_2014-10-20';
%FileName = 'BeamBump_2014-10-29_04-08-54';
FileName = 'BeamBump_2015-02-10_16-23-45';
%FileName = 'BeamBump_2015-02-11_17-06-01';

load([FileName, '.mat']);
k=1;
N = TBT{bpm}.N;
% create combined bpms data
Tx = zeros(1,N*43);
Ty = zeros(1,N*43);
tic
for i = 1:43
	Tx(N*(i-1)+k:N*i) = TBT{i}.X;
	Ty(N*(i-1)+k:N*i) = TBT{i}.Y;
end

k=1;
% pre defined cell arrays
tuneX1 = cell(1,floor((N)/spacing));
tuneY1 = cell(1,floor((N)/spacing));

for i = 2:floor(N/spacing)
	space_start = (i-1)*spacing*43+k;
	space_end = i*spacing*43;
	%[tuneX1{i-1}, tuneY1{j,i-1}] = levon_findtunes(Tx(space_start:space_end),Ty(space_start:space_end));
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
plot([1,length(tunex)],[0.1799,0.1799],'r');
scatter(1:length(tunex),tunex,'*');
subplot(212)
hold on
plot([1,length(tuney)],[0.2499,0.2499],'r');
scatter(1:length(tuney),tuney,'*');

%% save as txt file
c = clock;
cd('/home/levon/Desktop/MatlabMiddleLayerRelease/Release/mml/levon_tune_data')
fid = fopen(strcat('tune_data_real_allbpms_mixed_',int2str(c(1)),'_',int2str(c(2)),'_',int2str(c(3)),'_',int2str(c(4)),'_',int2str(c(5)),'_',int2str(c(6)),'.txt'),'w');
fprintf(fid,['X ','Y ','\n']);
fprintf(fid,'%f %f \n', [tunex,tuney]');
fclose(fid);
cd('..');
cd('..');






