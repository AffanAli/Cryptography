function CryptoApp
    % Create UI Figure
    fig = uifigure('Name', 'Crypto App', 'Position', [100 100 700 600]); % Increased width to 700
    
    % Grid Layout
    gl = uigridlayout(fig, [7, 4]); % Increased to 7 rows
    gl.RowHeight = {40, 40, 30, 30, 150, 40, 150}; % Added Row 4 for Nonce
    gl.ColumnWidth = {100, '1x', '1x', 160}; % Col 4 width for buttons increased to 160

    % File Upload Section
    uploadBtn = uibutton(gl, 'Text', 'Upload File');
    uploadBtn.Layout.Row = 1;
    uploadBtn.Layout.Column = 1;
    uploadBtn.BackgroundColor = [0.30, 0.50, 0.90]; % Blue
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
    methodDropdown.Items = {'Caesar', 'One-Time Pad', 'XOR - Bitwise stream cipher', 'DES block cipher', 'AES block cipher', 'Keyed Hash', 'RSA'};
    methodDropdown.Layout.Row = 2;
    methodDropdown.Layout.Column = [2 4];

    % Parameters (Shift / Key)
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

    % Key Generation Buttons Container (using a grid for multiple buttons)
    % Replaces single genKeyBtn
    keyBtnGrid = uigridlayout(gl, [1, 2]); % Reduced columns to 2 (Gen, DH)
    keyBtnGrid.Layout.Row = 3;
    keyBtnGrid.Layout.Column = 4;
    keyBtnGrid.Padding = [0 0 0 0];
    keyBtnGrid.ColumnSpacing = 2;
    keyBtnGrid.Visible = 'off'; % Controlled by visibility logic

    % Standard Gen Button (One-Time Pad, XOR, etc.)
    genKeyBtn = uibutton(keyBtnGrid, 'Text', 'Gen');
    genKeyBtn.Visible = 'off';
    genKeyBtn.BackgroundColor = [0.5, 0.5, 0.5];
    genKeyBtn.FontColor = [1 1 1];
    genKeyBtn.FontWeight = 'bold';

    % DH Key Button (Keyed Hash)
    genDHBtn = uibutton(keyBtnGrid, 'Text', 'DH');
    genDHBtn.Visible = 'off';
    genDHBtn.BackgroundColor = [0.6, 0.4, 0.8]; % Purple
    genDHBtn.FontColor = [1 1 1];
    genDHBtn.FontWeight = 'bold';

    % Algo Dropdown (Row 4 for Keyed Hash, reusing Nonce space/row)
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

    % Nonce (Row 4, Initially hidden, XOR only)
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
    encryptBtn.BackgroundColor = [0.39, 0.83, 0.07]; % Green
    encryptBtn.FontColor = [1 1 1];
    encryptBtn.FontWeight = 'bold';
    
    decryptBtn = uibutton(gl, 'Text', 'Decrypt');
    decryptBtn.Layout.Row = 6;
    decryptBtn.Layout.Column = 3;
    decryptBtn.BackgroundColor = [0.85, 0.33, 0.10]; % Red/Orange
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
    methodDropdown.ValueChangedFcn = @(dd,event) updateVisibility(dd, shiftLabel, shiftEdit, keyLabel, keyEdit, keyBtnGrid, genKeyBtn, genDHBtn, nonceLabel, nonceEdit, genNonceBtn, algoLabel, algoDropdown, encryptBtn, decryptBtn, gl);
    
    genKeyBtn.ButtonPushedFcn = @(btn,event) generateKey(keyEdit, inputTextArea, methodDropdown, fig);
    genDHBtn.ButtonPushedFcn = @(btn,event) generateKeyDH(keyEdit, fig);
    
    genNonceBtn.ButtonPushedFcn = @(btn,event) generateNonce(nonceEdit, fig);
    encryptBtn.ButtonPushedFcn = @(btn,event) processText(inputTextArea, outputTextArea, methodDropdown, shiftEdit, keyEdit, nonceEdit, algoDropdown, 'encrypt', fig);
    decryptBtn.ButtonPushedFcn = @(btn,event) processText(inputTextArea, outputTextArea, methodDropdown, shiftEdit, keyEdit, nonceEdit, algoDropdown, 'decrypt', fig);
    inputTextArea.ValueChangedFcn = @(area, event) textChanged(fileNameLabel);

    % Initialize visibility
    updateVisibility(methodDropdown, shiftLabel, shiftEdit, keyLabel, keyEdit, keyBtnGrid, genKeyBtn, genDHBtn, nonceLabel, nonceEdit, genNonceBtn, algoLabel, algoDropdown, encryptBtn, decryptBtn, gl);
end

