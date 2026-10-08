Feature: Escenarios positivos end-to-end con otras marcas

  # Visa: escenario positivo validado con perfil localizado en test-data/local/cards.json.
  # Requiere que CAL confirme el perfil aprobado y que el comercio esté habilitado para la marca Visa.
  @positivo @e2e @visa
  Scenario: Flujo completo aprobado con tarjeta Visa
    * def scenarioData = { profileName: 'visa-approved' }
    * def cardData = call read('classpath:features/resolver-perfil-tarjeta.feature') { profileName: '#(scenarioData.profileName)' }
    * def cardProfile = cardData.cardProfile
    * def cardStatus = cardData.cardStatus
    * def cardBrand = cardData.cardBrand
    * def cardNumber = cardData.cardNumber
    * match cardProfile == 'visa-approved'
    * match cardStatus == 'approved'
    * match cardBrand == 'Visa'
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature@llave-publica')
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def args = { publicKeyBase64: '#(publicKeyBase64)' }
    * call read('classpath:features/consultar-tipos-credito.feature') args
    * call read('classpath:features/calcular-interes.feature') args
    * call read('classpath:features/generar-otp.feature@otp') args
    * call read('classpath:features/validar-otp.feature@otp') args
    * call read('classpath:features/autorizar-consumo.feature') args

  # Mastercard: caso pendiente hasta confirmar con CAL el perfil exacto, código de entidad y código de marca MC.
  # Mientras tanto, se deja documentado como escenario futuro para evitar perder el caso de prueba.
  @pendiente @positivo @e2e @mastercard
  Scenario: Flujo completo aprobado con tarjeta Mastercard
    # Pendiente: confirmar con CAL el perfil exacto, codigo de entidad, codigo de marca MC y comercio habilitado.
    * def scenarioData = { profileName: 'mastercard-approved' }
    * def cardData = call read('classpath:features/resolver-perfil-tarjeta.feature') { profileName: '#(scenarioData.profileName)' }
    * def cardProfile = cardData.cardProfile
    * def cardStatus = cardData.cardStatus
    * def cardBrand = cardData.cardBrand
    * match cardProfile == 'mastercard-approved'
    * match cardStatus == 'approved'
    * match cardBrand == 'Mastercard'
    * print 'Pendiente: validación final con CAL'

  @pendiente @negativo @e2e @mastercard @rechazo-tarjeta
  Scenario: Rechazo funcional de tarjeta Mastercard
    # Pendiente: confirmar con CAL el perfil exacto y la respuesta funcional esperada del backend para Mastercard.
    * def scenarioData = { profileName: 'mastercard-declined' }
    * def cardData = call read('classpath:features/resolver-perfil-tarjeta.feature') { profileName: '#(scenarioData.profileName)' }
    * def cardProfile = cardData.cardProfile
    * def cardStatus = cardData.cardStatus
    * def cardBrand = cardData.cardBrand
    * match cardProfile == 'mastercard-declined'
    * match cardStatus == 'declined'
    * match cardBrand == 'Mastercard'
    * print 'Pendiente: validación final con CAL'
