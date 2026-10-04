Feature: Consultar tipos de credito

  Background:
    * def base = call read('classpath:features/base-request.js')
    * def crypto = call read('classpath:features/crypto-request.js')
    * url baseUrl
    * path tiposCreditoPath
    * header Content-Type = 'application/json'
    * header x-aplicacion-id = aplicacionId
    * header x-canal-id = canalId

  @credito @encrypted
  Scenario: Consultar formas de pago para la tarjeta dummy
    * def expectedHttpStatus = karate.get('expectedHttpStatus') || 200
    * def omitMerchantCode = karate.get('omitMerchantCode') || false
    * def omitEncryptedCard = karate.get('omitEncryptedCard') || false
    * def maskedCardOverride = karate.get('maskedCardOverride')
    * def merchantCodeOverride = karate.get('merchantCodeOverride')
    * def fields = crypto.encryptFields({ tarjeta: cardNumber })
    * def sessionId = base.uuid()
    * def dinHeader = base.header(sessionId)
    * def values = fields.values
    * def requestMerchantCode = merchantCodeOverride || merchantCode
    * def requestMaskedCard = maskedCardOverride || maskedCard
    * def dinBody = { codigoComercio: '#(requestMerchantCode)', tarjetaEncriptada: '#(values.tarjeta)', tarjetaEnmascarada: '#(requestMaskedCard)' }
    * eval if (omitMerchantCode) delete dinBody.codigoComercio
    * eval if (omitEncryptedCard) delete dinBody.tarjetaEncriptada
    * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
    * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
    * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
    Given request requestPayload
    When method post
    * match responseStatus == expectedHttpStatus
    And match response.body == '#string'
    And match response.secretKey == '#string'