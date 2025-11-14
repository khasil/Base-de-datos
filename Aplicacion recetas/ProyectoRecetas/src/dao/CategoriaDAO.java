package dao;

import database.Conexion;
import modelo.Categoria;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operaciones CRUD de Categorías
 */
public class CategoriaDAO {

    /**
     * Obtener todas las categorías
     */
    public List<Categoria> obtenerTodas() {
        List<Categoria> categorias = new ArrayList<>();
        String sql = "SELECT id_categoria, nombre, descripcion FROM categorias ORDER BY nombre";

        System.out.println("? CategoriaDAO: Ejecutando SQL: " + sql);

        try (Connection conn = Conexion.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            int count = 0;
            while (rs.next()) {
                Categoria cat = new Categoria();
                cat.setIdCategoria(rs.getInt("id_categoria"));
                cat.setNombre(rs.getString("nombre"));
                cat.setDescripcion(rs.getString("descripcion"));
                categorias.add(cat);
                count++;
            }
            System.out.println("? Total categorías: " + count);

        } catch (SQLException e) {
            System.err.println("? CategoriaDAO - Error al obtener categorías: " + e.getMessage());
            e.printStackTrace();
        }

        return categorias;
    }

    /**
     * Obtener categor�a por ID
     */
    public Categoria obtenerPorId(int idCategoria) {
        String sql = "SELECT id_categoria, nombre, descripcion FROM categorias WHERE id_categoria = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idCategoria);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Categoria cat = new Categoria();
                    cat.setIdCategoria(rs.getInt("id_categoria"));
                    cat.setNombre(rs.getString("nombre"));
                    cat.setDescripcion(rs.getString("descripcion"));
                    return cat;
                }
            }
        } catch (SQLException e) {
            System.err.println("? Error al obtener categoría: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Crear categor�a
     */
    public boolean crear(Categoria categoria) {
        String sql = "INSERT INTO categorias (nombre, descripcion) VALUES (?, ?)";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, categoria.getNombre());
            pstmt.setString(2, categoria.getDescripcion());

            int result = pstmt.executeUpdate();
            System.out.println("? Categoría creada: " + categoria.getNombre());
            return result > 0;
        } catch (SQLException e) {
            System.err.println("? Error al crear categoría: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Actualizar categor�a
     */
    public boolean actualizar(Categoria categoria) {
        String sql = "UPDATE categorias SET nombre = ?, descripcion = ? WHERE id_categoria = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, categoria.getNombre());
            pstmt.setString(2, categoria.getDescripcion());
            pstmt.setInt(3, categoria.getIdCategoria());

            int result = pstmt.executeUpdate();
            System.out.println("? Categoría actualizada: " + categoria.getNombre());
            return result > 0;
        } catch (SQLException e) {
            System.err.println("? Error al actualizar categoría: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Eliminar categor�a
     */
    public boolean eliminar(int idCategoria) {
        String sql = "DELETE FROM categorias WHERE id_categoria = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idCategoria);
            int result = pstmt.executeUpdate();
            System.out.println("? Categoría eliminada: ID " + idCategoria);
            return result > 0;
        } catch (SQLException e) {
            System.err.println("? Error al eliminar categoría: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}