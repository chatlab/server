const WebSocket = require('ws');
const ws = new WebSocket('ws://localhost:4444');

ws.on('open', () => {

    const message = {
        event: 'join_room',
        room_id: 'test123',
    }

    ws.on('message', message => {
        console.log('Received message: ', message);
    });

    ws.on('pong', (message) => {
        console.log('PONG!', message.toString());
    });

    ws.on('send_ping', (message) => {
        console.log('send_ping!', message.toString());
    });
});
