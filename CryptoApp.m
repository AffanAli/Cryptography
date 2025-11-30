function CryptoApp
    % Create UI Figure
    fig = uifigure('Name', 'Crypto App', 'Position', [100 100 700 600]); 
    
    % Grid Layout
    gl = uigridlayout(fig, [7, 4]); 
    gl.RowHeight = {40, 40, 30, 30, 150, 40, 150}; 
    gl.ColumnWidth = {100, '1x', '1x', 160}; 
    
    % File Upload Section
    uploadBtn = uibutton(gl, 'Text', 'Upload File');
    uploadBtn.Layout.Row = 1;
    uploadBtn.Layout.Column = 1;
    uploadBtn.BackgroundColor = [0.30, 0.50, 0.90]; 
    uploadBtn.FontColor = [1 1 1];
    uploadBtn.FontWeight = 'bold';
    
    fileNameLabel = uilabel(gl);
    fileNameLabel.Text = 'No file selected';
    fileNameLabel.Layout.Row = 1;
    fileNameLabel.Layout.Column = [2 4];

    % Method Selection
    methodLabel = uilabel(gl);
    methodLabel.Text = 'Method:';
    methodLabel.Layout.Row = 2;
    methodLabel.Layout.Column = 1;
    methodLabel.HorizontalAlignment = 'right';

    methodDropdown = uidropdown(gl);
    methodDropdown.Items = {'Caesar', 'One-Time Pad', 'XOR - Bitwise stream cipher', 'DES block cipher', 'AES block cipher', 'Keyed Hash', 'RSA', 'Envelope Encryption (KMS)'};
    methodDropdown.Layout.Row = 2;
    methodDropdown.Layout.Column = [2 4];

    % Parameters (Shift / Key / Envelope Params)
    % Shift
    shiftLabel = uilabel(gl);
    shiftLabel.Text = 'Shift:';
    shiftLabel.Layout.Row = 3;
    shiftLabel.Layout.Column = 1;
    shiftLabel.HorizontalAlignment = 'right';
    
    shiftEdit = uieditfield(gl, 'text');
    shiftEdit.Layout.Row = 3;
    shiftEdit.Layout.Column = [2 4]; 
    shiftEdit.Value = ''; 
    shiftEdit.Placeholder = 'Enter shift amount';

    % Key (Initially hidden)
    keyLabel = uilabel(gl);
    keyLabel.Text = 'Key:';
    keyLabel.Layout.Row = 3;
    keyLabel.Layout.Column = 1;
    keyLabel.HorizontalAlignment = 'right';
    keyLabel.Visible = 'off';

    keyEdit = uieditfield(gl, 'text');
    keyEdit.Layout.Row = 3;
    keyEdit.Layout.Column = [2 3]; 
    keyEdit.Visible = 'off';
    keyEdit.Placeholder = 'Enter key...';

    % Key Generation Buttons Container
    keyBtnGrid = uigridlayout(gl, [1, 2]); 
    keyBtnGrid.Layout.Row = 3;
    keyBtnGrid.Layout.Column = 4;
    keyBtnGrid.Padding = [0 0 0 0];
    keyBtnGrid.ColumnSpacing = 2;
    keyBtnGrid.Visible = 'off'; 

    % Standard Gen Button
    genKeyBtn = uibutton(keyBtnGrid, 'Text', 'Gen');
    genKeyBtn.Visible = 'off';
    genKeyBtn.BackgroundColor = [0.5, 0.5, 0.5];
    genKeyBtn.FontColor = [1 1 1];
    genKeyBtn.FontWeight = 'bold';

    % DH Key Button (Keyed Hash)
    genDHBtn = uibutton(keyBtnGrid, 'Text', 'DH');
    genDHBtn.Visible = 'off';
    genDHBtn.BackgroundColor = [0.6, 0.4, 0.8]; 
    genDHBtn.FontColor = [1 1 1];
    genDHBtn.FontWeight = 'bold';

    % Algo Dropdown (Row 4)
    algoLabel = uilabel(gl);
    algoLabel.Text = 'Algorithm:';
    algoLabel.Layout.Row = 4;
    algoLabel.Layout.Column = 1;
    algoLabel.HorizontalAlignment = 'right';
    algoLabel.Visible = 'off';

    algoDropdown = uidropdown(gl);
    algoDropdown.Items = {'SHA-1', 'SHA-384', 'SHA-512'};
    algoDropdown.Layout.Row = 4;
    algoDropdown.Layout.Column = [2 3];
    algoDropdown.Visible = 'off';

    % Nonce (Row 4)
    nonceLabel = uilabel(gl);
    nonceLabel.Text = 'Nonce:';
    nonceLabel.Layout.Row = 4;
    nonceLabel.Layout.Column = 1;
    nonceLabel.HorizontalAlignment = 'right';
    nonceLabel.Visible = 'off';

    nonceEdit = uieditfield(gl, 'text');
    nonceEdit.Layout.Row = 4;
    nonceEdit.Layout.Column = [2 3]; 
    nonceEdit.Visible = 'off';
    nonceEdit.Placeholder = 'Enter nonce (space separated uint8)...';

    genNonceBtn = uibutton(gl, 'Text', 'Gen Nonce');
    genNonceBtn.Layout.Row = 4;
    genNonceBtn.Layout.Column = 4;
    genNonceBtn.Visible = 'off';
    genNonceBtn.BackgroundColor = [0.5, 0.5, 0.5]; 
    genNonceBtn.FontColor = [1 1 1];
    genNonceBtn.FontWeight = 'bold';
    
    % RSA Inputs
    rsaPLabel = uilabel(gl);
    rsaPLabel.Text = 'Prime p:';
    rsaPLabel.Layout.Row = 3;
    rsaPLabel.Layout.Column = 1;
    rsaPLabel.HorizontalAlignment = 'right';
    rsaPLabel.Visible = 'off';
    
    rsaPEdit = uieditfield(gl, 'numeric');
    rsaPEdit.Layout.Row = 3;
    rsaPEdit.Layout.Column = 2; 
    rsaPEdit.Visible = 'off';
    
    rsaQLabel = uilabel(gl);
    rsaQLabel.Text = 'Prime q:';
    rsaQLabel.Layout.Row = 3;
    rsaQLabel.Layout.Column = 3;
    rsaQLabel.HorizontalAlignment = 'right';
    rsaQLabel.Visible = 'off';
    
    rsaQEdit = uieditfield(gl, 'numeric');
    rsaQEdit.Layout.Row = 3;
    rsaQEdit.Layout.Column = 4; 
    rsaQEdit.Visible = 'off';

    % Envelope Inputs (IV and AAD) - Reusing Row 3/4 space?
    
    % Envelope IV (Reuse Row 4 Nonce fields but change labels?)
    % Let's create distinct controls to avoid confusion, placed in Row 3 & 4
    
    envIVLabel = uilabel(gl);
    envIVLabel.Text = 'IV (Hex):';
    envIVLabel.Layout.Row = 3;
    envIVLabel.Layout.Column = 1;
    envIVLabel.HorizontalAlignment = 'right';
    envIVLabel.Visible = 'off';
    
    envIVEdit = uieditfield(gl, 'text');
    envIVEdit.Layout.Row = 3;
    envIVEdit.Layout.Column = [2 3];
    envIVEdit.Visible = 'off';
    envIVEdit.Placeholder = 'Enter IV (12 bytes hex) or leave empty for random';
    
    envGenIVBtn = uibutton(gl, 'Text', 'Gen IV');
    envGenIVBtn.Layout.Row = 3;
    envGenIVBtn.Layout.Column = 4;
    envGenIVBtn.Visible = 'off';
    envGenIVBtn.BackgroundColor = [0.5, 0.5, 0.5];
    envGenIVBtn.FontColor = [1 1 1];
    envGenIVBtn.FontWeight = 'bold';
    
    envAADLabel = uilabel(gl);
    envAADLabel.Text = 'AAD:';
    envAADLabel.Layout.Row = 4;
    envAADLabel.Layout.Column = 1;
    envAADLabel.HorizontalAlignment = 'right';
    envAADLabel.Visible = 'off';
    
    envAADEdit = uieditfield(gl, 'text');
    envAADEdit.Layout.Row = 4;
    envAADEdit.Layout.Column = [2 4];
    envAADEdit.Visible = 'off';
    envAADEdit.Placeholder = 'Additional Authenticated Data (Optional)';

    % Input Text Area
    inputTextLabel = uilabel(gl);
    inputTextLabel.Text = 'Text:'; 
    inputTextLabel.Layout.Row = 5;
    inputTextLabel.Layout.Column = 1;
    inputTextLabel.VerticalAlignment = 'top';
    inputTextLabel.HorizontalAlignment = 'right'; 

    inputTextArea = uitextarea(gl);
    inputTextArea.Layout.Row = 5;
    inputTextArea.Layout.Column = [2 4];
    inputTextArea.Editable = 'on'; 
    inputTextArea.Placeholder = 'Enter text here or upload a file...';

    % Action Buttons
    encryptBtn = uibutton(gl, 'Text', 'Encrypt');
    encryptBtn.Layout.Row = 6;
    encryptBtn.Layout.Column = 2; 
    encryptBtn.BackgroundColor = [0.39, 0.83, 0.07]; 
    encryptBtn.FontColor = [1 1 1];
    encryptBtn.FontWeight = 'bold';
    
    decryptBtn = uibutton(gl, 'Text', 'Decrypt');
    decryptBtn.Layout.Row = 6;
    decryptBtn.Layout.Column = 3;
    decryptBtn.BackgroundColor = [0.85, 0.33, 0.10]; 
    decryptBtn.FontColor = [1 1 1];
    decryptBtn.FontWeight = 'bold';

    % Output Text Area
    outputTextLabel = uilabel(gl);
    outputTextLabel.Text = 'Output:';
    outputTextLabel.Layout.Row = 7;
    outputTextLabel.Layout.Column = 1;
    outputTextLabel.VerticalAlignment = 'top';
    outputTextLabel.HorizontalAlignment = 'right'; 

    outputTextArea = uitextarea(gl);
    outputTextArea.Layout.Row = 7;
    outputTextArea.Layout.Column = [2 4];
    outputTextArea.Editable = 'off';

    % Callbacks
    uploadBtn.ButtonPushedFcn = @(btn,event) uploadFile(fileNameLabel, inputTextArea, fig);
    
    methodDropdown.ValueChangedFcn = @(dd,event) updateVisibility(dd, shiftLabel, shiftEdit, keyLabel, keyEdit, keyBtnGrid, genKeyBtn, genDHBtn, nonceLabel, nonceEdit, genNonceBtn, algoLabel, algoDropdown, rsaPLabel, rsaPEdit, rsaQLabel, rsaQEdit, envIVLabel, envIVEdit, envGenIVBtn, envAADLabel, envAADEdit, encryptBtn, decryptBtn, gl);
    
    genKeyBtn.ButtonPushedFcn = @(btn,event) generateKey(keyEdit, inputTextArea, methodDropdown, fig);
    genDHBtn.ButtonPushedFcn = @(btn,event) generateKeyDH(keyEdit, fig);
    genNonceBtn.ButtonPushedFcn = @(btn,event) generateNonce(nonceEdit, fig);
    envGenIVBtn.ButtonPushedFcn = @(btn,event) generateEnvIV(envIVEdit, fig);
    
    encryptBtn.ButtonPushedFcn = @(btn,event) processText(inputTextArea, outputTextArea, methodDropdown, shiftEdit, keyEdit, nonceEdit, algoDropdown, rsaPEdit, rsaQEdit, envIVEdit, envAADEdit, 'encrypt', fig);
    decryptBtn.ButtonPushedFcn = @(btn,event) processText(inputTextArea, outputTextArea, methodDropdown, shiftEdit, keyEdit, nonceEdit, algoDropdown, rsaPEdit, rsaQEdit, envIVEdit, envAADEdit, 'decrypt', fig);
    
    inputTextArea.ValueChangedFcn = @(area, event) textChanged(fileNameLabel, fig);

    % Initialize visibility
    updateVisibility(methodDropdown, shiftLabel, shiftEdit, keyLabel, keyEdit, keyBtnGrid, genKeyBtn, genDHBtn, nonceLabel, nonceEdit, genNonceBtn, algoLabel, algoDropdown, rsaPLabel, rsaPEdit, rsaQLabel, rsaQEdit, envIVLabel, envIVEdit, envGenIVBtn, envAADLabel, envAADEdit, encryptBtn, decryptBtn, gl);
