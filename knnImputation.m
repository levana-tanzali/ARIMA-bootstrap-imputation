function table = knnImputation(filename)
    table = readtable(filename);

    % Mendapatkan nama-nama kolom numerik
    numeric_column_names = table.Properties.VariableNames(2:end);
    
    % Iterasi melalui setiap kolom numerik
    for col = 1:length(numeric_column_names)
        % Mengonversi data dalam kolom ke dalam bentuk array
        column_data = table2array(table(:, numeric_column_names{col}));
        
        % Menemukan indeks terakhir data valid untuk kolom ini (yg bukan NaN)
        last_valid_index = find(~isnan(column_data), 1, 'last');
        
        % Identifikasi missing values yang bisa diimputasi
        % Cari missing values hanya antara data valid
        missing_indices = find(isnan(column_data(1:last_valid_index)));
        available_indices = find(~isnan(column_data(1:last_valid_index)));
        k = ceil(sqrt(length(column_data))); %nilai K diambil paling optimal berdasarkan literatur

        %Proses KNN Imputation
        for i = 1:length(missing_indices)
            distances = abs(available_indices - missing_indices(i));
            [~, sortedIdx] = sort(distances);
            nearestNeighborsIdx = available_indices(sortedIdx(1:k));
            column_data(missing_indices(i)) = mean(column_data(nearestNeighborsIdx));
        end
        
        % Mengganti kolom dalam tabel dengan data yang telah diproses
        table.(numeric_column_names{col}) = column_data;
    end
end