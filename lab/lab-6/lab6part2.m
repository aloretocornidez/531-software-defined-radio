%% Lab 1 Part 2: Fine Frequency Correction
clear

% Debugging flags
visuals = false;
% visuals = true;

%% General system details
sampleRateHz = 1e3; % Sample rate
samplesPerSymbol = 1;
frameSize = 2^10;
numFrames = 300;
numSamples = numFrames*frameSize; % Samples to simulate

%% Setup objects
mod = comm.DBPSKModulator();
cdPre = comm.ConstellationDiagram('ReferenceConstellation', [-1 1],...
  'Name','Baseband');
cdPost = comm.ConstellationDiagram('ReferenceConstellation', [-1 1],...
  'SymbolsToDisplaySource','Property',...
  'SymbolsToDisplay',frameSize/2,...
  'Name','Baseband with Freq Offset');
cdPre.Position(1) = 50;
cdPost.Position(1) = cdPre.Position(1)+cdPre.Position(3)+10;% Place side by side
ap = dsp.ArrayPlot;ap.ShowGrid = true;
ap.Title = 'Frequency Histogram';ap.XLabel = 'Hz';ap.YLabel = 'Magnitude';
ap.XOffset = -sampleRateHz/2;
ap.SampleIncrement = (sampleRateHz)/(2^10);

cdOut = comm.ConstellationDiagram('ReferenceConstellation', [-1 1],...
  'Name','Baseband');
cdPreOut = comm.ConstellationDiagram('ReferenceConstellation', [-1 1],...
  'Name','Baseband');

%% Impairments
snr = 5;
frequencyOffsetHz = sampleRateHz*0.05; % Offset in hertz
degrees = 3;
phaseOffset = degrees / 180 * (pi / 2); % Radians

%% Generate symbols
data = randi([0 samplesPerSymbol], numSamples, 1);
modulatedData = mod.step(data);

%% Add noise
noisyData = awgn(modulatedData,snr);%,'measured');

%% Model of error
% Add frequency offset to baseband signal

% Precalculate constants
normalizedOffset = 1i.*2*pi*frequencyOffsetHz./sampleRateHz;



dampingFactor = 0.707;
loopBandwidth = 0.03;

carsync = comm.CarrierSynchronizer(Modulation="BPSK", ...
  SamplesPerSymbol=samplesPerSymbol, ...
  DampingFactor=dampingFactor, ...
  NormalizedLoopBandwidth=loopBandwidth);


% evmOffset = zeros(size(noisyData));
% evmCorrected = zeros(size(noisyData));
% offsetData = zeros(size(noisyData));
% correctedData = zeros(size(noisyData));
% [correctedData, est] = carsync(offsetData);
err = zeros(size(noisyData));
for k=1:frameSize:numSamples
  
  timeIndex = (k:k+frameSize-1).';
  freqShift = exp(normalizedOffset*timeIndex + phaseOffset);
  
  % Offset data and maintain phase between frames
  offsetData(timeIndex) = noisyData(timeIndex).*freqShift;
  
  
  % evmOffset(timeIndex) = abs(abs(noisyData(timeIndex)) - abs(offsetData(timeIndex)));
  % evmCorrected(timeIndex) = abs(abs(noisyData(timeIndex)) - abs(correctedData(timeIndex)));
  
  
  % Visualize Error
  if visuals
    step(cdPre,noisyData(timeIndex));step(cdPost,offsetData(timeIndex));
    pause(0.1); %#ok<*UNRCH>
  end
  
end

% Use the comm.CarrierSynchronizer object to do fine frequency correction.
[correctedData(timeIndex), est] = carsync(noisyData(timeIndex));

size(offsetData);
size(modulatedData');

evm = comm.EVM(MaximumEVMOutputPort=true, ...
  XPercentileEVMOutputPort=true,XPercentileValue=90, ...
  SymbolCountOutputPort=true);




K = 10;
tempA = modulatedData(1:K);
tempB = modulatedData(1:K);
tempC = modulatedData(1:K);
[originalRmsEVM,maxEVM,pctEVM,numSym] = evm(correctedData(1:K), tempA(1:K)');
[offsetRmsEVM,maxEVM,pctEVM,numSym] = evm(offsetData(1:K), tempB(1:K)');
[correctedRmsEVM,maxEVM,pctEVM,numSym] = evm(corrected(1:K), tempC(1:K)');

K = size(offsetRmsEVM);


originalSum = 0;
offsetSum =  0;
correctedSum = 0;

for index = 1:K
  
  offsetSum = sum + offsetRmsEVM(index);
  sum = sum + offsetRmsEVM(index);
  sum = sum + offsetRmsEVM(index);
  
  originalSum = originalSum + originalRmsEVM(index);
  offsetSum = offsetSum + offsetRmsEVM(index);
  correctedSum = correctedSum + correctedRmsEVM(index);
  
  
  
end

offsetRms = offsetSum ./ size(offsetRmsEVM)
originalRms = originalSum ./ size(originalRmsEVM)
correctedRms = correctedSum ./ size(correctedRmsEVM)


estHz = diff(est)*sampleRateHz/(2*pi);
estHz = cumsum(estHz) ./ (1:length(estHz))';

plot(estHz);
title(['Damping Factor = ', num2str(dampingFactor), ' | ', 'Loop BW = ', num2str(loopBandwidth)]);

