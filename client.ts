import { io } from 'socket.io-client'
import * as aes256 from 'aes256'
import * as RandomString from 'randomstring'
import * as crypto from 'crypto'

let socket = io('http://localhost:5000/messages')

function encryptRSA(text, publicKey) {
  return crypto.publicEncrypt(
    {
      key: publicKey,
      padding: crypto.constants.RSA_PKCS1_OAEP_PADDING,
      oaepHash: 'sha256',
    },
    Buffer.from(text, 'ascii'),
  )
}

function decryptRSA(text, privateKey) {
  return crypto.privateDecrypt(
    {
      key: privateKey,
      padding: crypto.constants.RSA_PKCS1_OAEP_PADDING,
      oaepHash: 'sha256',
    },
    Buffer.from(text, 'hex'),
  )
}

socket.on('connect', () => {
  socket.on('PUBLIC_KEY', (publicKey) => {
    const secureKey = RandomString.generate(32)

    const data = aes256.encrypt(
      secureKey,
      JSON.stringify({
        username: 'Testuser',
        keyHash: 'hash',
        publicKey: publicKey,
      }),
    )
    socket.emit('connection', {
      data: data,
      key: encryptRSA(secureKey, publicKey),
    })
  })
})

socket.emit('sendToServer', {
  hallo: 'hallo',
})