function uploadFile(lbl, area, fig)
    [file, path] = uigetfile({'*.txt', 'Text Files (*.txt)'}, 'Select Text File');
    if isequal(file, 0)
        return;
    end
    fullPath = fullfile(path, file);
    lbl.Text = file;
    try
        content = fileread(fullPath);
        area.Value = content;
    catch ME
        uialert(fig, ['Error reading file: ' ME.message], 'File Error');
    end
end

function textChanged(lbl)
    lbl.Text = 'No file selected';
end

function updateVisibility(dd, sLbl, sEdit, kLbl, kEdit, kGrid, genBtn, dhBtn, nLbl, nEdit, nGenBtn, aLbl, aDD, encBtn, decBtn, gl)
    method = dd.Value;
    
    % Default visibility
    sLbl.Visible = 'off'; sEdit.Visible = 'off';
    kLbl.Visible = 'off'; kEdit.Visible = 'off'; 
    kGrid.Visible = 'off'; genBtn.Visible = 'off'; dhBtn.Visible = 'off';
    
    nLbl.Visible = 'off'; nEdit.Visible = 'off'; nGenBtn.Visible = 'off';
    aLbl.Visible = 'off'; aDD.Visible = 'off';
    
    encBtn.Text = 'Encrypt';
    decBtn.Visible = 'on'; % Default show decrypt button

    % Reset Row 3 height to default
    gl.RowHeight{3} = 30; 
    gl.RowHeight{4} = 0; % Hide Nonce/Algo row by default

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
        gl.RowHeight{4} = 30; % Show Nonce row
    elseif strcmp(method, 'AES block cipher')
        kLbl.Visible = 'on';
        kEdit.Visible = 'on';
        kGrid.Visible = 'on';
        genBtn.Visible = 'on';
        genBtn.Text = 'Gen AES-256';
    elseif strcmp(method, 'DES block cipher')
        kLbl.Visible = 'on'; % Show key label
        kEdit.Visible = 'on'; % Show key display
        kEdit.Editable = 'off'; % User cannot edit matrix manually
        kGrid.Visible = 'on';
        genBtn.Visible = 'on';
        genBtn.Text = 'Update Key Matrix';
        gl.RowHeight{3} = 150; % Increase height for matrix display
    elseif strcmp(method, 'Keyed Hash')
        kLbl.Visible = 'on';
        kEdit.Visible = 'on';
        
        % Show 2 buttons for Keyed Hash
        kGrid.Visible = 'on';
        genBtn.Visible = 'on';
        genBtn.Text = 'Gen Key';
        dhBtn.Visible = 'on';
        
        aLbl.Visible = 'on';
        aDD.Visible = 'on';
        gl.RowHeight{4} = 30; % Show Algo row

        encBtn.Text = 'Generate Hash';
        decBtn.Visible = 'off'; % No decryption for Hash
    end
end

function generateKey(kEdit, inArea, methodDD, fig)
    method = methodDD.Value;
    
    if strcmp(method, 'One-Time Pad')
        plaintext = inArea.Value;
        if iscell(plaintext)
            plaintext = strjoin(plaintext, newline);
        end
        
        if isempty(plaintext)
            uialert(fig, 'Please enter text or upload a file to generate a matching key.', 'Key Generation Error');
            return;
        end
        
        key = char(randi([65, 90], 1, length(plaintext)));
        kEdit.Value = key;
        
    elseif strcmp(method, 'AES block cipher')
        % AES 256-bit key = 64 hex characters
        hexChars = '0123456789abcdef';
        key = hexChars(randi(16, 1, 64));
        kEdit.Value = key;
    elseif strcmp(method, 'DES block cipher')
        % Generate/Update DES Key Matrix
        try
            addpath(genpath('week6'));
            key = keygen; % Generates 8x8 key matrix
            setappdata(fig, 'DESKey', key);
            
            % Format matrix for display
            % uieditfield cannot handle multi-line strings, so we use mat2str for the field
            kEdit.Value = mat2str(key);
            
            keyStr = num2str(key);
            msg = "DES Key Matrix Updated:" + newline + newline + join(string(keyStr), newline);
            uialert(fig, msg, 'Key Update');
        catch ME
            uialert(fig, ['Error generating DES key: ' ME.message], 'Key Gen Error');
        end
    elseif strcmp(method, 'XOR - Bitwise stream cipher')
        % Generate random string key
        % Length not specified, using 16 chars
        chars = ['A':'Z' 'a':'z' '0':'9'];
        key = chars(randi(length(chars), 1, 16));
        kEdit.Value = key;
    elseif strcmp(method, 'Keyed Hash')
        % Generate random string key for HMAC
        chars = ['A':'Z' 'a':'z' '0':'9'];
        key = chars(randi(length(chars), 1, 32)); % 32 chars for robustness
        kEdit.Value = key;
    end
end

