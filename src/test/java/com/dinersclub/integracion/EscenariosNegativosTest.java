package com.dinersclub.integracion;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.condition.DisabledIfSystemProperty;

@DisabledIfSystemProperty(
    named = "suite",
    matches = "all",
    disabledReason = "La suite general ejecuta este feature"
)
class EscenariosNegativosTest {

    @Karate.Test
    Karate ejecutarEscenariosNegativos() {
        return Karate.run("classpath:features/escenarios-negativos.feature");
    }
}