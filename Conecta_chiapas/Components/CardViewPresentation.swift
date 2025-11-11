//
//  CardViewPresentation.swift
//  Conecta_chiapas
//
//  Created by Martín Emmanuel Erants Solórzano on 20/10/25.
//

import SwiftUI


struct CardViewPresentation: View {
    
    enum StatsStyle {
        case presentation
        case porcent1
        case porcent2
        case porcent3
    }
    enum ImageCard {
        case presentation
        case view2
        case view3
        case view4
    }

    let style: StatsStyle
    let imageStyle: ImageCard
    
    let Encabezado : Text
    let Subtitulo : Text
    let Descripcion : Text
    
    var body: some View {
        
        
        VStack(alignment: .leading){
            Encabezado.font(.title3).foregroundStyle(.colorGray900).padding(.bottom, 2)
            Subtitulo.font(.default).foregroundStyle(.colorVerde).padding(.bottom,2)
            Descripcion.font(.subheadline).foregroundStyle(.colorGray700)

            // Componente seleccionable
            switch style {
            case .presentation:
                
                HStack{
                    
                    StatsPresentation(numero: "25K+", textStat: "Profesionales")
                    StatsPresentation(numero: "120+", textStat: "Municipios")
                    StatsPresentation(numero: "100%", textStat: "Chiapaneco")
                    
                }.padding()
            case .porcent1:
                VStack{
                    StatsPorcents1(TituloContenedor: "Turismo", Porcentaje: "+15%")
                    StatsPorcents1(TituloContenedor: "Agroindustria", Porcentaje: "+22%")
                    StatsPorcents1(TituloContenedor: "Sustentabilidad", Porcentaje: "+35%")
                    StatsPorcents1(TituloContenedor: "Tecnología", Porcentaje: "+40%")
                }
            case .porcent2:
                VStack{
                    StatsPorcents2(TituloContenedor: "Café", porcentaje: 40)
                    StatsPorcents2(TituloContenedor: "Cacao", porcentaje: 25)
                    StatsPorcents2(TituloContenedor: "Productos Orgánicos", porcentaje: 20)
                    StatsPorcents2(TituloContenedor: "Otros", porcentaje: 15)
                }
            case .porcent3:
                VStack{
                    StatsPorcents3(TituloContenedor: "Startup Locales", Porcentaje: "15%")
                    StatsPorcents3(TituloContenedor: "Empleos Tech", Porcentaje: "2,800+")
                    StatsPorcents3(TituloContenedor: "Inversion 2024", Porcentaje: "$15M")
                }
            }
            
            // Imagen según el estilo seleccionado
            switch imageStyle {
            case .presentation:
                Image("cañon del sumidero")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        Image(systemName: "location.fill")
                            .font(.system(size: 24, weight: .bold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(.colorVerde.opacity(0.8), in: RoundedRectangle(cornerRadius: 10))
                            .padding(8),       // separa del borde
                        alignment: .topLeading // posición
                    )
            case .view2:
                Image("palenque")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        Image(systemName: "briefcase")
                            .font(.system(size: 24, weight: .bold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(.colorVerde.opacity(0.8), in: RoundedRectangle(cornerRadius: 10))
                            .padding(8),       // separa del borde
                        alignment: .topLeading // posición
                    )
            case .view3:
                Image("cacao")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        Image(systemName: "leaf")
                            .font(.system(size: 24, weight: .bold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(.colorVerde.opacity(0.8), in: RoundedRectangle(cornerRadius: 10))
                            .padding(8),       // separa del borde
                        alignment: .topLeading // posición
                    )
            case .view4:
                Image("torrechiapas")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 24, weight: .bold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(.colorVerde.opacity(0.8), in: RoundedRectangle(cornerRadius: 10))
                            .padding(8),       // separa del borde
                        alignment: .topLeading // posición
                    )
            }
        }.padding()
    }
}

#Preview("Presentation") {
    CardViewPresentation(
        style: .presentation,
        imageStyle: .presentation,
        Encabezado: Text("¡Bienvenido a Conecta Chiapas!"),
        Subtitulo: Text("La red profesional que impulsa el desarrollo de nuestra región"),
        Descripcion: Text("Conecta con talento local, encuentra oportunidades de crecimiento y contribuye al desarrollo económico de Chiapas.")
    )
}

#Preview("Porcent 1") {
    CardViewPresentation(
        style: .porcent1,
        imageStyle: .view2,
        Encabezado: Text("¡Bienvenido a Conecta Chiapas!"),
        Subtitulo: Text("La red profesional que impulsa el desarrollo de nuestra región"),
        Descripcion: Text("Conecta con talento local, encuentra oportunidades de crecimiento y contribuye al desarrollo económico de Chiapas.")
    )
}

#Preview("Porcent 2") {
    CardViewPresentation(
        style: .porcent2,
        imageStyle: .view3,
        Encabezado: Text("¡Bienvenido a Conecta Chiapas!"),
        Subtitulo: Text("La red profesional que impulsa el desarrollo de nuestra región"),
        Descripcion: Text("Conecta con talento local, encuentra oportunidades de crecimiento y contribuye al desarrollo económico de Chiapas.")
    )
}
#Preview("Porcent 3") {
    CardViewPresentation(
        style: .porcent3,
        imageStyle: .view4,
        Encabezado: Text("¡Bienvenido a Conecta Chiapas!"),
        Subtitulo: Text("La red profesional que impulsa el desarrollo de nuestra región"),
        Descripcion: Text("Conecta con talento local, encuentra oportunidades de crecimiento y contribuye al desarrollo económico de Chiapas.")
    )
}
