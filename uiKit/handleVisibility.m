function handleVisibility(handles)
    method = handles.methodDropdown.Value;
    
    % Default: Hide All
    handles.shiftLabel.Visible = 'off'; handles.shiftEdit.Visible = 'off';
    handles.keyLabel.Visible = 'off'; handles.keyEdit.Visible = 'off'; 
    handles.keyBtnGrid.Visible = 'off'; handles.genKeyBtn.Visible = 'off'; handles.genDHBtn.Visible = 'off';
    
    handles.nonceLabel.Visible = 'off'; handles.nonceEdit.Visible = 'off'; handles.genNonceBtn.Visible = 'off';
    handles.algoLabel.Visible = 'off'; handles.algoDropdown.Visible = 'off';
    
    handles.rsaPLabel.Visible = 'off'; handles.rsaPEdit.Visible = 'off';
    handles.rsaQLabel.Visible = 'off'; handles.rsaQEdit.Visible = 'off';
    
    handles.envIVLabel.Visible = 'off'; handles.envIVEdit.Visible = 'off'; handles.envGenIVBtn.Visible = 'off';
    handles.envAADLabel.Visible = 'off'; handles.envAADEdit.Visible = 'off';
    
    % Reset all parameter and output fields when method changes
    handles.keyEdit.Value = '';
    handles.nonceEdit.Value = '';
    handles.envIVEdit.Value = '';
    handles.envAADEdit.Value = '';
    
    % For numeric fields, use 0 (within default Limits) as a cleared sentinel
    handles.rsaPEdit.Value = 0;
    handles.rsaQEdit.Value = 0;
    
    handles.outputTextArea.Value = '';
    
    handles.encryptBtn.Text = 'Encrypt';
    handles.decryptBtn.Visible = 'on'; 

    handles.gl.RowHeight{3} = 30; 
    handles.gl.RowHeight{4} = 0; 

    % Reset key button grid column widths (overridden for specific methods)
    handles.keyBtnGrid.ColumnWidth = {60, 60};

    handles.keyEdit.Editable = 'on'; 

    switch method
        case 'Caesar'
            handles.shiftLabel.Visible = 'on';
            handles.shiftEdit.Visible = 'on';
        case 'One-Time Pad'
            handles.keyLabel.Visible = 'on';
            handles.keyEdit.Visible = 'on';
            handles.keyBtnGrid.Visible = 'on';
            handles.genKeyBtn.Visible = 'on';
            handles.genKeyBtn.Text = 'Generate';
            
            % Make the Generate Key button take the full available width
            handles.keyBtnGrid.ColumnWidth = {'1x', 0};
        case 'XOR - Bitwise stream cipher'
            handles.keyLabel.Visible = 'on';
            handles.keyEdit.Visible = 'on';
            handles.keyBtnGrid.Visible = 'on';
            handles.genKeyBtn.Visible = 'on';
            handles.genKeyBtn.Text = 'Gen Key';
            
            handles.nonceLabel.Visible = 'on';
            handles.nonceEdit.Visible = 'on';
            handles.genNonceBtn.Visible = 'on';
            handles.gl.RowHeight{4} = 30; 

            % Make the Generate Key button take the full available width
            handles.keyBtnGrid.ColumnWidth = {'1x', 0};
        case 'AES block cipher'
            handles.keyLabel.Visible = 'on';
            handles.keyEdit.Visible = 'on';
            handles.keyBtnGrid.Visible = 'on';
            handles.genKeyBtn.Visible = 'on';
            handles.genKeyBtn.Text = 'Gen AES-256';
            
            % Make the Generate Key button take the full available width
            handles.keyBtnGrid.ColumnWidth = {'1x', 0};
        case 'DES block cipher'
            handles.keyLabel.Visible = 'on'; 
            handles.keyEdit.Visible = 'on'; 
            handles.keyEdit.Editable = 'off'; 
            handles.keyBtnGrid.Visible = 'on';
            handles.genKeyBtn.Visible = 'on';
            handles.genKeyBtn.Text = 'Update Key Matrix';

            % Make the Generate Key button take the full available width
            handles.keyBtnGrid.ColumnWidth = {'1x', 0};
        case 'Keyed Hash'
            handles.keyLabel.Visible = 'on';
            handles.keyEdit.Visible = 'on';
            handles.keyBtnGrid.Visible = 'on';
            handles.genKeyBtn.Visible = 'on';
            handles.genKeyBtn.Text = 'Gen Key';
            handles.genDHBtn.Visible = 'on';
            
            handles.algoLabel.Visible = 'on';
            handles.algoDropdown.Visible = 'on';
            handles.gl.RowHeight{4} = 30; 

            handles.encryptBtn.Text = 'Generate Hash';
            handles.decryptBtn.Visible = 'off'; 
        case 'RSA'
            handles.rsaPLabel.Visible = 'on';
            handles.rsaPEdit.Visible = 'on';
            handles.rsaQLabel.Visible = 'on';
            handles.rsaQEdit.Visible = 'on';
        case 'Envelope Encryption (KMS)'
            handles.envIVLabel.Visible = 'on';
            handles.envIVEdit.Visible = 'on';
            handles.envGenIVBtn.Visible = 'on';
            
            handles.envAADLabel.Visible = 'on';
            handles.envAADEdit.Visible = 'on';
            
            handles.gl.RowHeight{4} = 30; 
    end
end