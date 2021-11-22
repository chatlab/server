import { Module } from '@nestjs/common'
import { AppService } from './app.service'
import { AlertGateway } from './alert.gateway'
import { AppGateway } from './app.gateway'

@Module({
  imports: [],
  providers: [AppService, AppGateway, AlertGateway],
})
export class AppModule {}
