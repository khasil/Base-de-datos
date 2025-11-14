import vista.VistaPrincipal;
import database.Conexion;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;

/**
 * Clase principal de la aplicación
 * Con configuración de UTF-8 para caracteres especiales
 */
public class App {

    public static void main(String[] args) {
        // ============= CONFIGURAR UTF-8 =============
        System.setProperty("file.encoding", "UTF-8");
        System.setProperty("sun.stdout.encoding", "UTF-8");
        System.setProperty("sun.stderr.encoding", "UTF-8");

        // Configurar System.out y System.err para UTF-8
        try {
            System.setOut(new PrintStream(System.out, true, StandardCharsets.UTF_8));
            System.setErr(new PrintStream(System.err, true, StandardCharsets.UTF_8));
        } catch (Exception e) {
            e.printStackTrace();
        }

        // ============= INICIALIZAR APLICACIÓN =============
        System.out.println("\n╔════════════════════════════════════════════╗");
        System.out.println("║  🍰 SISTEMA DE GESTIÓN DE RECETAS DE POSTRES 🍰  ║");
        System.out.println("╚════════════════════════════════════════════╝\n");

        // Probar conexión a la base de datos
        System.out.println("🔌 Conectando a PostgreSQL...");
        Conexion.testConnection();

        // Inicializar interfaz gráfica en el hilo de eventos
        System.out.println("🖥️ Iniciando interfaz gráfica...\n");
        javax.swing.SwingUtilities.invokeLater(() -> {
            VistaPrincipal vista = new VistaPrincipal();
            vista.setVisible(true);
            System.out.println("✅ Aplicación lista\n");
        });
    }
}