end

function uploadFile(lbl, area, fig)
    [file, path] = uigetfile({'*.*', 'All Files (*.*)'}, 'Select File');
    if isequal(file, 0)
        return;
    end
    fullPath = fullfile(path, file);
    lbl.Text = file;
    try
        % Read as binary bytes
        fid = fopen(fullPath, 'rb');
        raw_bytes = fread(fid, inf, '*uint8')';
        fclose(fid);
        
        % Store raw bytes in appdata for processing
        setappdata(fig, 'BinaryInputData', raw_bytes);
        % Store file path too, envelopeWrapper might want it directly
        setappdata(fig, 'InputFilePath', fullPath);
        
        % Determine if it's text or binary for display
        is_binary = any(raw_bytes == 0) || (sum(raw_bytes < 9 | (raw_bytes > 13 & raw_bytes < 32)) / length(raw_bytes) > 0.1);
        
        if is_binary
            hex_str = upper(reshape(dec2hex(raw_bytes)', 1, []));
            area.Value = hex_str; 
        else
            text_content = char(raw_bytes);
            area.Value = text_content;
        end
    catch ME
        if exist('fid', 'var') && fid > 0
            fclose(fid);
        end
        uialert(fig, ['Error reading file: ' ME.message], 'File Error');
    end
end

function textChanged(lbl, fig)
    lbl.Text = 'No file selected';
    if isappdata(fig, 'BinaryInputData')
        rmappdata(fig, 'BinaryInputData');
    end
    if isappdata(fig, 'InputFilePath')
        rmappdata(fig, 'InputFilePath');
    end
end

function updateVisibility(dd, sLbl, sEdit, kLbl, kEdit, kGrid, genBtn, dhBtn, nLbl, nEdit, nGenBtn, aLbl, aDD, pLbl, pEdit, qLbl, qEdit, ivLbl, ivEdit, ivGen, aadLbl, aadEdit, encBtn, decBtn, gl)
    method = dd.Value;
    
    % Default visibility (hide all)
    sLbl.Visible = 'off'; sEdit.Visible = 'off';
    kLbl.Visible = 'off'; kEdit.Visible = 'off'; 
    kGrid.Visible = 'off'; genBtn.Visible = 'off'; dhBtn.Visible = 'off';
    
    nLbl.Visible = 'off'; nEdit.Visible = 'off'; nGenBtn.Visible = 'off';
    aLbl.Visible = 'off'; aDD.Visible = 'off';
    
    pLbl.Visible = 'off'; pEdit.Visible = 'off';
    qLbl.Visible = 'off'; qEdit.Visible = 'off';
    
    ivLbl.Visible = 'off'; ivEdit.Visible = 'off'; ivGen.Visible = 'off';
    aadLbl.Visible = 'off'; aadEdit.Visible = 'off';
    
    encBtn.Text = 'Encrypt';
    decBtn.Visible = 'on'; 

    gl.RowHeight{3} = 30; 
    gl.RowHeight{4} = 0; 

    kEdit.Editable = 'on'; 

    if strcmp(method, 'Caesar')
        sLbl.Visible = 'on';
        sEdit.Visible = 'on';
    elseif strcmp(method, 'One-Time Pad')
        kLbl.Visible = 'on';
        kEdit.Visible = 'on';
        kGrid.Visible = 'on';
        genBtn.Visible = 'on';
        genBtn.Text = 'Generate';
    elseif strcmp(method, 'XOR - Bitwise stream cipher')
        kLbl.Visible = 'on';
        kEdit.Visible = 'on';
        kGrid.Visible = 'on';
        genBtn.Visible = 'on';
        genBtn.Text = 'Gen Key';
        
        nLbl.Visible = 'on';
        nEdit.Visible = 'on';
        nGenBtn.Visible = 'on';
        gl.RowHeight{4} = 30; 
    elseif strcmp(method, 'AES block cipher')
        kLbl.Visible = 'on';
        kEdit.Visible = 'on';
        kGrid.Visible = 'on';
        genBtn.Visible = 'on';
        genBtn.Text = 'Gen AES-256';
    elseif strcmp(method, 'DES block cipher')
        kLbl.Visible = 'on'; 
        kEdit.Visible = 'on'; 
        kEdit.Editable = 'off'; 
        kGrid.Visible = 'on';
        genBtn.Visible = 'on';
        genBtn.Text = 'Update Key Matrix';
        gl.RowHeight{3} = 150; 
    elseif strcmp(method, 'Keyed Hash')
        kLbl.Visible = 'on';
        kEdit.Visible = 'on';
        kGrid.Visible = 'on';
        genBtn.Visible = 'on';
        genBtn.Text = 'Gen Key';
        dhBtn.Visible = 'on';
        
        aLbl.Visible = 'on';
        aDD.Visible = 'on';
        gl.RowHeight{4} = 30; 

        encBtn.Text = 'Generate Hash';
        decBtn.Visible = 'off'; 
    elseif strcmp(method, 'RSA')
        pLbl.Visible = 'on';
        pEdit.Visible = 'on';
        qLbl.Visible = 'on';
        qEdit.Visible = 'on';
    elseif strcmp(method, 'Envelope Encryption (KMS)')
        % Show IV and AAD inputs
        ivLbl.Visible = 'on';
        ivEdit.Visible = 'on';
        ivGen.Visible = 'on';
        
        aadLbl.Visible = 'on';
        aadEdit.Visible = 'on';
        
        gl.RowHeight{4} = 30; % Show AAD row
    end
end

function generateKey(kEdit, inArea, methodDD, fig)
    method = methodDD.Value;
    if strcmp(method, 'One-Time Pad')
        plaintext = inArea.Value;
        if iscell(plaintext), plaintext = strjoin(plaintext, newline); end
        if isempty(plaintext)
            uialert(fig, 'Please enter text or upload a file to generate a matching key.', 'Key Gen Error');
            return;
        end
        key = char(randi([65, 90], 1, length(plaintext)));
        kEdit.Value = key;
    elseif strcmp(method, 'AES block cipher')
        hexChars = '0123456789abcdef';
        key = hexChars(randi(16, 1, 64));
        kEdit.Value = key;
    elseif strcmp(method, 'DES block cipher')
        try
            addpath(genpath('week6'));
            key = keygen; 
            setappdata(fig, 'DESKey', key);
            kEdit.Value = mat2str(key);
            uialert(fig, "DES Key Matrix Updated", 'Key Update');
        catch ME
            uialert(fig, ['Error generating DES key: ' ME.message], 'Key Gen Error');
        end
    elseif strcmp(method, 'XOR - Bitwise stream cipher')
        chars = ['A':'Z' 'a':'z' '0':'9'];
        key = chars(randi(length(chars), 1, 16));
        kEdit.Value = key;
    elseif strcmp(method, 'Keyed Hash')
        chars = ['A':'Z' 'a':'z' '0':'9'];
        key = chars(randi(length(chars), 1, 32)); 
        kEdit.Value = key;
    end
end

function generateKeyDH(kEdit, fig)
    try
        addpath(genpath('week8'));
        prompt = {'Enter a prime value for g:', 'Enter a prime value for p:'};
        answer = inputdlg(prompt, 'Diffie-Hellman Inputs', [1 35], {'', ''});
        if isempty(answer), return; end
        g = str2double(answer{1}); p = str2double(answer{2});
        if isnan(g) || isnan(p) || ~isprime(g) || ~isprime(p)
            uialert(fig, 'g and p must be valid prime numbers.', 'Input Error');
            return;
        end
        key = DHKey(g, p);
        if isnumeric(key), key = num2str(key); end
        kEdit.Value = key;
        uialert(fig, 'Key generated using Diffie-Hellman.', 'DH Key Gen');
    catch ME
        uialert(fig, ['Error generating DH key: ' ME.message], 'Key Gen Error');
    end
end

function generateNonce(nEdit, fig)
    nonce = uint8(randi([0 255], 1, 8));
    nEdit.Value = num2str(nonce);
end

function generateEnvIV(ivEdit, fig)
    % Generate 12 bytes random hex
    iv = lower(reshape(dec2hex(randi([0 255], 1, 12))', 1, []));
    ivEdit.Value = iv;
end

function processText(inArea, outArea, methodDD, sEdit, kEdit, nEdit, aDD, pEdit, qEdit, ivEdit, aadEdit, mode, fig)
    hasBinaryData = isappdata(fig, 'BinaryInputData');
    if hasBinaryData
        text = getappdata(fig, 'BinaryInputData');
    else
        text = inArea.Value;
        if isempty(text)
            uialert(fig, 'Please enter text or upload a file.', 'Input Error');
            return; 
        end
        if iscell(text), text = strjoin(text, newline); end
    end

    method = methodDD.Value;
        
    try
        result = '';
        if strcmp(method, 'Caesar')
            if isnumeric(text), text = char(text); end
            shift = str2double(sEdit.Value);
            if isnan(shift), error('Please enter a valid numeric shift value.'); end
            result = caeser(text, shift, mode);
            
        elseif strcmp(method, 'One-Time Pad')
            if isnumeric(text), text = char(text); end
            key = kEdit.Value;
            if isempty(key), error('Please enter a key for One-Time Pad.'); end
            result = oneTimePad(text, key, mode);
            
        elseif strcmp(method, 'XOR - Bitwise stream cipher')
            key = kEdit.Value;
            nonceStr = nEdit.Value;
            if isempty(key) || isempty(nonceStr), error('Please enter key and nonce for XOR.'); end
            if strcmpi(mode, 'decrypt') && ~hasBinaryData
                 try
                     clean_text = strrep(text, ' ', '');
                     text = uint8(hex2dec(reshape(clean_text, 2, [])')');
                 catch
                     error('Input for decryption must be a valid Hex string.');
                 end
            end
            out_uint8 = xorCipher(text, key, nonceStr, mode);
            is_printable = all((out_uint8 >= 32 & out_uint8 <= 126) | out_uint8 == 9 | out_uint8 == 10 | out_uint8 == 13);
            if is_printable, result = char(out_uint8);
            else, result = lower(reshape(dec2hex(out_uint8)', 1, [])); end
            
        elseif strcmp(method, 'AES block cipher')
            if isnumeric(text), text = char(text); end
            key = kEdit.Value;
            if isempty(key) || length(key) ~= 64, error('AES-256 key must be 64 hex characters.'); end
            if strcmpi(mode, 'decrypt')
                result = aesBlockCipher(text, key, mode);
                try, result = strtrim(char(hex2dec(reshape(result, 2, [])')')); end
            else
                result = aesBlockCipher(text, key, mode);
            end
            
        elseif strcmp(method, 'DES block cipher')
            if isnumeric(text), text = char(text); end
            key = getappdata(fig, 'DESKey');
            if isempty(key), error('No DES key found.'); end
            result = desBlockCipher(text, key, mode);
            
        elseif strcmp(method, 'Keyed Hash')
            if isnumeric(text), text = char(text); end
            key = kEdit.Value;
            if isempty(key), error('Please enter a key.'); end
            result = HMAC(key, text, aDD.Value);
            
        elseif strcmp(method, 'RSA')
            p = pEdit.Value; q = qEdit.Value;
            if isempty(p) || isempty(q), error('Both p and q are required for RSA.'); end
            addpath(genpath('week8'));
            if strcmpi(mode, 'encrypt')
                if isnumeric(text), text = char(text); end
                cipher_ints = rsaWrapper(text, p, q, 'encrypt');
                result = num2str(cipher_ints);
            else
                if ischar(text) || isstring(text)
                    cipher_ints = str2num(char(text));
                end
                result = rsaWrapper(cipher_ints, p, q, 'decrypt');
            end
            
        elseif strcmp(method, 'Envelope Encryption (KMS)')
            addpath(genpath('week10'));
            if strcmpi(mode, 'encrypt')
                iv = ivEdit.Value;
                aad = aadEdit.Value;
                
                % Pass input as-is. envelopeWrapper handles text vs file path.
                % If file uploaded, we can pass the path.
                inputToWrapper = text;
                if isappdata(fig, 'InputFilePath')
                    inputToWrapper = getappdata(fig, 'InputFilePath');
                end
                
                % envelopeWrapper(input_data, mode, iv, aad)
                [env, ~] = envelopeWrapper(inputToWrapper, 'encrypt', iv, aad);
                
                % Display envelope details
                result = sprintf('Envelope Encryption Successful!\n\nIV: %s\nTag: %s\nCiphertext Length: %d bytes\nWrapped DEK Length: %d bytes\nKEK Version: %d\nAAD: %s', ...
                    env.iv, env.tag, length(env.ciphertext), length(env.wrappedDEK), env.kekVersion, env.aad);
                
                % Save option
                [file, path] = uiputfile('envelope.mat', 'Save Envelope Data');
                if ~isequal(file, 0)
                    envelope = env;
                    save(fullfile(path, file), 'envelope');
                    result = [result newline newline 'Envelope saved to: ' file];
                else
                    result = [result newline newline '(Envelope not saved)'];
                end
                
            else % Decrypt
                % Expecting user to upload envelope.mat
                if isappdata(fig, 'InputFilePath')
                    filePath = getappdata(fig, 'InputFilePath');
                    if ~endsWith(filePath, '.mat')
                        error('For decryption, please upload the envelope .mat file.');
                    end
                    
                    [plaintext, auth_ok] = envelopeWrapper(filePath, 'decrypt');
                    
                    % Updated wrapper returns plain text directly
                    if auth_ok
                         result = plaintext;
                    else
                         result = ['[AUTH FAILED - WARNING] ' newline plaintext];
                    end
                else
                    error('Please upload the envelope .mat file to decrypt.');
                end
            end
        end
        
        outArea.Value = result;
    catch ME
        uialert(fig, ME.message, 'Processing Error');
    end
end
