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
    
    handles.encryptBtn.Text = 'Encrypt';
    handles.decryptBtn.Visible = 'on'; 

    handles.gl.RowHeight{3} = 30; 
    handles.gl.RowHeight{4} = 0; 

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
        case 'AES block cipher'
            handles.keyLabel.Visible = 'on';
            handles.keyEdit.Visible = 'on';
            handles.keyBtnGrid.Visible = 'on';
            handles.genKeyBtn.Visible = 'on';
            handles.genKeyBtn.Text = 'Gen AES-256';
        case 'DES block cipher'
            handles.keyLabel.Visible = 'on'; 
            handles.keyEdit.Visible = 'on'; 
            handles.keyEdit.Editable = 'off'; 
            handles.keyBtnGrid.Visible = 'on';
            handles.genKeyBtn.Visible = 'on';
            handles.genKeyBtn.Text = 'Update Key Matrix';
            handles.gl.RowHeight{3} = 150; 
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