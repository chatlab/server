import { Injectable, Logger } from '@nestjs/common'
import {
  MessageBody,
  OnGatewayConnection,
  OnGatewayDisconnect,
  OnGatewayInit,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
  WsResponse,
} from '@nestjs/websockets'
import { Socket, Server } from 'socket.io'
import { CryptoService } from './crypto/crypto.service'
import * as aes256 from 'aes256'

enum WebsocketsEvents {
  PUBLIC_KEY = 'PUBLIC_KEY',
}

@WebSocketGateway({ namespace: 'messages' })
export class AppGateway
  implements
    OnGatewayInit<Server>,
    OnGatewayConnection<Socket>,
    OnGatewayDisconnect<Socket>
{
  // this is used to send message to everyone
  @WebSocketServer()
  private wss: Server
  private rsaPairKeys = CryptoService.createKeyPair()

  private logger: Logger = new Logger('AppGatewayLogger')

  handleDisconnect(client: Socket) {
    this.logger.log('socket gate way disconnected')
  }

  handleConnection(client: Socket, ...args: any[]) {
    this.logger.log('Socket Gateway connected!')

    // Emit public key to client
    this.wss
      .to(client.id)
      .emit(WebsocketsEvents.PUBLIC_KEY, this.rsaPairKeys.public)
  }

  afterInit(server: Server) {
    this.logger.log('Web socker gateway init ...')
  }

  @SubscribeMessage('connection')
  handleMessage(
    client: Socket,
    @MessageBody('data') data: string,
    @MessageBody('key') key: string,
  ): WsResponse<string> {
    // this is used to send message to everyone
    /* this.wss.emit('sendToServer',text) */

    console.log(
      aes256.decrypt(
        CryptoService.decryptRSA(key, this.rsaPairKeys.private).toString(),
        data,
      ),
    )

    // THIS
    /*   client.emit('sendToServer',text)  */
    // Equals this, Typed
    return { event: 'sendToClient', data: data }
  }
}
