spacing = 128;
ax = 1e-3;
ay = 1e-3;

% Choose bpm to be used for tune measurement
bpm = 1;

cd(getfamilydata('Directory','DataRoot'));
cd BeamDump

%FileName = 'BeamBump_2014-10-19';
%FileName = 'BeamBump_2014-10-20';
%FileName = 'BeamBump_2014-10-29_04-08-54';
%FileName = 'BeamBump_2015-02-10_16-23-45';
FileName = 'BeamBump_2015-02-11_17-06-01';

load([FileName, '.mat']);

k=1;
% pre defined cell arrays
tuneX1 = cell(1,length(floor(TBT{bpm}.N/spacing)));
tuneY1 = cell(1,length(floor(TBT{bpm}.N/spacing)));

% calculate the horz/vert tune frequencies for every x (spacingI) turns using calcnaff algorithm
for i = 2:floor(TBT{bpm}.N/spacing)
	space_start = (i-1)*spacing+k;
	space_end = i*spacing;
	%[tuneX1{i}, tuneY1{i}] = levon_findtunes(TBT{bpm}.X(space_start:space_end),TBT{bpm}.Y(space_start:space_end));
	tuneX1{i-1} = abs(calcnaff(TBT{bpm}.X(space_start:space_end), TBT{bpm}.X(space_start-1:space_end-1),1)/(2*pi));
	tuneY1{i-1} = abs(calcnaff(TBT{bpm}.Y(space_start:space_end), TBT{bpm}.Y(space_start-1:space_end-1),1)/(2*pi));
	k=0;
end

% pre defined cell arrays
tunex = zeros(length(tuneX1),1);
tuney = zeros(length(tuneY1),1);

%initial tune
currenttunex = 0.1799;
currenttuney = 0.2499;

% take values closest to last recorded measure of the tune
for i = 1:length(tuneX1)
	[~,indx] = min(abs(currenttunex - tuneX1{i}));
	[~,indy] = min(abs(currenttuney - tuneY1{i}));
	tunex(i) = tuneX1{i}(indx);
	tuney(i) = tuneY1{i}(indy);
	currenttunex = tunex(i);
	currenttuney = tuney(i);
end

%% save as txt file
c = clock;
cd('/home/levon/Desktop/MatlabMiddleLayerRelease/Release/mml')
cd('levon_tune_data');
fid = fopen(strcat('tune_data_real_',int2str(c(1)),'_',int2str(c(2)),'_',int2str(c(3)),'_',int2str(c(4)),'_',int2str(c(5)),'_',int2str(c(6)),'.txt'),'w');
fprintf(fid,['X ','Y ','\n']);
fprintf(fid,'%f %f \n', [tunex,tuney]');
fclose(fid);
cd('..');

%end
