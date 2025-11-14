package dao;

import database.Conexion;
import modelo.Usuario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operaciones CRUD de Usuarios
 */
public class UsuarioDAO {

    /**
     * Obtener todos los usuarios
     */
    public List<Usuario> obtenerTodos() {
        List<Usuario> usuarios = new ArrayList<>();
        String sql = "SELECT id_usuario, nombre, correo, rol FROM usuarios ORDER BY nombre";

        System.out.println("? UsuarioDAO: Ejecutando SQL: " + sql);

        try (Connection conn = Conexion.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            int count = 0;
            while (rs.next()) {
                Usuario usr = new Usuario();
                usr.setIdUsuario(rs.getInt("id_usuario"));
                usr.setNombre(rs.getString("nombre"));
                usr.setCorreo(rs.getString("correo"));
                usr.setRol(rs.getString("rol"));
                usuarios.add(usr);
                count++;
            }
            System.out.println("? Total usuarios: " + count);

        } catch (SQLException e) {
            System.err.println("? UsuarioDAO - Error al obtener usuarios: " + e.getMessage());
            e.printStackTrace();
        }

        return usuarios;
    }

    /**
     * Obtener usuario por ID
     */
    public Usuario obtenerPorId(int idUsuario) {
        String sql = "SELECT id_usuario, nombre, correo, rol FROM usuarios WHERE id_usuario = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idUsuario);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Usuario usr = new Usuario();
                    usr.setIdUsuario(rs.getInt("id_usuario"));
                    usr.setNombre(rs.getString("nombre"));
                    usr.setCorreo(rs.getString("correo"));
                    usr.setRol(rs.getString("rol"));
                    return usr;
                }
            }
        } catch (SQLException e) {
            System.err.println("? Error al obtener usuario: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Crear usuario
     */
    public boolean crear(Usuario usuario) {
        String sql = "INSERT INTO usuarios (nombre, correo, contrasena, rol) VALUES (?, ?, ?, ?)";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, usuario.getNombre());
            pstmt.setString(2, usuario.getCorreo());
            pstmt.setString(3, usuario.getContrasena() == null ? "123456" : usuario.getContrasena());
            pstmt.setString(4, usuario.getRol());

            int result = pstmt.executeUpdate();
            System.out.println("? Usuario creado: " + usuario.getNombre());
            return result > 0;

        } catch (SQLException e) {
            System.err.println("? Error al crear usuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Actualizar usuario
     */
    public boolean actualizar(Usuario usuario) {
        String sql = "UPDATE usuarios SET nombre = ?, correo = ?, rol = ? WHERE id_usuario = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, usuario.getNombre());
            pstmt.setString(2, usuario.getCorreo());
            pstmt.setString(3, usuario.getRol());
            pstmt.setInt(4, usuario.getIdUsuario());

            int result = pstmt.executeUpdate();
            System.out.println("? Usuario actualizado: " + usuario.getNombre());
            return result > 0;

        } catch (SQLException e) {
            System.err.println("? Error al actualizar usuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Eliminar usuario
     */
    public boolean eliminar(int idUsuario) {
        String sql = "DELETE FROM usuarios WHERE id_usuario = ?";

        try (Connection conn = Conexion.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, idUsuario);
            int result = pstmt.executeUpdate();
            System.out.println("? Usuario eliminado: ID " + idUsuario);
            return result > 0;

        } catch (SQLException e) {
            System.err.println("? Error al eliminar usuario: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}