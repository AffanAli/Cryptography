clc; clear; close all;

% Reads your text file (plaintext.txt).
% Converts each character into ASCII.
% Uses your existing crypt function with public key (Pk, e) to encrypt each character.
% Saves ciphertext as integers into ciphertext.txt.
% Reads ciphertext and decrypts each number using (Pk, d).
% Converts decrypted ASCII back into readable text.

disp('RSA Encryption/Decryption for Text File');

% Initialize RSA keys
p = input('Enter prime p: ');
q = input('Enter prime q: ');

[Pk, Phi, d, e] = intialize(p,q);

% Read plaintext file
filename = 'readme.txt';
fid = fopen(filename,'r');
plaintext = fread(fid, '*char')';
fclose(fid);

disp('Original Text:');
disp(plaintext);

% Convert text to ASCII
M = double(plaintext);
disp('file encrypted');

% Encrypt each character
cipher = zeros(size(M));

for j = 1:length(M)
    cipher(j) = crypt(M(j), Pk, e);
end

% Save cipher text to file
fid = fopen('cipher_text.txt','w');
fprintf(fid,'%d\n', cipher);
fclose(fid);

disp('Encryption complete. cipher text saved to cipher text.txt');

% Decrypt each character
decrypted = zeros(size(cipher));

for j = 1:length(cipher)
    decrypted(j) = crypt(cipher(j), Pk, d);
end

% Convert back to characters
decrypted_text = char(decrypted);

disp('Decrypted ASCII Codes:');
disp(decrypted);
disp('Decrypted Text:');
disp(decrypted_text);
