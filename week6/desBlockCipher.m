function result = desBlockCipher(text, key, mode)
    if strcmpi(mode, 'encrypt')
        result = DES(text, key, 'ENC');
    elseif strcmpi(mode, 'decrypt')
        result = DES(text, key, 'DEC');
    else
        error('Invalid mode. Use "encrypt" or "decrypt".');
    end
end