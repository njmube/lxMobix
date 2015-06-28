
import com.luxsoft.lx.core.Cliente
import com.luxsoft.lx.core.Direccion
import com.luxsoft.lx.cxp.Requisicion

testDataConfig {
    sampleData {
        'com.luxsoft.lx.core.Cliente'{
            direccion=new Direccion(
                calle:'CALLE'
                ,numeroExterior:'101'
                ,numeroInterior:''
                ,colonia:'COLONIA'
                ,municipio:'MUNICIPIO'
                ,estado:'ESTADO'
                ,codigoPostal:'37296'
                ,pais:'MEXICO'
            )
            rfc='XAXX010101000'
        }
        'com.luxsoft.lx.cxp.Requisicion'{
            def i=1
            folio={->i++}
            comentario={"Requisicion Demo"}
            total=1000.00
        }
    }
}


/*
// sample for creating a single static value for the com.foo.Book's title property:
// title for all Books that we "build()" will be "The Shining", unless explicitly set

testDataConfig {
    sampleData {
        'com.foo.Book' {
            title = "The Shining"
        }
    }
}
*/

/*
// sample for creating a dynamic title for com.foo.Book, useful for unique properties:
// just specify a closure that gets called

testDataConfig {
    sampleData {
        'com.foo.Book' {
            def i = 1
            title = {-> "title${i++}" }   // creates "title1", "title2", ...."titleN"
        }
    }
}
*/

/*
// When using a closure, if your tests expect a particular value, you'll likely want to reset
// the build-test-data config in the setUp of your test, or in the test itself.  Otherwise if
// your tests get run in a different order you'll get different values

// (in test/integration/FooTests.groovy)

void setUp() {
    grails.buildtestdata.TestDataConfigurationHolder.reset()
}
*/


/*
// if you'd like to disable the build-test-data plugin in an environment, just set
// the "enabled" property to false

environments {
    production {
        testDataConfig {
            enabled = false
        }
    }
}
*/