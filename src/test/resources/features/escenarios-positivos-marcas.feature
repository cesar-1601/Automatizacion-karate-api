Feature: Escenarios positivos end-to-end con otras marcas

  # Placeholders: no ejecutan requests hasta contar con perfiles y códigos confirmados por CAL.

  @pendiente @positivo @e2e @visa
  Scenario: Flujo completo aprobado con tarjeta Visa
    * print 'Pendiente: confirmar con CAL perfil Visa aprobado, codigo de entidad, codigo de marca VI y comercio habilitado'

  @pendiente @positivo @e2e @mastercard
  Scenario: Flujo completo aprobado con tarjeta Mastercard
    * print 'Pendiente: confirmar con CAL perfil Mastercard aprobado, codigo de entidad, codigo de marca MC y comercio habilitado'
