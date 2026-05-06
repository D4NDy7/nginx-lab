const WebSocket = require('ws');
const wss = new WebSocket.Server({ port: 8765 });

wss.on('connection', (ws, req) => {
    const clientIp = req.socket.remoteAddress;
    console.log(`[WS] Client connected: ${clientIp}`);

    ws.send(JSON.stringify({ type: 'welcome', message: 'Connected to WS server' }));

    ws.on('message', (data) => {
        console.log(`[WS] Received: ${data}`);
        ws.send(JSON.stringify({
            type: 'echo',
            original: data.toString(),
            timestamp: new Date().toISOString()
        }));
    });

    ws.on('close', () => console.log('[WS] Client disconnected'));
});

console.log('[WS] Server listening on :8765');
