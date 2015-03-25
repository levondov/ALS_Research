% Choose bpm to be used for tune measurement and the spacing
bpm = 1;
spacing = 32;


cd(getfamilydata('Directory','DataRoot'));
cd BeamDump

%FileName = 'BeamBump_2014-10-19';
%FileName = 'BeamBump_2014-10-20';
%FileName = 'BeamBump_2014-10-29_04-08-54';
FileName = 'BeamBump_2015-02-10_16-23-45';

load([FileName, '.mat']);
	
% grab lengths
sfx = spacing;
sfy = spacing;
figure;


global THERING
setradiation on;
setcavity off;
T = ringpass(THERING,[1e-3,0,1e-3,0,0,0]',1000);

% Everything in the for loop below is based on the findfreq function Christoph wrote
spacing = spacing - 1; %for loop
for i = 1:1000-spacing%TBT{bpm}.N-spacing
	% get current data
	xdata = T(1,i:i+spacing)';%TBT{bpm}.X(i:i+spacing);
	ydata = T(3,i:i+spacing)';%TBT{bpm}.Y(i:i+spacing);
	
	% subtract mean from data
	mxdata = xdata - ones(length(xdata),1)*mean(xdata);
	mydata = ydata - ones(length(ydata),1)*mean(ydata);
	
	% fft for xdata/ydata
	fftxdata = abs(fft(mxdata));
	fftydata = abs(fft(mydata));
	
	% get half the size of the data
	dmaxx = round(sfx/2);
	dmaxy = round(sfy/2);
	
	% look for max peak in half the data
	% note we skip first 10 points because there is an initial peak in the beginning of the data
	[~,indx] = max(fftxdata(10:dmaxx));
	[~,indy] = max(fftydata(10:dmaxy));
	indx=indx+10;
	indy=indy+10;

	% make the window between the peak 5 elements long
	dmaxx = indx + 5;
	dminx = indx - 5;
	dmaxy = indy + 5;
	dminy = indy - 5;
	
	% Hanning-like sine filter window
	% i.e. -> X(n) = A*sin(pi*n/N) -> A = amplitude of original data, N is # of turns/data
	sxdata = mxdata.*sin(pi*[0:1/(sfx-1):1])';
	sydata = mydata.*sin(pi*[0:1/(sfy-1):1])';
	
	% fft of the data with the sine filter window
	fftxdata = abs(fft(sxdata));
	fftydata = abs(fft(sydata));
	
	% find the max again
	[~,indx] = max(fftxdata(dminx:dmaxx));
	[~,indy] = max(fftydata(dminy:dmaxy));
	indx = indx + dminx;
	indy = indy + dminy;
	
	% index corrections
	% final index of the highest frequency is idx and idy
	if indx == 1
		indx1=2; indx3=2;
	elseif indx == sfx/2
		indx=sfx/2-1; indx3 = sfx/2-1;
	else
		indx1=indx-1; indx3=indx+1;
	end
	
	if (fftxdata(indx3)>fftxdata(indx1))
		ampx = fftxdata(indx); ampx2 = fftxdata(indx3);
		idx = indx;
	else
		ampx = fftxdata(indx1); ampx2 = fftxdata(indx);	
		if indx ~= 1
			idx = indx1;
		else
			idx = 0;
		end
	end
	
	if indy == 1
		indy1=2; indy3=2;
	elseif indy == sfy/2
		indy=sfy/2-1; indy3 = sfy/2-1;
	else
		indy1=indy-1; indy3=indy+1;
	end
	
	if (fftydata(indy3)>fftydata(indy1))
		ampy = fftydata(indy); ampy2 = fftydata(indy3);
		idy = indy;
	else
		ampy = fftydata(indy1); ampy2 = fftydata(indy);	
		if indy ~= 1
			idy = indy1;
		else
			idy = 0;
		end
	end
	
	% commented out is the sim settings. If running sim data, uncomment and comment out the TBT axis settings.
	indxReal = (i-1) + idx;
	indyReal = (i-1) + idy;
	subplot(211)
	plot(i:spacing+i,fftxdata,'b',[indxReal,indxReal],[0,100],'r')
	title('X Simulation data FFT with sine window filter')
	%axis([i,spacing+i,0,100])
	if ~isnan(fftxdata(idx))
		axis([i,spacing+i,0,fftxdata(idx)])
	else
		axis([i,spacing+i,0,fftydata(idy)])
	end
	subplot(212)
	plot(i:spacing+i,fftydata,'b',[indyReal,indyReal],[0,100],'r')
	title('Y Simulation data FFT with sine window filter')
	xlabel('Turns')
	%axis([i,spacing+i,0,100])
	axis([i,spacing+i,0,fftydata(idy)])
	pause(0.01)
	
	

end
