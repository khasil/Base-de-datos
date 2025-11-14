package dao;

import database.Conexion;
import modelo.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operaciones CRUD de Recetas
 * Incluye gestión de imágenes (corregido: url_imagen)
 */
public class RecetaDAO {

    /**
     * Obtener todas las recetas
     */
    public List<Receta> obtenerTodas() {
        List<Receta> recetas = new ArrayList<>();
        String sql = "SELECT r.id_receta, r.titulo, r.descripcion, r.tiempo_preparacion, " +
                     "r.dificultad, r.id_usuario, r.id_categoria, c.nombre as categoria, u.nombre as usuario " +
                     "FROM recetas r " +
                     "JOIN categorias c ON r.id_categoria = c.id_categoria " +
                     "JOIN usuarios u ON r.id_usuario = u.id_usuario " +
                     "ORDER BY r.fecha_creacion DESC";

        try (Connection conn = Conexion.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Receta receta = new Receta();
                receta.setIdReceta(rs.getInt("id_receta"));
                receta.setTitulo(rs.getString("titulo"));
                receta.setDescripcion(rs.getString("descripcion"));
                receta.setTiempoPreparacion(rs.getInt("tiempo_preparacion"));
                receta.setDificultad(rs.getString("dificultad"));
                receta.setIdUsuario(rs.getInt("id_usuario"));
                receta.setIdCategoria(rs.getInt("id_categoria"));
                receta.setNombreCategoria(rs.getString("categoria"));
                receta.setNombreUsuario(rs.getString("usuario"));
                recetas.add(receta);
            }
        } catch (SQLException e) {
            System.err.println("❌ Error al obtener recetas: " + e.getMessage());
        }

