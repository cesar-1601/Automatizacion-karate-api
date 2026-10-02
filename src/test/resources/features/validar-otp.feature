Feature: Validar OTP

  Background:
    * def base = call read('classpath:features/base-request.js')
    * def crypto = call read('classpath:features/crypto-request.js')
    * url baseUrl
    * path validarOtpPath
    * header Content-Type = 'application/json'
    * header x-aplicacion-id = aplicacionId
    * header x-canal-id = canalId

  @otp @encrypted
  Scenario: Validar OTP de calidad para la tarjeta dummy
    * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
    * def sessionId = base.uuid()
    * def dinHeader = base.header(sessionId)
    * def values = fields.values
    * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
    * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
    * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
    * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
    Given request requestPayload
    When method post
    Then status 200
    And match response.body == '#string'
    And match response.secretKey == '#string'