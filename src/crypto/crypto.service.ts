import { Injectable } from '@nestjs/common'
import * as crypto from 'crypto'

@Injectable()
export class CryptoService {
  public static createKeyPair() {
    const { publicKey, privateKey } = crypto.generateKeyPairSync('rsa', {
      modulusLength: 1024 * 4,
      publicKeyEncoding: {
        type: 'spki',
        format: 'pem',
      },
      privateKeyEncoding: {
        type: 'pkcs8',
        format: 'pem',
      },
    })

    return {
      private: privateKey,
      public: publicKey,
    }
  }

  public static encryptRSA(text, pbk) {
    return crypto.publicEncrypt(
      {
        key: pbk,
        padding: crypto.constants.RSA_PKCS1_OAEP_PADDING,
        oaepHash: 'sha256',
      },
      Buffer.from(text, 'ascii'),
    )
  }
  public static decryptRSA(text, pvk) {
    return crypto.privateDecrypt(
      {
        key: pvk,
        padding: crypto.constants.RSA_PKCS1_OAEP_PADDING,
        oaepHash: 'sha256',
      },
      Buffer.from(text, 'hex'),
    )
  }
}
