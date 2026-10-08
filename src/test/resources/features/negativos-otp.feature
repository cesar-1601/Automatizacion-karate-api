Feature: Escenarios negativos de generacion de OTP

  Background:
    * def base = call read('classpath:features/base-request.js')
    * def crypto = call read('classpath:features/crypto-request.js')
    * url baseUrl
    * path generarOtpPath
    * header Content-Type = 'application/json'
    * header x-aplicacion-id = aplicacionId
    * header x-canal-id = canalId

  @negativo @otp @tarjeta-no-encontrada
  #despues de implementar dio código 200, verificar si esto es el comportamiento esperado. revisar en que microservicio se consulta el número de tarjeta
  Scenario: 9994 - Tarjeta no encontrada
    * def fields = crypto.encryptFields({ tarjeta: '0000000000000000' })
    * def sessionId = base.uuid()
    * def dinHeader = base.header(sessionId)
    * def values = fields.values
    * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
    * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
    * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
    * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
    Given request requestPayload
    When method post
    Then status 404
    And match response.codigo == '9994'

  @negativo @otp @aplicacion-id-obligatorio
  #ok
  Scenario: 9995 - El AplicacionId es Requerido
    * def fields = crypto.encryptFields({ tarjeta: '0000000000000000' })
    * def sessionId = base.uuid()
    * def dinHeader = base.header(sessionId)
    * set dinHeader.aplicacionId = ''
    * def values = fields.values
    * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
    * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
    * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
    * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
    Given request requestPayload
    When method post
    Then status 400


  @negativo @otp @canal-id-obligatorio
  #OK
  Scenario: 9996 - El CanalId es Requerido
    * def fields = crypto.encryptFields({ tarjeta: '0000000000000000' })
    * def sessionId = base.uuid()
    * def dinHeader = base.header(sessionId)
    * set dinHeader.canalId = ''
    * def values = fields.values
    * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
    * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
    * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
    * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
    Given request requestPayload
    When method post
    Then status 400
    And match response.body == '#string'
    And match response.secretKey == '#string'

  @negativo @otp @descifrado-fallido
  #PENDIENTE
  Scenario: 9997 - Error en el Descifrado de datos
    * def fields = crypto.encryptFields({ tarjeta: '0000000000000000' })
    * def sessionId = base.uuid()
    * def dinHeader = base.header(sessionId)
    * def values = fields.values
    * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
    * def invalidBodyKey = crypto.encryptFields({}).key
    * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key, null, invalidBodyKey)
    * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
    Given request requestPayload
    When method post
    Then status 400
    And match response.body == '#string'
    And match response.secretKey == '#string'

  @negativo @otp @cifrado-fallido
  #PENDIENTE
  Scenario: 9998 - Error en el cifrado de datos
    * def fields = crypto.encryptFields({ tarjeta: '0000000000000000' })
    * def sessionId = base.uuid()
    * def dinHeader = base.header(sessionId)
    * def values = fields.values
    * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
    * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
    * set encrypted.body = 'invalid-body'
    * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
    * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
    Given request requestPayload
    When method post
    Then status 400
    And match response.codigo == '9998'

  @negativo @otp @criptografia-fallida
  #PENDIENTE
  Scenario: 9999 - Error en criptografía
    * def fields = crypto.encryptFields({ tarjeta: '0000000000000000' })
    * def sessionId = base.uuid()
    * def dinHeader = base.header(sessionId)
    * def values = fields.values
    * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
    * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key, 'invalid-secret-key')
    * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
    Given request requestPayload
    When method post
    Then status 400
    And match response.codigo == '9999'
