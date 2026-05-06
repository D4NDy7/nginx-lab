import asyncio, json, socket, websockets

async def test_websocket():
    uri = "ws://ws.localhost/ws"
    sock = socket.create_connection(("127.0.0.1", 80))
    async with websockets.connect(uri, sock=sock) as ws:
        welcome = await ws.recv()
        print(f"Welcome: {json.loads(welcome)}")

        await ws.send('Hello, NGINX!')
        echo = await ws.recv()
        data = json.loads(echo)
        print(f"Echo received: {data['original']} at {data['timestamp']}")

        assert data['type'] == 'echo'
        print('✅ WebSocket proxy works correctly!')

asyncio.run(test_websocket())
