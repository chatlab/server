import { Module } from '@nestjs/common'
import { AppService } from './app.service'
import { AppGateway } from './app.gateway'
import { CryptoService } from './crypto/crypto.service';

@Module({
  imports: [],
  providers: [AppService, AppGateway, CryptoService],
})
export class AppModule {}
