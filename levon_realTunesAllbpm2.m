%spacing = [70,100,125];
%spacing = [32,64,256];
%spacing = [32,64,128,256];
spacing = 70:5:200;
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
tuneX1 = cell(43,length(spacing));
tuneY1 = cell(43,length(spacing));

for j = 1:43
	%% Determine actual size of TBT that does not include noise
	TBT{j}.N = find([TBT{j}.S]<1e4,1);
	
	% calculate the horz/vert tune frequencies for every x (spacingI) turns using calcnaff algorithm
	for i = 2:length(spacing)+1
		space_start = 2;
		space_end = spacing(i-1)+space_start-1;
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

method = 1; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1 is find measurement closest to previous tune
% 0 is find first measurement within a certain range
for j = 1:43
	%initial tune
	currenttunex = 0.1799;
	currenttuney = 0.2499;
	if method == 1
		% take values closest to last recorded measure of the tune
		for i = 1:size(tuneX1,2)
			[~,indx] = min(abs(currenttunex - tuneX1{j,i}));
			[~,indy] = min(abs(currenttuney - tuneY1{j,i}));
			tunex(j,i) = tuneX1{j,i}(indx);
			tuney(j,i) = tuneY1{j,i}(indy);
			currenttunex = tunex(j,i);
			currenttuney = tuney(j,i);
		end
	else
		% first loop through all tune measurements at different spacings
		% i.e. spacing = [100 200 300] will loop 3 times here
		for i = 1:size(tuneX1,2)
			% Loop through all the values NAFF returned for both X & Y
			% Pick a value that is within a predetermined range
			for k = 1:length(tuneX1{j,i})
				if tuneX1{j,i}(k) > 0.15 && tuneX1{j,i}(k) < 0.2
					tunex(j,i) = tuneX1{j,i}(k);
				end
			end
			for k = 1:length(tuneY1{j,i})
				if tuneY1{j,i}(k) > 0.2 && tuneY1{j,i}(k) < 0.3
					tuney(j,i) = tuneY1{j,i}(k);
				end
			end
			% if no tune value was found within range
			if tunex(j,i) == 0
				tunex(j,i) = nan;
			end
			if tuney(j,i) == 0
				tuney(j,i) = nan;
			end
		end
	end
end

%% tune and bpm plots
%tunex_ave = zeros(size(tunex,2),1);
%tuney_ave = zeros(size(tuney,2),1);

%% Standard deviation plots
stdX = zeros(length(spacing),1);
stdY = zeros(length(spacing),1);

for i = 1:size(tunex,2)
	stdX(i) = std(tunex(:,i));
	stdY(i) = std(tuney(:,i));
end

figure
hold on
scatter(spacing,stdX,'b*');
scatter(spacing,stdY,'r*');
xlabel('# Turns')
ylabel('\sigma')
legend('Horizontal','Vertical')

%% plotting first 3 spacings
figure
subplot(211)
hold on

scatter(1:43,tunex(:,1),'r*')
scatter(1:43,tunex(:,2),'g^')
plot(1:43,tunex(:,3),'b')

plot([0,44],[0.1799,0.1799],'r')
%axis([0,44,0,0.5])
xlabel('BPM #')
ylabel('Qx')
legend(strcat(int2str(spacing(1)),' turns'),strcat(int2str(spacing(2)),' turns'),strcat(int2str(spacing(3)),' turns'))

subplot(212)
hold on

scatter(1:43,tuney(:,1),'r*')
scatter(1:43,tuney(:,2),'g^')
plot(1:43,tuney(:,3),'b')

plot([0,44],[0.2499,0.2499],'r')
%axis([0,44,0,0.5])
xlabel('BPM #')
ylabel('Qy')
legend(strcat(int2str(spacing(1)),' turns'),strcat(int2str(spacing(2)),' turns'),strcat(int2str(spacing(3)),' turns'))


%legend('BPM tunes','average tune','real tune');
%xlabel('BPMs')
%ylabel('Qx')

