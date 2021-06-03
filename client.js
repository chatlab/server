const WebSocket = require('ws');

ws = new WebSocket('ws://localhost:4333');
ws.on('open', () => {

    const message = {
        event: 'join_room',
        room_id: 'test123',
    }
    ws.send(message)

    ws.on('message', message => {
        console.log('Received message: ', message);
    });
});
