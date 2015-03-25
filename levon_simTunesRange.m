function tunex = levon_simTunes(spacingStart,spacingEnd,spacer,turns,ax,ay)

setradiation on;
setcavity off;
global THERING;

if nargin < 5
	ax = 1e-3;
	ay = 1e-3;
end

T = ringpass(THERING,[ax,0,ay,0,0,0]',turns);

numMeasured = (spacingEnd-spacingStart)/spacer;
tunex = cell(1,numMeasured);
tuney = cell(1,numMeasured);
fileNames = cell(1,numMeasured);

for k = 1:numMeasured
	spacing = spacingStart;
	index=1;
	%tuneX1 = zeros(8,(length(T(1,:))/spacing));
	tuneX1 = cell(1,floor(length(T(1,:))/spacing));
	tuneY1 = cell(1,floor(length(T(1,:))/spacing));

	for i = 1:(length(T(1,:))/spacing)
		tuneX1{i} = abs(calcnaff(T(1,(i-1)*spacing+k:i*spacing), T(2,(i-1)*spacing+k:i*spacing),1)/(2*pi));
		tuneY1{i} = abs(calcnaff(T(3,(i-1)*spacing+k:i*spacing), T(4,(i-1)*spacing+k:i*spacing),1)/(2*pi));
		index=0;
	end

	tunex{1,k} = zeros(length(tuneX1),1);
	tuney{1,k} = zeros(length(tuneY1),1);

	for j = 1:length(tuneX1)
		tunex{1,k}(j,1) = max(tuneX1{j});
		tuney{1,k}(j,1) = max(tuneY1{j});
	end
	spacingStart = spacingStart + spacer;
end

figure
hold on
for i=1:length(tunex)
	scatter(tunex{i}(:,1),tuney{i}(:,1));
	
	axis([0,0.5,0,0.5]);
end

%% save as txt file
c = clock;
cd('levon_tune_data');
fid = fopen(strcat('tune_data_sim_multi_',int2str(c(1)),'_',int2str(c(2)),'_',int2str(c(3)),'_',int2str(c(4)),'_',int2str(c(5)),'_',int2str(c(6)),'.txt'),'w');
fprintf(fid,['X ','Y ','\n']);
for i = 1:length(tunex)
	fprintf(fid,'%f %f \n', [tunex{i},tuney{i}]');
end
fclose(fid);
cd('..');


end




