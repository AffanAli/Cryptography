clc; clear;

plaintext = "I am affan Ali";
shift = 3;

% Caesar Cipher Test
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
fprintf('          Caesar              \n');
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
encryptedText_caesar = caeser(plaintext, shift, 'encrypt');
decryptedText_caesar = caeser(encryptedText_caesar, shift, 'decrypt');

fprintf('Original Text : %s\n', plaintext);
fprintf('Encrypted Text: %s\n', encryptedText_caesar);
fprintf('Decrypted Text: %s\n', decryptedText_caesar);
fprintf('\n');

% One Time Pad Test
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
fprintf('       One Time Pad           \n');
fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');

% Key generation handles string/char input length correctly now
key = char(randi([65, 90], 1, strlength(plaintext)));

encryptedText_otp = onetimepad(plaintext, key, 'encrypt');
decryptedText_otp = onetimepad(encryptedText_otp, key, 'decrypt');

fprintf('Original Text : %s\n', plaintext);
fprintf('Key           : %s\n', key);
fprintf('Encrypted Text: %s\n', encryptedText_otp);
fprintf('Decrypted Text: %s\n', decryptedText_otp);
fprintf('\n');
