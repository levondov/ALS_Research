spacing = 64;
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
FileName = 'BeamBump_2015-02-11_17-06-01'; %noise starts when SUM signal ~ 1e4

load([FileName, '.mat']);



%% Determine actual size of TBT that does not include noise

k=1;
% pre defined cell arrays
tuneX1 = cell(43,length(floor(TBT{bpm}.N/spacing)));
tuneY1 = cell(43,length(floor(TBT{bpm}.N/spacing)));

for j = 1:43
	%% Determine actual size of TBT that does not include noise
	TBT{j}.N = find([TBT{j}.S]<1e4,1);
	
	% calculate the horz/vert tune frequencies for every x (spacingI) turns using calcnaff algorithm
	for i = 2:floor((TBT{j}.N)/spacing)
		space_start = (i-1)*spacing+k;
		space_end = i*spacing;
		%[tuneX1{j,i-1}, tuneY1{j,i-1}] = levon_findtunes(TBT{j}.X(space_start:space_end),TBT{j}.Y(space_start:space_end));
		tuneX1{j,i-1} = abs(calcnaff(TBT{j}.X(space_start:space_end), TBT{j}.X(space_start-1:space_end-1),1)/(2*pi));
		tuneY1{j,i-1} = abs(calcnaff(TBT{j}.Y(space_start:space_end), TBT{j}.Y(space_start-1:space_end-1),1)/(2*pi));
		k=0;
	end
	display(strcat('BPM ',int2str(j),' finished'));
end

% pre defined cell arrays
tunex = zeros(43,size(tuneX1,2));
tuney = zeros(43,size(tuneY1,2));

for j = 1:43
	%initial tune
	currenttunex = 0.1799;
	currenttuney = 0.2499;
	% take values closest to last recorded measure of the tune
	for i = 1:size(tuneX1,2)
		[~,indx] = min(abs(currenttunex - tuneX1{j,i}));
		[~,indy] = min(abs(currenttuney - tuneY1{j,i}));
		tunex(j,i) = tuneX1{j,i}(indx);
		tuney(j,i) = tuneY1{j,i}(indy);
		currenttunex = tunex(j,i);
		currenttuney = tuney(j,i);
	end
end

%% tune and bpm plots
tunex_ave = zeros(size(tunex,2),1);
tuney_ave = zeros(size(tuney,2),1);
figure
input('Start Plot');
while true
for i = 1:size(tunex,2)
	subplot(211)
	scatter(1:43,tunex(:,i),'ro')
	ave = mean(tunex(:,i));
	tunex_ave(i) = ave;
	hold on
	%plot(1:43,tunex(:,i),'g')
	plot([0,44],[ave,ave],'b')
	plot([0,44],[0.1799,0.1799],'r')
	for j = 1:43
		plot([j,j],[0.1799,tunex(j,i)],'g')
	end
	axis([0,44,0,0.5])
	xlabel('BPM #')
	ylabel('Qx')
	hold off
	subplot(212)
	scatter(1:43,tuney(:,i),'ro')
	ave = mean(tuney(:,i));
	tuney_ave(i) = ave;
	hold on
	%plot(1:43,tuney(:,i),'g')
	plot([0,44],[ave,ave],'b')
	plot([0,44],[0.2499,0.2499],'r')
	for j = 1:43
		plot([j,j],[0.2499,tuney(j,i)],'g')
	end
	axis([0,44,0,0.5])
	xlabel('BPM #')
	ylabel('Qy')
	hold off
	pause(0.3);
end
input('rerun?');
end
%legend('BPM tunes','average tune','real tune');
%xlabel('BPMs')
%ylabel('Qx')


%% save as txt file
c = clock;
cd('/home/levon/Desktop/MatlabMiddleLayerRelease/Release/mml/levon_tune_data')
fid = fopen(strcat('tune_data_real_allbpms_',int2str(c(1)),'_',int2str(c(2)),'_',int2str(c(3)),'_',int2str(c(4)),'_',int2str(c(5)),'_',int2str(c(6)),'.txt'),'w');
fprintf(fid,['X ','Y ','\n']);
fprintf(fid,'%f %f \n', [tunex_ave,tuney_ave]');
fclose(fid);
cd('..');
cd('..');

%end
