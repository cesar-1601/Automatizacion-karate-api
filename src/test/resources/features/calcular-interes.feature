Feature: Calcular interes

  Background:
    * def base = call read('classpath:features/base-request.js')
    * def crypto = call read('classpath:features/crypto-request.js')
    * url baseUrl
    * path calcularInteresPath
    * header Content-Type = 'application/json'
    * header x-aplicacion-id = aplicacionId
    * header x-canal-id = canalId

  @interes @encrypted
  Scenario: Calcular interes con parametros de credito
    * def expectedHttpStatus = karate.get('expectedHttpStatus') || 200
    * def omitMatrixId = karate.get('omitMatrixId') || false
    * def matrixIdOverride = karate.get('matrixIdOverride')
    * def merchantCodeOverride = karate.get('merchantCodeOverride')
    * def omitCreditGroup = karate.get('omitCreditGroup') || false
    * def creditGroupOverride = karate.get('creditGroupOverride')
    * def omitCreditType = karate.get('omitCreditType') || false
    * def creditTypeOverride = karate.get('creditTypeOverride')
    * def fields = crypto.encryptFields({ tarjeta: cardNumber })
    * def sessionId = base.uuid()
    * def dinHeader = base.header(sessionId)
    * def values = fields.values
    * def transactionData = base.transactionData()
    * def requestMatrixId = matrixIdOverride || matrixId
    * def requestMerchantCode = merchantCodeOverride || merchantCode
    * def requestCreditGroup = creditGroupOverride || creditGroup
    * def requestCreditType = creditTypeOverride || creditType
    * def dinBody = { fecha: '#(transactionData.date)', hora: '#(transactionData.time)', montoTransaccion: '#(transactionAmount)', codigoComercio: '#(requestMerchantCode)', idMatriz: '#(requestMatrixId)', codigoGrupoTipoCredito: '#(requestCreditGroup)', tipoCredito: '#(requestCreditType)', cuotas: '#(installments)', tarjetaEncriptada: '#(values.tarjeta)', tarjetaEnmascarada: '#(maskedCard)' }
    * eval if (omitMatrixId) delete dinBody.idMatriz
    * eval if (omitCreditGroup) delete dinBody.codigoGrupoTipoCredito
    * eval if (omitCreditType) delete dinBody.tipoCredito
    * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
    * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
    * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
    Given request requestPayload
    When method post
    * match responseStatus == expectedHttpStatus
    And match response.body == '#string'
    And match response.secretKey == '#string'