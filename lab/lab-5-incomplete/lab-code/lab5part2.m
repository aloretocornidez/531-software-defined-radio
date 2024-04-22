%% Parameters
Nsym = 6;           % Filter span in symbol durations
beta = 0.1;         % Roll-off factor
sampsPerSym = 8;    % Resampling factor
snr = 10;

DataL = 20;             % Data length in symbols
R = 1000;               % Data rate
Fs = R * sampsPerSym;   % Sampling frequency

% Create a local random stream to be used by random number generators for repeatability
hStr = RandStream('mt19937ar',Seed=0);
s = RandStream('mt19937ar',Seed=1433);

% Generate random data
x = 2*randi(hStr,[0 1],DataL,1)-1;

% Time vector sampled at symbol rate in milliseconds
tx = 1000 * (0: DataL - 1) / R;

% Create an SRRC filter.
rctFilt = comm.RaisedCosineTransmitFilter(RolloffFactor=beta, FilterSpanInSymbols=Nsym, OutputSamplesPerSymbol=sampsPerSym);

yo = rctFilt([x; zeros(Nsym/2,1)]);

% Add white gaussian noise using the SNR specified.
yo_noise = awgn(yo, snr, 0, s);

% Filter group delay, since raised cosine filter is linear phase and symmetric.
fltDelay = Nsym / (2*R);

% Correct for propagation delay by removing filter transients
yo = yo(fltDelay*Fs+1:end);
yo_noise = yo_noise(fltDelay*Fs+1:end);
to = 1000 * (0: DataL*sampsPerSym - 1) / Fs;

t = tiledlayout(3, 1);
title(t, ['Beta: ' num2str(beta) ', SNR: ' num2str(snr)])
nexttile
stem(tx, x, 'kx');
hold on;
plot(to, yo, 'b-o', to, yo_noise, 'r-');
hold off;

axis([0 20 -1.5 1.5]);  xlabel('Time (ms)'); ylabel('Amplitude');
legend('Transmitted Data', 'Transmitted SRRC', 'Recieved Data with Noise','Location','southeast')

% Design and normalize filter.
rcrFilt = comm.RaisedCosineReceiveFilter('Shape', 'Square root', 'RolloffFactor', beta, 'FilterSpanInSymbols', Nsym, 'InputSamplesPerSymbol', sampsPerSym, 'DecimationFactor', 1);

% Design and normalize filter.
rcrFilt_dec = comm.RaisedCosineReceiveFilter('Shape', 'Square root', 'RolloffFactor', beta, 'FilterSpanInSymbols', Nsym, 'InputSamplesPerSymbol', sampsPerSym, 'DecimationFactor', sampsPerSym);

% Filter at the receiver.
yr = rcrFilt([yo_noise; zeros(Nsym*sampsPerSym/2, 1)]);
yr_dec = rcrFilt_dec([yr; zeros(Nsym*sampsPerSym/2, 1)]);

% Correct for propagation delay by removing filter transients
yr = yr(fltDelay*Fs+1:end);
demod = sign(yr_dec(Nsym+1:end));
demod_noise = sign(downsample(yo_noise, sampsPerSym));

% Plot data.
nexttile
stem(tx, x, 'kx');
hold on;
plot(to, yr, 'b-');
stem(tx, demod, 'mo');
hold off;

% Set axes and labels.
axis([0 20 -1.5 1.5]); xlabel('Time (ms)'); ylabel('Amplitude');
legend('Transmitted Data','Rcv Filter Output','Demodulated','Location','southeast')



nexttile
stem(tx, x, 'kx');
hold on;
plot(to, yo_noise, 'r-');
stem(tx, demod_noise, 'mo');
hold off;

% Set axes and labels.
axis([0 20 -1.5 1.5]);  xlabel('Time (ms)'); ylabel('Amplitude');
legend('Transmitted Data','Recieved Data w/ Noise','Demodulated','Location','southeast')
