//
//  Modelo.swift
//  Curso-ios-api-eltiempo
//
//  Created by Equipo 9 on 13/2/26.
//

import Foundation

// url de apis para probar
// https://free-apis.github.io/#/browse

// url de la api

// url de la doci .- https://www.el-tiempo.net/api
// https://api.el-tiempo.net/json/v3/general // las principales ciudades
//-------------
// https://api.el-tiempo.net/json/v3/provincias                     <-- listado de provincias
// https://api.el-tiempo.net/json/v3/provincias/01                  <-- nos retorna dato generico de 01 a 52
// https://api.el-tiempo.net/json/v3/provincias/01/municipios       <-- nos retorna listado de municipios con su Id "COD_GEO": "01510",
// https://api.el-tiempo.net/json/v3/provincias/01/municipios/01001 <-- con el "COD_GEO": "01510", nos da los datos del municipio concreto

// Struct detalles del municipio



struct StateSky: Codable, Hashable {
    let description: String
}

struct Temepratura: Codable, Hashable {
    let max: String
    let min: String
}

struct PronosticoMunicipio: Codable, Hashable {
    let stateSky :StateSky
    let temperatura_actual: String
    let temperaturas: Temepratura
    let humedad: String
    let viento: String
    let precipitacion: String
    let lluvia: String
}


// struc municipio
struct Municipio: Codable, Hashable, Identifiable {
    let id: UUID = UUID()
    let CODIGOINE: String
    let COD_GEO: String
    let CODPROV: String
    let NOMBRE: String
}

// struc municipios
// que llame a municipio
struct Municipios: Codable, Hashable {
    let title: String
    let municipios: [Municipio]
}

struct PronosticoProvincia: Codable, Hashable {
    let p: String
}

struct DetalleProvincia: Codable, Hashable {
    let today: PronosticoProvincia
    let tomorrow: PronosticoProvincia
}

struct Provincia: Codable, Hashable, Identifiable {
    let id: UUID = UUID()
    let CODPROV: String
    let NOMBRE_PROVINCIA: String

}

struct Provincias: Codable, Hashable {
    let title: String
    let provincias: [Provincia]
}
