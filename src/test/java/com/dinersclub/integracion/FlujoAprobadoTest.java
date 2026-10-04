package com.dinersclub.integracion;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.condition.DisabledIfSystemProperty;

@DisabledIfSystemProperty(
    named = "suite",
    matches = "all",
    disabledReason = "La suite general ejecuta este feature"
)
class FlujoAprobadoTest {

    @Karate.Test
    Karate ejecutarFlujoAprobado() {
        return Karate.run("classpath:features/flujo-completo.feature");
    }
}