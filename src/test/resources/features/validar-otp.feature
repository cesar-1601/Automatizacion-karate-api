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

  # Casos futuros para validación de errores en validación OTP
  # Scenario: 0001 - El valor del campo perfil es requerido
  #   * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * def values = fields.values
  #   * def dinBody = { perfil: '', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 400
  #   And match response.codigo == '0001'

  # Scenario: 0002 - La longitud del valor perfil es mayor a 1
  #   * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * def values = fields.values
  #   * def dinBody = { perfil: 'SE', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 400
  #   And match response.codigo == '0002'

  # Scenario: 0003 - El valor del campo codigoTransaccion es requerido
  #   * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * def values = fields.values
  #   * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 400
  #   And match response.codigo == '0003'

  # Scenario: 0004 - La longitud del valor codigoTransaccion es mayor a 3
  #   * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * def values = fields.values
  #   * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: 'AA', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 400
  #   And match response.codigo == '0004'

  # Scenario: 0005 - El valor del campo tarjetaEncriptada es requerido
  #   * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * def values = fields.values
  #   * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 400
  #   And match response.codigo == '0005'

  # Scenario: 0006 - La longitud del valor codigoEntidad es mayor a 2
  #   * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * def values = fields.values
  #   * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: 'ABC', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 400
  #   And match response.codigo == '0006'

  # Scenario: 0007 - La longitud del valor codigoMarca es mayor a 2
  #   * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * def values = fields.values
  #   * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: 'ABC', tipoTarjeta: 'C', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 400
  #   And match response.codigo == '0007'

  # Scenario: 0008 - El valor del campo tipoTarjeta es requerido
  #   * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * def values = fields.values
  #   * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: '', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 400
  #   And match response.codigo == '0008'

  # Scenario: 0009 - La longitud del valor tipoTarjeta es mayor a 1
  #   * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * def values = fields.values
  #   * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'CR', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 400
  #   And match response.codigo == '0009'

  # Scenario: 9994 - Tarjeta no encontrada
  #   * def fields = crypto.encryptFields({ tarjeta: '0000000000000000', otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * def values = fields.values
  #   * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 404
  #   And match response.codigo == '9994'

  # Scenario: 9995 - El AplicacionId es Requerido
  #   * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * set dinHeader.aplicacionId = ''
  #   * def values = fields.values
  #   * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 400
  #   And match response.codigo == '9995'

  # Scenario: 9996 - El CanalId es Requerido
  #   * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * set dinHeader.canalId = ''
  #   * def values = fields.values
  #   * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 400
  #   And match response.codigo == '9996'

  # Scenario: 9997 - Error en el Descifrado de datos
  #   * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * def values = fields.values
  #   * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set dinHeader.llaveSimetrica = 'invalid-key'
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 400
  #   And match response.codigo == '9997'

  # Scenario: 9998 - Error en el cifrado de datos
  #   * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * def values = fields.values
  #   * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set encrypted.body = 'invalid-body'
  #   * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 400
  #   And match response.codigo == '9998'

  # Scenario: 9999 - Error en criptografía
  #   * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * def values = fields.values
  #   * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set dinHeader.llaveSimetrica = 'invalid-secret-key'
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 400
  #   And match response.codigo == '9999'

  # Scenario: 0010 - El campo perfil no cumple con la expresión requerida S o E
  #   * def fields = crypto.encryptFields({ tarjeta: cardNumber, otp: otp })
  #   * def sessionId = base.uuid()
  #   * def dinHeader = base.header(sessionId)
  #   * def values = fields.values
  #   * def dinBody = { perfil: 'X', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoOTPEncriptado: '#(values.otp)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
  #   * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
  #   * set dinHeader.llaveSimetrica = encrypted.fieldSecretKey
  #   * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
  #   Given request requestPayload
  #   When method post
  #   Then status 400
  #   And match response.codigo == '0010'