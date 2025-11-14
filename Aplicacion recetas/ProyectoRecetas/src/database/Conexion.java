package database;

import java.sql.*;
import java.util.Properties;


public class Conexion {

    // Parametros de conexion
    private static final String URL = "jdbc:postgresql://localhost:5432/RecetasDB";
    private static final String USER = "postgres";
    private static final String PASSWORD = "1234";
    private static final String DRIVER = "org.postgresql.Driver";


    private static Connection connection = null;


    public static Connection getConnection() {
        try {
            // Registrar el driver
            Class.forName(DRIVER);

            // Crear la conexion
            if (connection == null || connection.isClosed()) {
                Properties props = new Properties();
                props.setProperty("user", USER);
                props.setProperty("password", PASSWORD);
                props.setProperty("ssl", "false");

                connection = DriverManager.getConnection(URL, props);
                System.out.println(" Conexión a PostgreSQL establecida");
            }

            return connection;

        } catch (ClassNotFoundException e) {
            System.err.println(" Error: Driver PostgreSQL no encontrado");
            System.err.println("Asegúrate de tener postgresql-42.x.x.jar en el classpath");
            e.printStackTrace();
            return null;

        } catch (SQLException e) {
            System.err.println(" Error: No se pudo conectar a la base de datos");
            System.err.println("Verifica que PostgreSQL esté corriendo y las credenciales sean correctas");
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Cierra la conexion a la base de datos
     */
    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println(" Conexión cerrada");
            }
        } catch (SQLException e) {
            System.err.println(" Error al cerrar la conexión");
            e.printStackTrace();
        }
    }

    /**
     * Prueba la conexion a la base de datos
     */
    public static void testConnection() {
        try {
            Connection conn = getConnection();
            if (conn != null) {
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT 1");
                if (rs.next()) {
                    System.out.println(" Conexión de prueba exitosa");
                }
                rs.close();
                stmt.close();
            }
        } catch (SQLException e) {
            System.err.println(" Error en la prueba de conexión");
            e.printStackTrace();
        }
    }
}