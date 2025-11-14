package dao;

import database.Conexion;
import modelo.Favorito;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operaciones CRUD de Favoritos
 */
public class FavoritoDAO {

    /**
     * Obtener todos los favoritos de un usuario
     */
    public List<Integer> obtenerFavoritosUsuario(int idUsuario) {
        List<Integer> favoritos = new ArrayList<>();
        String sql = "SELECT id_receta FROM favoritos WHERE id_usuario = ?";

        System.out.println("📊 FavoritoDAO: Obteniendo favoritos del usuario " + idUsuario);

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idUsuario);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    favoritos.add(rs.getInt("id_receta"));
                }
                System.out.println("✅ Total favoritos: " + favoritos.size());
            }
        } catch (SQLException e) {
            System.err.println("❌ FavoritoDAO - Error: " + e.getMessage());
            e.printStackTrace();
        }

        return favoritos;
    }

    /**
     * Verificar si una receta es favorita del usuario
     */
    public boolean esFavorito(int idUsuario, int idReceta) {
        String sql = "SELECT 1 FROM favoritos WHERE id_usuario = ? AND id_receta = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idUsuario);
            pstmt.setInt(2, idReceta);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("❌ Error al verificar favorito: " + e.getMessage());
            return false;
        }
    }

    /**
     * Agregar receta a favoritos
     */
    public boolean agregar(int idUsuario, int idReceta) {
        String sql = "INSERT INTO favoritos (id_usuario, id_receta) VALUES (?, ?)";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idUsuario);
            pstmt.setInt(2, idReceta);

            int result = pstmt.executeUpdate();
            System.out.println("✅ Agregado a favoritos: ID Receta " + idReceta);
            return result > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error al agregar a favoritos: " + e.getMessage());
            return false;
        }
    }

    /**
     * Eliminar receta de favoritos
     */
    public boolean eliminar(int idUsuario, int idReceta) {
        String sql = "DELETE FROM favoritos WHERE id_usuario = ? AND id_receta = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idUsuario);
            pstmt.setInt(2, idReceta);

            int result = pstmt.executeUpdate();
            System.out.println("✅ Eliminado de favoritos: ID Receta " + idReceta);
            return result > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error al eliminar de favoritos: " + e.getMessage());
            return false;
        }
    }
}