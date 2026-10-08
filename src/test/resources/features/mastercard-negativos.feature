Feature: Escenarios negativos end-to-end para Mastercard

  Background:
    * def base = call read('classpath:features/base-request.js')
    * def crypto = call read('classpath:features/crypto-request.js')
    * def negativeScenarios = read('classpath:test-data/negative-scenarios.json')
    * def mastercardCardData = call read('classpath:features/resolver-perfil-tarjeta.feature') { profileName: 'mastercard-approved' }
    * def cardProfile = mastercardCardData.cardProfile
    * def cardStatus = mastercardCardData.cardStatus
    * def cardBrand = mastercardCardData.cardBrand
    * def cardNumber = mastercardCardData.cardNumber
    * def maskedCard = mastercardCardData.maskedCard
    * def expirationDate = mastercardCardData.expirationDate
    * def cvv = mastercardCardData.cvv
    * match cardBrand == 'Mastercard'
    * match cardStatus == 'approved'

  @ignore @pendiente @negativo @e2e @mastercard @rechazo-tarjeta @stateful
  Scenario: Rechazo funcional de tarjeta Mastercard
    * def scenarioData = { cardProfile: 'mastercard-declined', expectedCardStatus: 'declined' }
    * def declinedCardData = call read('classpath:features/resolver-perfil-tarjeta.feature') { profileName: '#(scenarioData.cardProfile)' }
    * def cardProfile = declinedCardData.cardProfile
    * def cardStatus = declinedCardData.cardStatus
    * def cardBrand = declinedCardData.cardBrand
    * def cardNumber = declinedCardData.cardNumber
    * def maskedCard = declinedCardData.maskedCard
    * def expirationDate = declinedCardData.expirationDate
    * def cvv = declinedCardData.cvv
    * match cardProfile == scenarioData.cardProfile
    * match cardStatus == scenarioData.expectedCardStatus
    * match cardBrand == 'Mastercard'
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature@llave-publica')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def args = { publicKeyBase64: '#(publicKeyBase64)' }
    * call read('classpath:features/consultar-tipos-credito.feature') args
    * call read('classpath:features/calcular-interes.feature') args
    * def otpArgs = { expectedHttpStatus: 400 }
    * call read('classpath:features/generar-otp.feature@otp') otpArgs

  @ignore @pendiente @negativo @e2e @mastercard @cvv-invalido @destructive
  Scenario: Rechazo funcional de Mastercard con CVV invalido
    * def scenarioData = { cardProfile: 'mastercard-approved', expectedCardStatus: 'approved', cvvOverride: '999' }
    * match cardProfile == scenarioData.cardProfile
    * match cardStatus == scenarioData.expectedCardStatus
    * def args = { cvv: '#(scenarioData.cvvOverride)' }
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature@llave-publica')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * set args.publicKeyBase64 = publicKeyBase64
    * call read('classpath:features/consultar-tipos-credito.feature') args
    * call read('classpath:features/calcular-interes.feature') args
    * call read('classpath:features/generar-otp.feature@otp') args
    * call read('classpath:features/validar-otp.feature@otp') args
    * call read('classpath:features/autorizar-consumo.feature') args

  @ignore @pendiente @negativo @e2e @mastercard @otp-invalido @stateful
  Scenario: Detener el flujo Mastercard cuando el OTP es invalido
    * def scenarioData = negativeScenarios['otp-invalido']
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature@llave-publica')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def commonArgs = { publicKeyBase64: '#(publicKeyBase64)' }
    * call read('classpath:features/consultar-tipos-credito.feature') commonArgs
    * call read('classpath:features/calcular-interes.feature') commonArgs
    * call read('classpath:features/generar-otp.feature@otp') commonArgs
    * def validationArgs = { publicKeyBase64: '#(publicKeyBase64)', otp: '#(scenarioData.otpOverride)' }
    * call read('classpath:features/validar-otp.feature@otp') validationArgs

  # Perfil Mastercard expirado simulado; confirmar PAN y respuesta funcional con CAL.
  @ignore @pendiente @negativo @e2e @mastercard @tarjeta-vencida @destructive
  Scenario: Rechazo de Mastercard con fecha de expiracion vencida
    * def scenarioData = { cardProfile: 'mastercard-expired', expectedCardStatus: 'expired' }
    * def expiredCardData = call read('classpath:features/resolver-perfil-tarjeta.feature') { profileName: '#(scenarioData.cardProfile)' }
    * def cardProfile = expiredCardData.cardProfile
    * def cardStatus = expiredCardData.cardStatus
    * def cardBrand = expiredCardData.cardBrand
    * def cardNumber = expiredCardData.cardNumber
    * def maskedCard = expiredCardData.maskedCard
    * def expirationDate = expiredCardData.expirationDate
    * def cvv = expiredCardData.cvv
    * match cardProfile == scenarioData.cardProfile
    * match cardStatus == scenarioData.expectedCardStatus
    * match cardBrand == 'Mastercard'
    * match expirationDate == '1707'
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature@llave-publica')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def args = { publicKeyBase64: '#(publicKeyBase64)' }
    * call read('classpath:features/consultar-tipos-credito.feature') args
    * call read('classpath:features/calcular-interes.feature') args
    * call read('classpath:features/generar-otp.feature@otp') args
    * call read('classpath:features/validar-otp.feature@otp') args
    * call read('classpath:features/autorizar-consumo.feature') args

  @ignore @pendiente @negativo @mastercard @tipos-credito
  Scenario Outline: Rechazar datos invalidos al consultar tipos de credito para Mastercard: <caso>
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature@llave-publica')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def args = { publicKeyBase64: '#(publicKeyBase64)', omitMerchantCode: <omitMerchantCode>, merchantCodeOverride: '<merchantCodeOverride>', omitEncryptedCard: <omitEncryptedCard>, maskedCardOverride: '<maskedCardOverride>', expectedHttpStatus: 400 }
    * def result = call read('classpath:features/consultar-tipos-credito.feature') args
    * match result.responseStatus == args.expectedHttpStatus

    Examples:
      | caso                         | omitMerchantCode | merchantCodeOverride | omitEncryptedCard | maskedCardOverride       |
      | codigoComercio ausente       | true             |                      | false             |                          |
      | codigoComercio longitud      | false            | 12345678901          | false             |                          |
      | tarjetaEncriptada ausente    | false            |                      | true              |                          |
      | tarjetaEnmascarada longitud | false            |                      | false             | *********************** |

  @ignore @pendiente @negativo @mastercard @interes
  Scenario Outline: Rechazar parametros de interes invalidos para Mastercard: <scenarioKey>
    * def scenarioData = negativeScenarios['<scenarioKey>']
    * def args = { expectedHttpStatus: '#(scenarioData.expectedHttpStatus)', omitMatrixId: '#(scenarioData.omitMatrixId)', matrixIdOverride: '#(scenarioData.matrixIdOverride)', omitCreditGroup: '#(scenarioData.omitCreditGroup)', creditGroupOverride: '#(scenarioData.creditGroupOverride)', omitCreditType: '#(scenarioData.omitCreditType)', creditTypeOverride: '#(scenarioData.creditTypeOverride)', merchantCodeOverride: '#(scenarioData.merchantCodeOverride)', transactionAmount: '#(scenarioData.transactionAmount)', installments: '#(scenarioData.installments)' }
    * call read('classpath:features/calcular-interes.feature') args

    Examples:
      | scenarioKey              |
      | id-matriz-ausente        |
      | id-matriz-longitud       |
      | grupo-credito-ausente    |
      | grupo-credito-invalido   |
      | tipo-credito-ausente     |
      | tipo-credito-longitud    |
      | cuotas-negativas         |
      | cuotas-superiores-maximo |
      | monto-cero               |
      | monto-negativo           |
      | monto-invalido           |
      | monto-supera-longitud    |
      | tarjeta-sin-plan         |
      | comercio-matriz-incompatible |
      | cuotas-invalidas         |

  # El backend responde HTTP 200 a esta combinacion; confirmar el contrato con CAL antes de activarla.
  @ignore @pendiente @negativo @mastercard @interes @grupo-tipo-incompatible
  Scenario: Revisar combinacion incompatible de grupo y tipo de credito para Mastercard
    * def scenarioData = negativeScenarios['grupo-tipo-incompatible']
    * def args = { creditGroupOverride: '#(scenarioData.creditGroupOverride)', creditTypeOverride: '#(scenarioData.creditTypeOverride)', expectedHttpStatus: '#(scenarioData.expectedHttpStatus)' }
    * call read('classpath:features/calcular-interes.feature') args
