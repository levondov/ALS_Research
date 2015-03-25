function levon_simTunes(spacingI,turns,ax,ay)

setradiation on;
setcavity off;
global THERING;

% If initial conditions are not given, assume 1mm offset
if nargin < 3
	ax = 1e-3;
	ay = 1e-3;
end

% simulate x turns in ringpass
T = ringpass(THERING,[ax,0,ay,0,0,0]',turns);

% plot horizontal and vertical displacements of the beam
figure
subplot(211)
plot(T(1,:));
subplot(212)
plot(T(3,:));

spacing = spacingI;
k=1;
%tuneX1 = zeros(8,(length(T(1,:))/spacing));
% pre defined cell arrays
tuneX1 = cell(1,length(T(1,:))/spacing);
tuneY1 = cell(1,length(T(1,:))/spacing);

%to switch back to FFT method, comment out tuneX1,tuneY1,
% switch i =2:x to i=1:x
% line47 i=1:x-1 should be i=1:x

% calculate the horz/vert tune frequencies for every x (spacingI) turns using calcnaff algorithm
for i = 1:(length(T(1,:))/spacing)
	%tuneX1{i-1} = abs(calcnaff(T(1,(i-1)*spacing+k:i*spacing), T(1,(i-1)*spacing+k-1:i*spacing-1),1)/(2*pi));
	%tuneY1{i-1} = abs(calcnaff(T(3,(i-1)*spacing+k:i*spacing), T(3,(i-1)*spacing+k-1:i*spacing-1),1)/(2*pi));
	[tuneX1{i}, tuneY1{i}] = levon_findtunes(T(1,(i-1)*spacing+k:i*spacing)',T(3,(i-1)*spacing+k:i*spacing)');
	k=0;
end

% pre defined cell arrays
tunex = zeros(length(tuneX1),1);
tuney = zeros(length(tuneY1),1);

% take only maximum values from calcnaff
for i = 1:length(tuneX1)
	tunex(i) = max(tuneX1{i});
	tuney(i) = max(tuneY1{i});
end

%% save as txt file
c = clock;
cd('/home/levon/Desktop/MatlabMiddleLayerRelease/Release/mml')
cd('levon_tune_data');
fid = fopen(strcat('tune_data_sim_',int2str(c(1)),'_',int2str(c(2)),'_',int2str(c(3)),'_',int2str(c(4)),'_',int2str(c(5)),'_',int2str(c(6)),'.txt'),'w');
fprintf(fid,['X ','Y ','\n']);
fprintf(fid,'%f %f \n', [tunex,tuney]');
fclose(fid);
cd('..');

end



