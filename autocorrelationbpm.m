function[bpms] = autocorrelationbpm(signal, nBpms)
    
    if length(signal) > 256
        doubleStretchedSignal = stretchAudio(signal, 2, 'Window', hann(256, 'periodic'));
        quadStretchedSignal = stretchAudio(signal, 4, 'Window', hann(256, 'periodic'));
    end

    doubleStretchedAutoCorrelation = 0;
    quadStretchedAutoCorrelation = 0;
    
    [autoCorrelation, lags] = xcorr(signal);

    if length(signal) > 256
        doubleStretchedAutoCorrelation = xcorr(doubleStretchedSignal);
        [quadStretchedAutoCorrelation, lags] = xcorr(quadStretchedSignal);
        autoCorrelation = autoCorrelation((length(autoCorrelation) / 2) - (length(quadStretchedAutoCorrelation) / 2):((length(autoCorrelation) / 2) + (length(quadStretchedAutoCorrelation) / 2)) - 1 );
        doubleStretchedAutoCorrelation = doubleStretchedAutoCorrelation( (length(doubleStretchedAutoCorrelation) / 2) - (length(quadStretchedAutoCorrelation) / 2):((length(doubleStretchedAutoCorrelation) / 2) + (length(quadStretchedAutoCorrelation) / 2)) - 1);
    end 
    
    enhancedHarmonics = autoCorrelation + doubleStretchedAutoCorrelation + quadStretchedAutoCorrelation;

    enhancedHarmonics(lags < 60 | lags > 300) = 0;

    [autoCorrelationPeaks, autoCorrelationPeakLocs] = findpeaks(enhancedHarmonics, 'SortStr', 'descend', 'NPeaks', nBpms,  'MinPeakDistance', 10);
    
    bpms = zeros(nBpms, 1);
    for n=1:length(autoCorrelationPeaks)
        bpms(n) = lags(autoCorrelationPeakLocs(n));
    end
    
    bpms = sort(bpms, 'descend');
    
end

