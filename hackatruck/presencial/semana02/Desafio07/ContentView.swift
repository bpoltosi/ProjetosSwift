//
//  ContentView.swift
//  Desafio Sensor
//

import SwiftUI
import Charts

struct ContentView: View {
    @StateObject private var viewModel = SensorViewModel()
    
    var corUmidade: Color {
        if viewModel.umidadePercentual < 30 { return .red }
        if viewModel.umidadePercentual < 60 { return .orange }
        return .blue
    }
    
    var statusTexto: String {
        if viewModel.umidadePercentual < 30 { return "Solo Seco" }
        if viewModel.umidadePercentual < 60 { return "Humidade Ideal" }
        return "Solo Encharcado"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                VStack(spacing: 5) {
                    Text("🌿").font(.system(size: 80))
                    Text(viewModel.umidadePercentual < 30 ? "🪴😢" : "🪴😊").font(.system(size: 65))
                }
                .frame(height: 160)
                .animation(.easeInOut, value: viewModel.umidadePercentual)
                
                VStack(spacing: 8) {
                    Text("\(viewModel.umidadePercentual)%")
                        .font(.system(size: 45, weight: .bold))
                        .foregroundColor(corUmidade)
                    
                    Text(statusTexto)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black.opacity(0.8), lineWidth: 4)
                        .frame(width: 130, height: 200)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(corUmidade)
                        .frame(width: 120, height: max(10, min(190, CGFloat(viewModel.umidadePercentual) * 1.9)))
                        .padding(.bottom, 5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: viewModel.umidadePercentual)
                }
                .padding(.vertical, 20)
                
                NavigationLink(destination: ChartView(historico: viewModel.historico)) {
                    Image(systemName: "chart.xyaxis.line")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 65, height: 65)
                        .background(Color.orange)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                
                Spacer()
            }
            .onAppear {
                viewModel.iniciarMonitoramento()
            }
            .onDisappear {
                viewModel.pararMonitoramento()
            }
        }
    }
}

struct ChartView: View {
    var historico: [RegistroUmidade]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Histórico")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.trailing, 20)
                    .padding(.top, 10)
            }
            
            if historico.isEmpty {
                Spacer()
                Text("Aguardando dados...")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                Chart {
                    ForEach(historico) { item in
                        LineMark(
                            x: .value("Tempo", item.tempo),
                            y: .value("Humidade (%)", item.valor)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 3))
                        .foregroundStyle(Color.blue)
                    }
                }
                .chartYScale(domain: 0...100)
                .frame(maxHeight: 400)
                .padding(30)
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
