package no.ibear.mkdocs

import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import no.ibear.mkdocs.plugins.configureHTTP
import no.spk.plugins.*

fun main() {
    embeddedServer(
        Netty,
        port = 8080,
        host = "0.0.0.0",
        module = Application::module
    )
        .start(wait = true)
}

fun Application.module() {
    configureHTTP()
    configureMonitoring()
    configureRouting()
}
