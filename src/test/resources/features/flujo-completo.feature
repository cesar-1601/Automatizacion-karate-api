Feature: Flujo completo Place To Pay

  Background:
    * configure logPrettyRequest = true
    * configure logPrettyResponse = true
    * def executionId = java.util.UUID.randomUUID().toString()
    * karate.log('========================================')
    * karate.log('INICIO FEATURE - UUID de ejecución:', executionId)
    * karate.log('merchantId:', merchantId)
    * karate.log('merchantCode:', merchantCode)
    * karate.log('cardNumber:', cardNumber)
    * karate.log('maskedCard:', maskedCard)
    * karate.log('expirationDate:', expirationDate)
    * karate.log('cvv:', cvv)
    * karate.log('========================================')

  @full-flow @destructive
  Scenario: Ejecutar el flujo CAL desde la llave hasta la autorizacion
    * def rsa = call read('classpath:features/consultar-llave-rsa-publica.feature')
    * match rsa.response.dinBody.llavePublica == '#string'
    * def publicKeyBase64 = rsa.response.dinBody.llavePublica
    * def args = { publicKeyBase64: '#(publicKeyBase64)' }
    * def tiposCredito = call read('classpath:features/consultar-tipos-credito.feature') args
    * def interes = call read('classpath:features/calcular-interes.feature') args
    * def generarOtp = call read('classpath:features/generar-otp.feature') args
    * def validarOtp = call read('classpath:features/validar-otp.feature') args
    * def autorizacion = call read('classpath:features/autorizar-consumo.feature') args
    * match tiposCredito.response.body == '#string'
    * match interes.response.body == '#string'
    * match generarOtp.response.body == '#string'
    * match validarOtp.response.body == '#string'
    * match autorizacion.response.body == '#string'