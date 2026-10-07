Feature: Escenarios negativos de calculo de interes

  Background:
    * def negativeScenarios = read('classpath:test-data/negative-scenarios.json')

  # Los casos implementados varían una sola condición y se detienen en calcular-interes.

  @negativo @interes @id-matriz-ausente
  # Código esperado: 0005 - El campo idMatriz es obligatorio.
  Scenario: Rechazar calculo sin idMatriz
    * def scenarioData = negativeScenarios['id-matriz-ausente']
    * def args = { omitMatrixId: '#(scenarioData.omitMatrixId)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') args

  @negativo @interes @id-matriz-longitud
  # Código esperado: 0014 - La longitud de idMatriz supera el máximo permitido.
  Scenario: Rechazar idMatriz con longitud superior al limite
    * def scenarioData = negativeScenarios['id-matriz-longitud']
    * def args = { matrixIdOverride: '#(scenarioData.matrixIdOverride)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') args

  @negativo @interes @grupo-credito-ausente
  # Código esperado: 0006 - El campo codigoGrupoTipoCredito es obligatorio.
  Scenario: Rechazar calculo sin codigoGrupoTipoCredito
    * def scenarioData = negativeScenarios['grupo-credito-ausente']
    * def args = { omitCreditGroup: '#(scenarioData.omitCreditGroup)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') args

  @negativo @interes @grupo-credito-invalido
  # El contrato acepta C, P o X. El código funcional para Z requiere confirmación con CAL.
  Scenario: Rechazar grupo de credito no permitido
    * def scenarioData = negativeScenarios['grupo-credito-invalido']
    * def args = { creditGroupOverride: '#(scenarioData.creditGroupOverride)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') args

  @negativo @interes @tipo-credito-ausente
  # Código esperado: 0007 - El campo tipoCredito es obligatorio.
  Scenario: Rechazar calculo sin tipoCredito
    * def scenarioData = negativeScenarios['tipo-credito-ausente']
    * def args = { omitCreditType: '#(scenarioData.omitCreditType)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') args

  @negativo @interes @tipo-credito-longitud
  # Código esperado: 0016 - La longitud de tipoCredito supera el máximo permitido.
  Scenario: Rechazar tipoCredito con longitud superior a 3 caracteres
    * def scenarioData = negativeScenarios['tipo-credito-longitud']
    * def args = { creditTypeOverride: '#(scenarioData.creditTypeOverride)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') args

  # Caso temporalmente desactivado: la combinación debe validarse con CAL porque el backend responde 200 y no rechaza el flujo.
  @negativo @interes @grupo-tipo-incompatible
  Scenario: Rechazar combinacion incompatible de grupo y tipo de credito
    * def scenarioData = negativeScenarios['grupo-tipo-incompatible']
    * def args = { creditGroupOverride: '#(scenarioData.creditGroupOverride)', creditTypeOverride: '#(scenarioData.creditTypeOverride)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') args

  @negativo @interes @cuotas-negativas
  # HTTP 400 es una expectativa provisional; confirmar el código funcional con CAL.
  Scenario: Rechazar cuotas negativas
    * def scenarioData = negativeScenarios['cuotas-negativas']
    * def args = { installments: '#(scenarioData.installments)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') args

  @negativo @interes @cuotas-superiores-maximo
  # La especificación muestra P/02 con 50 cuotas; 51 es provisional y debe confirmarse con CAL para esta tarjeta.
  Scenario: Rechazar cuotas superiores al maximo permitido
    * def scenarioData = negativeScenarios['cuotas-superiores-maximo']
    * def args = { creditGroupOverride: '#(scenarioData.creditGroupOverride)', creditTypeOverride: '#(scenarioData.creditTypeOverride)', installments: '#(scenarioData.installments)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') args

  @negativo @interes @monto-cero
  # HTTP 400 es una expectativa provisional; confirmar el código funcional con CAL.
  Scenario: Rechazar monto igual a cero
    * def scenarioData = negativeScenarios['monto-cero']
    * def args = { transactionAmount: '#(scenarioData.transactionAmount)', installments: '#(scenarioData.installments)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') args

  @negativo @interes @monto-negativo
  # HTTP 400 es una expectativa provisional; confirmar el código funcional con CAL.
  Scenario: Rechazar monto negativo
    * def scenarioData = negativeScenarios['monto-negativo']
    * def args = { transactionAmount: '#(scenarioData.transactionAmount)', installments: '#(scenarioData.installments)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') args

  @negativo @interes @monto-longitud
  # Código esperado: 0012 según el contrato, sujeto a confirmar HTTP status.
  Scenario: Rechazar monto numerico superior a 11 caracteres
    * def scenarioData = negativeScenarios['monto-supera-longitud']
    * def args = { transactionAmount: '#(scenarioData.transactionAmount)', installments: '#(scenarioData.installments)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') args

  @negativo @interes @tarjeta-sin-plan
  # X/03 no aparece en el ejemplo documentado; confirmar que no esté habilitado para la tarjeta con CAL.
  Scenario: Rechazar tarjeta sin plan de credito solicitado
    * def scenarioData = negativeScenarios['tarjeta-sin-plan']
    * def args = { creditGroupOverride: '#(scenarioData.creditGroupOverride)', creditTypeOverride: '#(scenarioData.creditTypeOverride)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') args

  @negativo @interes @comercio-matriz-incompatible
  # Pareja candidata 1545070/matriz 1; confirmar incompatibilidad y código con CAL.
  Scenario: Rechazar comercio y matriz incompatibles
    * def scenarioData = negativeScenarios['comercio-matriz-incompatible']
    * def args = { merchantCodeOverride: '#(scenarioData.merchantCodeOverride)', matrixIdOverride: '#(scenarioData.matrixIdOverride)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') args

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
    And match response.codigo == '9995'

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
    And match response.codigo == '9996'

  Scenario: 9997 - Error en el Descifrado de datos
    * def fields = crypto.encryptFields({ tarjeta: '0000000000000000' })
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

  Scenario: 9999 - Error en criptografía
    * def fields = crypto.encryptFields({ tarjeta: '0000000000000000' })
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
