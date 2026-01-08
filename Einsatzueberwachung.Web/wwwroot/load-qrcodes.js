// QR Code Loader - API Calls without HttpClient dependency
window.QRCodeLoader = {
    async loadQRCodes(dotnetRef) {
        try {
            // Lade QR-Codes
            const qrcodeResponse = await fetch('api/network/qrcodes');
            if (!qrcodeResponse.ok) {
                throw new Error(`HTTP error! status: ${qrcodeResponse.status}`);
            }
            const qrcodes = await qrcodeResponse.json();

            // Lade Network Info
            const infoResponse = await fetch('api/network/info');
            const info = infoResponse.ok ? await infoResponse.json() : { HostName: 'Unbekannt' };

            // Callback zu Blazor
            if (dotnetRef) {
                await dotnetRef.invokeMethodAsync('SetQRCodes', qrcodes, info.HostName);
            }
            return { qrcodes, info };
        } catch (error) {
            console.error('QR Code Loading Error:', error);
            if (dotnetRef) {
                await dotnetRef.invokeMethodAsync('SetError', error.message);
            }
            throw error;
        }
    }
};
