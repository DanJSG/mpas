%AUTOCORRELATIONBPM Estimates n BPMs from a spectral flux signal.
% Uses an enhanced harmonic autocorrelation approach with peak picking to
% choose the n most likely BPMs from a spectral flux signal. These are then
% sorted before being returned.
% Input arguments:
%   signal - the spectral flux signal
%   nBpms - the number of BPMs to extract from the signal
function[bpms] = autocorrelationbpm(signal, nBpms)
       
    % Only apply the enhanced harmonic approach of time stretching the flux
    % if the signal is longer than 256 samples
    if length(signal) > 256
        % Stretch signal by factors of two and four
        doubleStretchedSignal = stretchAudio(signal, 2, 'Window', hann(256, 'periodic'));
        quadStretchedSignal = stretchAudio(signal, 4, 'Window', hann(256, 'periodic'));
    end
    
    % Initialise autocorrelation variables
    doubleStretchedAutoCorrelation = 0;
    quadStretchedAutoCorrelation = 0;
    
    % Calculate the autocorrelation of the original spectral flux signal
    [autoCorrelation, lags] = xcorr(signal);

    % Only try to calculate the autocorrelation if the spectral flux signal
    % has been timestretched
    if length(signal) > 256
        % Perform autocorrelation on the stretched signals
        doubleStretchedAutoCorrelation = xcorr(doubleStretchedSignal);
        [quadStretchedAutoCorrelation, lags] = xcorr(quadStretchedSignal);
        
        % Crop the original and factor of two stretched signal to the same
        % length as the factor of four stretched signal
        autoCorrelation = autoCorrelation(1:length(quadStretchedAutoCorrelation));
        doubleStretchedAutoCorrelation = doubleStretchedAutoCorrelation(1:length(quadStretchedAutoCorrelation));

    end 
    
    % Sum the autocorrelations together to get the autocorrelation signal
    % with enhanced harmonics 
    enhancedHarmonics = autoCorrelation + doubleStretchedAutoCorrelation + quadStretchedAutoCorrelation;
    
    % Limit the range of BPMs between 60 and 300 by removing these values
    % from the enhance harmonics autocorrelation signal
    enhancedHarmonics(lags < 60 | lags > 300) = 0;
    
    % If the length of the enhanced harmonics matrix is less than 3 samples
    % then zero pad it
    if length(enhancedHarmonics) < 3
        enhancedHarmonics(end + 1:end + 3) = 0;
    end
    
    % Detect the n largest peaks in the enhanced harmonics autocorrelation
    % signal
    [autoCorrelationPeaks, autoCorrelationPeakLocs] = findpeaks(enhancedHarmonics, 'SortStr', 'descend', 'NPeaks', nBpms);
    
    % Initialise matrix for storing estimated BPMs
    bpms = zeros(nBpms, 1);
    
    % Loop over the peaks and convert the sample locations to BPMs
    for n=1:length(autoCorrelationPeaks)
        bpms(n) = lags(autoCorrelationPeakLocs(n));
    end
    
    % Sort the BPMs from largest to smallest
    bpms = sort(bpms, 'descend');
    
end

