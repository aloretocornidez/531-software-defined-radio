---
title: ECE 531 | Lab 7 Frame Synchronization
author: Alan Manuel Loreto Cornídez
---

\newpage

\thispagestyle{empty} \clearpage \tableofcontents \pagenumbering{roman}
\clearpage \pagenumbering{arabic} \setcounter{page}{1}

# Questions

## Based on lab7part1.m implement an alternative scheme that utilized the filter function for estimation rather than xcorr. (filter is generally much faster than xcorr in interpreted MATLAB.) Provide a benchmark using tic and toc for their relative performance for different sequence lengths.

Instead of using the `corr = xcorr(y,seq)` line in the code, you can use the
following series of lines:

```MATLAB
size = 2 * length(y) - 1;
B = padarray(seq, size - length(seq), "post");
Y = padarray(y, size - length(y), "post");
corr = filter2(B, Y);
```

This allows the correlation to be done using a filter object instead of using
the xcorr function. When running timing analysis we get interesting results.

There are three parameters.

xcorr time is the time result from:

```MATLAB
tic
corr = xcorr(y,seq);
toc
```

filter time is the time result from:

```MATLAB
tic
corr = filter2(B, Y);
toc
```

filter + data prep time is the time result from:

| Barker Seq Length | xcorr Time   | filter Time  | filter + data prep time |
| ----------------- | ------------ | ------------ | ----------------------- |
| 2                 | 0.053491 (s) | 0.003780 (s) | 0.002400 (s)            |
| 3                 | 0.000383 (s) | 0.000340 (s) | 0.000620 (s)            |
| 4                 | 0.000301 (s) | 0.000216 (s) | 0.000619 (s)            |
| 5                 | 0.000386 (s) | 0.000292 (s) | 0.000723 (s)            |
| 7                 | 0.000459 (s) | 0.000258 (s) | 0.000626 (s)            |
| 11                | 0.000304 (s) | 0.000226 (s) | 0.000639 (s)            |
| 13                | 0.000180 (s) | 0.000114 (s) | 0.000295 (s)            |

As you can see, when the filter had a barker sequence with a length of two, the
filter time was pretty big compared to the other times in general. The fastest
operation took place when the barker sequence length was 13, which was
interesting.

An interesting note is the fact that the filter operation was, in fact, shorter
than the xcorr time, however, when taking into account the amount of time that
the data takes to be prepped for the operation, the shorter time was the xcorr
function.

If you have an application that is set up that only needs to do the initial data
setup once, then the payoff for using the filter function will be greater in the
long run, especially considering modern data transmission rates.

## Based on template provided in lab7part2.m and the example in lab7part1.m implement a frame synchronization scheme.

Here is what I added inside the loop for each transmission:

```MATLAB
payloadStart = barkerLength+1; % Trim preamble to display ASCII payload
rxTxt = dataHat(payloadStart:end);
rxTxt = reshape(rxTxt, 7, []);
rxTxt = transpose(rxTxt);
rxTxt = rxTxt(:,7) + 2*rxTxt(:,6) + 4*rxTxt(:,5) +...
  8*rxTxt(:,4) + 16*rxTxt(:,3) + 32*rxTxt(:,2)...
  + 64*rxTxt(:,1);
rxTxt = char(transpose(rxTxt))
```

First I take the payload by taking all parts of the payload after the barker
sequence. Then I condition the data using reshape and transpose. The next line
takes the product of multiple different elements and converts the data back to
binary. After the data has been converted back to binary, the data is then
converted to ascii encoding. This is done for every frame that is received.

## Test your frame synchronization implementation over the SNR range [0, 10] dB and provide the resuling plot for detection probability and packet error rate.

We can calculate the correct amount of transmissions by adding a percentage for
correct transmissions:

```MATLAB
total = 0;
correct = 0;
```

Inside the loop:

```MATLAB
total = total + 1;
if(rxTxt == "Arizona")
  correct = correct + 1;
end
```

After the loop:

```MATLAB
PER = (correct / total) * 100;

% Result
fprintf('PER %2.2f\n',mean(PER));
```

We can check different SNR Ranges:

| SNR (dB) | Accuracy (%) |
| -------- | ------------ |
| 0        | 0%           |
| 1        | 0%           |
| 2        | 2%           |
| 3        | 6%           |
| 4        | 17%          |
| 5        | 32%          |
| 6        | 43%          |
| 7        | 72%          |
| 8        | 86%          |
| 9        | 96%          |
| 10       | 99%          |

We can see that the accuracy of symbol recognition is somewhat depended on the
signal-to-noise ratio of the transmissions themselves in addition to the symbols
that are being transmitted. It is interesting to see the quick rise in symbol
recognition after the SNR reaches 5 dB. From 8 dB onwards, we can see that the
accuracy is above 80%. In my opinion, symbol recognition in SNRs as low as 6 dB
is impressive. It shows the developments made in communication theory.

# Conclusion

When considering how do intereperet the 1's and 0's in a data stream, it is
important to know when your data stream actually begins in your received
signals. This concept is so obvious that it's easy to forget about it. Becuase
of this, as I was reading the lab document I was intrigued by the idea of Barker
codes.

The idea of barker codes being used to know when the beginning of a signal
transmission occurs is so obvious when you think about the correlation of two
signals. I went down a Wikipedia rabbit hole regarding barker codes.

Regardless, the implementation of Barker code identification using a filter was
difficult to do. While I had the concept in mind quite easily, I spent many
hours trying to figure out how to use the filter object to accomplish the task.
After I was told by a collegue that they used filter2 instead of filter I was
able to figure out how to get the correct output after about 10 minutes.
