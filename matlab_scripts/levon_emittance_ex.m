setradiation on;
setcavity on;
global THERING;
turns = 1000;

cd(getfamilydata('Directory','DataRoot'));
cd BeamDump

%FileName = 'BeamBump_2014-10-19';
%FileName = 'BeamBump_2014-10-20';
%FileName = 'BeamBump_2014-10-29_04-08-54';
%FileName = 'BeamBump_2015-02-10_16-23-45';
FileName = 'BeamBump_2015-02-11_17-06-01'; %noise starts when SUM signal ~ 1e4

load([FileName, '.mat']);

% If initial conditions are not given, assume 1mm offset
if nargin < 3
	ax = 1e-3;
	ay = 1e-3;
end




% simulate x turns in ringpass
%T = ringpass(THERING,[ax,0,ay,0,0,0]',turns);
T = ringpass(THERING,[0,0,0,0,0,0]',turns);

simtype = input('sim-1 or real-0 \n');

if simtype
	figure
	hold on
	for i = 2:1000
		plot([T(1,i-1),T(1,i)],[T(2,i-1),T(2,i)])
		%axis([-2e-3,2e-3,-6e-5,6e-5])
		pause(0.05)
	end
else
	figure
	hold on
	for i = 3:1135
		plot([TBT{1}.X(i-1),TBT{1}.X(i)],[TBT{1}.X(i-2),TBT{1}.X(i-1)])
		pause(0.01)
	end
end


















