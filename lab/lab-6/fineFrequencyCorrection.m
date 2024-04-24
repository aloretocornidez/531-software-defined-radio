function returnValue = fineFrequencyCorrection(inputSignal, timeIndex, modulationOrder, sampleRate, frameSize, numFrames, filterUpsample)

% Find the change in frequency
df = sampleRate/(frameSize*numFrames);

% Generate the Array of the
frequencies = -sampleRate / 2 : df / filterUpsample : sampleRate/2 - df/filterUpsample;

% Get the abolute values of the frequency components in the signal.
a = abs(fftshift(fft(inputSignal .^ modulationOrder)));

%% Get the index of the max value
[~, idx] = max(a);

% Use the maximum frequency to calculate the offset.
% (Modulation order is used as a parameter to allow
% the user to pick what modulation scheme is being used)
fo = frequencies(idx) / modulationOrder;

% Get the expontent value using the offset.
offset = -1i.*2*pi*fo./sampleRate;

% Conduct the frequency shift.
freqShift = exp(offset*timeIndex);

% Multiply the input signal by the offset.
returnValue = inputSignal(timeIndex) .* freqShift;

% plot(frequencies, a);


end
