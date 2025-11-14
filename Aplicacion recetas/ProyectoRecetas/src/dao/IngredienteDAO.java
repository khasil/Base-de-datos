package dao;

import database.Conexion;
import modelo.Ingrediente;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operaciones CRUD de Ingredientes
 */
public class IngredienteDAO {

    /**
     * Obtener todos los ingredientes
     */
    public List<Ingrediente> obtenerTodos() {
        List<Ingrediente> ingredientes = new ArrayList<>();
        String sql = "SELECT id_ingrediente, nombre, unidad_medida FROM ingredientes ORDER BY nombre";

        System.out.println("? IngredienteDAO: Ejecutando SQL: " + sql);

        try (Connection conn = Conexion.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            int count = 0;
            while (rs.next()) {
                Ingrediente ing = new Ingrediente();
                ing.setIdIngrediente(rs.getInt("id_ingrediente"));
                ing.setNombre(rs.getString("nombre"));
                ing.setUnidadMedida(rs.getString("unidad_medida"));
                ingredientes.add(ing);
                count++;
            }
            System.out.println("? Total ingredientes: " + count);

        } catch (SQLException e) {
            System.err.println("? IngredienteDAO - Error al obtener ingredientes: " + e.getMessage());
            e.printStackTrace();
        }

        return ingredientes;
    }

    /**
     * Obtener ingrediente por ID
     */
    public Ingrediente obtenerPorId(int idIngrediente) {
        String sql = "SELECT id_ingrediente, nombre, unidad_medida FROM ingredientes WHERE id_ingrediente = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idIngrediente);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Ingrediente ing = new Ingrediente();
                    ing.setIdIngrediente(rs.getInt("id_ingrediente"));
                    ing.setNombre(rs.getString("nombre"));
                    ing.setUnidadMedida(rs.getString("unidad_medida"));
                    return ing;
                }
            }
        } catch (SQLException e) {
            System.err.println("? Error al obtener ingrediente: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Crear ingrediente
     */
    public boolean crear(Ingrediente ingrediente) {
        String sql = "INSERT INTO ingredientes (nombre, unidad_medida) VALUES (?, ?)";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, ingrediente.getNombre());
            pstmt.setString(2, ingrediente.getUnidadMedida());

            int result = pstmt.executeUpdate();
            System.out.println("? Ingrediente creado: " + ingrediente.getNombre());
            return result > 0;
        } catch (SQLException e) {
            System.err.println("? Error al crear ingrediente: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Actualizar ingrediente
     */
    public boolean actualizar(Ingrediente ingrediente) {
        String sql = "UPDATE ingredientes SET nombre = ?, unidad_medida = ? WHERE id_ingrediente = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, ingrediente.getNombre());
            pstmt.setString(2, ingrediente.getUnidadMedida());
            pstmt.setInt(3, ingrediente.getIdIngrediente());

            int result = pstmt.executeUpdate();
            System.out.println("? Ingrediente actualizado: " + ingrediente.getNombre());
            return result > 0;
        } catch (SQLException e) {
            System.err.println("? Error al actualizar ingrediente: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Eliminar ingrediente
     */
    public boolean eliminar(int idIngrediente) {
        String sql = "DELETE FROM ingredientes WHERE id_ingrediente = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idIngrediente);
            int result = pstmt.executeUpdate();
            System.out.println("? Ingrediente eliminado: ID " + idIngrediente);
            return result > 0;
        } catch (SQLException e) {
            System.err.println("? Error al eliminar ingrediente: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}