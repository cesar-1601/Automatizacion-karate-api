Feature: Resolver perfil de tarjeta

  Scenario: Cargar datos locales del perfil solicitado
    * def cards = read('classpath:test-data/local/cards.json')
    * def findProfile =
      """
      function(cards, profileName) {
        return cards.filter(function(card) {
          return card.profileName === profileName;
        });
      }
      """
    * def matches = findProfile(cards, profileName)
    * match karate.sizeOf(matches) == 1
    * def selectedCard = matches[0]
    * def expirationParts = selectedCard.expirationDate.split('/')
    * def expirationDate = expirationParts[1] + expirationParts[0]
    * def cardProfile = selectedCard.profileName
    * def cardNumber = selectedCard.cardNumber
    * def maskedCard = selectedCard.maskedCard
    * def cvv = selectedCard.cvv
    * def cardBrand = selectedCard.brand
    * def issuerCode = selectedCard.issuerCode
    * def cardStatus = selectedCard.status
