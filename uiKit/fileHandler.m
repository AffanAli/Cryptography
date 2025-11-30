function fileHandler(handles, fig)
    [file, path] = uigetfile({'*.*', 'All Files (*.*)'}, 'Select File');
    if isequal(file, 0), return; end
    fullPath = fullfile(path, file);
    handles.fileNameLabel.Text = file;
    try
        fid = fopen(fullPath, 'rb');
        raw_bytes = fread(fid, inf, '*uint8')';
        fclose(fid);
        
        setappdata(fig, 'BinaryInputData', raw_bytes);
        setappdata(fig, 'InputFilePath', fullPath);
        
        % Heuristic: Text vs Binary
        is_binary = any(raw_bytes == 0) || (sum(raw_bytes < 9 | (raw_bytes > 13 & raw_bytes < 32)) / length(raw_bytes) > 0.1);
        
        if is_binary
            hex_str = upper(reshape(dec2hex(raw_bytes)', 1, []));
            handles.inputTextArea.Value = hex_str; 
        else
            handles.inputTextArea.Value = char(raw_bytes);
        end
    catch ME
        if exist('fid', 'var') && fid > 0, fclose(fid); end
        uialert(fig, ['Error reading file: ' ME.message], 'File Error');
    end
end