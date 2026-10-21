//
//  ContentView.swift
//  Desafio 04
//
//  Created by Turma01-2 on 21/10/26.
//

import SwiftUI
import MapKit

struct ContentView: View {
    //  Controla a "altitude" da câmara para o Zoom
    @State private var distanceCamera: Double = 10_000_000.0
    
    //  MapCamera em vez de Region para poder inclinar a visão (pitch)
    @State private var position: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(
                latitude: -22.951916,
                longitude: -43.210487),
            distance: 10_000_000.0,
            heading: 0,
            pitch: 60 // Inclinação de 60 graus cria a perspetiva 3D
        )
    )
    
    @State private var local: Location = maravilhas[0]
    @State private var showSheet = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // Renderização do Mapa 3D e Anotações com Emojis
            Map(position: $position) {
                ForEach(maravilhas) { loc in
                    Annotation(loc.nome,
                               coordinate: CLLocationCoordinate2D(
                                latitude: loc.latitude,
                                longitude: loc.longitude)) {
                                    Text(loc.emoji)
                                        .font(.system(size: 35))
                                        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
                                        .scaleEffect(local == loc ? 1.3 : 1.0)
                                        .animation(.spring(), value: local)
                                        .onTapGesture {
                                            local = loc
                                            showSheet = true
                                        }
                                }
                            }
                        }
                        .mapStyle(.standard(elevation: .realistic))
                        .ignoresSafeArea()
            
            // mapa estilo 3d realista
            .mapStyle(.standard(elevation: .realistic))
            .ignoresSafeArea()
            
            VStack {
                
                // picker
                Picker("Local", selection: $local) {
                    ForEach(maravilhas) { loc in
                        Text(loc.nome).tag(loc)
                    }
                }
                .pickerStyle(.menu)
                .tint(.white)
                .padding()
                .background(Color(UIColor.systemBrown))
                .cornerRadius(10)
                .padding(.top, 10)
                .shadow(radius: 5)
                .onChange(of: local) { novoLocal in
                    distanceCamera = 5_000_000.0 // Distância ao mudar de local
                    withAnimation(.easeInOut(duration: 1.5)) {
                        position = .camera(MapCamera(
                            centerCoordinate: CLLocationCoordinate2D(latitude: novoLocal.latitude, longitude: novoLocal.longitude),
                            distance: distanceCamera,
                            heading: 0,
                            pitch: 60 // Mantém a visão 3D
                        ))
                    }
                }
                
                Spacer()
                
                // Botões de Zoom
                HStack {
                    Spacer()
                    VStack(spacing: 15) {
                        // Zoom In
                        Button(action: {
                            withAnimation(.easeInOut) {
                                distanceCamera = max(distanceCamera / 2.0, 500) // Aproxima
                                position = .camera(MapCamera(
                                    centerCoordinate: CLLocationCoordinate2D(latitude: local.latitude, longitude: local.longitude),
                                    distance: distanceCamera,
                                    heading: 0,
                                    pitch: 60
                                ))
                            }
                        }) {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.title2)
                                .frame(width: 45, height: 45)
                                .background(.thinMaterial)
                                .foregroundColor(.primary)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                        
                        // Zoom Out
                        Button(action: {
                            withAnimation(.easeInOut) {
                                distanceCamera = min(distanceCamera * 2.0, 20_000_000.0) // Afasta
                                position = .camera(MapCamera(
                                    centerCoordinate: CLLocationCoordinate2D(latitude: local.latitude, longitude: local.longitude),
                                    distance: distanceCamera,
                                    heading: 0,
                                    pitch: 60
                                ))
                            }
                        }) {
                            Image(systemName: "minus.magnifyingglass")
                                .font(.title2)
                                .frame(width: 45, height: 45)
                                .background(.thinMaterial)
                                .foregroundColor(.primary)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            SheetView(objeto: $local)
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
