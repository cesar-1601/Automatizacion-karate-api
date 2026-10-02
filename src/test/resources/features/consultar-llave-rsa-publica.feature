Feature: Consultar llave RSA publica

  Background:
    * def base = call read('classpath:features/base-request.js')
    * url baseUrl
    * path rsaPublicKeyPath
    * header Content-Type = 'application/json'
    * header x-aplicacion-id = aplicacionId
    * header x-canal-id = canalId

  @smoke @llave-publica
  Scenario: Obtener la llave RSA asociada a la aplicacion y canal
    * def requestBody =
      """
      {
        "dinHeader": {
          "aplicacionId": "#(aplicacionId)",
          "canalId": "#(canalId)",
          "sesionId": "#(base.uuid())",
          "dispositivo": "",
          "idioma": "",
          "portalId": "",
          "uuid": "#(base.uuid())",
          "ip": "127.0.0.1",
          "horaTransaccion": "2026-09-15T00:00:00.000",
          "llaveSimetrica": "",
          "usuario": "",
          "paginado": {
            "cantRegistros": 0,
            "numTotalPag": 0,
            "numPagActual": 0
          },
          "tags": []
        },
        "dinBody": null
      }
      """
    Given request requestBody
    When method post
    Then status 200
    And match response.dinBody.llavePublica == '#string'
    And match response.dinBody.llavePublica != ''