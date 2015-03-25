global THERING;
setradiation on;
setcavity off;

% Find indices for new BPMs and their locations around the ring
BPMs = family2atindex('BPMx',getbpmlist('nonbergoz'));
spos = findspos(THERING,1:length(THERING)+1);

% get all X values from last turn of TBT
%last_turn = length(TBT{1}.X);
%xpos = cellfun(@(i) i(1:end).X(last_turn), TBT);
%ypos = cellfun(@(i) i(1:end).Y(last_turn), TBT);

figure()
axis([0,1000,-0.02,0.02])
hold on
turns = 1000;



xlin = 0
color_incre = fliplr(linspace(0,1,length(xlin)));

% simulate oscillation of 1000 turns
for i = 1:length(xlin)
	xpos_sim = ringpass(THERING,[xlin(i),0,0,0,0,0]',turns);
	beamlosscolIndex = find(isnan(xpos_sim(1,:)),1) - 1;
	%plot(xpos_sim(1,:))%,'b-')
	display(xlin(i))
	for k = 1:999%beamlosscolIndex-1
		plot([k k+1],xpos_sim(1,k:k+1))
		hold on
		grid on
		pause(0.002)
	end
	pause(0.01)
end
