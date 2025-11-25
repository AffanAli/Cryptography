clc; clear;

% User inputs
key = 'SECRET123';
% message = 'This is a test message';
method = 'SHA-256';   % Or SHA-1 / SHA-384 / SHA-512

% Select & read content from text file
filename = 'test_message.txt';
fid = fopen(filename, 'rb');
file_data = fread(fid, '*uint8')';
fclose(fid);

file_text = char(file_data);

disp('file content')
disp(file_text)

% Call HMAC function
hash_value = HMAC(key, file_text, method);

% Display result
disp(['HMAC Output (Hex):', hash_value]);

% Show verification test
% Simulating receiver side
received_hash = HMAC(key, file_text, method);

if strcmpi(hash_value, received_hash)
    disp('SUCCESS: Message authenticated correctly');
else
    disp('ERROR: Message integrity verification failed.');
end
