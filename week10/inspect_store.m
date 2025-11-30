load('kms_store.mat', 'kms');

for i = 1:numel(kms.auditLog)
    e = kms.auditLog(i);
    fprintf('%s | op=%s | v=%d | %s\n', ...
        datestr(e.timestamp, 'yyyy-mm-dd HH:MM:SS'), ...
        e.operation, e.version, e.details);
end