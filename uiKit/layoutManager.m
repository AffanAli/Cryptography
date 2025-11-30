function handles = layoutManager(fig)
    % LayoutManager: Creates all UI components for CryptoApp
    % Returns a struct 'handles' containing references to all UI elements.

    % Grid Layout
    gl = uigridlayout(fig, [7, 4]); 
    gl.RowHeight = {40, 40, 30, 30, 150, 40, 150}; 
    gl.ColumnWidth = {100, '1x', '1x', 160}; 
    
    handles.gl = gl;

    % --- Row 1: File Upload ---
    handles.uploadBtn = uibutton(gl, 'Text', 'Upload File');
    handles.uploadBtn.Layout.Row = 1;
    handles.uploadBtn.Layout.Column = 1;
    handles.uploadBtn.BackgroundColor = [0.30, 0.50, 0.90]; 
    handles.uploadBtn.FontColor = [1 1 1];
    handles.uploadBtn.FontWeight = 'bold';
    
    handles.fileNameLabel = uilabel(gl);
    handles.fileNameLabel.Text = 'No file selected';
    handles.fileNameLabel.Layout.Row = 1;
    handles.fileNameLabel.Layout.Column = [2 4];

    % --- Row 2: Method Selection ---
    handles.methodLabel = uilabel(gl);
    handles.methodLabel.Text = 'Method:';
    handles.methodLabel.Layout.Row = 2;
    handles.methodLabel.Layout.Column = 1;
    handles.methodLabel.HorizontalAlignment = 'right';

    handles.methodDropdown = uidropdown(gl);
    handles.methodDropdown.Items = {'Caesar', 'One-Time Pad', 'XOR - Bitwise stream cipher', 'DES block cipher', 'AES block cipher', 'Keyed Hash', 'RSA', 'Envelope Encryption (KMS)'};
    handles.methodDropdown.Layout.Row = 2;
    handles.methodDropdown.Layout.Column = [2 4];

    % --- Row 3: Parameters (Shift / Key / P&Q / IV) ---
    
    % Shift (Caesar)
    handles.shiftLabel = uilabel(gl);
    handles.shiftLabel.Text = 'Shift:';
    handles.shiftLabel.Layout.Row = 3;
    handles.shiftLabel.Layout.Column = 1;
    handles.shiftLabel.HorizontalAlignment = 'right';
    
    handles.shiftEdit = uieditfield(gl, 'text');
    handles.shiftEdit.Layout.Row = 3;
    handles.shiftEdit.Layout.Column = [2 4]; 
    handles.shiftEdit.Placeholder = 'Enter shift amount';

    % Key (Generic)
    handles.keyLabel = uilabel(gl);
    handles.keyLabel.Text = 'Key:';
    handles.keyLabel.Layout.Row = 3;
    handles.keyLabel.Layout.Column = 1;
    handles.keyLabel.HorizontalAlignment = 'right';
    handles.keyLabel.Visible = 'off';

    handles.keyEdit = uieditfield(gl, 'text');
    handles.keyEdit.Layout.Row = 3;
    handles.keyEdit.Layout.Column = [2 3]; 
    handles.keyEdit.Visible = 'off';
    handles.keyEdit.Placeholder = 'Enter key...';

    % Key Generation Buttons Container
    handles.keyBtnGrid = uigridlayout(gl, [1, 2]); 
    handles.keyBtnGrid.Layout.Row = 3;
    handles.keyBtnGrid.Layout.Column = 4;
    handles.keyBtnGrid.Padding = [0 0 0 0];
    handles.keyBtnGrid.ColumnSpacing = 2;
    handles.keyBtnGrid.Visible = 'off'; 

    handles.genKeyBtn = uibutton(handles.keyBtnGrid, 'Text', 'Gen');
    handles.genKeyBtn.Visible = 'off';
    handles.genKeyBtn.BackgroundColor = [0.5, 0.5, 0.5];
    handles.genKeyBtn.FontColor = [1 1 1];
    handles.genKeyBtn.FontWeight = 'bold';

    handles.genDHBtn = uibutton(handles.keyBtnGrid, 'Text', 'DH');
    handles.genDHBtn.Visible = 'off';
    handles.genDHBtn.BackgroundColor = [0.6, 0.4, 0.8]; 
    handles.genDHBtn.FontColor = [1 1 1];
    handles.genDHBtn.FontWeight = 'bold';
    
    % RSA Inputs (P & Q)
    handles.rsaPLabel = uilabel(gl);
    handles.rsaPLabel.Text = 'Prime p:';
    handles.rsaPLabel.Layout.Row = 3;
    handles.rsaPLabel.Layout.Column = 1;
    handles.rsaPLabel.HorizontalAlignment = 'right';
    handles.rsaPLabel.Visible = 'off';
    
    handles.rsaPEdit = uieditfield(gl, 'numeric');
    handles.rsaPEdit.Layout.Row = 3;
    handles.rsaPEdit.Layout.Column = 2; 
    handles.rsaPEdit.Visible = 'off';
    
    handles.rsaQLabel = uilabel(gl);
    handles.rsaQLabel.Text = 'Prime q:';
    handles.rsaQLabel.Layout.Row = 3;
    handles.rsaQLabel.Layout.Column = 3;
    handles.rsaQLabel.HorizontalAlignment = 'right';
    handles.rsaQLabel.Visible = 'off';
    
    handles.rsaQEdit = uieditfield(gl, 'numeric');
    handles.rsaQEdit.Layout.Row = 3;
    handles.rsaQEdit.Layout.Column = 4; 
    handles.rsaQEdit.Visible = 'off';

    % Envelope Inputs (IV)
    handles.envIVLabel = uilabel(gl);
    handles.envIVLabel.Text = 'IV (Hex):';
    handles.envIVLabel.Layout.Row = 3;
    handles.envIVLabel.Layout.Column = 1;
    handles.envIVLabel.HorizontalAlignment = 'right';
    handles.envIVLabel.Visible = 'off';
    
    handles.envIVEdit = uieditfield(gl, 'text');
    handles.envIVEdit.Layout.Row = 3;
    handles.envIVEdit.Layout.Column = [2 3];
    handles.envIVEdit.Visible = 'off';
    handles.envIVEdit.Placeholder = 'Enter IV (12 bytes hex) or leave empty for random';
    
    handles.envGenIVBtn = uibutton(gl, 'Text', 'Gen IV');
    handles.envGenIVBtn.Layout.Row = 3;
    handles.envGenIVBtn.Layout.Column = 4;
    handles.envGenIVBtn.Visible = 'off';
    handles.envGenIVBtn.BackgroundColor = [0.5, 0.5, 0.5];
    handles.envGenIVBtn.FontColor = [1 1 1];
    handles.envGenIVBtn.FontWeight = 'bold';

    % --- Row 4: Algo / Nonce / AAD ---

    % Algo Dropdown (Keyed Hash)
    handles.algoLabel = uilabel(gl);
    handles.algoLabel.Text = 'Algorithm:';
    handles.algoLabel.Layout.Row = 4;
    handles.algoLabel.Layout.Column = 1;
    handles.algoLabel.HorizontalAlignment = 'right';
    handles.algoLabel.Visible = 'off';

    handles.algoDropdown = uidropdown(gl);
    handles.algoDropdown.Items = {'SHA-1', 'SHA-384', 'SHA-512'};
    handles.algoDropdown.Layout.Row = 4;
    handles.algoDropdown.Layout.Column = [2 3];
    handles.algoDropdown.Visible = 'off';

    % Nonce (XOR)
    handles.nonceLabel = uilabel(gl);
    handles.nonceLabel.Text = 'Nonce:';
    handles.nonceLabel.Layout.Row = 4;
    handles.nonceLabel.Layout.Column = 1;
    handles.nonceLabel.HorizontalAlignment = 'right';
    handles.nonceLabel.Visible = 'off';

    handles.nonceEdit = uieditfield(gl, 'text');
    handles.nonceEdit.Layout.Row = 4;
    handles.nonceEdit.Layout.Column = [2 3]; 
    handles.nonceEdit.Visible = 'off';
    handles.nonceEdit.Placeholder = 'Enter nonce (space separated uint8)...';

    handles.genNonceBtn = uibutton(gl, 'Text', 'Gen Nonce');
    handles.genNonceBtn.Layout.Row = 4;
    handles.genNonceBtn.Layout.Column = 4;
    handles.genNonceBtn.Visible = 'off';
    handles.genNonceBtn.BackgroundColor = [0.5, 0.5, 0.5]; 
    handles.genNonceBtn.FontColor = [1 1 1];
    handles.genNonceBtn.FontWeight = 'bold';
    
    % AAD (Envelope)
    handles.envAADLabel = uilabel(gl);
    handles.envAADLabel.Text = 'AAD:';
    handles.envAADLabel.Layout.Row = 4;
    handles.envAADLabel.Layout.Column = 1;
    handles.envAADLabel.HorizontalAlignment = 'right';
    handles.envAADLabel.Visible = 'off';
    
    handles.envAADEdit = uieditfield(gl, 'text');
    handles.envAADEdit.Layout.Row = 4;
    handles.envAADEdit.Layout.Column = [2 4];
    handles.envAADEdit.Visible = 'off';
    handles.envAADEdit.Placeholder = 'Additional Authenticated Data (Optional)';

    % --- Row 5: Input Text ---
    handles.inputTextLabel = uilabel(gl);
    handles.inputTextLabel.Text = 'Text:'; 
    handles.inputTextLabel.Layout.Row = 5;
    handles.inputTextLabel.Layout.Column = 1;
    handles.inputTextLabel.VerticalAlignment = 'top';
    handles.inputTextLabel.HorizontalAlignment = 'right'; 

    handles.inputTextArea = uitextarea(gl);
    handles.inputTextArea.Layout.Row = 5;
    handles.inputTextArea.Layout.Column = [2 4];
    handles.inputTextArea.Editable = 'on'; 
    handles.inputTextArea.Placeholder = 'Enter text here or upload a file...';

    % --- Row 6: Actions ---
    handles.encryptBtn = uibutton(gl, 'Text', 'Encrypt');
    handles.encryptBtn.Layout.Row = 6;
    handles.encryptBtn.Layout.Column = 2; 
    handles.encryptBtn.BackgroundColor = [0.39, 0.83, 0.07]; 
    handles.encryptBtn.FontColor = [1 1 1];
    handles.encryptBtn.FontWeight = 'bold';
    
    handles.decryptBtn = uibutton(gl, 'Text', 'Decrypt');
    handles.decryptBtn.Layout.Row = 6;
    handles.decryptBtn.Layout.Column = 3;
    handles.decryptBtn.BackgroundColor = [0.85, 0.33, 0.10]; 
    handles.decryptBtn.FontColor = [1 1 1];
    handles.decryptBtn.FontWeight = 'bold';

    % --- Row 7: Output Text ---
    handles.outputTextLabel = uilabel(gl);
    handles.outputTextLabel.Text = 'Output:';
    handles.outputTextLabel.Layout.Row = 7;
    handles.outputTextLabel.Layout.Column = 1;
    handles.outputTextLabel.VerticalAlignment = 'top';
    handles.outputTextLabel.HorizontalAlignment = 'right'; 

    handles.outputTextArea = uitextarea(gl);
    handles.outputTextArea.Layout.Row = 7;
    handles.outputTextArea.Layout.Column = [2 4];
    handles.outputTextArea.Editable = 'off';
end