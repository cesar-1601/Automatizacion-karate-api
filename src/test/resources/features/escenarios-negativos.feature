Feature: Escenarios negativos end-to-end

  Background:
    * def negativeScenarios = read('classpath:test-data/negative-scenarios.json')

  # Cada escenario obtiene sus datos desde negative-scenarios.json.
  # El flujo aprobado ya esta cubierto por flujo-completo.feature.

  @negativo @e2e @rechazo-tarjeta @destructive
  Scenario: Rechazo funcional de tarjeta
    * def scenarioData = negativeScenarios['rechazo-tarjeta']
    * def cardData = call read('classpath:features/resolver-perfil-tarjeta.feature') { profileName: '#(scenarioData.cardProfile)' }
    * def cardProfile = cardData.cardProfile
    * def cardStatus = cardData.cardStatus
    * def cardNumber = cardData.cardNumber
    * def maskedCard = cardData.maskedCard
    * def expirationDate = cardData.expirationDate
    * def cvv = cardData.cvv
    * match cardProfile == scenarioData.cardProfile
    * match cardStatus == scenarioData.expectedCardStatus
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def args = { publicKeyBase64: '#(publicKeyBase64)' }
    * call read('classpath:features/consultar-tipos-credito.feature') args
    * call read('classpath:features/calcular-interes.feature') args
    * call read('classpath:features/generar-otp.feature') args
    * call read('classpath:features/validar-otp.feature') args
    * call read('classpath:features/autorizar-consumo.feature') args

  @negativo @e2e @cvv-invalido @destructive
  Scenario: Rechazo funcional por CVV invalido
    * def scenarioData = negativeScenarios['cvv-invalido']
    * def cardData = call read('classpath:features/resolver-perfil-tarjeta.feature') { profileName: '#(scenarioData.cardProfile)' }
    * def cardProfile = cardData.cardProfile
    * def cardStatus = cardData.cardStatus
    * def cardNumber = cardData.cardNumber
    * def maskedCard = cardData.maskedCard
    * def expirationDate = cardData.expirationDate
    * def cvv = cardData.cvv
    * def scenarioCvv = scenarioData.cvvOverride
    * karate.log('CVV configurado desde el inicio del escenario:', scenarioCvv)
    * match cardProfile == scenarioData.cardProfile
    * match cardStatus == scenarioData.expectedCardStatus
    * def args = { cvv: '#(scenarioCvv)' }
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * set args.publicKeyBase64 = publicKeyBase64
    * call read('classpath:features/consultar-tipos-credito.feature') args
    * call read('classpath:features/calcular-interes.feature') args
    * call read('classpath:features/generar-otp.feature') args
    * call read('classpath:features/validar-otp.feature') args
    * call read('classpath:features/autorizar-consumo.feature') args

  @negativo @e2e @otp-invalido @stateful
  Scenario: Detener el flujo cuando el OTP es invalido
    * def scenarioData = negativeScenarios['otp-invalido']
    * def cardData = call read('classpath:features/resolver-perfil-tarjeta.feature') { profileName: '#(scenarioData.cardProfile)' }
    * def cardProfile = cardData.cardProfile
    * def cardStatus = cardData.cardStatus
    * def cardNumber = cardData.cardNumber
    * def maskedCard = cardData.maskedCard
    * def expirationDate = cardData.expirationDate
    * def cvv = cardData.cvv
    * match cardProfile == scenarioData.cardProfile
    * match cardStatus == scenarioData.expectedCardStatus
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def args = { publicKeyBase64: '#(publicKeyBase64)' }
    * call read('classpath:features/consultar-tipos-credito.feature') args
    * call read('classpath:features/calcular-interes.feature') args
    * call read('classpath:features/generar-otp.feature') args
    * def validationArgs = { publicKeyBase64: '#(publicKeyBase64)', otp: '#(scenarioData.otpOverride)' }
    * call read('classpath:features/validar-otp.feature') validationArgs

  @negativo @e2e @tarjeta-vencida @destructive
  Scenario: Rechazo funcional de tarjeta vencida
    * def scenarioData = negativeScenarios['tarjeta-vencida']
    * def cardData = call read('classpath:features/resolver-perfil-tarjeta.feature') { profileName: '#(scenarioData.cardProfile)' }
    * def cardProfile = cardData.cardProfile
    * def cardStatus = cardData.cardStatus
    * def cardNumber = cardData.cardNumber
    * def maskedCard = cardData.maskedCard
    * def expirationDate = cardData.expirationDate
    * def cvv = cardData.cvv
    * match cardProfile == scenarioData.cardProfile
    * match cardStatus == scenarioData.expectedCardStatus
    * match expirationDate == scenarioData.expectedExpirationDate
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def args = { publicKeyBase64: '#(publicKeyBase64)' }
    * call read('classpath:features/consultar-tipos-credito.feature') args
    * call read('classpath:features/calcular-interes.feature') args
    * call read('classpath:features/generar-otp.feature') args
    * call read('classpath:features/validar-otp.feature') args
    * call read('classpath:features/autorizar-consumo.feature') args

  @negativo @e2e @monto-invalido
  Scenario: Error de negocio por monto invalido
    * def scenarioData = negativeScenarios['monto-invalido']
    * def cardData = call read('classpath:features/resolver-perfil-tarjeta.feature') { profileName: '#(scenarioData.cardProfile)' }
    * def cardProfile = cardData.cardProfile
    * def cardStatus = cardData.cardStatus
    * def cardNumber = cardData.cardNumber
    * def maskedCard = cardData.maskedCard
    * def expirationDate = cardData.expirationDate
    * def cvv = cardData.cvv
    * match cardProfile == scenarioData.cardProfile
    * match cardStatus == scenarioData.expectedCardStatus
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def commonArgs = { publicKeyBase64: '#(publicKeyBase64)' }
    * call read('classpath:features/consultar-tipos-credito.feature') commonArgs
    * def calculationArgs = { publicKeyBase64: '#(publicKeyBase64)', transactionAmount: '#(scenarioData.transactionAmount)', installments: '#(scenarioData.installments)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') calculationArgs

  @negativo @e2e @monto-supera-longitud
  Scenario: Error de negocio por monto superior a la longitud permitida
    * def scenarioData = negativeScenarios['monto-supera-longitud']
    * def cardData = call read('classpath:features/resolver-perfil-tarjeta.feature') { profileName: '#(scenarioData.cardProfile)' }
    * def cardProfile = cardData.cardProfile
    * def cardStatus = cardData.cardStatus
    * def cardNumber = cardData.cardNumber
    * def maskedCard = cardData.maskedCard
    * def expirationDate = cardData.expirationDate
    * def cvv = cardData.cvv
    * match cardProfile == scenarioData.cardProfile
    * match cardStatus == scenarioData.expectedCardStatus
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def commonArgs = { publicKeyBase64: '#(publicKeyBase64)' }
    * call read('classpath:features/consultar-tipos-credito.feature') commonArgs
    * def calculationArgs = { publicKeyBase64: '#(publicKeyBase64)', transactionAmount: '#(scenarioData.transactionAmount)', installments: '#(scenarioData.installments)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') calculationArgs

  @negativo @e2e @cuotas-invalidas
  Scenario: Error de negocio por cuotas invalidas
    * def scenarioData = negativeScenarios['cuotas-invalidas']
    * def cardData = call read('classpath:features/resolver-perfil-tarjeta.feature') { profileName: '#(scenarioData.cardProfile)' }
    * def cardProfile = cardData.cardProfile
    * def cardStatus = cardData.cardStatus
    * def cardNumber = cardData.cardNumber
    * def maskedCard = cardData.maskedCard
    * def expirationDate = cardData.expirationDate
    * def cvv = cardData.cvv
    * match cardProfile == scenarioData.cardProfile
    * match cardStatus == scenarioData.expectedCardStatus
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def commonArgs = { publicKeyBase64: '#(publicKeyBase64)' }
    * call read('classpath:features/consultar-tipos-credito.feature') commonArgs
    * def calculationArgs = { publicKeyBase64: '#(publicKeyBase64)', transactionAmount: '#(scenarioData.transactionAmount)', installments: '#(scenarioData.installments)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') calculationArgs

  @negativo @e2e @comercio-no-autorizado @destructive
  Scenario: Rechazo funcional de comercio no autorizado
    * def scenarioData = negativeScenarios['comercio-no-autorizado']
    * def cardData = call read('classpath:features/resolver-perfil-tarjeta.feature') { profileName: '#(scenarioData.cardProfile)' }
    * def cardProfile = cardData.cardProfile
    * def cardStatus = cardData.cardStatus
    * def cardNumber = cardData.cardNumber
    * def maskedCard = cardData.maskedCard
    * def expirationDate = cardData.expirationDate
    * def cvv = cardData.cvv
    * match cardProfile == scenarioData.cardProfile
    * match cardStatus == scenarioData.expectedCardStatus
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def commonArgs = { publicKeyBase64: '#(publicKeyBase64)' }
    * call read('classpath:features/consultar-tipos-credito.feature') commonArgs
    * call read('classpath:features/calcular-interes.feature') commonArgs
    * call read('classpath:features/generar-otp.feature') commonArgs
    * call read('classpath:features/validar-otp.feature') commonArgs
    * def authorizationArgs = { publicKeyBase64: '#(publicKeyBase64)', merchantCode: '#(scenarioData.merchant.merchantCode)', actividadComercial: '#(scenarioData.merchant.actividadComercial)', nombreEstablecimiento: '#(scenarioData.merchant.nombreEstablecimiento)' }
    * call read('classpath:features/autorizar-consumo.feature') authorizationArgs

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

  Scenario: 9995 - El AplicacionId es Requerido
    * def fields = crypto.encryptFields({ tarjeta: cardNumber })
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
    And match response.codigo == '9995'

  Scenario: 9996 - El CanalId es Requerido
    * def fields = crypto.encryptFields({ tarjeta: cardNumber })
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
    And match response.codigo == '9996'

  Scenario: 9997 - Error en el Descifrado de datos
    * def fields = crypto.encryptFields({ tarjeta: cardNumber })
    * def sessionId = base.uuid()
    * def dinHeader = base.header(sessionId)
    * def values = fields.values
    * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
    * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
    * set dinHeader.llaveSimetrica = 'invalid-key'
    * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
    Given request requestPayload
    When method post
    Then status 400
    And match response.codigo == '9997'

  Scenario: 9998 - Error en el cifrado de datos
    * def fields = crypto.encryptFields({ tarjeta: cardNumber })
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

  Scenario: 9999 - Error en criptografía
    * def fields = crypto.encryptFields({ tarjeta: cardNumber })
    * def sessionId = base.uuid()
    * def dinHeader = base.header(sessionId)
    * def values = fields.values
    * def dinBody = { perfil: '#(profile)', usuarioBiometricoEncriptado: '', codigoTransaccion: '#(transactionCode)', tarjetaEncriptada: '#(values.tarjeta)', codigoEntidad: '', codigoMarca: '', tipoTarjeta: 'C', parametrosAdicionales: [] }
    * def encrypted = crypto.encryptBody({ dinHeader: dinHeader, dinBody: dinBody }, fields.key)
    * set dinHeader.llaveSimetrica = 'invalid-secret-key'
    * def requestPayload = { body: '#(encrypted.body)', secretKey: '#(encrypted.secretKey)' }
    Given request requestPayload
    When method post
    Then status 400
    And match response.codigo == '9999'
