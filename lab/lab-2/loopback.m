

% parameters
gainSource = 'Manual';
% gainSource = 'AGC Slow Attack';
% gainSource = 'AGC Fast Attack';

gainValue = 20;

% Setup Receiver
rx=sdrrx('Pluto','OutputDataType','double','SamplesPerFrame',2^15, 'GainSource', gainSource, 'Gain', gainValue);

% rx=sdrrx('Pluto','OutputDataType','double','SamplesPerFrame',2^15); % original

% Setup Transmitter
recieveGain = -30;
tx = sdrtx('Pluto','Gain', recieveGain);

% Transmit sinewave
sine = dsp.SineWave('Frequency',300, 'SampleRate',rx.BasebandSampleRate, 'SamplesPerFrame', 2^12, 'ComplexOutput', true);
% sine = dsp.NCO('OutputDataType', 'double', 'Waveform', 'Complex exponential','Dither', true);


% sine = imnoise(sine(), 'gaussian',  0.005);


tx.transmitRepeat(sine()); % Transmit continuously

% Setup Scope
samplesPerStep = rx.SamplesPerFrame/rx.BasebandSampleRate;
steps = 3;
ts = timescope('SampleRate', rx.BasebandSampleRate,...
                   'TimeSpan', samplesPerStep*steps,...
                   'BufferLength', rx.SamplesPerFrame*steps);

% Receive and view sine
for k=1:steps
  ts(rx());
end
