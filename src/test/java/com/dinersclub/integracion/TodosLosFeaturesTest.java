package com.dinersclub.integracion;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.condition.DisabledIfSystemProperty;

@DisabledIfSystemProperty(
    named = "feature",
    matches = ".+",
    disabledReason = "La ejecucion puntual usa EndpointTest"
)
class TodosLosFeaturesTest {

    @Karate.Test
    Karate flujoCompleto() {
        return Karate.run("classpath:features/flujo-completo.feature");
    }

    @Karate.Test
    Karate escenariosNegativos() {
        return Karate.run("classpath:features/escenarios-negativos.feature");
    }

    @Karate.Test
    Karate escenariosNegativosTiposCredito() {
        return Karate.run("classpath:features/escenarios-negativos-tipos-credito.feature");
    }

    @Karate.Test
    Karate escenariosNegativosCalculoInteres() {
        return Karate.run("classpath:features/escenarios-negativos-calculo-interes.feature");
    }

    @Karate.Test
    Karate escenariosPositivosMarcas() {
        return Karate.run("classpath:features/escenarios-positivos-marcas.feature");
    }

    @Karate.Test
    Karate escenariosFlujo() {
        return Karate.run("classpath:features/escenarios-flujo.feature");
    }
}
