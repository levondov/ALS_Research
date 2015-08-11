global THERING;
setradiation off;
setcavity on;

% Get beam dump data
cd(getfamilydata('Directory','DataRoot'));
cd BeamDump

%FileName = 'BeamBump_2014-10-19';
%FileName = 'BeamBump_2014-10-20';
%FileName = 'BeamBump_2014-10-29_04-08-54';
FileName = 'BeamBump_2014-11-10_08-15-47';
load([FileName, '.mat']);

% Find indices for new BPMs and their locations around the ring
BPMs = family2atindex('BPMx',getbpmlist('nonbergoz'));
spos = findspos(THERING,1:length(THERING)+1);

% get all X values from last turn of TBT
last_turn = length(TBT{1}.X);
xpos = cellfun(@(i) i(1:end).X(last_turn), TBT);
%ypos = cellfun(@(i) i(1:end).Y(last_turn), TBT);

% simulate last turn with X data 
% start from first bpm as that is where our data is from
% TBT gives us the answer in mm, but linepass accepts input in meters
xlin = linspace(-10e-3,10e-3,100);
%closest = 1000;
%closestI = 0;
xpos_sim = cell(1,length(xlin));
figure()%'units','normalized','outerposition',[0 0 1 1])
while true
for i = 1:length(xlin)
	xpos_sim{1,i} = linepass(THERING,[xlin(i),0,0,0,0,0]',1:length(THERING)+1)*10^3;
	plot(spos(BPMs),xpos,'b-o',spos(BPMs),xpos_sim{1,i}(BPMs),'g-o')
	grid on
	pause(0.01)
end
for i = length(xlin):-1:1
	xpos_sim{1,i} = linepass(THERING,[xlin(i),0,0,0,0,0]',1:length(THERING)+1)*10^3;
	plot(spos(BPMs),xpos,'b-o',spos(BPMs),xpos_sim{1,i}(BPMs),'g-o')
	grid on
	pause(0.01)
end
end

%figure()
%grid on
%hold on
%plot(spos(BPMs),xpos,'b-o')
%plot(spos(BPMs),xpos_sim{1,closestI}(BPMs)*10^3,'g-o')

legend('real','simulated')
xlabel('Ring circumference(m)')
ylabel('x Orbit (mm)')




