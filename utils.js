module.exports = {

    writeResponse: function (res, data) {
        data = data.toString();
        res.writeHead(200, { 'Content-Type': 'text/html', 'Content-Length': data.length });
        res.write(data);
        res.end();
    },

    writeError: function (res, data) {
        data = data.toString();
        res.writeHead(500, { 'Content-Type': 'text/html', 'Content-Length': data.length });
        res.write(data);
        res.end();
    },

    writeStatus: function (res, statusCode, data) {
        data = data.toString();
        res.writeHead(statusCode, { 'Content-Type': 'text/html', 'Content-Length': Buffer.byteLength(data) });
        res.write(data);
        res.end();
    },

    // Reads a positive integer setting, falling back to the default when the
    // configured value is missing or not a usable positive integer.
    positiveIntSetting: function (value, defaultValue) {
        var parsed = Number(value);
        if (Number.isSafeInteger(parsed) && parsed > 0) {
            return parsed;
        }
        return defaultValue;
    },

    // Returns the requested record count, or null when the body is not a
    // non-negative integer within the allowed range.
    parseEntryCount: function (body, maxEntries) {
        var trimmed = String(body === undefined || body === null ? "" : body).trim();
        if (!/^\d+$/.test(trimmed)) {
            return null;
        }
        var entries = Number(trimmed);
        if (!Number.isSafeInteger(entries) || entries > maxEntries) {
            return null;
        }
        return entries;
    }
}