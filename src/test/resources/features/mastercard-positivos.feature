Feature: Mastercard aprobada

  Background:
    * def base = call read('classpath:features/base-request.js')
    * def crypto = call read('classpath:features/crypto-request.js')
    * def scenarioData = { cardProfile: 'mastercard-approved', expectedCardStatus: 'approved' }
    * def cardData = call read('classpath:features/resolver-perfil-tarjeta.feature') { profileName: '#(scenarioData.cardProfile)' }
    * def cardProfile = cardData.cardProfile
    * def cardStatus = cardData.cardStatus
    * def cardBrand = cardData.cardBrand
    * def cardNumber = cardData.cardNumber
    * def maskedCard = cardData.maskedCard
    * def expirationDate = cardData.expirationDate
    * def cvv = cardData.cvv
    * match cardProfile == scenarioData.cardProfile
    * match cardStatus == scenarioData.expectedCardStatus
    * match cardBrand == 'Mastercard'
    * match cvv == '#string'
    * match cvv != ''

  # El perfil Mastercard aún requiere confirmación de PAN y habilitación del comercio con CAL.
  @pendiente @positivo @e2e @mastercard @destructive
  Scenario: Aprobacion funcional de Mastercard
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature@llave-publica')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def args = { publicKeyBase64: '#(publicKeyBase64)' }
    * call read('classpath:features/consultar-tipos-credito.feature') args
    * call read('classpath:features/calcular-interes.feature') args
    * call read('classpath:features/generar-otp.feature@otp') args
    * call read('classpath:features/validar-otp.feature@otp') args
    * call read('classpath:features/autorizar-consumo.feature') args
