import { defineSecret } from 'firebase-functions/params';
import * as logger from 'firebase-functions/logger';
import * as admin from 'firebase-admin';
import * as dotenv from 'dotenv';
import { onCall, CallableRequest } from 'firebase-functions/v2/https';
dotenv.config();

import {
  Cielo,
  CieloConstructor,
  TransactionCreditCardRequestModel,
  CaptureRequestModel,
  CancelTransactionRequestModel,
  EnumBrands,
} from 'cielo';

// Inicializa o Admin SDK
admin.initializeApp();

// Segredos para produção
const secretMerchantId = defineSecret('CIELO_MERCHANT_ID');
const secretMerchantKey = defineSecret('CIELO_MERCHANT_KEY');

// Pega variáveis de ambiente (.env) ou usa secrets (em produção)
const merchantId = process.env.CIELO_MERCHANT_ID || secretMerchantId.value();
const merchantKey = process.env.CIELO_MERCHANT_KEY || secretMerchantKey.value();

// Configuração da Cielo
const cieloParams: CieloConstructor = {
  merchantId,
  merchantKey,
  sandbox: true,
  debug: true,
};

const cielo = new Cielo(cieloParams);

export const authorizeCreditCard = onCall(
  { secrets: [secretMerchantId, secretMerchantKey] },
  async (request: CallableRequest<any>) => {
    const data = request.data;
    const context = request;

    if (!data) {
      return {
        success: false,
        error: {
          code: -1,
          message: 'Dados não informados',
        },
      };
    }

    if (!context.auth) {
      return {
        success: false,
        error: {
          code: -1,
          message: 'Nenhum usuário logado',
        },
      };
    }

    const userId = context.auth.uid;

    const snapshot = await admin.firestore().collection("users").doc(userId).get();
    const userData = snapshot.data() || {};

    let brand: EnumBrands;
    switch(data.creditCard.brand){
      case "VISA":
        brand = EnumBrands.VISA;
        break;
      case "MASTERCARD":
        brand = EnumBrands.MASTER;
        break;
      case "AMEX":
        brand = EnumBrands.AMEX;
        break;
      case "ELO":
        brand = EnumBrands.ELO;
        break;
      case "JCB":
        brand = EnumBrands.JCB;
        break;
      case "DINERSCLUB":
        brand = EnumBrands.DINERS;
        break;
      case "DISCOVER":
        brand = EnumBrands.DISCOVERY;
        break;
      case "MASTERCARD":
        brand = EnumBrands.HIPERCARD;
        break;
      default:
        return {
          "sucess": false,
          error: {
            "code": -1,
            "message": "cartao nao encontrado" + data.creditCard.brand
          }
        }  
      }

    const saleData: TransactionCreditCardRequestModel = {
      merchantOrderId: data.merchantOrderId,
      customer: {
        name: userData.name,
        identity: data.cpf,
        identityType: "cpf",
        email: userData.email,
        deliveryAddress: {
          street: userData.adress.street,
          number: userData.adress.number,
          complement: userData.adress.complement,
          zipCode: userData.address.city,
          city: userData.adress.state,
          country: "BRA",
          district: userData.address.district
        }
      },
      payment: {
        currency: "BRL",
        country: "BRA",
        amount: data.amount,
        installments: data.installments,
        softDescriptor: data.softDescriptor,
        type: data.paymentType,
        capture: false,
        creditCard: {
          cardNumber: data.creditCard.cardNumber,
          holder: data.creditCard.holder,
          expirationDate: data.creditCard.expirationDate,
          securityCode: data.creditCard.securityCode,
          brand: brand,
        }
      }
    }
    
  try {
      const transaction = await cielo.creditCard.transaction(saleData);
  
  
      if(transaction.payment.status === 1){
        return {
          "success": true,
          "paymenID": transaction.payment.paymentId
        }
      } else {
        let message = "";
        switch(transaction.payment.returnCode) {
          case '5':
            message = 'Nao Autorizada';
            break;
          case '57':
            message = 'cartao expirada';
            break;
          case '78':
            message = 'Carto bloqueado';
            break;
          case '99':
            message = 'TimeOut';
            break;
          case '77':
            message = 'Cartao Cancelado';
            break;
          case '70':
            message = 'Problemas com o cartao de credito';
            break;
          default:
            message = transaction.payment.returnMessage;
            break;
        }
        return {
          "success": false,
          "status": transaction.payment.status,
          "error": {
            "code": transaction.payment.returnCode,
            "message": message
          }
        }
      }
  } catch (error) {
    return {
      "success": false,
      "error": {
        "code": error.response[0].Code,
        "message": error.response[0].message
        }
      };
    }
  }
);

export const captureCreditCard = onCall(
  { secrets: [secretMerchantId, secretMerchantKey] },
  async (request: CallableRequest<any>) => {
    const data = request.data;
    const context = request;

    if (!data) {
      return {
        "success": false,
        "error": {
          "code": -1,
          "message": 'Dados não informados',
        },
      };
    }

    if (!context.auth) {
      return {
        "success": false,
        "error": {
          "code": -1,
          "message": 'Nenhum usuário logado',
        },
      };
    }

    const captureParams: CaptureRequestModel = {
      paymentId: data.payId,
    }

try {
      const capture = await cielo.creditCard.captureSaleTransaction(captureParams);
  
      if(capture.status === 2){
        return {sucess: true};
      } else{
        return {
          sucess: false,
          "status": capture.status,
          "error": {
            "code": capture.returnCode,
            "message": capture.returnMessage
          }
        }
      }
} catch (error) {
  console.log("error", error);
    return {
      "success": false,
      "error": {
        "code": error.response[0].Code,
        "message": error.response[0].message
        }
      };
    }
  }
);

export const cancelCreditCard = onCall(
  { secrets: [secretMerchantId, secretMerchantKey] },
  async (request: CallableRequest<any>) => {
    const data = request.data;
    const context = request;

    if (!data) {
      return {
        "success": false,
        "error": {
          "code": -1,
          "message": 'Dados não informados',
        },
      };
    }

    if (!context.auth) {
      return {
        "success": false,
        "error": {
          "code": -1,
          "message": 'Nenhum usuário logado',
        },
      };
    }

    const cancelParams: CancelTransactionRequestModel = {
      paymentId: data.payId,
    }

try {
      const capture = await cielo.creditCard.cancelTransaction(captureParams);
  
      if(cancel.status === 10 || cancel.status === 11){
        return {sucess: true};
      } else{
        return {
          "sucess": false,
          "status": cancel.status,
          "error": {
            "code": cancel.returnCode,
            "message": cancel.returnMessage
          }
        }
      }
} catch (error) {
  console.log("error", error);
    return {
      "success": false,
      "error": {
        "code": error.response[0].Code,
        "message": error.response[0].message
        }
      };
    }
  }
);



// Função para obter dados do usuário autenticado
export const getUserData = onCall({ secrets: [secretMerchantId, secretMerchantKey] }, async (request) => {
  if (!request.auth) {
    return { error: 'Nenhum usuário autenticado.' };
  }

  try {
    const snapshot = await admin.firestore()
      .collection('users')
      .doc(request.auth.uid)
      .get();

    if (!snapshot.exists) {
      return { error: 'Usuário não encontrado.' };
    }

    return { data: snapshot.data() };
  } catch (error) {
    logger.error('Erro ao buscar dados do usuário:', error);
    return { error: 'Erro interno ao buscar usuário.' };
  }
});
