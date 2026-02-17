//
//  ContentView.swift
//  Curso-ios-api-eltiempo
//
//  Created by Equipo 9 on 13/2/26.
//

import SwiftUI

struct ContentView: View {
    // inicializado a nill para que no pete
    @State private var provincias: Provincias? = nil
    @State private var municipios: Municipios? = nil
    @State private var pronosticoMunicipio: PronosticoMunicipio? = nil

    var body: some View {

        NavigationStack {

            VStack {
//                Button("obtener provincias") {
//                    Task {
//                        do {
//                            self.provincias = try await obtenerProvincias()
//                        } catch {
//                            print("Error: \(error)")
//                        }
//                    }
//                }
                if let provincias {
//                    Text(provincias.title)
                    Text("Selecciona una provincia")
//                    Text("\(provincias.provincias.count) provincias")

                    // pintamos las provincias
                    List(provincias.provincias) { provincia in
                        NavigationLink(
                            destination: VistaDetalleProvincia(
                                provincia: provincia
                            )
                        ) {
                            HStack {
                                Text("\(provincia.CODPROV)")
                                Text("\(provincia.NOMBRE_PROVINCIA)")
                            }
                        }
                    }

                }
            }

            .padding()
        }
        .navigationTitle("La API del tiempo")

        .task {
            do {
                self.provincias = try await obtenerProvincias()
            } catch {
                print("Error: \(error)")
            }
        }

    }

    func obtenerProvincias() async throws -> Provincias {

        guard
            let url = URL(
                string: "https://api.el-tiempo.net/json/v3/provincias"
            )
        else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // leemos los post
        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            let respuestaError = response as? HTTPURLResponse
            print(respuestaError?.statusCode)

            throw URLError(.badServerResponse)
        }

        let miObjeto = try JSONDecoder().decode(Provincias.self, from: data)

        return miObjeto
    }

}

struct VistaDetalleProvincia: View {

    @State private var municipios: Municipios? = nil
    @State private var pronoticoProvincia: DetalleProvincia? = nil
    var provincia: Provincia

    var body: some View {
        VStack(spacing: 20) {
            //            Text("Detalle de la provincia")
            //                .font(.caption)
            HStack {
//                Text(provincia.CODPROV)
//                    .padding()
                Text(provincia.NOMBRE_PROVINCIA)
                    .padding()
                    .font(.title)
            }
            if let pronoticoProvincia {
                VStack(alignment: .leading) {
                    Text("Pronostico para hoy")
                    Text(pronoticoProvincia.today.p)
                }
                VStack(alignment: .leading) {
                    Text("Pronostico para Mañana")
                    Text(pronoticoProvincia.today.p)

                }
            }
        }
        .padding()
        .task {
            do {
                self.pronoticoProvincia = try await obtenerPronosticoProvincia(
                    codprov: provincia.CODPROV
                )
            } catch {
                print("Error: \(error)")
            }
        }
        Text("Selecciona un municipio")
        NavigationStack {

            VStack {

                if let municipios {

                    //                    Text("\(municipios.municipios.count) Municipios")

                    // pintamos las provincias
                    List(municipios.municipios) { municipio in
                        NavigationLink(
                            destination: VistaDetalleMunicipio(
                                municipio: municipio
                            )
                        ) {
                            HStack {
                                Text("\(municipio.COD_GEO)")
                                Text("\(municipio.NOMBRE)")
                            }
                        }
                    }

                }
            }

            .padding()
        }
        .navigationTitle("La API del tiempo")

        .task {
            do {
                self.municipios = try await obtenerMunicipos(
                    codprov: provincia.CODPROV
                )
            } catch {
                print("Error: \(error)")
            }
        }
    }

    func obtenerPronosticoProvincia(codprov: String) async throws
        -> DetalleProvincia
    {

        guard
            let url = URL(
                string:
                    "https://api.el-tiempo.net/json/v3/provincias/\(codprov)"
            )
        else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)

        // leemos los post
        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            let respuestaError = response as? HTTPURLResponse
            print(respuestaError?.statusCode)

            throw URLError(.badServerResponse)
        }

        let miObjeto = try JSONDecoder().decode(
            DetalleProvincia.self,
            from: data
        )

        return miObjeto
    }

    func obtenerMunicipos(codprov: String) async throws -> Municipios {

        guard
            let url = URL(
                string:
                    "https://api.el-tiempo.net/json/v3/provincias/\(codprov)/municipios"
            )
        else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // leemos los post
        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            let respuestaError = response as? HTTPURLResponse
            print(respuestaError?.statusCode)

            throw URLError(.badServerResponse)
        }

        let miObjeto = try JSONDecoder().decode(Municipios.self, from: data)

        return miObjeto
    }
}

struct VistaDetalleMunicipio: View {
    @State private var pronostico: PronosticoMunicipio?
    var municipio: Municipio

    var body: some View {

        let idMunicipio = String(municipio.CODIGOINE.prefix(5))

        VStack(spacing: 20) {
            if let pronostico {
                
                Text("📍 \(municipio.NOMBRE)")
                    .font(.title)
                Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                            GridRow {
                                Text("Máxima")
                                Text(pronostico.temperaturas.max)
                                Image(systemName: "arrowshape.up.fill")
                                    .foregroundStyle(.red)
                            }
                            GridRow {
                                Text("Mínima")
                                Text(pronostico.temperaturas.min)
                                Image(systemName: "arrowshape.down.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                .padding(10)
                .border(.blue, width: 1)
                
                .cornerRadius(10)
                

                
                Text("humnedad \(pronostico.humedad)")
                Image(systemName: "humidity.fill")
                Text("lluvia \(pronostico.lluvia)")
                Image(systemName: "cloud.rain.fill")
                
//                Text("precipitacion \(pronostico.precipitacion)")
                Text("viento \(pronostico.viento)")
                Image(systemName: "wind")
            }
        }
        .task {
            do {
                self.pronostico = try await obtenerPronostico(
                    codprov: municipio.CODPROV,
                    idMunicipio: idMunicipio
                )
            } catch {
                print("Error: \(error)")
            }

        }

    }

    func obtenerPronostico(codprov: String, idMunicipio: String) async throws
        -> PronosticoMunicipio
    {

        guard
            let url = URL(
                string:
                    "https://api.el-tiempo.net/json/v3/provincias/\(codprov)/municipios/\(idMunicipio)"
            )
        else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // leemos los post
        guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            let respuestaError = response as? HTTPURLResponse
            print(respuestaError?.statusCode)

            throw URLError(.badServerResponse)
        }

        let miObjeto = try JSONDecoder().decode(
            PronosticoMunicipio.self,
            from: data
        )

        return miObjeto
    }

}

#Preview {
    ContentView()
}
