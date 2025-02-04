% Read the table
F1 = readtable('test_PSD.xlsx');

% Initialize an empty table for storing results
outputTable = table();

% Define y and x for graph axis.
for i=2:width(F1)
    y = F1(:,i);  
    y=table2array(y);
    x = F1.Time;

    % Calculate the Fourier Transform of the signal
    Y = fft(y);  % Fast Fourier Transform

    % Compute the two-sided spectrum P2, then the single-sided spectrum P1
    L = length(y);  % Length of the signal
    P2 = abs(Y/L);  % Two-sided spectrum
    P1 = P2(1:L/2+1);  % Single-sided spectrum
    P1(2:end-1) = 2*P1(2:end-1);  % Adjust for symmetry
    
    % Frequency domain (f) corresponds to the time domain sampling rate
    Fs = 1 / (x(2) - x(1));  % Sampling frequency (inverse of time interval)
    f = Fs*(0:(L/2))/L;  % Frequency vector
    
    % Calculate the power spectral density (PSD)
    PSD = (1/(Fs*L)) * abs(Y).^2;
    PSD = PSD(1:L/2+1);  % Single-sided PSD
    PSD(2:end-1) = 2*PSD(2:end-1);  % Adjust for symmetry

    % Plot the original signal (calcium oscillation) and its PSD
    figure;
    subplot(2,1,1);
    plot(x, y);
    xlabel('Time (s)');
    ylabel('Fluorescent Intensity');
    title('Calcium Oscillation Signal');
    
    subplot(2,1,2);
    plot(f, PSD);
    xlabel('Frequency (Hz)');
    ylabel('PSD');
    title('Power Spectral Density of Calcium Oscillation');
    
    
    % Convert the PSD to a table and give it the same variable name as in the orignial spreadsheet
    Table2Add = array2table([PSD], 'VariableNames', F1.Properties.VariableNames(i))
    
     % Append the PSD column to the output table
    if i == 2  % Add frequency vector as the first column on the first loop
        outputTable = table(f', PSD, 'VariableNames', {'Frequency', F1.Properties.VariableNames{i}});
    else
        outputTable = [outputTable, Table2Add];  % Append the new PSD column
    end
   
end

%%%****** The outputTable contains the final results. Copy into an Excel spreadsheet for further
%analysis.******