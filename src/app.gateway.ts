import { Logger } from '@nestjs/common'
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
import { Socket,Server } from 'socket.io'

@WebSocketGateway({ namespace: 'messages' })
export class AppGateway
  implements OnGatewayInit<Server>, OnGatewayConnection<Socket>, OnGatewayDisconnect<Socket>
{
  // this is used to send message to everyone
  /* @WebSocketServer() wss : Server; */

  private logger: Logger = new Logger('AppGatewayLogger')

  handleDisconnect(client: Socket) {
    this.logger.log('socket gate way disconnected')
  }
  handleConnection(client: Socket, ...args: any[]) {
    this.logger.log('socket gate way connected')
  }

  afterInit(server: Server) {
    this.logger.log('Web socker gateway init ...')
  }

  @SubscribeMessage('sendToServer')
  handleMessage(
      client: Socket,
      @MessageBody()
      text: string
  ): WsResponse<string> {
    // this is used to send message to everyone
    /* this.wss.emit('sendToServer',text) */

    this.logger.log('recieved', text)

    // THIS
    /*   client.emit('sendToServer',text)  */
    // Equals this, Typed
    return { event: 'sendToClient', data: text }
  }
}
