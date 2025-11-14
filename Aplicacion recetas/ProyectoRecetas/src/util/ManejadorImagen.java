package util;

import javax.swing.*;
import java.awt.Image;
import java.io.IOException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Utilidad para manejar imágenes con CACHÉ y carga asíncrona
 * VERSIÓN OPTIMIZADA: Carga rápida sin bloqueos
 */
public class ManejadorImagen {

    // CACHÉ en memoria - Almacena imágenes ya descargadas
    private static Map<String, ImageIcon> cacheImagenes = new HashMap<>();

    // Pool de threads para carga asíncrona
    private static ExecutorService executorService = Executors.newFixedThreadPool(2);

    private static final int ANCHO = 400;
    private static final int ALTO = 300;

    /**
     * Descargar imagen desde URL CON CACHÉ
     * Si ya está en caché, retorna inmediatamente (muy rápido)
     */
    public static ImageIcon descargarImagenDesdeURL(String urlString) {
        try {
            // Verificar si está en caché
            if (cacheImagenes.containsKey(urlString)) {
                System.out.println("✅ Imagen desde CACHÉ (rápido): " + urlString);
                return cacheImagenes.get(urlString);
            }

            System.out.println("📥 Descargando imagen: " + urlString);

            // Descargar solo si no está en caché
            URL url = new URL(urlString);
            ImageIcon icon = new ImageIcon(url);

            if (icon.getIconWidth() > 0 && icon.getIconHeight() > 0) {
                // Escalar imagen
                Image img = icon.getImage().getScaledInstance(ANCHO, ALTO, Image.SCALE_SMOOTH);
                ImageIcon iconEscalado = new ImageIcon(img);

                // Guardar en caché
                cacheImagenes.put(urlString, iconEscalado);
                System.out.println("✅ Imagen cacheada y lista");

                return iconEscalado;
            }

            return null;

        } catch (IOException e) {
            System.err.println("❌ Error al descargar: " + urlString);
            System.err.println("   Razón: " + e.getMessage());
            return null;
        } catch (Exception e) {
            System.err.println("❌ Error: " + e.getMessage());
            return null;
        }
    }

    /**
     * Cargar imagen local (archivo en disco)
     * Muy rápido, sin descarga
     */
    public static ImageIcon cargarImagenLocal(String rutaLocal) {
        try {
            // Verificar si está en caché
            if (cacheImagenes.containsKey(rutaLocal)) {
                return cacheImagenes.get(rutaLocal);
            }

            System.out.println("📂 Cargando imagen local: " + rutaLocal);

            ImageIcon icon = new ImageIcon(rutaLocal);
            if (icon.getIconWidth() > 0 && icon.getIconHeight() > 0) {
                Image img = icon.getImage().getScaledInstance(ANCHO, ALTO, Image.SCALE_SMOOTH);
                ImageIcon iconEscalado = new ImageIcon(img);

                // Guardar en caché
                cacheImagenes.put(rutaLocal, iconEscalado);

                return iconEscalado;
            }
            return null;
        } catch (Exception e) {
            System.err.println("❌ Error al cargar imagen local: " + e.getMessage());
            return null;
        }
    }

    /**
     * Detectar tipo de ruta (URL o local) y cargar
     * OPTIMIZADO: Usa caché primero
     */
    public static ImageIcon cargarImagen(String ruta) {
        if (ruta == null || ruta.isEmpty()) {
            return null;
        }

        // Prioridad 1: Caché
        if (cacheImagenes.containsKey(ruta)) {
            return cacheImagenes.get(ruta);
        }

        // Prioridad 2: Detectar tipo
        if (ruta.startsWith("http://") || ruta.startsWith("https://")) {
            return descargarImagenDesdeURL(ruta);
        } else {
            return cargarImagenLocal(ruta);
        }
    }

    /**
     * Cargar imagen de forma ASÍNCRONA (no bloquea interfaz)
     */
    public static void cargarImagenAsincrona(String ruta, JLabel labelDestino) {
        executorService.execute(() -> {
            try {
                ImageIcon imagen = cargarImagen(ruta);

                // Actualizar interfaz en hilo de eventos
                SwingUtilities.invokeLater(() -> {
                    if (imagen != null) {
                        labelDestino.setIcon(imagen);
                        labelDestino.setText("");
                        System.out.println("✅ Imagen mostrada");
                    } else {
                        labelDestino.setIcon(null);
                        labelDestino.setText("❌ No se pudo cargar");
                    }
                });
            } catch (Exception e) {
                SwingUtilities.invokeLater(() -> {
                    labelDestino.setIcon(null);
                    labelDestino.setText("❌ Error: " + e.getMessage());
                });
            }
        });
    }

    /**
     * Limpiar caché (liberar memoria si es necesario)
     */
    public static void limpiarCache() {
        cacheImagenes.clear();
        System.out.println("🗑️ Caché de imágenes limpiado");
    }

    /**
     * Ver estado del caché
     */
    public static void mostrarEstadoCache() {
        System.out.println("📊 Caché de imágenes: " + cacheImagenes.size() + " imágenes almacenadas");
    }
}