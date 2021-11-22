import { io } from 'socket.io-client'

let socket = io('http://localhost:5000/messages')

socket.on('sendToClient', (message) => {
  console.log(message)
})

socket.on('connected', console.log)

socket.emit('sendToServer', {
  hallo: "hallo"
})

