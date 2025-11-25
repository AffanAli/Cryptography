function result = caeser(text, shift, mode)
    % Ensure input is character array
    text = char(text);

    if strcmpi(mode, 'encrypt')
        result = encrypt(text, shift);
    elseif strcmpi(mode, 'decrypt')
        result = decrypt(text, shift);
    else
        error('Invalid mode. Use "encrypt" or "decrypt".');
    end
end

function encryptedText = encrypt(text, shift)
    encryptedText = '';
    for i = 1:length(text)
        ch = text(i);
        if isletter(ch)
            if isstrprop(ch, 'upper')
                encryptedText = [encryptedText, char(mod(double(ch) - double('A') + shift, 26) + double('A'))];
            else
                encryptedText = [encryptedText, char(mod(double(ch) - double('a') + shift, 26) + double('a'))];
            end
        else
            encryptedText = [encryptedText, ch];
        end
    end
end

function decryptedText = decrypt(text, shift)
    decryptedText = '';
    for i = 1:length(text)
        ch = text(i);
        if isletter(ch)
            if isstrprop(ch, 'upper')
                decryptedText = [decryptedText, char(mod(double(ch) - double('A') - shift, 26) + double('A'))];
            else
                decryptedText = [decryptedText, char(mod(double(ch) - double('a') - shift, 26) + double('a'))];
            end
        else
            decryptedText = [decryptedText, ch];
        end
    end
end
