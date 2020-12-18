function[spectralFlux] = spectralflux(audio, Fs, windowLength, nOverlap, nFft)
    
    startBin = ceil(100 / ((Fs / 2) / (nFft / 2)));
    endBin = ceil(10e3 / ((Fs / 2) / (nFft / 2)));

    stft = spectrogram(audio, hamming(windowLength), nOverlap, nFft);
    stft = abs(stft);

    nBins = length(stft(1, :));

    spectralFlux = zeros(nBins, 1);
    prevSpectrum = stft(:, 1);
    for n=2:nBins

        currentSpectrum = stft(:, n);

        currentFlux = 0;
        for m=startBin:endBin
            currentFlux = currentFlux + (sqrt(abs(currentSpectrum(m))) - sqrt(abs(prevSpectrum(m))));
        end

        spectralFlux(n - 1) = currentFlux;
        prevSpectrum = currentSpectrum;

    end
end