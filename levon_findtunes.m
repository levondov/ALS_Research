function [tx,ty] = levon_findtunes(xdata,ydata,option)
%
%	written from the findfreq function in mml
%
%
%

if nargin == 2
	option = 'fftw';
end

if strcmp(option,'fftw')

	% grab lengths
	sfx = length(xdata);
	sfy = length(ydata);
	
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
	
	if indx == 1
		indx1=2; indx3=2;
	elseif indx == sfx/2
		indx1=sfx/2-1; indx3 = sfx/2-1;
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
	
	tx = 1/sfx * (idx-1 + (2*ampx2./(ampx+ampx2)) - 0.5);
	
	if indy == 1
		indy1=2; indy3=2;
	elseif indy == sfy/2
		indy1=sfy/2-1; indy3 = sfy/2-1;
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
	
	ty = 1/sfy * (idy-1 + (2*ampy2./(ampy+ampy2)) - 0.5);
	
end



end
