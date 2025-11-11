import SwiftUI

struct StatsPorcents2: View {
    let TituloContenedor: String
    let porcentaje: Int   // 0...100
    
    @State private var animatedProgress: CGFloat = 0
    
    private let barWidth: CGFloat = 90
    
    var body: some View {
        HStack(spacing: 12) {
            
            // Título
            Text(TituloContenedor)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .foregroundStyle(.colorGray600)
            
            Spacer()
            
            // Barra
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(.systemGray5))
                Capsule()
                    .fill(Color.colorVerde)
                    .frame(width: barWidth * animatedProgress)
            }
            .frame(width: barWidth, height: 10)
            .clipShape(Capsule())
            .animation(.easeOut(duration: 0.6), value: animatedProgress)
            
            // Porcentaje
            Text("\(Int(animatedProgress * 100))%")
                .font(.subheadline)
                .foregroundColor(.colorVerde)
                .monospacedDigit()
                .frame(minWidth: 40, alignment: .trailing)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            animatedProgress = 0
            withAnimation(.easeOut(duration: 0.6)) {
                animatedProgress = CGFloat(porcentaje) / 100
            }
        }
        .onChange(of: porcentaje) { _, newValue in
            withAnimation(.easeOut(duration: 0.6)) {
                animatedProgress = CGFloat(newValue) / 100
            }
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 16) {
        StatsPorcents2(TituloContenedor: "Café", porcentaje: 10)
        StatsPorcents2(TituloContenedor: "Cacao", porcentaje: 25)
        StatsPorcents2(TituloContenedor: "Productos Orgánicos", porcentaje: 20)
        StatsPorcents2(TituloContenedor: "Otros", porcentaje: 15)
    }
    .padding()
}