        return recetas;
    }

    /**
     * Obtener receta por ID con sus ingredientes
     */
    public Receta obtenerPorId(int idReceta) {
        Receta receta = null;
        String sql = "SELECT r.id_receta, r.titulo, r.descripcion, r.tiempo_preparacion, " +
                     "r.dificultad, r.id_usuario, r.id_categoria, c.nombre as categoria, u.nombre as usuario " +
                     "FROM recetas r " +
                     "JOIN categorias c ON r.id_categoria = c.id_categoria " +
                     "JOIN usuarios u ON r.id_usuario = u.id_usuario " +
                     "WHERE r.id_receta = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idReceta);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    receta = new Receta();
                    receta.setIdReceta(rs.getInt("id_receta"));
                    receta.setTitulo(rs.getString("titulo"));
                    receta.setDescripcion(rs.getString("descripcion"));
                    receta.setTiempoPreparacion(rs.getInt("tiempo_preparacion"));
                    receta.setDificultad(rs.getString("dificultad"));
                    receta.setIdUsuario(rs.getInt("id_usuario"));
                    receta.setIdCategoria(rs.getInt("id_categoria"));
                    receta.setNombreCategoria(rs.getString("categoria"));
                    receta.setNombreUsuario(rs.getString("usuario"));

                    receta.setIngredientes(obtenerIngredientesDeReceta(idReceta));
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error al obtener receta: " + e.getMessage());
        }

        return receta;
    }

    /**
     * Crear nueva receta
     */
    public boolean crear(Receta receta) {
        String sql = "INSERT INTO recetas (titulo, descripcion, tiempo_preparacion, dificultad, id_usuario, id_categoria) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, receta.getTitulo());
            pstmt.setString(2, receta.getDescripcion());
            pstmt.setInt(3, receta.getTiempoPreparacion());
            pstmt.setString(4, receta.getDificultad());
            pstmt.setInt(5, receta.getIdUsuario());
            pstmt.setInt(6, receta.getIdCategoria());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error al crear receta: " + e.getMessage());
            return false;
        }
    }

    /**
     * Actualizar receta
     */
    public boolean actualizar(Receta receta) {
        String sql = "UPDATE recetas SET titulo = ?, descripcion = ?, tiempo_preparacion = ?, " +
                     "dificultad = ?, id_categoria = ? WHERE id_receta = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, receta.getTitulo());
            pstmt.setString(2, receta.getDescripcion());
            pstmt.setInt(3, receta.getTiempoPreparacion());
            pstmt.setString(4, receta.getDificultad());
            pstmt.setInt(5, receta.getIdCategoria());
            pstmt.setInt(6, receta.getIdReceta());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error al actualizar receta: " + e.getMessage());
            return false;
        }
    }

    /**
     * Eliminar receta
     */
    public boolean eliminar(int idReceta) {
        String sql = "DELETE FROM recetas WHERE id_receta = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idReceta);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error al eliminar receta: " + e.getMessage());
            return false;
        }
    }

    /**
     * Obtener ingredientes de una receta
     */
    public List<RecetaIngrediente> obtenerIngredientesDeReceta(int idReceta) {
        List<RecetaIngrediente> ingredientes = new ArrayList<>();
        String sql = "SELECT ri.id_ingrediente, ri.cantidad, i.nombre, i.unidad_medida " +
                     "FROM receta_ingredientes ri " +
                     "JOIN ingredientes i ON ri.id_ingrediente = i.id_ingrediente " +
                     "WHERE ri.id_receta = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idReceta);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    RecetaIngrediente ri = new RecetaIngrediente();
                    ri.setIdReceta(idReceta);
                    ri.setIdIngrediente(rs.getInt("id_ingrediente"));
                    ri.setCantidad(rs.getDouble("cantidad"));
                    ri.setNombreIngrediente(rs.getString("nombre"));
                    ri.setUnidadMedida(rs.getString("unidad_medida"));
                    ingredientes.add(ri);
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error al obtener ingredientes: " + e.getMessage());
        }

        return ingredientes;
    }

    /**
     * Obtener ruta de imagen de una receta (CORREGIDO: url_imagen)
     */
    public String obtenerImagenReceta(int idReceta) {
        String sql = "SELECT url_imagen FROM imagenes_recetas WHERE id_receta = ? LIMIT 1";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idReceta);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String url = rs.getString("url_imagen");
                    System.out.println("✅ Imagen obtenida: " + url);
                    return url;
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error al obtener imagen: " + e.getMessage());
        }

        return null;
    }

    /**
     * Guardar imagen de receta (CORREGIDO: url_imagen)
     */
    public boolean guardarImagen(int idReceta, String rutaImagen) {
        // Verificar si ya existe imagen
        String sqlCheck = "SELECT id_imagen FROM imagenes_recetas WHERE id_receta = ?";
        String sqlInsert = "INSERT INTO imagenes_recetas (id_receta, url_imagen) VALUES (?, ?)";
        String sqlUpdate = "UPDATE imagenes_recetas SET url_imagen = ? WHERE id_receta = ?";

        try (Connection conn = Conexion.getConnection()) {

            // Verificar si existe
            try (PreparedStatement pstmtCheck = conn.prepareStatement(sqlCheck)) {
                pstmtCheck.setInt(1, idReceta);
                ResultSet rs = pstmtCheck.executeQuery();

                if (rs.next()) {
                    // Actualizar
                    try (PreparedStatement pstmtUpdate = conn.prepareStatement(sqlUpdate)) {
                        pstmtUpdate.setString(1, rutaImagen);
                        pstmtUpdate.setInt(2, idReceta);
                        int result = pstmtUpdate.executeUpdate();
                        System.out.println("✅ Imagen actualizada: " + rutaImagen);
                        return result > 0;
                    }
                } else {
                    // Insertar
                    try (PreparedStatement pstmtInsert = conn.prepareStatement(sqlInsert)) {
                        pstmtInsert.setInt(1, idReceta);
                        pstmtInsert.setString(2, rutaImagen);
                        int result = pstmtInsert.executeUpdate();
                        System.out.println("✅ Imagen guardada: " + rutaImagen);
                        return result > 0;
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ Error al guardar imagen: " + e.getMessage());
            return false;
        }
    }
}