function corr = myFilter(x, y)


% make an array that is the largest size
size = 2 * length(x) - 1;

corr = zeros(size);



% iterate through the signal.
for i = 1:length(corr)
  
  sum = 0;
  
  % figure out the index for both of the signals to start comparing.
  
  
  %% iterate the reference signal.
  for j = 1:length(seq)
    
    sum = sum + x(i)*seq(j);
    
  end
  
  corr(delay) = sum;
  
end
