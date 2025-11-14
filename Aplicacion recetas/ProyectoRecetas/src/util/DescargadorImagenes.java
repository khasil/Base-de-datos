package util;

import javax.swing.*;
import java.awt.Image;
import java.io.*;
import java.net.URL;
import java.net.URLConnection;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Descargador de imágenes desde URLs a almacenamiento local
 * Acelera las cargas exponencialmente usando caché local
 */
public class DescargadorImagenes {

    // Directorio local para guardar imágenes
    private static final String DIRECTORIO_CACHE = System.getProperty("user.home") + File.separator + 
                                                    ".recetas_app" + File.separator + "imagenes";

    // Caché en memoria
    private static Map<String, ImageIcon> cacheLocal = new HashMap<>();

    // Pool de threads para descargas asincronas
    private static ExecutorService executorService = Executors.newFixedThreadPool(3);

    private static final int ANCHO = 400;
    private static final int ALTO = 300;

    static {
        // Crear directorio de caché si no existe
        crearDirectorioCache();
    }

    /**
     * Crear directorio de caché
     */
    private static void crearDirectorioCache() {
        try {
            Files.createDirectories(Paths.get(DIRECTORIO_CACHE));
            System.out.println("📁 Caché local: " + DIRECTORIO_CACHE);
        } catch (IOException e) {
            System.err.println("❌ Error creando directorio: " + e.getMessage());
        }
    }

    /**
     * Obtener nombre de archivo a partir de URL
     */
    private static String obtenerNombreArchivo(String url) {
        // Crear hash del URL para nombre único
        int hash = url.hashCode();
        return "img_" + Math.abs(hash) + ".jpg";
    }

    /**
     * Obtener ruta completa de archivo en caché
     */
    private static String obtenerRutaArchivo(String url) {
        return DIRECTORIO_CACHE + File.separator + obtenerNombreArchivo(url);
    }

    /**
     * Verificar si imagen ya está en caché local
     */
    private static boolean existeEnCache(String url) {
        String ruta = obtenerRutaArchivo(url);
        return Files.exists(Paths.get(ruta));
    }

    /**
     * Cargar imagen desde caché local o URL
     * PRINCIPAL: Intenta caché primero, luego URL
     */
    public static ImageIcon cargarImagen(String url) {
        if (url == null || url.isEmpty()) {
            return null;
        }

        // 1. Verificar caché en memoria
        if (cacheLocal.containsKey(url)) {
            System.out.println("✅ Desde caché RAM : " + obtenerNombreArchivo(url));
            return cacheLocal.get(url);
        }

        // 2. Verificar caché local en disco
        String rutaLocal = obtenerRutaArchivo(url);
        if (existeEnCache(url)) {
            System.out.println("📂 Cargando desde disco: " + obtenerNombreArchivo(url));
            ImageIcon icon = new ImageIcon(rutaLocal);
            if (icon.getIconWidth() > 0) {
                Image img = icon.getImage().getScaledInstance(ANCHO, ALTO, Image.SCALE_SMOOTH);
                ImageIcon iconEscalado = new ImageIcon(img);

                // Guardar en caché RAM
                cacheLocal.put(url, iconEscalado);
                return iconEscalado;
            }
        }

        // 3. Descargar desde URL y guardar en caché
        return descargarYGuardar(url);
    }

