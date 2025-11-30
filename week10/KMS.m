classdef KMS
    % Mini KMS: versions + AES Key Wrap 
    methods(Static)
        function kms = init()
            % Single latest KEK for backwards compatibility.
            kms.KEK = [];
            
            % Versioning metadata: multiple KEK versions.
            kms.versionCounter = 0;
            kms.keks = struct( ...
                'version', {}, ...
                'key', {}, ...
                'enabled', {}, ...
                'createdAt', {}, ...
                'wrapCount', {}, ...
                'unwrapCount', {});

            % Audit log for rotate / wrap / unwrap / disable.
            kms.auditLog = struct( ...
                'timestamp', {}, ...
                'operation', {}, ...
                'version', {}, ...
                'details', {});
        end

        function [kms] = rotate(kms)
            % Create a new KEK version and mark it as enabled.
            ver = kms.versionCounter + 1;
            kms.versionCounter = ver;

            newKey = uint8(randi([0,255],[1,32]));
            kms.KEK = newKey; % keep latest for older code

            newKek.version     = ver;
            newKek.key         = newKey;
            newKek.enabled     = true;
            newKek.createdAt   = datetime('now');
            newKek.wrapCount   = 0;
            newKek.unwrapCount = 0;

            kms.keks(end+1) = newKek; %#ok<AGROW>

            kms = KMS.append_audit_log(kms, 'rotate', ver, 'Created new KEK version');
        end

        function kms = disable(kms, ver)
            % Disable a specific KEK version so it is not used for wrapping.
            if isempty(kms.keks)
                warning('KMS:disable', 'No KEKs to disable.');
                return;
            end

            allVersions = [kms.keks.version];
            idx = find(allVersions == ver, 1, 'last');

            if isempty(idx)
                warning('KMS:disable', 'KEK version %d not found.', ver);
                return;
            end

            kms.keks(idx).enabled = false;

            if isequal(kms.KEK, kms.keks(idx).key)
                kms.KEK = [];
            end

            msg = sprintf('Disabled KEK version %d', ver);
            kms = KMS.append_audit_log(kms, 'disable', ver, msg);
        end

        function [wrappedDEK, kms] = wrap(kms, DEK)
            % Wrap DEK using latest enabled KEK version.
            idx = KMS.select_latest_enabled_kek_index(kms);

            KEK = kms.keks(idx).key;
            kms.KEK = KEK; % keep in sync

            wrappedDEK = KMS.aes_key_wrap(DEK, KEK);

            kms.keks(idx).wrapCount = kms.keks(idx).wrapCount + 1;

            ver = kms.keks(idx).version;
            msg = sprintf('Wrapped %d-byte DEK with KEK v%d', numel(DEK), ver);
            kms = KMS.append_audit_log(kms, 'wrap', ver, msg);
        end

        function [DEK, kms] = unwrap(kms, wrappedDEK, varargin)
            % Unwrap DEK using a KEK version.
            % If version is omitted, the latest enabled KEK is used.
            if ~isempty(varargin)
                ver = varargin{1};

                allVersions = [kms.keks.version];
                idx = find(allVersions == ver, 1, 'last');

                if isempty(idx)
                    error('KMS:unwrap', 'Requested KEK version %d not found.', ver);
                end
            else
                idx = KMS.select_latest_enabled_kek_index(kms);
                ver = kms.keks(idx).version;
            end

            KEK = kms.keks(idx).key;
            kms.KEK = KEK;

            DEK = KMS.aes_key_unwrap(wrappedDEK, KEK);

            kms.keks(idx).unwrapCount = kms.keks(idx).unwrapCount + 1;

            msg = sprintf('Unwrapped DEK with KEK v%d', ver);
            kms = KMS.append_audit_log(kms, 'unwrap', ver, msg);
        end
    end


    methods(Static, Access=private)
        function idx = select_latest_enabled_kek_index(kms)
            % Return index of latest enabled KEK in kms.keks.
            if isempty(kms.keks)
                error('KMS:wrap', 'No KEKs available. Please rotate first.');
            end

            enabledMask = [kms.keks.enabled];
            if ~any(enabledMask)
                error('KMS:wrap', 'No enabled KEKs available.');
            end

            enabledKeks     = kms.keks(enabledMask);
            enabledVersions = [enabledKeks.version];
            latestVer       = max(enabledVersions);

            allVersions = [kms.keks.version];
            idx = find(allVersions == latestVer, 1, 'last');
        end

        function kms = append_audit_log(kms, operation, ver, details)
            % Append a single audit log entry.
            entry.timestamp = datetime('now');
            entry.operation = string(operation);
            entry.version   = ver;
            entry.details   = string(details);

            kms.auditLog(end+1) = entry; %#ok<AGROW>
        end
    
        % ---------- AES Key Wrap ----------
        function C = aes_key_wrap(P, KEK)
            P = uint8(P(:).'); KEK = uint8(KEK(:).');
            if mod(numel(P),8)~=0 || numel(P)<16
                error('AES-KW: P must be multiple of 8 and >=16 bytes.');
            end
            n = numel(P)/8;
            R = reshape(P,8,[]).';
            A = uint8(repmat(hex2dec('A6'),1,8)); % 64-bit IV

            for j=0:5
                for i=1:n
                    B = KMS.aes_encrypt_block([A R(i,:)], KEK);
                    T = uint64(n*j + i);
                    A = KMS.msb64_xor(B(1:8), T);
                    R(i,:) = B(9:16);
                end
            end
            C = [A reshape(R.',1,[])];
        end

        function P = aes_key_unwrap(C, KEK)
            C = uint8(C(:).'); KEK = uint8(KEK(:).');
            
            n = numel(C)/8 - 1;
            A = C(1:8);
            R = reshape(C(9:end),8,[]).';

            for j=5:-1:0
                for i=n:-1:1
                    T = uint64(n*j + i);
                    B = KMS.aes_decrypt_block([KMS.msb64_xor(A,T) R(i,:)], KEK);
                    A = B(1:8);
                    R(i,:) = B(9:16);
                end
            end
            IV = uint8(repmat(hex2dec('A6'),1,8));
            if ~isequal(A, IV), 
                error('AES-KW integrity check failed'); 
            end
            P = reshape(R.',1,[]);
        end

        % --- AES block adapters to David Hill's AES (hex-in/hex-out) ---
        function out = aes_encrypt_block(P, K)
            out_hex = Cipher(KMS.bytes_to_hex(K), KMS.bytes_to_hex(P));
            out     = KMS.hex_to_bytes(out_hex);
        end
        function out = aes_decrypt_block(C, K)
            out_hex = InvCipher(KMS.bytes_to_hex(K), KMS.bytes_to_hex(C));
            out     = KMS.hex_to_bytes(out_hex);
        end

        % ------------------- small helpers -------------------
        function out = msb64_xor(A, T)
            out = KMS.to_be64(bitxor(KMS.from_be64(A), T));
        end
        function u64 = from_be64(b)
            u64 = uint64(0);
            for i=1:8, u64 = bitor(bitshift(u64,8), uint64(b(i))); end
        end
        function b = to_be64(u64)
            b = zeros(1,8,'uint8');
            for i=0:7, b(8-i)=uint8(bitand(bitshift(u64,-(8*i)),255)); end
        end
        function hex = bytes_to_hex(u8)
            hex = reshape(dec2hex(u8).',1,[]);
        end
        function u8  = hex_to_bytes(hex)
            hex = lower(hex(:).'); u8 = uint8(sscanf(hex,'%2x').');
        end
    end
end
