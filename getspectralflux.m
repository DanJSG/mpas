%GETSPECTRALFLUX Function for calculating the spectral flux of an audio
%                signal.
% Calculates the spectral flux by taking a Short Time Fourier Transfer of
% the audio signal, then summing the differences between frames for each
% sample point.
% Input arguments:
%   audio - the audio to calculate the spectral flux of
%   Fs - the sampling frequency of the audio
%   windowLength - the length of the window for the STFT
%   nOverlap - the number of samples of overlap
%   nFft - the number of samples in each FFT
function[spectralFlux] = getspectralflux(audio, Fs, windowLength, nOverlap, nFft)
    
    % Defines the lowest frequency bin to consider as roughly 100 Hz
    startBin = ceil(100 / ((Fs / 2) / (nFft / 2)));
    
    % Defines the highest frequency bin to consider as roughly 10kHz
    endBin = ceil(10e3 / ((Fs / 2) / (nFft / 2)));

    % Take the STFT of the audio signal with the given params
    stft = spectrogram(audio, hamming(windowLength), nOverlap, nFft);
    % Calculate the absolute value of the STFT (not interested in phase)
    stft = abs(stft);
    
    % Number of bins in the STFT
    nBins = length(stft(1, :));
    
    % Initialise variable for the spectral flux
    spectralFlux = zeros(nBins, 1);
    
    % Initalise a variable for the previous spectrum
    prevSpectrum = stft(:, 1);
    
    % Loop from index 2 to the total number of bins in the STFT
    for n=2:nBins
        
        % Get the current spectrum from the stft
        currentSpectrum = stft(:, n);
        
        % Set the current flux for the current window to 0
        currentFlux = 0;
        % Loop between the defined low and high bins
        for m=startBin:endBin
            % Calculates the spectral flux summation
            currentFlux = currentFlux + (sqrt(abs(currentSpectrum(m))) - sqrt(abs(prevSpectrum(m))));
        end
        
        % Set the spectral flux for the previous point to the current
        % spectral flux
        spectralFlux(n - 1) = currentFlux;
        
        % Update previous spectrum
        prevSpectrum = currentSpectrum;

    end
end