    /**
     * Descargar imagen desde URL y guardar en caché local
     */
    private static ImageIcon descargarYGuardar(String url) {
        try {
            System.out.println("📥 Descargando: " + obtenerNombreArchivo(url));

            URL urlObj = new URL(url);
            URLConnection conexion = urlObj.openConnection();
            conexion.setConnectTimeout(5000);
            conexion.setReadTimeout(5000);
            conexion.setRequestProperty("User-Agent", "Mozilla/5.0");

            // Descargar archivo
            try (InputStream inputStream = conexion.getInputStream();
                 FileOutputStream outputStream = new FileOutputStream(obtenerRutaArchivo(url))) {

                byte[] buffer = new byte[1024];
                int bytesLeidos;
                while ((bytesLeidos = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesLeidos);
                }
            }

            // Cargar imagen guardada
            String rutaLocal = obtenerRutaArchivo(url);
            ImageIcon icon = new ImageIcon(rutaLocal);

            if (icon.getIconWidth() > 0 && icon.getIconHeight() > 0) {
                Image img = icon.getImage().getScaledInstance(ANCHO, ALTO, Image.SCALE_SMOOTH);
                ImageIcon iconEscalado = new ImageIcon(img);

                // Guardar en caché RAM
                cacheLocal.put(url, iconEscalado);

                System.out.println("✅ Descargado y cacheado: " + obtenerNombreArchivo(url));
                return iconEscalado;
            }

        } catch (Exception e) {
            System.err.println("❌ Error descargando: " + e.getMessage());
        }

        return null;
    }

    /**
     * Cargar imagen ASINCRONAMENTE sin bloquear interfaz
     * Se descarga de forma asíncrona si no está en caché
     */
    public static void cargarImagenAsincrona(String url, JLabel labelDestino) {
        // Si ya está en caché RAM, mostrar inmediatamente
        if (cacheLocal.containsKey(url)) {
            labelDestino.setIcon(cacheLocal.get(url));
            labelDestino.setText("");
            System.out.println("✅ Imagen mostrada desde RAM ");
            return;
        }

        // Si está en disco, cargar en thread separado
        if (existeEnCache(url)) {
            executorService.execute(() -> {
                ImageIcon imagen = cargarImagen(url);
                SwingUtilities.invokeLater(() -> {
                    if (imagen != null) {
                        labelDestino.setIcon(imagen);
                        labelDestino.setText("");
                    } else {
                        labelDestino.setText("❌ Error");
                    }
                });
            });
            return;
        }

        // Si no está en caché, descargar de URL
        labelDestino.setText("⏳ Descargando...");
        executorService.execute(() -> {
            try {
                ImageIcon imagen = descargarYGuardar(url);
                SwingUtilities.invokeLater(() -> {
                    if (imagen != null) {
                        labelDestino.setIcon(imagen);
                        labelDestino.setText("");
                    } else {
                        labelDestino.setText("❌ No disponible");
                    }
                });
            } catch (Exception e) {
                SwingUtilities.invokeLater(() -> {
                    labelDestino.setText("❌ Error: " + e.getMessage());
                });
            }
        });
    }

    /**
     * Mostrar información del caché
     */
    public static void mostrarEstadoCache() {
        System.out.println("📊 ESTADO DEL CACHÉ:");
        System.out.println("  • Caché RAM: " + cacheLocal.size() + " imágenes");
        System.out.println("  • Directorio: " + DIRECTORIO_CACHE);

        try {
            long archivos = Files.list(Paths.get(DIRECTORIO_CACHE))
                    .filter(Files::isRegularFile)
                    .count();
            System.out.println("  • Archivos en disco: " + archivos);

            long tamaño = Files.list(Paths.get(DIRECTORIO_CACHE))
                    .filter(Files::isRegularFile)
                    .mapToLong(p -> {
                        try {
                            return Files.size(p);
                        } catch (IOException e) {
                            return 0;
                        }
                    }).sum();

            System.out.println("  • Tamaño total: " + (tamaño / 1024 / 1024) + " MB");
        } catch (IOException e) {
            System.err.println("  ❌ Error: " + e.getMessage());
        }
    }

    /**
     * Limpiar caché (liberar espacio)
     */
    public static void limpiarCache() {
        cacheLocal.clear();
        try {
            Files.list(Paths.get(DIRECTORIO_CACHE))
                    .filter(Files::isRegularFile)
                    .forEach(p -> {
                        try {
                            Files.delete(p);
                        } catch (IOException e) {
                            System.err.println("❌ Error: " + e.getMessage());
                        }
                    });
            System.out.println("🗑️ Caché limpiado completamente");
        } catch (IOException e) {
            System.err.println("❌ Error: " + e.getMessage());
        }
    }
}