function generateKeyDH(kEdit, fig)
    try
        addpath(genpath('week8'));
        
        % Create input dialog for g and p
        prompt = {'Enter a prime value for g:', 'Enter a prime value for p:'};
        dlgtitle = 'Diffie-Hellman Inputs';
        dims = [1 35];
        definput = {'', ''};
        answer = inputdlg(prompt, dlgtitle, dims, definput);
        
        if isempty(answer)
            return; % User cancelled
        end
        
        g_str = answer{1};
        p_str = answer{2};
        
        if isempty(g_str) || isempty(p_str)
            uialert(fig, 'Both g and p are required.', 'Input Error');
            return;
        end
        
        g = str2double(g_str);
        p = str2double(p_str);
        
        if isnan(g) || isnan(p)
            uialert(fig, 'g and p must be numeric.', 'Input Error');
            return;
        end
        
        % Check if primes
        if ~isprime(g)
             uialert(fig, 'g must be a prime number.', 'Input Error');
             return;
        end
        if ~isprime(p)
             uialert(fig, 'p must be a prime number.', 'Input Error');
             return;
        end
        
        % Call DHKey with inputs
        key = DHKey(g, p);
        
        % Convert to string if numeric
        if isnumeric(key)
            key = num2str(key);
        end
        kEdit.Value = key;
        uialert(fig, 'Key generated using Diffie-Hellman.', 'DH Key Gen');
        
    catch ME
        uialert(fig, ['Error generating DH key: ' ME.message], 'Key Gen Error');
    end
end

function generateNonce(nEdit, fig)
    % Generate random nonce: uint8(randi([0 255], 1, 8))
    nonce = uint8(randi([0 255], 1, 8));
    % Display as space-separated values
    nEdit.Value = num2str(nonce);
end

function processText(inArea, outArea, methodDD, sEdit, kEdit, nEdit, aDD, mode, fig)
    text = inArea.Value;
    if isempty(text)
        uialert(fig, 'Please enter text or upload a file.', 'Input Error');
        return; 
    end
    if iscell(text)
        text = strjoin(text, newline);
    end

    method = methodDD.Value;
        
    try
        result = '';
        if strcmp(method, 'Caesar')
            shiftStr = sEdit.Value;
            shift = str2double(shiftStr);
            if isnan(shift)
                error('Please enter a valid numeric shift value.');
            end
            result = caeser(text, shift, mode);
        elseif strcmp(method, 'One-Time Pad')
            key = kEdit.Value;
            if isempty(key)
                 error('Please enter a key for One-Time Pad.');
            end
            result = oneTimePad(text, key, mode);
        elseif strcmp(method, 'XOR - Bitwise stream cipher')
            key = kEdit.Value;
            nonceStr = nEdit.Value;
            if isempty(key)
                 error('Please enter a key for XOR bitwise stream cipher.');
            end
            if isempty(nonceStr)
                 error('Please enter a nonce for XOR bitwise stream cipher.');
            end

            % Pre-processing for XOR Decrypt (Hex String -> Bytes)
            if strcmpi(mode, 'decrypt')
                 try
                     % Remove spaces if any
                     clean_text = strrep(text, ' ', '');
                     % Convert Hex string to uint8 array
                     text = uint8(hex2dec(reshape(clean_text, 2, [])')');
                 catch
                     error('Input for decryption must be a valid Hex string.');
                 end
            end

            % XOR Cipher Output is uint8
            out_uint8 = xorCipher(text, key, nonceStr, mode);

            % Handle display
            if strcmpi(mode, 'encrypt')
                % Convert uint8 array to Hex String for display
                result = lower(reshape(dec2hex(out_uint8)', 1, []));
            else
                % Decrypt: xorCipher result is plaintext bytes
                % Convert back to char
                result = char(out_uint8);
            end
        elseif strcmp(method, 'AES block cipher')
            key = kEdit.Value;
            if isempty(key)
                error('Please enter a 64-character Hex key for AES.');
            end
            if length(key) ~= 64
                 error('AES-256 key must be exactly 64 hex characters.');
            end
            
            if strcmpi(mode, 'decrypt')
                result = aesBlockCipher(text, key, mode);
                try
                    str_result = char(hex2dec(reshape(result, 2, [])')');
                    result = strtrim(str_result); 
                catch
                    error('Decryption successful but failed to convert Hex to String. Ensure ciphertext is valid Hex.');
                end
            else
                result = aesBlockCipher(text, key, mode);
            end
        elseif strcmp(method, 'DES block cipher')
            key = getappdata(fig, 'DESKey');
            if isempty(key)
                error('No DES key found. Please click "Update Key Matrix" first.');
            end
            result = desBlockCipher(text, key, mode);
        elseif strcmp(method, 'Keyed Hash')
            key = kEdit.Value;
            if isempty(key)
                error('Please enter a key for HMAC.');
            end
            
            algo = aDD.Value;
            result = HMAC(key, text, algo);
        end
        outArea.Value = result;
    catch ME
        uialert(fig, ME.message, 'Processing Error');
    end
end