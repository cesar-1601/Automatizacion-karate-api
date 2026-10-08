Feature: Visa aprobada

  Background:
    * def base = call read('classpath:features/base-request.js')
    * def crypto = call read('classpath:features/crypto-request.js')
    * def scenarioData = { cardProfile: 'visa-approved', expectedCardStatus: 'approved' }
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
    * match cardBrand == 'Visa'
    * match cvv == '#string'
    * match cvv != ''

  @positivo @e2e @visa @destructive
  Scenario: Aprobacion funcional de Visa
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature@llave-publica')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def args = { publicKeyBase64: '#(publicKeyBase64)' }
    * call read('classpath:features/consultar-tipos-credito.feature') args
    * call read('classpath:features/calcular-interes.feature') args
    * call read('classpath:features/generar-otp.feature@otp') args
    * call read('classpath:features/validar-otp.feature@otp') args
    * call read('classpath:features/autorizar-consumo.feature') args