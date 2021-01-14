midiMatrix = readmidi("./audio/GymnopediesIntroPerformance.mid");
[audio, Fs] = audioread("audio\GymnopediesIntroPerformance.wav");

% Convert to mono and normalize the signal
audio = monoconvert(audio);
audio = audio / max(abs(audio));
audio = cropsilence(audio, 0.002);

midiWaveform = nmat2snd(midiMatrix, 'fm', Fs)';
midiWaveform = midiWaveform / max(abs(midiWaveform));
midiWaveform = cropsilence(midiWaveform, 0.002);

mRecordingBpm = 100;
timeSigNumerator = 3;

[~, mOnsets, ~] = getglobalmidibpm(midiMatrix, mRecordingBpm, timeSigNumerator);

endPoint = length(midiWaveform) / Fs * (120 / mRecordingBpm);
% disp("End point: " + endPoint);

% mLocalBpms = getlocalmidibpms(mOnsets, mBpm, timeSigNumerator);

[mBpm, mLocalBpms] = getaudiobpms(midiWaveform, Fs, timeSigNumerator);

[aGlobalBpm, newLocalBpms] = getaudiobpms(audio, Fs, timeSigNumerator);

rmsDynamics = getrmsdynamics(audio, Fs, 500e-3);

localDynamics = getlocaldynamics(rmsDynamics, length(audio), Fs, aGlobalBpm, timeSigNumerator);

[dynamics, dynamicsIndices] = convertrmstolabels(localDynamics);

mVelocities = getlocalvelocities(midiMatrix, mOnsets, mBpm, timeSigNumerator);

[~, mDynamicsIndices] = convertvelocitytolabels(mVelocities);

dynamicsLabels = ["pp", "p", "mp", "mf", "f", "ff"];

mLocalBpms = matchsegments(mLocalBpms, length(newLocalBpms), length(audio) / Fs);
mDynamicsIndices = matchsegments(mDynamicsIndices, length(dynamicsIndices), length(audio) / Fs);
mDynamics = dynamicsLabels(mDynamicsIndices)';

startPoints = linspace(0, length(audio) / Fs, length(mLocalBpms));
endPoints = startPoints(2:end);
endPoints(end + 1) = startPoints(end) + (endPoints(2) - endPoints(1));
timeRangeColumn = (startPoints + " - " + endPoints);

% endPoints = startPoints + ((length(audio) / Fs) / length(mLocalBpms));

length(1:length(mLocalBpms));

tbl = table(1:length(mLocalBpms), timeRangeColumn);

uitable('Data', timeRangeColumn);

% uitable(tbl);

% nSegments = length(newLocalBpms);
% midiTimeDomain = linspace(0, length(audio) / Fs, length(mLocalBpms));
% midiSegmentLength = midiTimeDomain(end) / nSegments;
% 
% fittedVals = zeros(nSegments, 1);
% for n=1:nSegments
%     midiRange = midiTimeDomain <= n * midiSegmentLength & midiTimeDomain >= (n - 1) * midiSegmentLength;
%     indices = find(midiRange);
%     value = mLocalBpms(indices);
%     if length(value) > 1
%         value = mean(value);
%     end
%     fittedVals(n) = value;
% end

disp(mLocalBpms);
% disp(fittedVals);

% crotchetLength = 60 / mBpm;
% barLength = crotchetLength * timeSigNumerator;
% segmentLength = barLength * 2;
% 
% velocityOnsets = zeros(length(midiMatrix), 2);
% velocityOnsets(:, 1) = midiMatrix(:, 1);
% velocityOnsets(:, 2) = midiMatrix(:, 5);
% velocityOnsets(:, 1) = (velocityOnsets(:, 1) - 1) .* crotchetLength;
% 
% lastOnset = velocityOnsets(end, 1);
% nSegments = ceil(lastOnset / segmentLength);
% 
% localVelocities = zeros(nSegments, 1);
% for n=1:nSegments
%     
%     segmentStart = (n - 1) * segmentLength;
%     segmentEnd = segmentStart + segmentLength;
%     
%     segmentVelocityOnsets = velocityOnsets(velocityOnsets(:, 1) >= segmentStart & velocityOnsets(:, 1) < segmentEnd, :);
%     
%     meanVelocity = mean(segmentVelocityOnsets(:, 2));
%     
%     localVelocities(n) = meanVelocity;
%    
% end

% disp(dynamics);

% disp(localDynamics);

% nSamplesBetweenCrotchets = floor((60 / aGlobalBpm) * Fs);
% nSamplesInBar = timeSigNumerator * nSamplesBetweenCrotchets;
% nSamplesInSegment = nSamplesInBar * 2;
% nSegments = ceil(length(audio) / nSamplesInSegment);
% 
% localDynamics = zeros(nSegments, 1);
% for n=1:nSegments
%     
%     startSample = (n - 1) * nSamplesInSegment + 1;
%     endSample = startSample + nSamplesInSegment;
%     
%     if endSample > length(audio)
%         endSample = length(audio);
%     end
%     
%     startSample = floor(startSample * (length(rmsDynamics) / length(audio)));
%     endSample = floor(endSample * (length(rmsDynamics) / length(audio)));
%     
%     if startSample == 0
%         startSample = 1;
%     end
%     
%     disp(startSample);
%     disp(endSample);
%     
%     localDynamics(n) = mean(rmsDynamics(startSample:endSample));
%     
% end
% 
% disp(localDynamics);

% disp("Global BPM of Audio:" + aGlobalBpm);
% disp("Local BPMs of Audio:");
% disp(aLocalBpms);
% 
% disp("Global BPM of MIDI: " + mBpm);
% disp("Local BPMS of MIDI:");
% disp(mLocalBpms);

% figure(1);
% tDomain1 = linspace(0, length(audio) / Fs, length(audio)); 
% tDomain2 = linspace(0, length(audio) / Fs, length(rmsDynamics));
% tDomain3 = linspace(0, length(audio) / Fs, length(localDynamics));
% plot(tDomain1, audio, tDomain2, rmsDynamics, tDomain3, localDynamics);
% 
% figure(2);
% tDomain1 = linspace(0, length(audio) / Fs, length(newLocalBpms));
% % tDomain2 = linspace(0, length(audio) / Fs, length(aLocalBpms));
% % plot(tDomain1, newLocalBpms, tDomain2, aLocalBpms);
% plot(tDomain1, newLocalBpms);
% ylim([60, 200]);


