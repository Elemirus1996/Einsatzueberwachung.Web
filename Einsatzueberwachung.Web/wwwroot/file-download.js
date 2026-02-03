// File Download Helper für Excel Export/Import
// Diese Funktion ermöglicht den Download von Byte-Arrays als Dateien

window.downloadFileFromByteArray = function (fileName, byteArray, mimeType) {
    // Konvertiere Byte-Array zu Blob
    const blob = new Blob([new Uint8Array(byteArray)], { type: mimeType });
    
    // Erstelle einen temporären Download-Link
    const url = window.URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = fileName;
    
    // Füge Link zum DOM hinzu, klicke darauf und entferne ihn wieder
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    // Aufräumen
    window.URL.revokeObjectURL(url);
};
