import {
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets'
import { Server } from 'http'

@WebSocketGateway({ namespace: 'alerts' })
export class AlertGateway {
  @WebSocketServer() wss: Server

  sendToAll(msg: string) {
    this.wss.emit('sendAlert', msg)
  }
}
